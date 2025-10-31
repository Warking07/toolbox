import 'package:flutter/material.dart';
import 'gender_page.dart';
import 'age_page.dart';
import 'universities_page.dart';
import 'weather_page.dart';
import 'pokemon_page.dart';
import 'wordpress_page.dart';
import 'about_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Aplicación multi-herramienta')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Image.asset('assets/toolbox.jpg', height: 180, fit: BoxFit.cover),
          SizedBox(height: 12),
          ElevatedButton.icon(
            icon: Icon(Icons.person_search),
            label: Text('Predecir género por nombre'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => GenderPage()),
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.cake),
            label: Text('Determinar edad por nombre'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AgePage()),
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.school),
            label: Text('Buscar universidades por país'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UniversitiesPage()),
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.wb_sunny),
            label: Text('Clima en República Dominicana (hoy)'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => WeatherPage()),
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.catching_pokemon),
            label: Text('Buscar Pokémon'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PokemonPage()),
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.web),
            label: Text('Noticias desde un sitio WordPress'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => WordpressPage()),
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.info_outline),
            label: Text('Acerca de'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AboutPage()),
            ),
          ),
        ],
      ),
    );
  }
}
