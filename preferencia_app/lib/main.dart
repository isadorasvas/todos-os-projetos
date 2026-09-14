import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const PreferenciaApp());
}

class PreferenciaApp extends StatefulWidget {
  const PreferenciaApp({super.key});

  @override
  State<PreferenciaApp> createState() => _PreferenciaAppState();
}

class _PreferenciaAppState extends State<PreferenciaApp> {
  bool _temaEscuro = false;

  @override
  void initState() {
    super.initState();
    _carregarTema();
  }

  // Carrega o tema salvo
  Future<void> _carregarTema() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _temaEscuro = prefs.getBool('isDark') ?? false;
    });
  }

  // Altera e salva o tema
  Future<void> _alternarTema(bool valor) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isDark', valor);

    setState(() {
      _temaEscuro = valor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Preferências do Usuário',
      debugShowCheckedModeBanner: false,

      theme: _temaEscuro
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),

      home: ConfigScreen(
        temaEscuro: _temaEscuro,
        onTemaAlterado: _alternarTema,
      ),
    );
  }
}

class ConfigScreen extends StatefulWidget {
  final bool temaEscuro;
  final ValueChanged<bool> onTemaAlterado;

  const ConfigScreen({
    super.key,
    required this.temaEscuro,
    required this.onTemaAlterado,
  });

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final _nomeController = TextEditingController();

  String _nomeSalvo = '';

  // Exercício 02
  String _tamanhoFonte = 'Médio';

  // Exercício 03
  bool _receberNotificacoes = false;

  @override
  void initState() {
    super.initState();

    _carregarNome();
    _carregarConfiguracoes();
  }

  // Carrega o nome salvo
  Future<void> _carregarNome() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _nomeSalvo = prefs.getString('usuario_nome') ?? 'Não informado';

      _nomeController.text =
          prefs.getString('usuario_nome') ?? '';
    });
  }

  // Carrega tamanho da fonte e notificações
  Future<void> _carregarConfiguracoes() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _tamanhoFonte = prefs.getString('tamanho_fonte') ?? 'Médio';

      _receberNotificacoes =
          prefs.getBool('receber_notificacoes') ?? false;
    });
  }

  // Salva o nome
  Future<void> _salvarNome() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'usuario_nome',
      _nomeController.text.trim(),
    );

    setState(() {
      _nomeSalvo = _nomeController.text.trim();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nome salvo localmente com sucesso!'),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }

  // Exercício 02
  // Altera e salva o tamanho da fonte
  Future<void> _alterarTamanhoFonte(String valor) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('tamanho_fonte', valor);

    setState(() {
      _tamanhoFonte = valor;
    });
  }

  // Exercício 03
  // Altera e salva as notificações
  Future<void> _alterarNotificacoes(bool valor) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('receber_notificacoes', valor);

    setState(() {
      _receberNotificacoes = valor;
    });
  }

  // Exercício 01
  // Limpa todas as configurações
  Future<void> _limparConfiguracoes() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    setState(() {
      _nomeSalvo = 'Não informado';
      _nomeController.clear();

      _tamanhoFonte = 'Médio';
      _receberNotificacoes = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todas as configurações foram apagadas!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Define o tamanho da fonte
  double _getTamanhoFonte() {
    if (_tamanhoFonte == 'Pequeno') {
      return 14;
    }

    if (_tamanhoFonte == 'Grande') {
      return 22;
    }

    return 18;
  }

  @override
  void dispose() {
    _nomeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double tamanhoFonte = _getTamanhoFonte();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configurações Locais',
          style: TextStyle(fontSize: tamanhoFonte),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              // MODO ESCURO
              Card(
                child: SwitchListTile(
                  title: Text(
                    'Modo Escuro',
                    style: TextStyle(fontSize: tamanhoFonte),
                  ),

                  subtitle: Text(
                    'Ativar visual escuro na aplicação',
                    style: TextStyle(
                      fontSize: tamanhoFonte - 2,
                    ),
                  ),

                  secondary: Icon(
                    _temaEscuroIcone(),
                  ),

                  value: widget.temaEscuro,

                  onChanged: widget.onTemaAlterado,
                ),
              ),

              const SizedBox(height: 20),

              // PERFIL
              Text(
                'Perfil do Usuário',
                style: TextStyle(
                  fontSize: tamanhoFonte,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // NOME
              TextField(
                controller: _nomeController,

                decoration: const InputDecoration(
                  labelText: 'Nome do Usuário',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 10),

              // BOTÃO SALVAR NOME
              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  onPressed: _salvarNome,

                  icon: const Icon(Icons.save),

                  label: Text(
                    'Salvar Nome',
                    style: TextStyle(
                      fontSize: tamanhoFonte - 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // EXERCÍCIO 02
              // TAMANHO DA FONTE
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        'Tamanho da Fonte',
                        style: TextStyle(
                          fontSize: tamanhoFonte,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      DropdownButton<String>(
                        value: _tamanhoFonte,

                        isExpanded: true,

                        items: const [
                          DropdownMenuItem(
                            value: 'Pequeno',
                            child: Text('Pequeno'),
                          ),

                          DropdownMenuItem(
                            value: 'Médio',
                            child: Text('Médio'),
                          ),

                          DropdownMenuItem(
                            value: 'Grande',
                            child: Text('Grande'),
                          ),
                        ],

                        onChanged: (valor) {
                          if (valor != null) {
                            _alterarTamanhoFonte(valor);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // EXERCÍCIO 03
              // NOTIFICAÇÕES
              Card(
                child: SwitchListTile(
                  title: Text(
                    'Receber Notificações',
                    style: TextStyle(
                      fontSize: tamanhoFonte,
                    ),
                  ),

                  subtitle: Text(
                    'Ativar ou desativar notificações',
                    style: TextStyle(
                      fontSize: tamanhoFonte - 2,
                    ),
                  ),

                  secondary: const Icon(
                    Icons.notifications,
                  ),

                  value: _receberNotificacoes,

                  onChanged: _alterarNotificacoes,
                ),
              ),

              const Divider(height: 40),

              // NOME SALVO
              Text(
                'Valor atual salvo no disco: $_nomeSalvo',

                style: TextStyle(
                  fontSize: tamanhoFonte,
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 20),

              // INFORMAÇÕES DAS CONFIGURAÇÕES
              Text(
                'Configurações atuais:',

                style: TextStyle(
                  fontSize: tamanhoFonte,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Fonte: $_tamanhoFonte',

                style: TextStyle(
                  fontSize: tamanhoFonte,
                ),
              ),

              Text(
                'Notificações: ${_receberNotificacoes ? 'Ativadas' : 'Desativadas'}',

                style: TextStyle(
                  fontSize: tamanhoFonte,
                ),
              ),

              const SizedBox(height: 25),

              // EXERCÍCIO 01
              // LIMPAR CONFIGURAÇÕES
              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  onPressed: _limparConfiguracoes,

                  icon: const Icon(
                    Icons.delete_forever,
                  ),

                  label: Text(
                    'Limpar Configurações',
                    style: TextStyle(
                      fontSize: tamanhoFonte - 2,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _temaEscuroIcone() {
    return widget.temaEscuro
        ? Icons.dark_mode
        : Icons.light_mode;
  }
}