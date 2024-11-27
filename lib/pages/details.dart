import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    getDetails();
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
              _cover.isNotEmpty
                  ? Center(
                      child: Image.network(
                        _cover,
                        height: 250,
                      ),
                    )
                  : const Center(
                      child: Text('Imagem da capa não disponível'),
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
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bookmark_add_outlined),
                    Text('Adicionar a Meus Livros'),
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