import 'package:compiti_2/screens/dashboard/calendario_mes.dart';
import 'package:compiti_2/screens/dashboard/corpo_dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'toggle_dashboard.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double topCorpo = 100;

  double _leftCalendario = 0;
  double _leftEventos = 0;

  double _hiddenCalendario;
  double _hiddenEventos;

  bool calendarioPosition = false;
  bool eventoPosition = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(!calendarioPosition){
      _hiddenCalendario = MediaQuery.of(context).size.width;
    }
    if(!eventoPosition){
      _hiddenEventos = 0 - MediaQuery.of(context).size.width;
    }
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          child: BarraSuperior(
            parent: this,
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 400),
          top: topCorpo,
          left: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFF383838),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(top: 24.0, bottom: 24.0),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      left: 0,
                      width: MediaQuery.of(context).size.width,
                      child: ToggleDashboard(),
                    ),
                    PositionedTransition(
                      rect: RelativeRectTween(
                        begin: RelativeRect.fromSize(
                          Rect.fromLTWH(
                            _leftEventos,
                            50,
                            MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height,
                          ),
                          Size(
                            MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height,
                          ),
                        ),
                        end: RelativeRect.fromSize(
                          Rect.fromLTWH(
                            _hiddenEventos,
                            50,
                            MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height,
                          ),
                          Size(
                            MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height,
                          ),
                        ),
                      ).animate(_controller),
                      child: GestureDetector(
                        onHorizontalDragUpdate: (dragInfo) {
                          setState(() {
                            _leftEventos += dragInfo.delta.dx;
                            _hiddenCalendario += dragInfo.delta.dx;
                            calendarioPosition = true;
                          });
                        },
                        onHorizontalDragEnd: (dragInfo) {
                          setState(() {
                            if (_leftEventos > -65) {
                              _leftEventos = 0;
                              calendarioPosition = false;
                            } else {
                              _controller.forward();
                              _leftCalendario = 0;
                              calendarioPosition = false;
                            }
                          });
                        },
                        child: CorpoDashboard(),
                      ),
                    ),
                    PositionedTransition(
                      rect: RelativeRectTween(
                        begin: RelativeRect.fromSize(
                          Rect.fromLTWH(
                            _hiddenCalendario,
                            50,
                            MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height,
                          ),
                          Size(
                            MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height,
                          ),
                        ),
                        end: RelativeRect.fromSize(
                          Rect.fromLTWH(
                            _leftCalendario,
                            50,
                            MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height,
                          ),
                          Size(
                            MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height,
                          ),
                        ),
                      ).animate(_controller),
                      child: GestureDetector(
                        onHorizontalDragUpdate: (dragInfo) {
                          setState(() {
                            _leftCalendario += dragInfo.delta.dx;
                            _hiddenEventos += dragInfo.delta.dx;
                            eventoPosition = true;
                          });
                        },
                        onHorizontalDragEnd: (dragInfo) {
                          setState(() {
                            if (_leftCalendario < 65) {
                              _leftCalendario = 0;
                              eventoPosition = false;
                            } else {
                              _controller.reverse();
                              _leftEventos = 0;
                              eventoPosition = false;
                            }
                          });
                        },
                        child: CalendarioMes(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BarraSuperior extends StatelessWidget {
  _DashboardState parent;

  BarraSuperior({this.parent});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.cyan,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      if (this.parent.topCorpo == 100.0) {
                        this.parent.setState(() {
                          this.parent.topCorpo = 400.0;
                        });
                      } else {
                        this.parent.setState(() {
                          this.parent.topCorpo = 100.0;
                        });
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 32.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 95.0),
                    child: Text(
                      'Compiti',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 24.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Item Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    'Item Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    'Item Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    'Item Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
