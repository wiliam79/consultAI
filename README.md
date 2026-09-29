# ConsultAI

O **ConsultAI** é um protótipo de aplicação desenvolvido em Flutter para auxiliar empresas e profissionais na realização de consultorias técnicas na área de Tecnologia da Informação.

O sistema permite cadastrar empresas, selecionar diferentes áreas de consultoria, preencher checklists técnicos e gerar diagnósticos e recomendações com auxílio de Inteligência Artificial.

Este projeto foi desenvolvido como parte de um projeto acadêmico, aplicando conceitos de desenvolvimento mobile, integração com APIs, programação e Inteligência Artificial.

---

## 🎯 Objetivo

O objetivo do ConsultAI é facilitar a realização de avaliações técnicas em empresas, organizando informações da consultoria e utilizando Inteligência Artificial para auxiliar na geração de:

- Diagnósticos técnicos
- Pontos de atenção
- Recomendações
- Planos de ação

O diagnóstico gerado pode ser revisado pelo consultor antes de ser salvo no histórico.

---

## 🚀 Funcionalidades

O protótipo possui as seguintes funcionalidades:

- Tela de login demonstrativa
- Cadastro de empresas
- Validação para impedir CNPJ duplicado
- Listagem de empresas cadastradas
- Criação de novas consultorias
- Seleção da empresa que será avaliada
- Seleção da área de consultoria
- Checklists específicos para cada área
- Campo para observações técnicas
- Integração com Inteligência Artificial
- Geração de diagnóstico técnico
- Geração de recomendações
- Geração de plano de ação
- Aprovação do diagnóstico
- Histórico de consultorias realizadas
- Diagnóstico demonstrativo como fallback caso o serviço de IA esteja indisponível
- Interface responsiva

---

## 🧠 Áreas de consultoria

O ConsultAI possui quatro áreas disponíveis para avaliação.

### Angular / Web

Avaliação de aplicações web, considerando aspectos como:

- Versão do Angular
- Arquitetura modular
- Lazy loading
- Testes automatizados
- Performance

### Infraestrutura

Avaliação da infraestrutura tecnológica da empresa:

- Backups
- Monitoramento
- Cloud
- Controle de acesso
- Plano de recuperação

### Cibersegurança

Avaliação de práticas relacionadas à segurança da informação:

- Autenticação multifator (MFA)
- Política de senhas
- Logs e auditoria
- Atualização de patches
- Controle de privilégios

### Desenvolvimento de Software

Avaliação das práticas utilizadas durante o desenvolvimento:

- Arquitetura
- Controle de versão com Git
- Testes automatizados
- CI/CD
- Padrões de código

---

## 🤖 Inteligência Artificial

O ConsultAI possui integração com a **Google Gemini API**.

Durante uma consultoria, o sistema reúne:

1. Empresa selecionada
2. Área da consultoria
3. Respostas do checklist
4. Observações do consultor

Essas informações são enviadas para um backend desenvolvido em Java.

O backend realiza a comunicação com a API de Inteligência Artificial e retorna o diagnóstico para a aplicação Flutter.

Fluxo simplificado:

```text
Flutter
   ↓
Backend Java
   ↓
Google Gemini API
   ↓
Backend Java
   ↓
Flutter
```

A IA utiliza as informações fornecidas durante a avaliação para produzir um diagnóstico contendo resumo, pontos de atenção, recomendações e plano de ação.

O diagnóstico deve ser revisado pelo profissional responsável antes de sua aprovação.

---

## 🛡️ Fallback de diagnóstico

Serviços externos de Inteligência Artificial podem ficar temporariamente indisponíveis.

Por esse motivo, o ConsultAI possui um mecanismo de fallback.

```text
Solicitação de diagnóstico
        ↓
   Google Gemini
     ↙       ↘
 sucesso     falha
    ↓          ↓
IA real     diagnóstico
            demonstrativo
     ↘        ↙
      resultado
```

Caso a comunicação com a IA não seja concluída, o protótipo pode gerar um diagnóstico demonstrativo local utilizando as informações do checklist.

Isso permite que o fluxo principal da aplicação continue funcionando durante uma demonstração.

---

## 🛠️ Tecnologias utilizadas

### Front-end

- Flutter
- Dart
- Material Design
- HTTP

### Backend

- Java
- Java HttpServer
- Java HttpClient

### Inteligência Artificial

- Google Gemini API

### Ferramentas

- Visual Studio Code
- Git
- GitHub

---

## 📁 Estrutura simplificada

```text
ConsultAI/
│
├── lib/
│   └── main.dart
│
├── backend/
│   └── ConsultAIBackend.java
│
├── android/
├── web/
├── test/
│
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

---

## ▶️ Como executar

### Pré-requisitos

Para executar o projeto é necessário possuir:

- Flutter SDK
- Dart
- Java JDK
- Google Chrome ou dispositivo/emulador compatível
- Chave de API do Google Gemini para utilizar a IA

---

### 1. Instalar as dependências

Na pasta principal do projeto:

```bash
flutter pub get
```

---

### 2. Configurar a Gemini API

A chave da API deve ser armazenada em uma variável de ambiente chamada:

```text
GEMINI_API_KEY
```

A chave **não deve ser adicionada diretamente ao código-fonte nem enviada ao GitHub**.

---

### 3. Compilar o backend

Entre na pasta:

```text
backend
```

Execute:

```bash
javac --add-modules jdk.httpserver ConsultAIBackend.java
```

---

### 4. Executar o backend

```bash
java --add-modules jdk.httpserver ConsultAIBackend
```

O backend ficará disponível localmente em:

```text
http://localhost:8080
```

---

### 5. Executar o Flutter

Em outro terminal, na pasta principal do projeto:

```bash
flutter run -d chrome
```

A aplicação será iniciada no Google Chrome.

---

## 💾 Armazenamento de dados

O ConsultAI foi desenvolvido como um **protótipo acadêmico**.

Nesta versão, os dados de empresas e o histórico das consultorias são armazenados temporariamente em memória durante a execução da aplicação.

Portanto, ao reiniciar completamente a aplicação, os novos dados cadastrados durante a sessão podem ser perdidos.

Uma evolução futura do projeto poderá incluir integração com banco de dados.

---

## 🔐 Segurança

A chave da API de Inteligência Artificial não é armazenada diretamente no código Flutter.

A aplicação utiliza um backend Java para realizar a comunicação com o serviço de IA, mantendo a credencial fora do código do cliente.

Arquivos contendo credenciais e chaves privadas não devem ser enviados ao repositório.

---

## 📌 Status do projeto

Protótipo funcional.

Principais fluxos implementados:

- Cadastro de empresas
- Validação de CNPJ duplicado
- Consultorias por área
- Checklists técnicos
- Integração com Inteligência Artificial
- Diagnóstico técnico
- Recomendações
- Plano de ação
- Histórico de atendimentos
- Fallback para indisponibilidade da IA

O código principal da aplicação também foi verificado utilizando:

```bash
flutter analyze lib
```

Resultado:

```text
No issues found!
```

---

## 🔮 Melhorias futuras

Algumas possíveis evoluções do ConsultAI:

- Banco de dados persistente
- Autenticação real de usuários
- Edição e exclusão de empresas
- Exportação de relatórios
- Dashboard com indicadores
- Controle de usuários e permissões
- Histórico persistente
- Melhorias na validação de dados
- Novos modelos e serviços de Inteligência Artificial

---

## 🎓 Projeto acadêmico

Este sistema foi desenvolvido para fins acadêmicos, com o objetivo de demonstrar conceitos de desenvolvimento de aplicações, integração entre front-end e backend, consumo de APIs e utilização de Inteligência Artificial aplicada a um problema empresarial.