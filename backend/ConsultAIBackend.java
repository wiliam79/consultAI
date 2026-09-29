import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;

public class ConsultAIBackend {

    private static final String GEMINI_URL =
            "https://generativelanguage.googleapis.com/v1beta/models/"
            + "gemini-3.8-flash:generateContent";

    public static void main(String[] args) throws Exception {

        String apiKey = System.getenv("GEMINI_API_KEY");

        if (apiKey == null || apiKey.isBlank()) {
            System.err.println("ERRO: GEMINI_API_KEY não encontrada.");
            return;
        }

        HttpServer server = HttpServer.create(
                new InetSocketAddress("localhost", 8080), 0);

        server.createContext("/diagnostico", exchange -> {

            adicionarCors(exchange);

            if ("OPTIONS".equalsIgnoreCase(exchange.getRequestMethod())) {
                exchange.sendResponseHeaders(204, -1);
                return;
            }

            if (!"POST".equalsIgnoreCase(exchange.getRequestMethod())) {
                responder(
                        exchange,
                        405,
                        "{\"erro\":\"Use POST.\"}"
                );
                return;
            }

            try {

                String dados = new String(
                        exchange.getRequestBody().readAllBytes(),
                        StandardCharsets.UTF_8
                );

                String prompt = """
                        Você é um assistente técnico de uma empresa
                        de consultoria em Tecnologia da Informação.

                        Analise os dados enviados pelo aplicativo ConsultAI.

                        Gere um diagnóstico profissional em português.

                        Use obrigatoriamente esta estrutura:

                        Resumo:
                        Faça um resumo da situação encontrada.

                        Pontos de atenção:
                        Liste os principais problemas identificados.

                        Recomendações:
                        Apresente recomendações técnicas para os problemas.

                        Plano de ação:
                        Crie um plano de ação objetivo e numerado.

                        Regras:
                        - Não invente informações.
                        - Baseie-se somente nos dados fornecidos.
                        - Considere itens marcados como NÃO como pontos
                          que precisam de atenção.
                        - Considere as observações do consultor.
                        - Utilize linguagem profissional e objetiva.

                        Dados da consultoria:

                        """ + dados;

                String json = """
                        {
                          "contents": [
                            {
                              "role": "user",
                              "parts": [
                                {
                                  "text": "%s"
                                }
                              ]
                            }
                          ]
                        }
                        """.formatted(escaparJson(prompt));

                HttpRequest request = HttpRequest.newBuilder()
                        .uri(URI.create(GEMINI_URL))
                        .header("x-goog-api-key", apiKey)
                        .header(
                                "Content-Type",
                                "application/json; charset=UTF-8"
                        )
                        .POST(
                                HttpRequest.BodyPublishers.ofString(
                                        json,
                                        StandardCharsets.UTF_8
                                )
                        )
                        .build();

                HttpClient client = HttpClient.newHttpClient();

                HttpResponse<String> respostaGemini =
                        client.send(
                                request,
                                HttpResponse.BodyHandlers.ofString(
                                        StandardCharsets.UTF_8
                                )
                        );

                if (respostaGemini.statusCode() < 200 ||
                        respostaGemini.statusCode() >= 300) {

                    System.err.println(
                            "Erro Gemini: "
                                    + respostaGemini.statusCode()
                    );

                    System.err.println(respostaGemini.body());

                    responder(
                            exchange,
                            respostaGemini.statusCode(),
                            respostaGemini.body()
                    );

                    return;
                }

                String texto =
                        extrairTextoGemini(respostaGemini.body());

                String respostaFlutter =
                        "{\"output\":[{\"content\":["
                                + "{\"type\":\"output_text\","
                                + "\"text\":\""
                                + escaparJson(texto)
                                + "\"}]}]}";

                responder(
                        exchange,
                        200,
                        respostaFlutter
                );

            } catch (Exception e) {

                e.printStackTrace();

                responder(
                        exchange,
                        500,
                        "{\"erro\":\"Erro interno no backend.\"}"
                );
            }
        });

        server.start();

        System.out.println("----------------------------------");
        System.out.println("ConsultAI Backend iniciado!");
        System.out.println("IA: Google Gemini");
        System.out.println("http://localhost:8080");
        System.out.println("----------------------------------");
    }

    private static String extrairTextoGemini(String json) {

        int parts = json.indexOf("\"parts\"");

        if (parts == -1) {
            throw new RuntimeException(
                    "Gemini respondeu sem conteúdo."
            );
        }

        int textKey = json.indexOf("\"text\"", parts);

        if (textKey == -1) {
            throw new RuntimeException(
                    "Gemini respondeu sem texto."
            );
        }

        int doisPontos = json.indexOf(':', textKey);
        int inicio = json.indexOf('"', doisPontos + 1);

        if (inicio == -1) {
            throw new RuntimeException(
                    "Não foi possível interpretar a resposta."
            );
        }

        StringBuilder resultado = new StringBuilder();

        boolean escape = false;

        for (int i = inicio + 1; i < json.length(); i++) {

            char c = json.charAt(i);

            if (escape) {

                switch (c) {
                    case 'n' -> resultado.append('\n');
                    case 'r' -> resultado.append('\r');
                    case 't' -> resultado.append('\t');
                    case '"' -> resultado.append('"');
                    case '\\' -> resultado.append('\\');
                    default -> resultado.append(c);
                }

                escape = false;

            } else if (c == '\\') {

                escape = true;

            } else if (c == '"') {

                return resultado.toString();

            } else {

                resultado.append(c);
            }
        }

        throw new RuntimeException(
                "Resposta do Gemini incompleta."
        );
    }

    private static void adicionarCors(HttpExchange exchange) {

        exchange.getResponseHeaders().add(
                "Access-Control-Allow-Origin",
                "*"
        );

        exchange.getResponseHeaders().add(
                "Access-Control-Allow-Methods",
                "POST, OPTIONS"
        );

        exchange.getResponseHeaders().add(
                "Access-Control-Allow-Headers",
                "Content-Type"
        );
    }

    private static void responder(
            HttpExchange exchange,
            int status,
            String resposta
    ) throws IOException {

        byte[] bytes =
                resposta.getBytes(StandardCharsets.UTF_8);

        exchange.getResponseHeaders().set(
                "Content-Type",
                "application/json; charset=UTF-8"
        );

        exchange.sendResponseHeaders(
                status,
                bytes.length
        );

        try (OutputStream os =
                     exchange.getResponseBody()) {

            os.write(bytes);
        }
    }

    private static String escaparJson(String texto) {

        return texto
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n")
                .replace("\t", "\\t");
    }
}