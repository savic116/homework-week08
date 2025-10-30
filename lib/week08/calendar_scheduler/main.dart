import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/week08/calendar_scheduler/database/drift_database.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/week08/calendar_scheduler/screen/home_screen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final database = LocalDatabase();

  GetIt.I.registerSingleton<LocalDatabase> (database);

  runApp(
    MaterialApp(
      home: HomeScreen(),
    ),
  );

}