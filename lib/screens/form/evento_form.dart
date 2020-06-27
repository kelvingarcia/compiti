import 'package:compiti_2/controllers/controlador_agendamento.dart';
import 'package:compiti_2/models/agendamento.dart';
import 'package:compiti_2/models/evento.dart';
import 'package:compiti_2/models/semana.dart';
import 'package:compiti_2/screens/dashboard/eventos_dia.dart';
import 'package:compiti_2/screens/dashboard/todos_eventos.dart';
import 'package:compiti_2/screens/form/campo_data_hora.dart';
import 'package:compiti_2/screens/form/data_hora.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class EventoForm extends StatefulWidget {
  final TodosEventosState todosEventosState;
  final EventosDiaState eventosDiaState;
  final Evento evento;
  final Agendamento agendamento;

  EventoForm(this.todosEventosState, this.eventosDiaState,
      {this.evento, this.agendamento});

  @override
  EventoFormState createState() => EventoFormState();
}

class EventoFormState extends State<EventoForm> {
  final _formKey = GlobalKey<FormState>();
  final DateFormat formatoData = DateFormat('dd/MM/yyyy');

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _horaInicialController = TextEditingController();
  final TextEditingController _horaFinalController = TextEditingController();
  final TextEditingController _dataInicialController = TextEditingController();
  final TextEditingController _dataFinalController = TextEditingController();
  final ControladorAgendamento controladorAgendamento =
      ControladorAgendamento();
  List<Semana> diasDaSemana = List();
  List<SemanaButtonState> listaSemanaButton = List();

  @override
  void initState() {
    if (widget.evento != null) {
      _tituloController.text = widget.evento.titulo;
      _descricaoController.text = widget.evento.descricao;
      _horaInicialController.text =
          widget.evento.horaInicial.toString().substring(10, 15);
      _horaFinalController.text =
          widget.evento.horaFinal.toString().substring(10, 15);
      if (widget.agendamento == null) {
        var dataInicialSplit =
            widget.evento.dataInicial.toString().substring(0, 10).split('-');
        _dataInicialController.text = dataInicialSplit.elementAt(2) +
            '/' +
            dataInicialSplit.elementAt(1) +
            '/' +
            dataInicialSplit.elementAt(0);
        var dataFinalSplit =
            widget.evento.dataFinal.toString().substring(0, 10).split('-');
        _dataFinalController.text = dataFinalSplit.elementAt(2) +
            '/' +
            dataFinalSplit.elementAt(1) +
            '/' +
            dataFinalSplit.elementAt(0);
        diasDaSemana = widget.evento.diasDaSemana;
      } else {
        var dataInicialSplit = widget.agendamento.dataInicial
            .toString()
            .substring(0, 10)
            .split('-');
        _dataInicialController.text = dataInicialSplit.elementAt(2) +
            '/' +
            dataInicialSplit.elementAt(1) +
            '/' +
            dataInicialSplit.elementAt(0);
        var dataFinalSplit =
            widget.agendamento.dataFinal.toString().substring(0, 10).split('-');
        _dataFinalController.text = dataFinalSplit.elementAt(2) +
            '/' +
            dataFinalSplit.elementAt(1) +
            '/' +
            dataFinalSplit.elementAt(0);
        diasDaSemana =
            controladorAgendamento.diasDaSemanaAgendamento(widget.agendamento);
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      datasListener();
      _dataInicialController.addListener(datasListener);
      _dataFinalController.addListener(datasListener);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black,
          ),
        ),
        Positioned(
          top: 25,
          left: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 24.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'O título não pode estar vazio';
                                return null;
                              },
                              controller: _tituloController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Título',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 24.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'O campo descrição não pode ser vazio';
                                return null;
                              },
                              controller: _descricaoController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Descrição',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 24.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: CampoDataHora(
                                    label: 'Hora inicial',
                                    controller: _horaInicialController,
                                    dataHora: DataHora.hora,
                                  ),
                                ),
                                Expanded(
                                  child: CampoDataHora(
                                    label: 'Hora final',
                                    controller: _horaFinalController,
                                    dataHora: DataHora.hora,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 24.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: CampoDataHora(
                                    label: 'Data inicial',
                                    controller: _dataInicialController,
                                    dataHora: DataHora.data,
                                  ),
                                ),
                                Expanded(
                                  child: CampoDataHora(
                                    label: 'Data final',
                                    controller: _dataFinalController,
                                    dataHora: DataHora.data,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24.0),
                      child: Container(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 7,
                          itemBuilder: (context, index) {
                            return SemanaButton(index, this);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          RaisedButton(
                            child: Text('Adicionar'),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                var dataInicialSplit =
                                    _dataInicialController.text.split('/');

                                var dataFinalSplit =
                                    _dataFinalController.text.split('/');

                                var horaInicialSplit =
                                    _horaInicialController.text.split(':');

                                var horaFinalSplit =
                                    _horaFinalController.text.split(':');

                                Evento eventoNew = Evento(
                                  0,
                                  _tituloController.text,
                                  _descricaoController.text,
                                  TimeOfDay(
                                    hour: int.parse(
                                        horaInicialSplit.elementAt(0)),
                                    minute: int.parse(
                                        horaInicialSplit.elementAt(1)),
                                  ),
                                  TimeOfDay(
                                    hour:
                                        int.parse(horaFinalSplit.elementAt(0)),
                                    minute:
                                        int.parse(horaFinalSplit.elementAt(1)),
                                  ),
                                  DateTime(
                                    int.parse(dataInicialSplit.elementAt(2)),
                                    int.parse(dataInicialSplit.elementAt(1)),
                                    int.parse(dataInicialSplit.elementAt(0)),
                                  ),
                                  DateTime(
                                    int.parse(dataFinalSplit.elementAt(2)),
                                    int.parse(dataFinalSplit.elementAt(1)),
                                    int.parse(dataFinalSplit.elementAt(0)),
                                  ),
                                  diasDaSemana,
                                );

                                if (widget.evento == null) {
                                  controladorAgendamento
                                      .salvarEventoAgendamento(
                                          eventoNew,
                                          context,
                                          widget.eventosDiaState.widget
                                              .dashboardState);
                                } else {
                                  if (widget.agendamento == null) {
                                    eventoNew.id = widget.evento.id;

                                    controladorAgendamento
                                        .editarEventoAgendamento(
                                            eventoNew,
                                            widget.eventosDiaState.widget
                                                .dashboardState,
                                            context,
                                            widget.evento);
                                  } else {
                                    controladorAgendamento
                                        .editarSomenteAgendamento(
                                            eventoNew,
                                            widget.eventosDiaState.widget
                                                .dashboardState,
                                            context,
                                            widget.agendamento);
                                  }
                                }
                                Navigator.pop(context);
                              }
                            },
                          ),
                          RaisedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancelar'),
                          ),
                        ],
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

  datasListener() {
    if (_dataInicialController.text != '' &&
        _dataFinalController.text != '' &&
        listaSemanaButton.isNotEmpty) {
      listaSemanaButton.forEach((button) => button.desmarcaButton());
      DateTime dataInicial = formatoData.parse(_dataInicialController.text);
      DateTime dataFinal = formatoData.parse(_dataFinalController.text);
      if (dataFinal.weekday >= dataInicial.weekday &&
          dataFinal.difference(dataInicial).inDays < 7) {
        for (int i = dataInicial.weekday; i <= dataFinal.weekday; i++) {
          listaSemanaButton
              .firstWhere((button) => button.index == i - 1)
              .marcaButton();
        }
      } else {
        if (dataFinal.difference(dataInicial).inDays > 7) {
          listaSemanaButton.forEach((button) => button.marcaButton());
        } else {
          for (int i = dataInicial.weekday; i <= 7; i++) {
            listaSemanaButton
                .firstWhere((button) => button.index == i - 1)
                .marcaButton();
          }
          for (int i = 1; i <= dataFinal.weekday; i++) {
            listaSemanaButton
                .firstWhere((button) => button.index == i - 1)
                .marcaButton();
          }
        }
      }
    }
  }

  // void addDiaDaSemana(int dia) {
  //   switch (dia) {
  //     case 0:
  //       diasDaSemana.add(Semana.domingo);
  //       listaSemanaButton.where((button) => button.index == 6).first.marcaButton();
  //       break;
  //     case 1:
  //       diasDaSemana.add(Semana.segunda);
  //       listaSemanaButton.where((button) => button.index == 0).first.marcaButton();
  //       break;
  //     case 2:
  //       diasDaSemana.add(Semana.terca);
  //       listaSemanaButton.where((button) => button.index == 1).first.marcaButton();
  //       break;
  //     case 3:
  //       diasDaSemana.add(Semana.quarta);
  //       listaSemanaButton.where((button) => button.index == 2).first.marcaButton();
  //       break;
  //     case 4:
  //       diasDaSemana.add(Semana.quinta);
  //       listaSemanaButton.where((button) => button.index == 3).first.marcaButton();
  //       break;
  //     case 5:
  //       diasDaSemana.add(Semana.sexta);
  //       listaSemanaButton.where((button) => button.index == 4).first.marcaButton();
  //       break;
  //     case 6:
  //       diasDaSemana.add(Semana.sabado);
  //       listaSemanaButton.where((button) => button.index == 5).first.marcaButton();
  //       break;
  //     default:
  //       break;
  //   }
  // }

  // void removeDiaDaSemana(int dia) {
  //   switch (dia) {
  //     case 0:
  //       diasDaSemana.removeAt(diasDaSemana.indexOf(Semana.domingo));
  //       listaSemanaButton.where((button) => button.index == 6).first.desmarcaButton();
  //       break;
  //     case 1:
  //       diasDaSemana.removeAt(diasDaSemana.indexOf(Semana.segunda));
  //       listaSemanaButton.where((button) => button.index == 0).first.desmarcaButton();
  //       break;
  //     case 2:
  //       diasDaSemana.removeAt(diasDaSemana.indexOf(Semana.terca));
  //       listaSemanaButton.where((button) => button.index == 1).first.desmarcaButton();
  //       break;
  //     case 3:
  //       diasDaSemana.removeAt(diasDaSemana.indexOf(Semana.quarta));
  //       listaSemanaButton.where((button) => button.index == 2).first.desmarcaButton();
  //       break;
  //     case 4:
  //       diasDaSemana.removeAt(diasDaSemana.indexOf(Semana.quinta));
  //       listaSemanaButton.where((button) => button.index == 3).first.desmarcaButton();
  //       break;
  //     case 5:
  //       diasDaSemana.removeAt(diasDaSemana.indexOf(Semana.sexta));
  //       listaSemanaButton.where((button) => button.index == 4).first.desmarcaButton();
  //       break;
  //     case 6:
  //       diasDaSemana.removeAt(diasDaSemana.indexOf(Semana.sabado));
  //       listaSemanaButton.where((button) => button.index == 5).first.desmarcaButton();
  //       break;
  //     default:
  //       break;
  //   }
  // }
}

class SemanaButton extends StatefulWidget {
  final int _dia;
  final EventoFormState eventoFormState;

  SemanaButton(this._dia, this.eventoFormState);

  @override
  SemanaButtonState createState() => SemanaButtonState();
}

class SemanaButtonState extends State<SemanaButton> {
  String _textoDia;
  int index;
  Color _color = Colors.white;
  Color _colorSplash = Colors.white;

  @override
  void initState() {
    super.initState();
    switch (widget._dia) {
      case 0:
        _textoDia = 'D';
        index = 6;
        break;
      case 1:
        _textoDia = 'S';
        index = 0;
        break;
      case 2:
        _textoDia = 'T';
        index = 1;
        break;
      case 3:
        _textoDia = 'Q';
        index = 2;
        break;
      case 4:
        _textoDia = 'Q';
        index = 3;
        break;
      case 5:
        _textoDia = 'S';
        index = 4;
        break;
      case 6:
        _textoDia = 'S';
        index = 5;
        break;
      default:
        _textoDia = 'S';
        index = 5;
        break;
    }
    if (widget.eventoFormState.diasDaSemana != null) {
      widget.eventoFormState.diasDaSemana.forEach((dia) {
        if (dia.index == this.index) {
          _color = Colors.cyan;
          _colorSplash = Colors.cyan;
        }
      });
    }
    widget.eventoFormState.listaSemanaButton.add(this);
  }

  void marcaButton() {
    setState(() {
      widget.eventoFormState.diasDaSemana.add(Semana.values[index]);
      _color = Colors.cyan;
      _colorSplash = Colors.cyan;
    });
  }

  void desmarcaButton() {
    setState(() {
      widget.eventoFormState.diasDaSemana
          .removeWhere((dia) => dia == Semana.values[index]);
      _color = Colors.white;
      _colorSplash = Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Material(
        color: _color,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          splashColor: _colorSplash,
          customBorder: CircleBorder(),
          onTap: () {
            if (_color == Colors.white) {
              marcaButton();
            } else {
              desmarcaButton();
            }
          },
          child: Container(
            width: 35.0,
            height: 35.0,
            child: Center(
              child: Text(_textoDia),
            ),
          ),
        ),
      ),
    );
  }
}
