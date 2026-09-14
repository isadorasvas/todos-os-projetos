import 'package:flutter/material.dart';
import '../models/produto.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  Future<void> _confirmarVolta(BuildContext context) async {
    final resultado = await showDialog<bool>(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text('Voltar?'),

          content: const Text(
            'Você deseja realmente voltar para a lista de produtos?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Não'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Sim, voltar'),
            ),
          ],
        );
      },
    );

    if (resultado == true && context.mounted) {
      Navigator.pop(context, 'Produto confirmado!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final produto =
        ModalRoute.of(context)!.settings.arguments as Produto;

    return Scaffold(
      appBar: AppBar(
        title: Text(produto.nome),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              produto.nome,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'R\$ ${produto.preco.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              produto.descricao,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                onPressed: () {
                  _confirmarVolta(context);
                },

                icon: const Icon(Icons.arrow_back),

                label: const Text('Voltar e Confirmar'),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}