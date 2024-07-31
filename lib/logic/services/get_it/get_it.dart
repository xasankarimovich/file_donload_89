import 'package:get_it/get_it.dart';
import 'package:read_book/data/repositories/file_repository.dart';
import 'package:read_book/logic/bloc/file/file_bloc.dart';

final getIt = GetIt.instance;

void setUp() {
  getIt.registerSingleton(BookRepository());

  getIt.registerSingleton(
    FileBloc(fileRepository: getIt.get<BookRepository>()),
  );
}
