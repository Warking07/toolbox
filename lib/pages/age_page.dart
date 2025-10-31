import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AgePage extends StatefulWidget {
  @override
  _AgePageState createState() => _AgePageState();
}

class _AgePageState extends State<AgePage> {
  final _controller = TextEditingController();
  int? age;
  String? category;
  bool loading = false;

  Future<void> fetchAge(String name) async {
    setState(() {
      loading = true;
      age = null;
      category = null;
    });
    final url = Uri.parse(
      'https://api.agify.io/?name=${Uri.encodeComponent(name)}',
    );
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final a = (data['age'] as num?)?.toInt();
      String cat = 'Desconocido';
      if (a != null) {
        if (a < 30)
          cat = 'Joven';
        else if (a < 60)
          cat = 'Adulto';
        else
          cat = 'Anciano';
      }
      setState(() {
        age = a;
        category = cat;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
        category = 'Error';
      });
    }
  }

  String imageForCategory() {
    if (category == 'Joven') return 'assets/joven.jpg';
    if (category == 'Adulto') return 'assets/adulto.jpg';
    if (category == 'Anciano') return 'assets/anciano.jpg';
    return 'assets/desconocido.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Determinar edad')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => fetchAge(_controller.text.trim()),
              child: Text('Consultar edad'),
            ),
            SizedBox(height: 20),
            if (loading) CircularProgressIndicator(),
            if (!loading && category != null) ...[
              Image.asset(imageForCategory(), height: 120),
              SizedBox(height: 8),
              Text(
                'Edad: ${age?.toString() ?? '—'}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Clasificación: ${category}',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
