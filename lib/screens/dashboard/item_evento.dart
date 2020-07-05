import 'package:compiti/controllers/controlador_agendamento.dart';
import 'package:compiti/models/agendamento.dart';
import 'package:compiti/models/evento_status.dart';
import 'package:compiti/models/opcao.dart';
import 'package:compiti/screens/dashboard/roteamento_animado.dart';
import 'package:compiti/screens/form/evento_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dashboard.dart';

class ItemEvento extends StatefulWidget {
  final Agendamento agendamento;
  final DashboardState dashboardState;

  ItemEvento(this.agendamento, this.dashboardState);

  @override
  ItemEventoState createState() => ItemEventoState();
}

class ItemEventoState extends State<ItemEvento> {
  double _toggleLeft = 95;
  String _status = 'Agendado';
  int dragCount = 0;
  ControladorAgendamento _controladorAgendamento = ControladorAgendamento();
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  @override
  void initState() {
    super.initState();
    switch (widget.agendamento.eventoStatus) {
      case EventoStatus.agendado:
        _status = 'Agendado';
        _toggleLeft = 95;
        break;
      case EventoStatus.feito:
        _status = 'Feito';
        _toggleLeft = 2;
        break;
      case EventoStatus.nao_feito:
        _status = 'Não feito';
        _toggleLeft = 202;
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dashboardState.atualizouBanco) {
      switch (widget.agendamento.eventoStatus) {
        case EventoStatus.agendado:
          _status = 'Agendado';
          _toggleLeft = 95;
          break;
        case EventoStatus.feito:
          _status = 'Feito';
          _toggleLeft = 2;
          break;
        case EventoStatus.nao_feito:
          _status = 'Não feito';
          _toggleLeft = 202;
          break;
        default:
          break;
      }
    }
    var dataInicial = dateFormat.format(widget.agendamento.dataInicial);
    var horaInicial =
        widget.agendamento.dataInicial.toString().substring(11, 16);
    var horaFinal = widget.agendamento.dataFinal.toString().substring(11, 16);
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        color: Color(0xFF626262),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.07,
              color: Color(0xFF121212),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.event,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Text(
                            widget.agendamento.evento.titulo,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: InkWell(
                            onTap: () {
                              if (widget.agendamento.evento.dataFinal
                                      .difference(
                                          widget.agendamento.evento.dataInicial)
                                      .inDays >
                                  0) {
                                _editarMaisDeUm();
                              } else {
                                Navigator.of(context).push(
                                  createRoute(
                                    Material(
                                      child: EventoForm(
                                        widget.dashboardState.todosEventos
                                            .todosEventosState,
                                        widget.dashboardState.eventosDia
                                            .eventosDiaState,
                                        evento: widget.agendamento.evento,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (widget.agendamento.evento.dataFinal
                                    .difference(
                                        widget.agendamento.evento.dataInicial)
                                    .inDays >
                                0) {
                              _deletarMaisDeUm();
                            } else {
                              _deletarUm();
                            }
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    dataInicial,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    horaInicial + ' ~ ' + horaFinal,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                widget.agendamento.evento.descricao,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(24.0)),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 8,
                        left: 35,
                        child: GestureDetector(
                          onTap: () {
                            widget.dashboardState.atualizouBanco = false;
                            setState(() {
                              _toggleLeft = 2;
                              _status = 'Feito';
                              this.atualizaStatus();
                            });
                          },
                          child: Text('Feito'),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 125,
                        child: GestureDetector(
                          onTap: () {
                            widget.dashboardState.atualizouBanco = false;
                            setState(() {
                              _toggleLeft = 95;
                              _status = 'Agendado';
                              this.atualizaStatus();
                            });
                          },
                          child: Text('Agendado'),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 225,
                        child: GestureDetector(
                          onTap: () {
                            widget.dashboardState.atualizouBanco = false;
                            setState(() {
                              _toggleLeft = 202;
                              _status = 'Não feito';
                              this.atualizaStatus();
                            });
                          },
                          child: Text('Não feito'),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 200),
                        top: 1.5,
                        left: _toggleLeft,
                        child: GestureDetector(
                          onHorizontalDragUpdate: (dragInfo) {
                            widget.dashboardState.atualizouBanco = false;
                            dragCount++;
                            setState(() {
                              if (dragInfo.delta.dx < 0) {
                                if (_toggleLeft == 95) {
                                  _toggleLeft = 2;
                                } else {
                                  if (_toggleLeft == 202) {
                                    _toggleLeft = 95;
                                  }
                                }
                              } else {
                                if (_toggleLeft == 95) {
                                  _toggleLeft = 202;
                                } else {
                                  if (_toggleLeft == 2) {
                                    _toggleLeft = 95;
                                  }
                                }
                              }
                            });
                          },
                          onHorizontalDragEnd: (dragInfo) {
                            setState(() {
                              if (_toggleLeft == 202 &&
                                  _status == 'Feito' &&
                                  dragCount < 15) {
                                _toggleLeft = 95;
                                _status = 'Agendado';
                              } else {
                                if (_toggleLeft == 202 &&
                                    _status == 'Agendado') {
                                  _status = 'Não feito';
                                } else {
                                  if (_toggleLeft == 95 &&
                                      (_status == 'Feito' ||
                                          _status == 'Não feito')) {
                                    _status = 'Agendado';
                                  } else {
                                    if (_toggleLeft == 02 &&
                                        _status == 'Agendado') {
                                      _status = 'Feito';
                                    } else {
                                      if (_toggleLeft == 02 &&
                                          _status == 'Não feito' &&
                                          dragCount < 15) {
                                        _toggleLeft = 95;
                                        _status = 'Agendado';
                                      } else {
                                        if (_toggleLeft == 202 &&
                                            _status == 'Feito' &&
                                            dragCount >= 15) {
                                          _status = 'Não feito';
                                        } else {
                                          if (_toggleLeft == 02 &&
                                              _status == 'Não feito' &&
                                              dragCount >= 15) {
                                            _status = 'Feito';
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                              dragCount = 0;
                              this.atualizaStatus();
                            });
                          },
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            child: SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.045,
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Center(
                                child: Text(
                                  _status,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void atualizaStatus() {
    Future.delayed(Duration(seconds: 1), () {
      _controladorAgendamento.editaStatus(
          widget.agendamento, _status, widget.dashboardState);
    });
  }

  Future<void> _deletarMaisDeUm() async {
    switch (await showDialog<Opcao>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Selecione uma opção: '),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Opcao.agendamento);
                },
                child: const Text('Deletar somente esse evento'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Opcao.evento);
                },
                child: const Text('Deletar todos os eventos dessa série'),
              ),
            ],
          );
        })) {
      case Opcao.evento:
        _deletarTodos();
        break;
      case Opcao.agendamento:
        _deletarUm();
        break;
    }
  }

  Future<void> _editarMaisDeUm() async {
    switch (await showDialog<Opcao>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Selecione uma opção: '),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Opcao.agendamento);
                },
                child: const Text('Editar somente esse evento'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Opcao.evento);
                },
                child: const Text('Editar todos os eventos dessa série'),
              ),
            ],
          );
        })) {
      case Opcao.evento:
        Navigator.of(context).push(
          createRoute(
            Material(
              child: EventoForm(
                widget.dashboardState.todosEventos.todosEventosState,
                widget.dashboardState.eventosDia.eventosDiaState,
                evento: widget.agendamento.evento,
              ),
            ),
          ),
        );
        break;
      case Opcao.agendamento:
        Navigator.of(context).push(
          createRoute(
            Material(
              child: EventoForm(
                widget.dashboardState.todosEventos.todosEventosState,
                widget.dashboardState.eventosDia.eventosDiaState,
                evento: widget.agendamento.evento,
                agendamento: widget.agendamento,
              ),
            ),
          ),
        );
        break;
    }
  }

  Future<void> _deletarTodos() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Atenção'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Tem certeza que deseja deletar todos os eventos dessa série?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Não'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Sim'),
              onPressed: () {
                _controladorAgendamento.deletaTodosAgendamentosComEvento(
                    widget.agendamento, widget.dashboardState);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletarUm() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Atenção'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tem certeza que deseja deletar este evento?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Não'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Sim'),
              onPressed: () {
                if (widget.agendamento.evento.dataFinal
                        .difference(widget.agendamento.evento.dataInicial)
                        .inDays >
                    0) {
                  _controladorAgendamento.deletaUmAgendamento(
                      widget.agendamento, widget.dashboardState);
                } else {
                  _controladorAgendamento.deletaUmAgendamentoComEvento(
                      widget.agendamento, widget.dashboardState);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
