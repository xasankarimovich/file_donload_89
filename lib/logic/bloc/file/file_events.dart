part of 'file_bloc.dart';

@immutable
sealed class FileEvents {}

final class GetFilesEvent extends FileEvents {}

final class DownloadFileEvent extends FileEvents {
  final BookModel file;

  DownloadFileEvent({required this.file});
}

final class OpenFileEvent extends FileEvents {
  final String path;

  OpenFileEvent({required this.path});
}

final class UploadFileEvent extends FileEvents {
  final String path;

  UploadFileEvent({required this.path});
}

final class SearchBookEvent extends FileEvents {
  final String query;

  SearchBookEvent({required this.query});
}
