import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:magic_maze/pages/decks.dart';
import 'package:magic_maze/pages/randomDeckPage.dart';

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
              'assets/icons/CardRandom.svg',
              semanticsLabel: 'Random Deck',
              width: 30,
              color: _selectedIndex == 0
                  ? Colors.white// Blanco para seleccionado
                  : const Color.fromARGB(255, 2, 124, 224), // Azul para no seleccionado
            ),
            label: 'Random Deck',
            backgroundColor: const Color.fromARGB(255, 11, 34, 63),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/Save.svg',
              semanticsLabel: 'Save Deck',
              width: 30,
              color: _selectedIndex == 1
                  ? Colors.white // Blanco para seleccionado
                  : const Color.fromARGB(255, 2, 124, 224), // Azul para no seleccionado
            ),
            label: 'Saved Decks',
            backgroundColor: const Color.fromARGB(255, 11, 34, 63),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255), // Color del ícono seleccionado
        unselectedItemColor: Colors.white, // Color del ícono no seleccionado
        onTap: _onItemTapped,
      ),
    );
  }
}