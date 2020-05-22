import 'package:compiti_2/screens/dashboard/calendario_mes.dart';
import 'package:compiti_2/screens/dashboard/eventos_dia.dart';
import 'package:compiti_2/screens/dashboard/todos_eventos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'barra_superior.dart';
import 'toggle_dashboard.dart';

class Dashboard extends StatefulWidget {
  int animationTime = 200;

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  AnimationController _controllerEvento;
  AnimationController _controllerCalendario;
  AnimationController _controllerDia;
  double topCorpo = 100;

  double _leftCalendario = 0;
  double _leftEventos = 0;
  double _leftDia = 0;

  double _hiddenCalendario;
  double _hiddenEventos;
  double _hiddenDia;

  bool appStarted = true;
  bool reverseAnimation = false;
  bool forwardAnimation = false;
  bool diaAnimation = false;

  @override
  void initState() {
    super.initState();
    _controllerEvento = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationTime),
    );
    _controllerCalendario = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationTime),
    );
    _controllerDia = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationTime),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (appStarted) {
      _leftEventos = 0;
      _leftCalendario = 0;
      _leftDia = 0;
      _hiddenCalendario = MediaQuery.of(context).size.width;
      _hiddenEventos = 0 - MediaQuery.of(context).size.width;
      _hiddenDia = 0 - MediaQuery.of(context).size.width;
    }
    if (reverseAnimation) {
      _leftEventos = 0;
      _hiddenCalendario = MediaQuery.of(context).size.width;
      _hiddenDia = 0 - MediaQuery.of(context).size.width;
    }
    if (forwardAnimation) {
      _leftCalendario = 0;
      _hiddenEventos = 0 - MediaQuery.of(context).size.width;
    }
    if (diaAnimation) {
      _leftDia = 0;
      _hiddenEventos = MediaQuery.of(context).size.width;
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
                      child: ToggleDashboard(
                        dashboard: this,
                      ),
                    ),
                    PositionedTransition(
                      rect: RelativeRectTween(
                        begin: RelativeRect.fromSize(
                          Rect.fromLTWH(
                            _hiddenDia,
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
                            _leftDia,
                            50,
                            MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height,
                          ),
                          Size(
                            MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.height,
                          ),
                        ),
                      ).animate(_controllerDia),
                      child: GestureDetector(
                        onHorizontalDragUpdate: (dragInfo) {
                          setState(() {
                            _leftDia += dragInfo.delta.dx;
                            _hiddenEventos += dragInfo.delta.dx;
                            appStarted = false;
                            forwardAnimation = false;
                            reverseAnimation = false;
                            diaAnimation = false;
                          });
                        },
                        onHorizontalDragEnd: (dragInfo) {
                          setState(() {
                            if (_leftDia > -75) {
                              diaAnimation = true;
                            } else {
                              reverseAnimation = true;
                              _controllerEvento.reverse();
                              _controllerDia.reverse();
                            }
                          });
                        },
                        child: TodosEventos(),
                      ),
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
                      ).animate(_controllerEvento),
                      child: GestureDetector(
                        onHorizontalDragUpdate: (dragInfo) {
                          setState(() {
                            _leftEventos += dragInfo.delta.dx;
                            _hiddenCalendario += dragInfo.delta.dx;
                            _hiddenDia += dragInfo.delta.dx;
                            appStarted = false;
                            forwardAnimation = false;
                            reverseAnimation = false;
                            diaAnimation = false;
                          });
                        },
                        onHorizontalDragEnd: (dragInfo) {
                          setState(() {
                            if ((_leftEventos > -75 && _leftEventos < 0) ||
                                (_leftEventos > 0 && _leftEventos < 75)) {
                              appStarted = true;
                            } else {
                              if (_leftEventos < 0) {
                                forwardAnimation = true;
                                _controllerEvento.forward();
                                _controllerCalendario.forward();
                              } else {
                                diaAnimation = true;
                                _controllerEvento.forward();
                                _controllerDia.forward();
                              }
                            }
                          });
                        },
                        child: EventosDia(),
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
                      ).animate(_controllerCalendario),
                      child: GestureDetector(
                        onHorizontalDragUpdate: (dragInfo) {
                          setState(() {
                            _leftCalendario += dragInfo.delta.dx;
                            _hiddenEventos += dragInfo.delta.dx;
                            appStarted = false;
                            forwardAnimation = false;
                            reverseAnimation = false;
                            diaAnimation = false;
                          });
                        },
                        onHorizontalDragEnd: (dragInfo) {
                          setState(() {
                            if (_leftCalendario < 75) {
                              appStarted = true;
                            } else {
                              reverseAnimation = true;
                              _controllerEvento.reverse();
                              _controllerCalendario.reverse();
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

  void diaFromEventos() {
    setState(() {
      appStarted = false;
      forwardAnimation = false;
      diaAnimation = false;
      reverseAnimation = true;
      _controllerEvento.reverse();
      _controllerDia.reverse();
    });
  }

  void mesFromDia() {
    setState(() {
      appStarted = false;
      reverseAnimation = false;
      diaAnimation = false;
      forwardAnimation = true;
      _controllerEvento.forward();
      _controllerCalendario.forward();
    });
  }

  void eventosFromDia() {
    setState(() {
      appStarted = false;
      forwardAnimation = false;
      reverseAnimation = false;
      diaAnimation = true;
      _controllerEvento.forward();
      _controllerDia.forward();
    });
  }

  void diaFromMes() {
    setState(() {
      appStarted = false;
      forwardAnimation = false;
      diaAnimation = false;
      reverseAnimation = true;
      _controllerEvento.reverse();
      _controllerCalendario.reverse();
    });
  }

  void eventosFromMes() {
    setState(() {
      appStarted = false;
      forwardAnimation = false;
      diaAnimation = false;
      reverseAnimation = true;
      _controllerEvento.reverse();
      _controllerCalendario.reverse().whenComplete(() {
        setState(() {
          appStarted = false;
          forwardAnimation = false;
          reverseAnimation = false;
          diaAnimation = true;
          _controllerEvento.forward();
          _controllerDia.forward();
        });
      });
    });
  }

  void mesFromEventos(){
    setState(() {
      appStarted = false;
      forwardAnimation = false;
      diaAnimation = false;
      reverseAnimation = true;
      _controllerEvento.reverse();
      _controllerDia.reverse().whenComplete((){
        setState(() {
          appStarted = false;
          reverseAnimation = false;
          diaAnimation = false;
          forwardAnimation = true;
          _controllerEvento.forward();
          _controllerCalendario.forward();
        });
      });
    });
  }
}
