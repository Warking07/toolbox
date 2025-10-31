import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class UniversitiesPage extends StatefulWidget {
  @override
  _UniversitiesPageState createState() => _UniversitiesPageState();
}

class _UniversitiesPageState extends State<UniversitiesPage> {
  final _controller = TextEditingController(text: '');
  List universities = [];
  bool loading = false;

  Future<void> fetchUniversities(String country) async {
    setState(() {
      loading = true;
      universities = [];
    });
    final q = Uri.encodeComponent(country);
    final url = Uri.parse('http://universities.hipolabs.com/search?country=$q');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List;
      setState(() {
        universities = data;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Universidades por país')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'País (En Ingles)'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => fetchUniversities(_controller.text.trim()),
              child: Text('Buscar'),
            ),
            SizedBox(height: 12),
            if (loading) CircularProgressIndicator(),
            if (!loading)
              Expanded(
                child: ListView.builder(
                  itemCount: universities.length,
                  itemBuilder: (context, i) {
                    final u = universities[i];
                    final name = u['name'] ?? '';
                    final domains = (u['domains'] as List).cast<String>();
                    final webPages = (u['web_pages'] as List).cast<String>();
                    return Card(
                      child: ListTile(
                        title: Text(name),
                        subtitle: Text(domains.join(', ')),
                        trailing: IconButton(
                          icon: Icon(Icons.open_in_new),
                          onPressed: () async {
                            final url = webPages.isNotEmpty
                                ? webPages[0]
                                : null;
                            if (url != null && await canLaunch(url))
                              launch(url);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
