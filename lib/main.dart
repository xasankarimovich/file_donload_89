import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:read_book/core/app.dart';
import 'package:read_book/data/repositories/file_repository.dart';
import 'package:read_book/logic/bloc/file/file_bloc.dart';
import 'package:read_book/logic/services/get_it/get_it.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  setUp();

  await Firebase.initializeApp();

  runApp(
    RepositoryProvider(
      create: (context) => getIt.get<BookRepository>(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => getIt.get<FileBloc>()),
        ],
        child: const MainApp(),
      ),
    ),
  );
}
