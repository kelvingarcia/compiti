import 'package:compiti_2/models/toggle_status.dart';
import 'package:compiti_2/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class ToggleDashboard extends StatefulWidget {
  final DashboardState dashboard;

  ToggleDashboard({this.dashboard});

  @override
  _ToggleDashboardState createState() => _ToggleDashboardState();
}

class _ToggleDashboardState extends State<ToggleDashboard> {
  Color _borderEventos;
  Color _borderDia;
  Color _borderMes;

  @override
  Widget build(BuildContext context) {
    if(widget.dashboard.toggleStatus == ToggleStatus.dia){
      _borderEventos = Color(0xFF383838);
      _borderMes = Color(0xFF383838);
      _borderDia = Colors.cyan;
    } else {
      if(widget.dashboard.toggleStatus == ToggleStatus.eventos){
        _borderEventos = Colors.cyan;
        _borderMes = Color(0xFF383838);
        _borderDia = Color(0xFF383838);
      } else {
        if(widget.dashboard.toggleStatus == ToggleStatus.mes){
          _borderEventos = Color(0xFF383838);
          _borderMes = Colors.cyan;
          _borderDia = Color(0xFF383838);
        }
      }
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                if(widget.dashboard.toggleStatus == ToggleStatus.dia) {
                  widget.dashboard.eventosFromDia();
                } else {
                  if(widget.dashboard.toggleStatus == ToggleStatus.mes){
                    widget.dashboard.eventosFromMes();
                  }
                }
                widget.dashboard.toggleStatus = ToggleStatus.eventos;
              });
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: _borderEventos, width: 1.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                child: Text(
                  'Eventos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                if(widget.dashboard.toggleStatus == ToggleStatus.eventos){
                  widget.dashboard.diaFromEventos();
                } else {
                  if(widget.dashboard.toggleStatus == ToggleStatus.mes){
                    widget.dashboard.diaFromMes();
                  }
                }
                widget.dashboard.toggleStatus = ToggleStatus.dia;
              });
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: _borderDia, width: 1.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                child: Text(
                  'Dia',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                if(widget.dashboard.toggleStatus == ToggleStatus.dia) {
                  widget.dashboard.mesFromDia();
                } else {
                  if(widget.dashboard.toggleStatus == ToggleStatus.eventos){
                    widget.dashboard.mesFromEventos();
                  }
                }
                widget.dashboard.toggleStatus = ToggleStatus.mes;
              });
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: _borderMes, width: 1.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                child: Text(
                  'Mês',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
