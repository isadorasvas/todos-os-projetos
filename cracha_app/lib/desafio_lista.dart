import 'package:flutter/material.dart';
import 'widgets/cartao_estudante.dart';

class DesafioLista extends StatelessWidget {
  const DesafioLista({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PPDM - Identificação Estudantil',
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CartaoEstudante(
              nome: 'Ana Silva Santos',
              curso: 'Desenvolvimento Mobile / PPDM',
              ra: '2026109923',
              email: 'ana.silva@estudante.edu.br',
              imagem: 'https://i.pravatar.cc/150?img=47',
            ),

            const SizedBox(height: 20),

            const CartaoEstudante(
              nome: 'Carlos Oliveira',
              curso: 'Desenvolvimento de Sistemas',
              ra: '2026109924',
              email: 'carlos.oliveira@estudante.edu.br',
              imagem: 'https://i.pravatar.cc/150?img=12',
            ),

            const SizedBox(height: 20),

            const CartaoEstudante(
              nome: 'Mariana Santos',
              curso: 'Análise e Desenvolvimento de Sistemas',
              ra: '2026109925',
              email: 'mariana.santos@estudante.edu.br',
              imagem: 'https://i.pravatar.cc/150?img=32',
            ),
          ],
        ),
      ),
    );
  }
}
