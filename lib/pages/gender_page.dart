import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GenderPage extends StatefulWidget {
  @override
  _GenderPageState createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  final _controller = TextEditingController();
  String? gender;
  double probability = 0.0;
  bool loading = false;

  Future<void> predict(String name) async {
    setState(() {
      loading = true;
      gender = null;
    });
    final url = Uri.parse(
      'https://api.genderize.io/?name=${Uri.encodeComponent(name)}',
    );
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      setState(() {
        gender = data['gender'];
        probability = (data['probability'] ?? 0).toDouble();
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
        gender = 'unknown';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMale = gender == 'male';
    final bgColor = (gender == null)
        ? Colors.white
        : (isMale ? Colors.blue[100] : Colors.pink[100]);

    return Scaffold(
      appBar: AppBar(title: Text('Predecir género')),
      body: Container(
        color: bgColor,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => predict(_controller.text.trim()),
              child: Text('Predecir'),
            ),
            SizedBox(height: 20),
            if (loading) CircularProgressIndicator(),
            if (!loading && gender != null) ...[
              Text(
                'Género: ${gender ?? "Desconocido"}',
                style: TextStyle(fontSize: 20),
              ),
              Text('Probabilidad: ${probability.toStringAsFixed(2)}'),
            ],
          ],
        ),
      ),
    );
  }
}
