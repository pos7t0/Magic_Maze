import 'package:flutter/material.dart';
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
    RandomDeckPage(),
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.house_outlined),
            label: 'Casa',
            backgroundColor: Color.fromARGB(255, 168, 71, 36),
          ),
          BottomNavigationBarItem(
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
