import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:open_file/open_file.dart';
import 'package:resumify_mobile/services/summarize_service.dart';


class ConvertToSummary extends StatefulWidget {
  final String title;
  final String message;
  final String thumbnailUrl;

  ConvertToSummary({required this.title, required this.message, required this.thumbnailUrl});

  @override
  State<ConvertToSummary> createState() => _ConvertToSummaryState();
}

class _ConvertToSummaryState extends State<ConvertToSummary> {
  final TextEditingController _textEditingController = TextEditingController();
  String _summaryText = '';
  //final pw.Document pdf = pw.Document();


  Future<Uint8List> loadFont() async {
    final ByteData data = await rootBundle.load('assets/OpenSans-Regular.ttf');
    return data.buffer.asUint8List();
  }

  Future<pw.Font> loadCustomFont() async {
    final ByteData fontData =
    await rootBundle.load('assets/OpenSans-Regular.ttf');
    final pw.Font customFont = pw.Font.ttf(fontData.buffer.asByteData());
    return customFont;
  }

  Future<void> _createPdf(pw.Document pdf) async {
    final String title = widget.title;
    final pw.Font customFont = await loadCustomFont();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
                pw.Text(
                  title,
                  style: pw.TextStyle(font: customFont, fontSize: 18.0, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  "Transcripción del video",
                  style: pw.TextStyle(font: customFont, fontSize: 14.0, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                pw.Paragraph(
                  text: widget.message,
                  style: pw.TextStyle(font: customFont, fontSize: 12.0, fontWeight: pw.FontWeight.normal),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  "Resumen del video",
                  style: pw.TextStyle(font: customFont, fontSize: 14.0, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                pw.Paragraph(
                  text: _summaryText,
                  style: pw.TextStyle(font: customFont, fontSize: 12.0, fontWeight: pw.FontWeight.normal),
                ),
              ];
        },
      ),
    );
  }



  Future<void> _saveAndDownloadPdf() async {
    final pw.Document pdf = pw.Document();
    await _createPdf(pdf);


    // Obtener el directorio de descargas
    final Directory? downloadsDir = await getDownloadsDirectory();

    if (downloadsDir == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo obtener el directorio de descargas.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    final String downloadsPath = downloadsDir.path;
    final String filePath = '$downloadsPath/${widget.title}.pdf';

    // Guardar el PDF en el directorio de descargas
    final File file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Abrir el PDF usando open_file
    final result = await OpenFile.open(filePath);

    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo abrir el archivo PDF.'),
          duration: Duration(seconds: 3),
        ),
      );
    }

  }

  Future<void> _sharePdf() async {
    final pw.Document pdf = pw.Document();
    await _createPdf(pdf);

    await Printing.sharePdf(bytes: await pdf.save(), filename: '${widget.title}.pdf');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Summarize your video", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: true,),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                              child: Image.network(widget.thumbnailUrl, width: double.infinity, height: 200, fit: BoxFit.cover),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.title,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                    )
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Resumen del Video',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 20),

              FutureBuilder(
                  future: SummarizeService.summarize(widget.message),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final summaryText = snapshot.data!;
                        _summaryText = summaryText.summary ?? 'No se pudo transcribir el video';
                        return Container(
                          padding: const EdgeInsets.all(10),
                          color: const Color.fromRGBO(229, 229, 229, 100),
                          child: Column(
                            children: [
                              Text(
                                _summaryText,
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
              Row(
                children: [
                  Expanded(
                    child:
                    ElevatedButton(
                      onPressed: _saveAndDownloadPdf,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(250, 40),
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Descargar PDF', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: _sharePdf,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(250, 40),
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('Compartir PDF', style: TextStyle(color: Colors.white),)
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}