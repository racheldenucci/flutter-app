import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Details extends StatefulWidget {
  final String isbn;

  const Details({super.key, required this.isbn});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  String _title = 'Carregando...';
  String _author = 'Carregando...';
  int _pages = 0;
  int _year = 0;
  String _synopsis = 'Carregando...';
  String _cover = '';
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    getDetails();
    checkIfFavorite();
  }

  Future<void> getDetails() async {
    try {
      var dio = Dio();
      var response = await dio.request(
        'https://brasilapi.com.br/api/isbn/v1/${widget.isbn}?providers=open-library,google-books',
        options: Options(
          method: 'GET',
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        var data = response.data;

        setState(() {
          _cover = data['cover_url'] ?? 'empty';
          _title = data['title'] ?? 'Livro não encontrado';
          _author = data['authors'][0] ?? 'Nome do autor não encontrado';
          _synopsis = data['synopsis'] ?? 'Sinópse não disponível';
          _pages = data['page_count'] ?? 0;
          _year = data['year'] ?? 0;
        });
      }
    } catch (e) {
      setState(() {
        _title = 'Erro ao buscar livro: $e';
      });
    }
  }

  Future<void> addToMyBooks(String title, String author, String isbn) async {
    final user = FirebaseAuth.instance.currentUser;
    print('Usuário autenticado: ${user?.uid}');
    if (user != null) {
      final userBooks = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('myBooks');

      await userBooks.doc(isbn).set({
        'title': title,
        'author': author,
      });

      setState(() {
        _isFavorite = true;
      });
    } else {
      throw Exception('Usuário não autenticado');
    }
  }

  Future<void> checkIfFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userBooks = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('myBooks');

      final doc = await userBooks.doc(widget.isbn).get();
      if (doc.exists) {
        setState(() {
          _isFavorite = true;
        });
      }
    }
  }

  Future<void> removeFromMyBooks(String isbn) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userBooks = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('myBooks');

      await userBooks.doc(isbn).delete();

      // Atualize o estado para refletir que o livro não é mais favorito
      setState(() {
        _isFavorite = false;
      });
    } else {
      throw Exception('Usuário não autenticado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
                  Center(
                      child: _cover != 'empty'
                          ? Image.network(
                              _cover,
                              height: 250,
                            )
                          : Text('Imagem da capa não disponível'),
                    ),
                  
              const SizedBox(height: 20),
              Text(
                _title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _author,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  try {
                    if (_isFavorite) {
                      await removeFromMyBooks(widget.isbn);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Removido de Meus Livros!')),
                      );
                    } else {
                      await addToMyBooks(_title, _author, widget.isbn);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Livro adicionado a Meus Livros!')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao adicionar livro: $e')),
                    );
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_isFavorite
                        ? Icons.check
                        : Icons.bookmark_add_outlined),
                    SizedBox(width: 8),
                    Text(
                        _isFavorite ? 'Adicionado' : 'Adicionar a Meus Livros'),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                '$_pages páginas',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Ano: $_year',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              Text(
                'Sinópse: \n $_synopsis',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
