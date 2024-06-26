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
  _YouTubeVideoDetailsState createState() => _YouTubeVideoDetailsState(videoUrl: videoUrl);
}

class _YouTubeVideoDetailsState extends State<YouTubeVideoDetails> {
  final String videoUrl;
  _YouTubeVideoDetailsState({required this.videoUrl});

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
          return const Center( child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final videoDetails = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Detalles de video de youtube:',
                style: const TextStyle(fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(videoDetails['thumbnailUrl']!, width: double.infinity, height: 200, fit: BoxFit.cover),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          videoDetails['title']!,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  )
                ),
              ),

              if (videoDetails['title'] != 'VIDEO NO ENCONTRADO')
                Column(
                  children: [
                    ConvertToText(urlVideo: videoUrl, title: videoDetails['title']!, thumbnailUrl: videoDetails['thumbnailUrl']!),
                  ],
                )
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
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enlace de video de Youtube :',
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
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _videoURL = _controller.text;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(250, 40),
                            backgroundColor: Colors.lightBlue),
                        child: const Text('Transcribir video', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_videoURL.isNotEmpty)
                  YouTubeVideoDetails(videoUrl: _videoURL),
              ],
            ),
          ),
      ),
    );
  }
}