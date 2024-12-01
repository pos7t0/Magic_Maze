import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: const Color.fromARGB(255, 11, 34, 63),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(255, 15, 50, 92),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sobre la aplicación',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Magic Maze es una herramienta diseñada para los amantes del juego de cartas Magic: The Gathering. '
                'Permite gestionar mazos, buscar cartas y construir estrategias personalizadas de manera eficiente. '
                'También ofrece mazos aleatorios para inspirar a los jugadores y explorar nuevas posibilidades.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Características principales',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildFeatureCard(
                iconWidget: const Icon(Icons.search, color: Colors.white, size: 40),
                title: 'Búsqueda avanzada',
                description: 'Busca cartas fácilmente por nombre, tipo o habilidades.',
              ),
              _buildFeatureCard(
                iconWidget: SvgPicture.asset(
                  'assets/icons/Management.svg',
                  width: 40,
                  height: 40,
                  color: Colors.white, // Blanco para SVG
                ),
                title: 'Gestión de mazos',
                description: 'Crea, edita y organiza tus mazos favoritos.',
              ),
              _buildFeatureCard(
                iconWidget: const Icon(Icons.sync, color: Colors.white, size: 40),
                title: 'Actualizaciones constantes',
                description: 'Obtén las cartas más recientes del juego con nuestras actualizaciones.',
              ),
              const SizedBox(height: 24),
              const Text(
                'Equipo de desarrollo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildDeveloperCard(
                name: 'Vicente Santander',
                role: 'Programador principal',
                description:
                    'Apasionado por los videojuegos y experto en Flutter. Diseñó el núcleo de la aplicación.',
              ),
              _buildDeveloperCard(
                name: 'Rodrigo Soto',
                role: 'Diseñador / Programador',
                description:
                    'Encargado de crear una interfaz amigable y atractiva para los usuarios, además de ser responsable de encontrar la API.',
              ),
              const SizedBox(height: 24),
              const Text(
                '¡Gracias por usar Magic Maze!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required Widget iconWidget,
    required String title,
    required String description,
  }) {
    return Card(
      color: const Color.fromARGB(255, 20, 40, 70),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: iconWidget,
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  Widget _buildDeveloperCard({required String name, required String role, required String description}) {
    return Card(
      color: const Color.fromARGB(255, 20, 40, 70),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              role,
              style: const TextStyle(color: Colors.white70, fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}