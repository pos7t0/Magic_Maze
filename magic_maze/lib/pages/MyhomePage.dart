import 'package:flutter/material.dart';
import 'package:magic_maze/utils/api_helper.dart';
import 'package:magic_maze/models/magic_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final MagicApiHelper apiHelper = MagicApiHelper();
  List<MagicCard> _cards = []; // Lista para almacenar las cartas obtenidas

  // Lista de las páginas que quieres mostrar
  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Página 1')),
    Center(child: Text('Página 2')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Método que se ejecuta al presionar el botón para obtener cartas aleatorias
  void _fetchRandomCards() async {
    try {
      // Solicitar un número aleatorio de cartas dentro del rango permitido
      const int randomCount = 60; // Cambiar a cualquier valor entre 60 y 100
      List<MagicCard> cards =
          await apiHelper.fetchRandomCards(count: randomCount);
      setState(() {
        _cards = cards;
      });
    } catch (e) {
      // Si ocurre un error, mostramos un mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar cartas: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _pages[_selectedIndex], // Página seleccionada
            ),
            ElevatedButton(
              onPressed:
                  _fetchRandomCards, // Llamar al método cuando se presiona el botón
              child: const Text('Obtener Cartas'),
            ),
            // Mostrar las cartas obtenidas (si las hay)
            if (_cards.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _cards.length,
                  itemBuilder: (context, index) {
                    var card = _cards[index];
                    return ListTile(
                      title: Text(
                          card.name), // Acceder a las propiedades directamente
                      subtitle: Text(
                          card.type), // Acceder a las propiedades directamente
                    );
                  },
                ),
              ),
          ],
        ),
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
