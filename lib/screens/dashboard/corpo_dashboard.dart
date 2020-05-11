import 'package:compiti_2/screens/dashboard/item_evento.dart';
import 'package:compiti_2/screens/dashboard/toggle_dashboard.dart';
import 'package:flutter/material.dart';

class CorpoDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Color(0xFF383838),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          )),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.only(top: 24.0),
          child: Column(
            children: <Widget>[
              ToggleDashboard(),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      ItemEvento(),
                      ItemEvento(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
