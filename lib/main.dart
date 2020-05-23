import 'package:flutter/material.dart';

import 'database/evento_dao.dart';
import 'screens/dashboard/dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final EventoDao _dao = EventoDao();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _dao.findAll().then((list){
      list.forEach((evento) => debugPrint(evento.toString()));
    });
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Material(child: Dashboard()),
    );
  }
}
