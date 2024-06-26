import 'package:flutter/material.dart';
import 'package:resumify_mobile/models/resumen_model.dart';
import 'package:resumify_mobile/presentation/views/convert_summary_view.dart';
import 'package:resumify_mobile/services/resumen_service.dart';

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
      appBar: AppBar(
        title: const Text('Biblioteca de Resúmenes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resúmenes guardados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            FutureBuilder(
                future: ResumenService.getResumenes(),
                builder: (context, snapshot) {
                  List<ResumenModel> resumenes = snapshot.data ?? [];
                  if (resumenes.isEmpty) {
                    return const Text('No hay resúmenes guardados');
                  } else {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: resumenes.length,
                          itemBuilder: (context, index) {
                            var resumen = resumenes[index];
                            return Padding(
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
                                            child: Image.network(resumen.thumbnail ?? "", width: double.infinity, height: 200, fit: BoxFit.cover),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            resumen.title ?? "",
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => ConvertToSummary(title: resumen.title!, message: resumen.content!, thumbnailUrl: resumen.thumbnail!)
                                                      ));
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.blue,
                                                  ),
                                                  child: const Text('Ver Resumen', style: TextStyle(color: Colors.white)),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                  )
                              ),
                            );
                          }
                      ),
                    );
                  }
                }
            )
          ],
        ),
      )
    );
  }
}
