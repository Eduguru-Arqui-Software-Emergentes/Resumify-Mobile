import 'package:flutter/material.dart';
import 'package:resumify_mobile/models/transcription_model.dart';
import 'package:resumify_mobile/services/transcription_service.dart';

import '../views/convert_summary_view.dart';

class ConvertToText extends StatefulWidget {
  final String urlVideo;
  final String title;
  final String thumbnailUrl;

  const ConvertToText({super.key, required this.urlVideo, required this.title, required this.thumbnailUrl});

  @override
  State<ConvertToText> createState() => _ConvertToTextState(urlVideo: urlVideo);
}

class _ConvertToTextState extends State<ConvertToText> {
  final String urlVideo;
  _ConvertToTextState({required this.urlVideo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transcript your video", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: true),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const SizedBox(height: 40),

              Text(
                '${widget.title}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              Image.network('${widget.thumbnailUrl}'),

              const SizedBox(height: 20),

              const Text(
                'Conversión del Video',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              FutureBuilder(
                  future: TranscriptionService.transcript(urlVideo),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final trascripttedText = snapshot.data!;
                        return Container(
                          width: 300,
                          padding: const EdgeInsets.all(10),
                          color: const Color.fromRGBO(229, 229, 229, 100),
                          child: Column(
                            children: [
                              Text(
                                'Lenguaje: ${trascripttedText.lang ?? 'No se pudo detectar el lenguaje'}',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                trascripttedText.message ?? 'No se pudo transcribir el video',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  }
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConvertToSummary(title: '${widget.title}', thumbnailUrl: '${widget.thumbnailUrl}'),
                    ),);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 40),
                  backgroundColor: const Color.fromRGBO(77, 148, 255, 100),
                ),
                child: const Text('Resumir'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
