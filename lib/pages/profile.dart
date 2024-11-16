import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/scanner.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  /* final List<Widget> pages = [
    const Profile(),
    const Scanner()
  ];

  int currentPage = 0; */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Este é o seu perfil'),
      ),
      /* bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (value){
          setState(() {
            currentPage = value;
          });
        },
        items: const [
          /* BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início'
          ), */
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Meu Perfil'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_rounded),
            label: 'Ler Código'
          ),
        ],
      ), */
    );
  }
}
