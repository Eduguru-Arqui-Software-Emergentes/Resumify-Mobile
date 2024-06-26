import 'package:flutter/material.dart';
import 'package:resumify_mobile/services/resumen_service.dart';
import 'package:resumify_mobile/services/transcription_service.dart';
import 'package:resumify_mobile/services/translate_service.dart';

import '../../models/resumen_model.dart';
import '../views/convert_summary_view.dart';

class ConvertToText extends StatefulWidget {
  final String urlVideo;
  final String title;
  final String thumbnailUrl;

  const ConvertToText({super.key, required this.urlVideo, required this.title, required this.thumbnailUrl});

  @override
  State<ConvertToText> createState() => _ConvertToTextState();
}

class _ConvertToTextState extends State<ConvertToText> {
  String _transcripttedText = '';
  String _lang = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Transcripción del Video:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              FutureBuilder(
                  future: TranscriptionService.transcript(widget.urlVideo),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text('Transcribiendo...', style: TextStyle(fontSize: 16)),
                        ],
                      );
                    } else {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final trascripttedText = snapshot.data!;
                        _lang = trascripttedText.lang ?? 'es';
                        _transcripttedText = trascripttedText.message ?? 'No se pudo transcribir el video';
                        return Container(
                          padding: const EdgeInsets.all(10),
                          color: const Color.fromRGBO(229, 229, 229, 100),
                          child: Column(
                            children: [
                              Text(
                                'Lenguaje: ${_lang}',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _transcripttedText,
                                style: const TextStyle(fontSize: 16),
                              ),
                              /*const SizedBox(height: 20),
                              Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          final translation = await TranslateService.translate(_transcripttedText, 'es');
                                          setState(() {
                                            _transcripttedText = translation.text ?? 'No se pudo traducir el texto';
                                          }
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                        ),
                                        child: const Text('Traducir', style: TextStyle(color: Colors.white)),
                                      ),
                                    )
                                  ]
                              ),*/
                            ],
                          ),
                        );
                      }
                    }
                  }
              ),


              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConvertToSummary(title: widget.title, message: _transcripttedText, thumbnailUrl: widget.thumbnailUrl),
                          ),);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Resumir', style: TextStyle(color: Colors.white)),
                    ),
                  )
                ]
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          final resumen = ResumenModel(
                            title: widget.title,
                            content: _transcripttedText,
                            thumbnail: widget.thumbnailUrl,
                            dayAdded: DateTime.now().toString(),
                            link: widget.urlVideo,
                          );
                          await ResumenService.addResumen(resumen);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Resumen guardado correctamente'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(250, 40),
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Guardar resumen', style: TextStyle(color: Colors.white),)
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
  }
}
