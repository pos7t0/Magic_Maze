import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:magic_maze/pages/randomDeckPage.dart';
import 'package:magic_maze/pages/decks.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // Lista de las páginas que quieres mostrar
  static const List<Widget> _pages = <Widget>[
    RandomDeckPage(),
    DecksPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages[_selectedIndex], // Mostrar la página seleccionada
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/Prueba.svg',
              semanticsLabel: 'user Logo',
              width: 20,
            ),
            label: 'Casa',
            backgroundColor: const Color.fromARGB(255, 168, 71, 36),
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.house_outlined),
            label: 'Casa',
            backgroundColor: Color.fromARGB(255, 168, 71, 36),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
