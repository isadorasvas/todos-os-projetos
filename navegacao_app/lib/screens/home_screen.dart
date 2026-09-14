import 'package:flutter/material.dart';
import '../models/produto.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Produto> _produtos = [
    Produto(
      nome: 'Notebook Pro',
      descricao: 'Processador de última geração, 16GB RAM, SSD 512GB.',
      preco: 4500.00,
    ),
    Produto(
      nome: 'Smartphone X',
      descricao: 'Tela AMOLED 120Hz, Câmera Tripla de 50MP.',
      preco: 2800.00,
    ),
    Produto(
      nome: 'Fone Bluetooth',
      descricao: 'Cancelamento ativo de ruído e bateria de até 30h.',
      preco: 350.00,
    ),
  ];

  Future<void> _adicionarProduto() async {
    final resultado = await Navigator.pushNamed(
      context,
      '/adicionar',
    );

    if (resultado is Produto && mounted) {
      setState(() {
        _produtos.add(resultado);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produto adicionado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _abrirDetalhes(Produto produto) async {
    final resultado = await Navigator.pushNamed(
      context,
      '/detalhes',
      arguments: produto,
    );

    if (resultado != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Retorno da tela: $resultado'),
          backgroundColor: Colors.indigo,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Produtos'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: ListView.builder(
        itemCount: _produtos.length,
        itemBuilder: (ctx, index) {
          final prod = _produtos[index];

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),

            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.indigoAccent,
                child: Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                ),
              ),

              title: Text(
                prod.nome,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                'R\$ ${prod.preco.toStringAsFixed(2)}',
              ),

              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),

              onTap: () => _abrirDetalhes(prod),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarProduto,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}