// lib/screens/extra/news_screen.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Importa el paquete url_launcher
import '../../models/news.dart';
import '../../services/news_service.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsService _newsService = NewsService();
  late Future<List<News>> _newsList;

  @override
  void initState() {
    super.initState();
    _newsList = _newsService.fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticias'),
      ),
      body: FutureBuilder<List<News>>(
        future: _newsList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final newsList = snapshot.data ?? [];
            return ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: news.image.isNotEmpty
                        ? Image.network(news.image, width: 100, fit: BoxFit.cover)
                        : const SizedBox(width: 100, height: 100, child: Icon(Icons.image, size: 50, color: Colors.grey)),
                    title: Text(news.title),
                    subtitle: Text(news.description),
                    onTap: () => _showNewsDetail(context, news),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showNewsDetail(BuildContext context, News news) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(news.title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (news.image.isNotEmpty)
                  Image.network(news.image, fit: BoxFit.cover),
                const SizedBox(height: 10),
                Text(news.content),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _openNewsLink(news.link),
                  child: const Text(
                    'Leer más',
                    style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openNewsLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se pudo abrir el enlace: $url';
    }
  }
}
