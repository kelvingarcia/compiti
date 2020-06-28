import 'package:compiti_2/models/agendamento.dart';
import 'package:compiti_2/models/toggle_status.dart';
import 'package:compiti_2/screens/dashboard/barra_inferior_info.dart';
import 'package:compiti_2/screens/dashboard/calendario_mes.dart';
import 'package:compiti_2/screens/dashboard/eventos_dia.dart';
import 'package:compiti_2/screens/dashboard/todos_eventos.dart';
import 'package:compiti_2/screens/form/evento_form.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'barra_superior.dart';
import 'toggle_dashboard.dart';

class Dashboard extends StatefulWidget {
  final int animationTime = 200;

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  bool atualizouBanco = false;
  List<Agendamento> listaAgendamentos = List();
  
  TodosEventos todosEventos = TodosEventos();
  EventosDia eventosDia = EventosDia();
  BarraInferiorInfo barraInferiorInfo = BarraInferiorInfo();

  ToggleStatus toggleStatus;
  AnimationController _controllerDia;
  AnimationController _controllerCalendario;
  AnimationController _controllerEventos;
  double topCorpo = 100;

  double _leftCalendario = 0;
  double _leftDia = 0;
  double _leftEventos = 0;

  double _hiddenCalendario;
  double _hiddenDia;
  double _hiddenEventos;

  bool appStarted = true;
  bool reverseAnimation = false;
  bool forwardAnimation = false;
  bool eventosAnimation = false;

  double _bottomSnackBar = -50;
  double _bottomFloatButton = 15;

  @override
  void initState() {
    super.initState();
    _controllerDia = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationTime),
    );
    _controllerCalendario = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationTime),
    );
    _controllerEventos = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationTime),
    );
    eventosDia.dashboardState = this;
    todosEventos.dashboardState = this;
    barraInferiorInfo.dashboardState = this;
  }

  @override
  Widget build(BuildContext context) {
    if (appStarted) {
      _leftDia = 0;
      _leftCalendario = 0;
      _leftEventos = 0;
      _hiddenCalendario = MediaQuery.of(context).size.width;
      _hiddenDia = 0 - MediaQuery.of(context).size.width;
      _hiddenEventos = 0 - MediaQuery.of(context).size.width;
      toggleStatus = ToggleStatus.dia;
    }
    if (reverseAnimation) {
      _leftDia = 0;
      _hiddenCalendario = MediaQuery.of(context).size.width;
      _hiddenEventos = 0 - MediaQuery.of(context).size.width;
      toggleStatus = ToggleStatus.dia;
    }
    if (forwardAnimation) {
      _leftCalendario = 0;
      _hiddenDia = 0 - MediaQuery.of(context).size.width;
      toggleStatus = ToggleStatus.mes;
    }
    if (eventosAnimation) {
      _leftEventos = 0;
      _hiddenDia = MediaQuery.of(context).size.width;
      toggleStatus = ToggleStatus.eventos;
    }
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          child: BarraSuperior(
            parent: this,
            listaAgendamentos: listaAgendamentos,
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
                        end: RelativeRect.fromSize(
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
                      ).animate(_controllerEventos),
                      child: GestureDetector(
                        onHorizontalDragUpdate: (dragInfo) {
                          setState(() {
                            _leftEventos += dragInfo.delta.dx;
                            _hiddenDia += dragInfo.delta.dx;
                            appStarted = false;
                            forwardAnimation = false;
                            reverseAnimation = false;
                            eventosAnimation = false;
                          });
                        },
                        onHorizontalDragEnd: (dragInfo) {
                          setState(() {
                            if (_leftEventos > -75) {
                              eventosAnimation = true;
                            } else {
                              reverseAnimation = true;
                              _controllerDia.reverse();
                              _controllerEventos.reverse();
                            }
                          });
                        },
                        child: todosEventos,
                      ),
                    ),
                    PositionedTransition(
                      rect: RelativeRectTween(
                        begin: RelativeRect.fromSize(
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
                        end: RelativeRect.fromSize(
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
                      ).animate(_controllerDia),
                      child: GestureDetector(
                        onHorizontalDragUpdate: (dragInfo) {
                          setState(() {
                            _leftDia += dragInfo.delta.dx;
                            _hiddenCalendario += dragInfo.delta.dx;
                            _hiddenEventos += dragInfo.delta.dx;
                            appStarted = false;
                            forwardAnimation = false;
                            reverseAnimation = false;
                            eventosAnimation = false;
                          });
                        },
                        onHorizontalDragEnd: (dragInfo) {
                          setState(() {
                            if ((_leftDia > -75 && _leftDia < 0) ||
                                (_leftDia > 0 && _leftDia < 75)) {
                              appStarted = true;
                            } else {
                              if (_leftDia < 0) {
                                forwardAnimation = true;
                                _controllerDia.forward();
                                _controllerCalendario.forward();
                              } else {
                                eventosAnimation = true;
                                _controllerDia.forward();
                                _controllerEventos.forward();
                              }
                            }
                          });
                        },
                        child: eventosDia,
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
                            _hiddenDia += dragInfo.delta.dx;
                            appStarted = false;
                            forwardAnimation = false;
                            reverseAnimation = false;
                            eventosAnimation = false;
                          });
                        },
                        onHorizontalDragEnd: (dragInfo) {
                          setState(() {
                            if (_leftCalendario < 75) {
                              forwardAnimation = true;
                            } else {
                              reverseAnimation = true;
                              _controllerDia.reverse();
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
        AnimatedPositioned(
          duration: Duration(milliseconds: 300),
          bottom: _bottomFloatButton,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: FloatingActionButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Material(
                      child: EventoForm(todosEventos.todosEventosState,
                          eventosDia.eventosDiaState)),
                ),
              ),
              backgroundColor: Colors.cyan,
              splashColor: Colors.white,
              child: Icon(Icons.add),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 300),
          bottom: _bottomSnackBar,
          left: 0,
          child: barraInferiorInfo,
        ),
      ],
    );
  }

  void toggleSnackBar() {
    setState(() {
      _bottomSnackBar = 0;
      _bottomFloatButton = 60;
    });
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _bottomSnackBar = -50;
        _bottomFloatButton = 15;
        barraInferiorInfo.barraInferiorInfoState.desfez = false;
      });
    });
  }

  void diaFromEventos() {
    setState(() {
      appStarted = false;
      forwardAnimation = false;
      eventosAnimation = false;
      reverseAnimation = true;
      _controllerDia.reverse();
      _controllerEventos.reverse();
    });
  }

  void mesFromDia() {
    setState(() {
      appStarted = false;
      reverseAnimation = false;
      eventosAnimation = false;
      forwardAnimation = true;
      _controllerDia.forward();
      _controllerCalendario.forward();
    });
  }

  void eventosFromDia() {
    setState(() {
      appStarted = false;
      forwardAnimation = false;
      reverseAnimation = false;
      eventosAnimation = true;
      _controllerDia.forward();
      _controllerEventos.forward();
    });
  }

  void diaFromMes() {
    setState(() {
      appStarted = false;
      forwardAnimation = false;
      eventosAnimation = false;
      reverseAnimation = true;
      _controllerDia.reverse();
      _controllerCalendario.reverse();
    });
  }

  void eventosFromMes() {
    setState(() {
      appStarted = false;
      forwardAnimation = false;
      eventosAnimation = false;
      reverseAnimation = true;
      _controllerDia.reverse();
      _controllerCalendario.reverse().whenComplete(() {
        setState(() {
          appStarted = false;
          forwardAnimation = false;
          reverseAnimation = false;
          eventosAnimation = true;
          _controllerDia.forward();
          _controllerEventos.forward();
        });
      });
    });
  }

  void mesFromEventos() {
    setState(() {
      appStarted = false;
      forwardAnimation = false;
      eventosAnimation = false;
      reverseAnimation = true;
      _controllerDia.reverse();
      _controllerEventos.reverse().whenComplete(() {
        setState(() {
          appStarted = false;
          reverseAnimation = false;
          eventosAnimation = false;
          forwardAnimation = true;
          _controllerDia.forward();
          _controllerCalendario.forward();
        });
      });
    });
  }
}
