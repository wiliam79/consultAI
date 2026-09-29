import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const ConsultAIApp());

class Cliente {
  final String nome, cnpj, email;

  Cliente(this.nome, this.cnpj, this.email);
}

class Consultoria {
  final String cliente, area, diagnostico;
  final DateTime data;

  Consultoria(this.cliente, this.area, this.diagnostico, this.data);
}

class Dados {
  static final clientes = <Cliente>[
    Cliente(
      'Empresa Demonstração',
      '00.000.000/0001-00',
      'contato@empresa.com',
    ),
  ];

  static final historico = <Consultoria>[];
}

class ConsultAIApp extends StatelessWidget {
  const ConsultAIApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ConsultAI',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1565C0),
          ),
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        home: const LoginPage(),
      );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final senha = TextEditingController();

  bool ocultar = true;

  void entrar() {
    if (email.text.trim().isEmpty || senha.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha e-mail e senha.'),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.psychology_alt_outlined,
                        size: 72,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'ConsultAI',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('Consultoria inteligente de TI'),
                      const SizedBox(height: 28),
                      TextField(
                        controller: email,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: senha,
                        obscureText: ocultar,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() => ocultar = !ocultar);
                            },
                            icon: Icon(
                              ocultar
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FilledButton(
                          onPressed: entrar,
                          child: const Text('ENTRAR'),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Demonstração: use qualquer e-mail e senha.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> abrir(Widget w) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => w),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('ConsultAI'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Painel do consultor',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Gerencie clientes, diagnósticos e atendimentos.',
                ),
                const SizedBox(height: 22),
                MenuCard(
                  Icons.business,
                  'Clientes',
                  '${Dados.clientes.length} empresa(s) cadastrada(s)',
                  () => abrir(const ClientesPage()),
                ),
                MenuCard(
                  Icons.assignment_add,
                  'Nova consultoria',
                  'Iniciar diagnóstico técnico',
                  () => abrir(const NovaConsultoriaPage()),
                ),
                MenuCard(
                  Icons.history,
                  'Histórico',
                  '${Dados.historico.length} atendimento(s)',
                  () => abrir(const HistoricoPage()),
                ),
                MenuCard(
                  Icons.auto_awesome,
                  'IA aplicada',
                  'Diagnósticos e recomendações técnicas',
                  () => abrir(const SobreIAPage()),
                ),
              ],
            ),
          ),
        ),
      );
}

class MenuCard extends StatelessWidget {
  final IconData icon;
  final String titulo, subtitulo;
  final VoidCallback onTap;

  const MenuCard(
    this.icon,
    this.titulo,
    this.subtitulo,
    this.onTap, {
    super.key,
  });

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 14),
        child: ListTile(
          contentPadding: const EdgeInsets.all(18),
          leading: CircleAvatar(
            child: Icon(icon),
          ),
          title: Text(
            titulo,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(subtitulo),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      );
}

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Clientes'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CadastroClientePage(),
              ),
            );

            setState(() {});
          },
          icon: const Icon(Icons.add),
          label: const Text('Cadastrar'),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: Dados.clientes.length,
          itemBuilder: (_, i) {
            final c = Dados.clientes[i];

            return Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.business),
                ),
                title: Text(c.nome),
                subtitle: Text(
                  'CNPJ: ${c.cnpj}\n${c.email}',
                ),
                isThreeLine: true,
              ),
            );
          },
        ),
      );
}

class CadastroClientePage extends StatefulWidget {
  const CadastroClientePage({super.key});

  @override
  State<CadastroClientePage> createState() =>
      _CadastroClientePageState();
}

class _CadastroClientePageState extends State<CadastroClientePage> {
  final nome = TextEditingController();
  final cnpj = TextEditingController();
  final email = TextEditingController();

  String norm(String s) => s.replaceAll(RegExp(r'\D'), '');

  void salvar() {
    if (nome.text.trim().isEmpty || cnpj.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe nome e CNPJ.'),
        ),
      );
      return;
    }

    if (Dados.clientes.any(
      (c) => norm(c.cnpj) == norm(cnpj.text),
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Empresa já cadastrada. CNPJ duplicado.',
          ),
        ),
      );
      return;
    }

    Dados.clientes.add(
      Cliente(
        nome.text.trim(),
        cnpj.text.trim(),
        email.text.trim(),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Cadastrar empresa'),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  TextField(
                    controller: nome,
                    decoration: const InputDecoration(
                      labelText: 'Razão social / Nome',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: cnpj,
                    decoration: const InputDecoration(
                      labelText: 'CNPJ',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: email,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: salvar,
                      child: const Text('SALVAR EMPRESA'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class NovaConsultoriaPage extends StatefulWidget {
  const NovaConsultoriaPage({super.key});

  @override
  State<NovaConsultoriaPage> createState() =>
      _NovaConsultoriaPageState();
}

class _NovaConsultoriaPageState
    extends State<NovaConsultoriaPage> {
  String? cliente;

  String area = 'Angular / Web';

  final obs = TextEditingController();

  final checks = <String, bool>{};

  bool carregando = false;

  final areas = const [
    'Angular / Web',
    'Infraestrutura',
    'Cibersegurança',
    'Desenvolvimento de Software',
  ];

  List<String> get itens {
    if (area == 'Angular / Web') {
      return [
        'Angular atualizado',
        'Arquitetura modular',
        'Lazy loading',
        'Testes automatizados',
        'Performance revisada',
      ];
    }

    if (area == 'Infraestrutura') {
      return [
        'Backups configurados',
        'Monitoramento ativo',
        'Cloud documentada',
        'Controle de acesso',
        'Plano de recuperação',
      ];
    }

    if (area == 'Cibersegurança') {
      return [
        'MFA habilitado',
        'Política de senhas',
        'Logs e auditoria',
        'Patches atualizados',
        'Controle de privilégios',
      ];
    }

    return [
      'Arquitetura documentada',
      'Git utilizado',
      'Testes automatizados',
      'CI/CD',
      'Padrões de código',
    ];
  }

  Future<String> gerarDiagnostico() async {
    final lista = itens
        .map(
          (i) =>
              '$i: ${checks[i] == true ? "SIM" : "NÃO"}',
        )
        .join('\n');

    final dados = {
      'empresa': cliente,
      'area': area,
      'checklist': lista,
      'observacoes': obs.text.trim(),
    };

    final r = await http.post(
      Uri.parse(
        'http://localhost:8080/diagnostico',
      ),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(dados),
    );

    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception(
        'Backend/IA retornou erro ${r.statusCode}: ${r.body}',
      );
    }

    final data = jsonDecode(r.body);

    for (final item in (data['output'] as List? ?? [])) {
      for (final part in (item['content'] as List? ?? [])) {
        if (part['type'] == 'output_text') {
          return part['text'].toString();
        }
      }
    }

    throw Exception(
      'A IA respondeu, mas nenhum diagnóstico foi encontrado.',
    );
  }

  Future<void> analisar() async {
    if (cliente == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma empresa.'),
        ),
      );
      return;
    }

    setState(() => carregando = true);

    try {
      final d = await gerarDiagnostico();

      if (!mounted) return;

      final salvo = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => DiagnosticoPage(
            cliente!,
            area,
            d,
          ),
        ),
      );

      if (salvo == true && mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => carregando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Nova consultoria'),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                DropdownButtonFormField<String>(
                  initialValue: cliente,
                  decoration: const InputDecoration(
                    labelText: 'Empresa',
                  ),
                  items: Dados.clientes
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.nome,
                          child: Text(e.nome),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    setState(() => cliente = v);
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: area,
                  decoration: const InputDecoration(
                    labelText: 'Área da consultoria',
                  ),
                  items: areas
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      area = v!;
                      checks.clear();
                    });
                  },
                ),
                const SizedBox(height: 22),
                const Text(
                  'Checklist técnico',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...itens.map(
                  (i) => CheckboxListTile(
                    value: checks[i] ?? false,
                    title: Text(i),
                    controlAffinity:
                        ListTileControlAffinity.leading,
                    onChanged: (v) {
                      setState(
                        () => checks[i] = v ?? false,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: obs,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Observações técnicas',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: carregando ? null : analisar,
                    icon: carregando
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.auto_awesome),
                    label: Text(
                      carregando
                          ? 'ANALISANDO...'
                          : 'GERAR DIAGNÓSTICO COM IA',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class DiagnosticoPage extends StatelessWidget {
  final String cliente, area, diagnostico;

  const DiagnosticoPage(
    this.cliente,
    this.area,
    this.diagnostico, {
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Diagnóstico'),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          cliente,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(area),
                        const Divider(height: 32),
                        SelectableText(
                          diagnostico,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () {
                              Dados.historico.add(
                                Consultoria(
                                  cliente,
                                  area,
                                  diagnostico,
                                  DateTime.now(),
                                ),
                              );

                              Navigator.pop(
                                context,
                                true,
                              );
                            },
                            icon: const Icon(Icons.save),
                            label: const Text(
                              'APROVAR E SALVAR',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class HistoricoPage extends StatelessWidget {
  const HistoricoPage({super.key});

  String fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/'
      '${d.year}';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Histórico'),
        ),
        body: Dados.historico.isEmpty
            ? const Center(
                child: Text(
                  'Nenhuma consultoria salva ainda.',
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: Dados.historico.length,
                itemBuilder: (_, i) {
                  final c =
                      Dados.historico.reversed.toList()[i];

                  return Card(
                    child: ExpansionTile(
                      leading: const Icon(
                        Icons.assignment_turned_in,
                      ),
                      title: Text(c.cliente),
                      subtitle: Text(
                        '${c.area} • ${fmt(c.data)}',
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(18),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SelectableText(
                              c.diagnostico,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      );
}

class SobreIAPage extends StatelessWidget {
  const SobreIAPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: SizedBox(
                width: 650,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 64,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Inteligência Artificial',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'O ConsultAI transforma dados do checklist e '
                          'observações do consultor em diagnóstico, '
                          'recomendações e plano de ação. O resultado '
                          'deve ser revisado pelo profissional responsável.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}