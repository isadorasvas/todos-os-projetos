import 'package:flutter/material.dart';

void main() {
  runApp(const CrachaApp());
}

class CrachaApp extends StatelessWidget {
  const CrachaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blueGrey[900],
        appBar: AppBar(
          title: const Text('Crachá Digital'),
          centerTitle: true,
          backgroundColor: Colors.blueGrey[800],
        ),
        body: const Center(
          child: CartaoCracha(),
        ),
      ),
    );
  }
}

class CartaoCracha extends StatelessWidget {
  const CartaoCracha({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Exercício 4: fundo gradiente
        gradient: const LinearGradient(
          colors: [
            Colors.white,
            Colors.blueGrey,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Exercício 1: imagem usando NetworkImage
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/150',
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'Isaac Gonçalves',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const Text(
            'Desenvolvedor Flutter',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),

          const Divider(
            height: 30,
            thickness: 1,
          ),

          // Informações
          const Row(
            children: [
              Icon(
                Icons.email,
                color: Colors.blueAccent,
              ),
              SizedBox(width: 10),
              Text('isaac@email.com'),
            ],
          ),

          const SizedBox(height: 10),

          const Row(
            children: [
              Icon(
                Icons.phone,
                color: Colors.blueAccent,
              ),
              SizedBox(width: 10),
              Text('+55 (11) 99999-9999'),
            ],
          ),

          const SizedBox(height: 20),

          // Exercício 2: Sobre Mim
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Sobre Mim',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Sou estudante de programação e estou aprendendo '
            'a desenvolver aplicativos usando Flutter.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 15),

          // Exercício 3: habilidades usando Chip
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Habilidades',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 8),

          const Wrap(
            spacing: 6,
            runSpacing: 5,
            children: [
              Chip(
                label: Text('Flutter'),
                avatar: Icon(Icons.phone_android, size: 18),
              ),
              Chip(
                label: Text('Dart'),
                avatar: Icon(Icons.code, size: 18),
              ),
              Chip(
                label: Text('HTML'),
                avatar: Icon(Icons.web, size: 18),
              ),
              Chip(
                label: Text('CSS'),
                avatar: Icon(Icons.palette, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
