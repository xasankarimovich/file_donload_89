import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:read_book/data/models/book_model.dart';
import 'package:read_book/data/repositories/file_repository.dart';
import 'package:read_book/logic/bloc/file/file_bloc.dart';
import 'package:read_book/logic/services/get_it/get_it.dart';
import 'package:read_book/ui/widgets/book_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Book read app'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              onChanged: (value) {
                context.read<FileBloc>().add(SearchBookEvent(query: value));
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<FileBloc, FileState>(
              bloc: context.read<FileBloc>()..add(GetFilesEvent()),
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.errorMessage != null) {
                  return Center(child: Text(state.errorMessage!));
                } else if (state.files == null || state.files!.isEmpty) {
                  return const Center(child: Text('no files are available'));
                } else {
                  final files = state.files!;
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    padding: const EdgeInsets.all(15),
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      return BookWidget(book: files[index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf'],
          );

          if (result != null && result.files.single.path != null) {
            String? filePath = result.files.single.path;
            getIt.get<BookRepository>().books.add(BookModel(
                  title: filePath!.split('/').last.split('.')[0],
                  bookUrl: 'null',
                  coverageUrl:
                      'https://www.mysafetysign.com/img/lg/S/caution-testing-in-progress-sign-s-8894.png',
                  savePath: filePath,
                  progress: 0,
                  isLoading: false,
                  isDownloaded: true,
                ));
            if (context.mounted) {
              context.read<FileBloc>().add(GetFilesEvent());
            }
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('File picker has been canceled'),
              ));
            }
          }
        },
        backgroundColor: Colors.amber,
        child: const Icon(Icons.upload_file_sharp),
      ),
    );
  }
}
