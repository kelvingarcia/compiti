import 'package:flutter/material.dart';

import 'database/evento_dao.dart';
import 'models/evento.dart';
import 'screens/dashboard/dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final EventoDao _dao = EventoDao();
  List<Evento> listaEventos;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _dao.findAll().then((list) => listaEventos = list);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Material(child: Dashboard(listaEventos)),
    );
  }
}
