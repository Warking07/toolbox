import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  bool loading = true;
  Map? weather;

  Future<void> fetchWeather() async {
    setState(() {
      loading = true;
    });
    final lat = 18.4861, lon = -69.9312; // Santo Domingo
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&daily=temperature_2m_max,temperature_2m_min,weathercode&timezone=America%2FSanto_Domingo',
    );
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      setState(() {
        weather = data;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clima — República Dominicana (Santo Domingo)'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: loading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Clima diario (primer registro):',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  if (weather != null) ...[
                    Text('Fecha: ${weather!['daily']['time'][0]}'),
                    Text(
                      'Temp max: ${weather!['daily']['temperature_2m_max'][0]} °C',
                    ),
                    Text(
                      'Temp min: ${weather!['daily']['temperature_2m_min'][0]} °C',
                    ),
                    Text(
                      'Weather code: ${weather!['daily']['weathercode'][0]}',
                    ),
                  ] else
                    Text('No se pudo obtener el clima.'),
                ],
              ),
      ),
    );
  }
}
