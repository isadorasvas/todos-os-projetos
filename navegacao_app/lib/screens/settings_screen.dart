import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _tamanhoFonte = 'Médio';
  bool _receberNotificacoes = true;

  @override
  void initState() {
    super.initState();
    _carregarConfiguracoes();
  }

  Future<void> _carregarConfiguracoes() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _tamanhoFonte = prefs.getString('tamanhoFonte') ?? 'Médio';
      _receberNotificacoes =
          prefs.getBool('receberNotificacoes') ?? true;
    });
  }

  Future<void> _salvarTamanhoFonte(String tamanho) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('tamanhoFonte', tamanho);

    setState(() {
      _tamanhoFonte = tamanho;
    });
  }

  Future<void> _salvarNotificacoes(bool valor) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('receberNotificacoes', valor);

    setState(() {
      _receberNotificacoes = valor;
    });
  }

  Future<void> _limparConfiguracoes() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    setState(() {
      _tamanhoFonte = 'Médio';
      _receberNotificacoes = true;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configurações limpas com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  double get _tamanhoFonteAtual {
    switch (_tamanhoFonte) {
      case 'Pequeno':
        return 14;
      case 'Grande':
        return 22;
      default:
        return 18;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Configurações do aplicativo',
            style: TextStyle(
              fontSize: _tamanhoFonteAtual + 4,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tamanho da fonte',
                    style: TextStyle(
                      fontSize: _tamanhoFonteAtual,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  RadioListTile<String>(
                    title: Text(
                      'Pequeno',
                      style: const TextStyle(fontSize: 14),
                    ),
                    value: 'Pequeno',
                    groupValue: _tamanhoFonte,
                    onChanged: (valor) {
                      if (valor != null) {
                        _salvarTamanhoFonte(valor);
                      }
                    },
                  ),

                  RadioListTile<String>(
                    title: Text(
                      'Médio',
                      style: const TextStyle(fontSize: 18),
                    ),
                    value: 'Médio',
                    groupValue: _tamanhoFonte,
                    onChanged: (valor) {
                      if (valor != null) {
                        _salvarTamanhoFonte(valor);
                      }
                    },
                  ),

                  RadioListTile<String>(
                    title: Text(
                      'Grande',
                      style: const TextStyle(fontSize: 22),
                    ),
                    value: 'Grande',
                    groupValue: _tamanhoFonte,
                    onChanged: (valor) {
                      if (valor != null) {
                        _salvarTamanhoFonte(valor);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: SwitchListTile(
              title: Text(
                'Receber Notificações',
                style: TextStyle(
                  fontSize: _tamanhoFonteAtual,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                _receberNotificacoes
                    ? 'Notificações ativadas'
                    : 'Notificações desativadas',
                style: TextStyle(
                  fontSize: _tamanhoFonteAtual - 2,
                ),
              ),
              value: _receberNotificacoes,
              onChanged: _salvarNotificacoes,
            ),
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _limparConfiguracoes,
              icon: const Icon(Icons.delete_sweep),
              label: Text(
                'Limpar Configurações',
                style: TextStyle(
                  fontSize: _tamanhoFonteAtual,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}