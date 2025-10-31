import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class WordpressPage extends StatefulWidget {
  const WordpressPage({Key? key}) : super(key: key);

  @override
  State<WordpressPage> createState() => _WordpressPageState();
}

class _WordpressPageState extends State<WordpressPage> {
  final String site = 'https://kinsta.com'; // sitio fijo
  List posts = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final res = await http.get(
        Uri.parse('$site/wp-json/wp/v2/posts?per_page=3'),
      );
      if (res.statusCode == 200) posts = json.decode(res.body);
    } catch (_) {}
    setState(() => loading = false);
  }

  String _clean(String html) => html.replaceAll(RegExp(r'<[^>]*>'), '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticias WordPress')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset('assets/logo.jpg', height: 100),
            const SizedBox(height: 10),
            if (loading)
              const CircularProgressIndicator()
            else if (posts.isEmpty)
              const Text('No se encontraron noticias.')
            else
              Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (c, i) {
                    final p = posts[i];
                    return ListTile(
                      title: Text(_clean(p['title']['rendered'] ?? '')),
                      subtitle: Text(
                        _clean(p['excerpt']['rendered'] ?? ''),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.open_in_new),
                      onTap: () => launchUrl(Uri.parse(p['link'] ?? '')),
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
