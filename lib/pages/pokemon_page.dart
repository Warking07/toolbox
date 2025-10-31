import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:just_audio/just_audio.dart';

class PokemonPage extends StatefulWidget {
  @override
  _PokemonPageState createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  final _controller = TextEditingController(text: '');
  Map? pokemon;
  String? cryUrl;
  bool loading = false;

  final player = AudioPlayer();

  Future<void> fetchPokemon(String name) async {
    setState(() {
      loading = true;
      pokemon = null;
      cryUrl = null;
    });

    try {
      final url = Uri.parse(
        'https://pokeapi.co/api/v2/pokemon/${Uri.encodeComponent(name.toLowerCase())}',
      );
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final pokeId = data['id'];
        final cry =
            'https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/$pokeId.ogg';

        setState(() {
          pokemon = data;
          cryUrl = cry;
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Pokémon no encontrado')));
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar Pokémon')));
    }
  }

  Future<void> playSound() async {
    if (cryUrl != null) {
      try {
        await player.setUrl(cryUrl!);
        player.play();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo reproducir el sonido')),
        );
      }
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buscar Pokémon')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Nombre del Pokémon'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => fetchPokemon(_controller.text.trim()),
              child: Text('Buscar'),
            ),
            SizedBox(height: 12),
            if (loading) CircularProgressIndicator(),
            if (!loading && pokemon != null) ...[
              Image.network(
                pokemon!['sprites']['front_default'] ?? '',
                height: 120,
              ),
              SizedBox(height: 8),
              Text('Experiencia base: ${pokemon!['base_experience']}'),
              Text('Habilidades:'),
              for (var a in pokemon!['abilities'])
                Text('- ${a['ability']['name']}'),
              SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: playSound,
                icon: Icon(Icons.volume_up),
                label: Text('Reproducir sonido'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
