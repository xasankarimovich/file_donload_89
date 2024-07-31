import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:read_book/data/models/book_model.dart';
import 'package:read_book/ui/screens/book_pdf_screen.dart';

import '../../logic/bloc/file/file_bloc.dart';

class BookWidget extends StatelessWidget {
  final BookModel book;

  const BookWidget({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (book.isDownloaded) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => BookPdfScreen(bookModel: book),
            ),
          );
        }
      },
      child: Stack(
        children: [
          Card(
            elevation: 10,
            child: SizedBox(
              width: double.infinity,
              height: 250,
              child: Image.network(
                book.coverageUrl,
                fit: BoxFit.cover,
                loadingBuilder:
                    (context, child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Positioned(
            top: 100,
            right: 90,
            child: book.isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : IconButton(
                    onPressed: () {
                      if (book.isDownloaded) {
                        context.read<FileBloc>().add(OpenFileEvent(
                              path: book.savePath,
                            ));
                      } else {
                        context.read<FileBloc>().add(DownloadFileEvent(
                              file: book,
                            ));
                      }
                    },
                    icon: Icon(
                      book.isDownloaded ? Icons.check : Icons.arrow_circle_down,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.black.withOpacity(0.5),
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    book.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                    ),
                  ),
                ),
                LinearProgressIndicator(
                  minHeight: 10,
                  color: Colors.red,
                  value: book.progress,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
