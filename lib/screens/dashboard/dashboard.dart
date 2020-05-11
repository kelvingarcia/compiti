import 'package:compiti_2/screens/dashboard/BarraSuperior.dart';
import 'package:compiti_2/screens/dashboard/corpo_dashboard.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          child: BarraSuperior(),
        ),
        Positioned(
          top: 100,
          left: 0,
          child: CorpoDashboard(),
        )
      ],
    );
  }
}

