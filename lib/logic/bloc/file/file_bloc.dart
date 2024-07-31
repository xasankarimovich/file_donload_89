import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:read_book/data/repositories/file_repository.dart';
import 'package:read_book/logic/services/permission_service/permissions.dart';
import '../../../data/models/book_model.dart';

part 'file_events.dart';

part 'file_state.dart';

class FileBloc extends Bloc<FileEvents, FileState> {
  final Dio _dio = Dio();
  final BookRepository _fileRepository;

  FileBloc({required BookRepository fileRepository})
      : _fileRepository = fileRepository,
        super(FileState()) {
    on<GetFilesEvent>(_onGetFile);
    on<DownloadFileEvent>(_onDownload);
    on<UploadFileEvent>(_onUpload);
    on<OpenFileEvent>(_onOpen);
    on<SearchBookEvent>(_onSearch);
  }

  void _onGetFile(
    GetFilesEvent event,
    Emitter<FileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      for (var file in _fileRepository.books) {
        final fullPath = await _getSavePath(file);
        if (_checkFileExists(fullPath)) {
          file = file
            ..savePath = fullPath
            ..isDownloaded = true;
        }
      }

      emit(state.copyWith(
        files: _fileRepository.books,
        isLoading: false,
      ));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onDownload(
    DownloadFileEvent event,
    Emitter<FileState> emit,
  ) async {
    final file = event.file;
    file.isLoading = true;
    emit(state.copyWith(file: file));

    if (await PermissionService.requestStoragePermission()) {
      try {
        final fullPath = await _getSavePath(file);
        if (_checkFileExists(fullPath)) {
          add(OpenFileEvent(path: fullPath));
          emit(state.copyWith(
            file: state.file!
              ..savePath = fullPath
              ..isLoading = false
              ..isDownloaded = true,
          ));
        } else {
          await _dio.download(
            file.bookUrl,
            fullPath,
            onReceiveProgress: (count, total) {
              emit(state.copyWith(
                file: state.file!..progress = count / total,
              ));
            },
          );
          emit(state.copyWith(
            file: state.file!
              ..savePath = fullPath
              ..isDownloaded = true
              ..isLoading = false,
          ));
        }
      } on DioException catch (e) {
        emit(state.copyWith(
          file: state.file!..isLoading = false,
          errorMessage: e.toString(),
        ));
      } catch (e) {
        emit(state.copyWith(
          file: state.file!..isLoading = false,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  void _onUpload(
    UploadFileEvent event,
    Emitter<FileState> emit,
  ) async {
    try {
      final file = File(event.path);
      final formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(
          file.readAsBytesSync(),
          filename: "event.pdf",
        ),
      });

      final response = await _dio.post(
        "https://api.escuelajs.co/api/v1/files/upload",
        data: formData,
        onSendProgress: (count, total) {
          debugPrint("${count / total}% sending");
        },
      );

      debugPrint(response.data);
    } on DioException catch (e) {
      debugPrint(e.response?.data);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _onSearch(SearchBookEvent event, Emitter<FileState> emit) {
    try {
      emit(state.copyWith(
          files: _fileRepository.books
              .where(
                (element) => element.title
                    .toLowerCase()
                    .contains(event.query.toLowerCase()),
              )
              .toList()));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void _onOpen(
    OpenFileEvent event,
    Emitter<FileState> emit,
  ) async {
    await OpenFilex.open(event.path);
  }

  bool _checkFileExists(String filePath) => File(filePath).existsSync();

  Future<String> _getSavePath(BookModel file) async {
    final savePath = await getApplicationDocumentsDirectory();
    return "${savePath.path}/${file.title}.${file.bookUrl.split('.').last}";
  }
}
