import 'package:flutter/material.dart';

class VideoToLibrary with ChangeNotifier {
  List<Map<String, String>> _videos = [];

  List<Map<String, String>> get videos => _videos;

  void addVideo(String thumbnail, String title) {
    _videos.add({'thumbnail': thumbnail, 'title': title});
    notifyListeners();
  }
}

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _Library();
}

class _Library extends State<LibraryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(20),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Biblioteca de Resúmenes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
