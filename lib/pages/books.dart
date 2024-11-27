import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyBooks extends StatefulWidget {
  const MyBooks({super.key});

  @override
  State<MyBooks> createState() => _MyBooksState();
}

class _MyBooksState extends State<MyBooks> {
  late final User? user;
  late final CollectionReference<Map<String, dynamic>> userBooksRef;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      userBooksRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('myBooks');
    }
  }

  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Meus Livros'),
        ),
        body: Center(
          child: Text('Usuário não autenticado!'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Livros'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userBooksRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('Nenhum livro adicionado'),
            );
          }

          final books = snapshot.data!.docs;

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return ListTile(
                leading: Icon(Icons.book),
                title: Text(book['title'] ?? 'Título não disponível'),
                subtitle: Text(book['author'] ?? 'Autor não disponível'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await userBooksRef.doc(book.id).delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Removido de Meus Livros')),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}