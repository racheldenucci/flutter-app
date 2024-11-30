import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/details.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _isbnController = TextEditingController();
  String _bookName = 'empty';
  String _authorName = 'empty';
  String _bookCover = '';
  bool _isLoading = false;

  Future<void> getBook(String isbn) async {
    setState(() {
      _isLoading = true;
      _bookName = 'empty';
      _authorName = 'empty';
      _bookCover = '';
    });

    try {
      var dio = Dio();

      var response = await dio.request(
        'https://brasilapi.com.br/api/isbn/v1/$isbn?providers=open-library,google-books',
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
          _bookCover = data['cover_url'] ?? 'empty';
          _bookName = data['title'] ?? 'Livro não encontrado';
          _authorName = data['authors']?[0] ?? 'Nome do autor não encontrado';
        });
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        setState(() {
          _bookName = '404: Livro não disponível, por favor tente outro.';
        });
      } else {
        setState(() {
          _bookName = 'Erro ao buscar livro: $e';
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Busca por ISBN'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _isbnController,
              decoration: InputDecoration(
                labelText: 'Digite o ISBN',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search_rounded),
                  onPressed: () {
                    final isbn = _isbnController.text.trim();
                    if (isbn.isNotEmpty) {
                      getBook(isbn);
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            if(_isLoading)
              CircularProgressIndicator()
            else if (_bookName != 'empty')
              Column(
                children: [
                  Text(
                    '$_bookName - $_authorName',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _bookCover != 'empty'
                      ? Image.network(_bookCover, height: 200)
                      : Text('Imagem da capa não disponível'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[400],
                      padding: EdgeInsets.all(14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Details(isbn: _isbnController.text),
                        ),
                      );
                    },
                    child: Text(
                      'Mais detalhes',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}