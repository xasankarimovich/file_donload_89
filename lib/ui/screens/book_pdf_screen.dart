import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:read_book/data/models/book_model.dart';

class BookPdfScreen extends StatelessWidget {
  final BookModel bookModel;
  const BookPdfScreen({super.key, required this.bookModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PDFView(
        filePath: bookModel.savePath,
      ),
    );
  }
}
