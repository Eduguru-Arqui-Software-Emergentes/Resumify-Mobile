import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:open_file/open_file.dart';


class ConvertToSummary extends StatefulWidget {
  final String title;
  final String thumbnailUrl;

  ConvertToSummary({required this.title, required this.thumbnailUrl});

  @override
  State<ConvertToSummary> createState() => _ConvertToSummaryState();
}

class _ConvertToSummaryState extends State<ConvertToSummary> {
  final TextEditingController _textEditingController = TextEditingController();
  //final pw.Document pdf = pw.Document();
  final String content = 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia, molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum numquam blanditiis harum quisquam eius sed odit fugiat iusto fuga praesentium optio, eaque rerum! Provident similique accusantium nemo autem.';

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
    final String text = widget.title;
    final String image = widget.thumbnailUrl;
    final pw.Font customFont = await loadCustomFont();

    // Añadir una página al documento
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(
                text,
                style: pw.TextStyle(font: customFont, fontSize: 20.0, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                content,
                style: pw.TextStyle(font: customFont, fontSize: 16.0, fontWeight: pw.FontWeight.bold),
              ),
            ],
          ); // Contenido de la página
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
    final String filePath = '$downloadsPath/example.pdf';

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

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'example.pdf');

  }

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
                'Resumen del Video',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                width: 300,
                padding: const EdgeInsets.all(10),
                color: const Color.fromRGBO(229, 229, 229, 100),
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveAndDownloadPdf,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 40),
                  backgroundColor: const Color.fromRGBO(77, 148, 255, 100),
                ),
                child: const Text('Descargar PDF'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _sharePdf,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 40),
                  backgroundColor: const Color.fromRGBO(77, 148, 255, 100),
                ),
                child: const Text('Compartir PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}