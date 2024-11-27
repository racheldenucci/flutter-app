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
        'https://brasilapi.com.br/api/isbn/v1/${widget.isbn}?providers=open-library|google-books|cbl|mercado-editorial',
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
      body: Padding(
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
              'Título: $_title',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Autor: $_author',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

//TODO: add ano e qnt paginas e adicionar aos favoritos/bookmark