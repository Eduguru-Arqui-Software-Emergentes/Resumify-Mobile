import 'package:flutter/material.dart';

import 'convert_summary_screen.dart';

class ConvertToText extends StatefulWidget {
  final String title;
  final String thumbnailUrl;

  ConvertToText({required this.title, required this.thumbnailUrl});

  @override
  State<ConvertToText> createState() => _ConvertToTextState();
}

class _ConvertToTextState extends State<ConvertToText> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              SizedBox(height: 40),

              Text(
                '${widget.title}',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),

              Image.network('${widget.thumbnailUrl}'),

              SizedBox(height: 20),

              Text(
                'Conversión del Video',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),

              Container(
                width: 300,
                padding: EdgeInsets.all(10),
                color: Color.fromRGBO(229, 229, 229, 100),
                child:Text(
                  'Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia, molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum numquam blanditiis harum quisquam eius sed odit fugiat iusto fuga praesentium optio, eaque rerum! Provident similique accusantium nemo autem. Veritatis obcaecati tenetur iure eius earum ut molestias architecto voluptate aliquam obcaecati tenetur iure eius earum ut molestias architecto voluptate aliquam',
                  style: TextStyle(fontSize: 16),
                ),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConvertToSummary(title: '${widget.title}', thumbnailUrl: '${widget.thumbnailUrl}'),
                    ),);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(250, 40),
                  backgroundColor: Color.fromRGBO(77, 148, 255, 100),
                ),
                child: Text('Resumir'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}