import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

import '../views/convert_text_view.dart';

String extractVideoId(String url) {
  RegExp regExp = RegExp(
    r'^(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})',
    caseSensitive: false,
  );
  Match? match = regExp.firstMatch(url);
  return match?.group(1) ?? '';
}

Future<Map<String, String>> fetchVideoDetails(String videoId) async {
  final response =
  await http.get(Uri.parse('https://www.youtube.com/watch?v=$videoId'));

  if (response.statusCode == 200) {
    var document = parse(response.body);
    String title =
        document.querySelector('meta[name="title"]')?.attributes['content'] ??
            'VIDEO NO ENCONTRADO';
    String thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';

    return {
      'title': title,
      'thumbnailUrl': thumbnailUrl,
    };
  } else {
    throw Exception('Failed to load video details');
  }
}

class YouTubeVideoDetails extends StatefulWidget {
  final String videoUrl;

  YouTubeVideoDetails({required this.videoUrl});

  @override
  _YouTubeVideoDetailsState createState() => _YouTubeVideoDetailsState();
}

class _YouTubeVideoDetailsState extends State<YouTubeVideoDetails> {
  late Future<Map<String, String>> _videoDetails;

  @override
  void didUpdateWidget(covariant YouTubeVideoDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      String videoId = extractVideoId(widget.videoUrl);
      _videoDetails = fetchVideoDetails(videoId);
    }
  }

  @override
  void initState() {
    super.initState();
    String videoId = extractVideoId(widget.videoUrl);
    _videoDetails = fetchVideoDetails(videoId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _videoDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final videoDetails = snapshot.data!;
          return Column(
            children: [
              Text(
                videoDetails['title']!,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Image.network(videoDetails['thumbnailUrl']!),
              const SizedBox(height: 20),
              if (videoDetails['title'] != 'VIDEO NO ENCONTRADO')
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConvertToText(title: videoDetails['title']!, thumbnailUrl: videoDetails['thumbnailUrl']!),
                      ),);

                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(250, 40),
                    backgroundColor: const Color.fromRGBO(77, 148, 255, 100),
                  ),
                  child: const Text('Convertir a Texto'),
                ),
            ],
          );
        }
      },
    );
  }
}

class SearchVideo extends StatefulWidget {
  const SearchVideo({super.key});

  @override
  State<SearchVideo> createState() => _SearchVideoState();
}

class _SearchVideoState extends State<SearchVideo> {
  String _videoURL = "";
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transcript your video", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: true,),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Enlace de video de Youtube :            ',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Pega el enlace aquí',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _videoURL = _controller.text;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(250, 40),
                      backgroundColor: const Color.fromRGBO(77, 148, 255, 100)),
                  child: const Text('Buscar video'),
                ),
                const SizedBox(height: 20),
                if (_videoURL.isNotEmpty)
                  YouTubeVideoDetails(videoUrl: _videoURL),
              ],
            ),
          ),
        ),
      ),
    );
  }
}