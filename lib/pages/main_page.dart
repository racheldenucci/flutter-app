import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/books.dart';
import 'package:flutter_application_2/pages/profile.dart';
import 'package:flutter_application_2/pages/scanner.dart';
//import 'package:flutter_application_2/pages/search.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final List<Widget> pages = [
    const Profile(),
    const MyBooks(),
    //const Search(),
    const Scanner(),
  ];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (value){
          setState(() {
            currentPage = value;
          });
        },
        items: const [ 
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Meu Perfil'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections_bookmark),
            label: 'Meus Livros'
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.search_rounded),
          //   label: 'Buscar por ISBN'
          // ), 
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_rounded),
            label: 'Ler Código'
          ),
        ],
      ),
    );
  }
}
