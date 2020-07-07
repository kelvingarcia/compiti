import 'package:compiti/controllers/controlador_agendamento.dart';
import 'package:compiti/models/agendamento.dart';
import 'package:compiti/models/evento.dart';
import 'package:compiti/models/semana.dart';
import 'package:compiti/screens/dashboard/eventos_dia.dart';
import 'package:compiti/screens/listas/todos_eventos.dart';
import 'package:compiti/screens/form/campo_data_hora.dart';
import 'package:compiti/screens/form/data_hora.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final TextEditingController horaInicialController = TextEditingController();
  final TextEditingController horaFinalController = TextEditingController();
  final TextEditingController dataInicialController = TextEditingController();
  final TextEditingController dataFinalController = TextEditingController();
  final ControladorAgendamento controladorAgendamento =
      ControladorAgendamento();
  List<Semana> diasDaSemana = List();
  List<SemanaButtonState> listaSemanaButton = List();
  List<Semana> diasValidos = List();

  bool submitted = false;

  @override
  void initState() {
    if (widget.evento != null) {
      _tituloController.text = widget.evento.titulo;
      _descricaoController.text = widget.evento.descricao;
      horaInicialController.text =
          widget.evento.horaInicial.toString().substring(10, 15);
      horaFinalController.text =
          widget.evento.horaFinal.toString().substring(10, 15);
      if (widget.agendamento == null) {
        var dataInicialSplit =
            widget.evento.dataInicial.toString().substring(0, 10).split('-');
        dataInicialController.text = dataInicialSplit.elementAt(2) +
            '/' +
            dataInicialSplit.elementAt(1) +
            '/' +
            dataInicialSplit.elementAt(0);
        var dataFinalSplit =
            widget.evento.dataFinal.toString().substring(0, 10).split('-');
        dataFinalController.text = dataFinalSplit.elementAt(2) +
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
        dataInicialController.text = dataInicialSplit.elementAt(2) +
            '/' +
            dataInicialSplit.elementAt(1) +
            '/' +
            dataInicialSplit.elementAt(0);
        var dataFinalSplit =
            widget.agendamento.dataFinal.toString().substring(0, 10).split('-');
        dataFinalController.text = dataFinalSplit.elementAt(2) +
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
      dataInicialController.addListener(datasListener);
      dataFinalController.addListener(datasListener);
      if (widget.evento != null) {
        widget.evento.diasDaSemana.forEach((diaDaSemana) {
          listaSemanaButton
              .firstWhere((button) => button.index == diaDaSemana.index)
              .marcaButton();
        });
      }
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
          top: MediaQuery.of(context).size.height * 0.04,
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 4.0, top: 8.0),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Icon(
                                Icons.close,
                                color: Colors.black,
                                size: 28.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty)
                                  return 'O título não pode estar vazio';
                                if (value.length > 20)
                                  return 'O título deve ter no máximo 20 caracteres';
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
                          Stack(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 24.0),
                                child: TextFormField(
                                  focusNode: FocusNode(),
                                  showCursor: false,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  validator: (_) {
                                    var horaInicialSplit =
                                        horaInicialController.text.split(':');
                                    var horaFinalSplit =
                                        horaFinalController.text.split(':');
                                    var horaInicial = DateTime.now().add(
                                        Duration(
                                            hours:
                                                int.parse(horaInicialSplit[0]),
                                            minutes: int.parse(
                                                horaInicialSplit[1])));
                                    var horaFinal = DateTime.now().add(Duration(
                                        hours: int.parse(horaFinalSplit[0]),
                                        minutes: int.parse(horaFinalSplit[1])));
                                    var dataInicial = formatoData
                                        .parse(dataInicialController.text);
                                    var dataFinal = formatoData
                                        .parse(dataFinalController.text);
                                    if (horaInicial.isAfter(horaFinal) &&
                                        (dataFinal.isBefore(dataInicial) ||
                                            dataFinal.isAtSameMomentAs(
                                                dataInicial))) {
                                      return 'Hora inicial não pode ser depois da data final';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 24.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: CampoDataHora(
                                        label: 'Hora inicial',
                                        controller: horaInicialController,
                                        dataHora: DataHora.hora,
                                        eventoFormState: this,
                                      ),
                                    ),
                                    Expanded(
                                      child: CampoDataHora(
                                        label: 'Hora final',
                                        controller: horaFinalController,
                                        dataHora: DataHora.hora,
                                        eventoFormState: this,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 24.0),
                                child: TextFormField(
                                  focusNode: FocusNode(),
                                  showCursor: false,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  validator: (_) {
                                    if (formatoData
                                        .parse(dataInicialController.text)
                                        .isAfter(formatoData
                                            .parse(dataFinalController.text))) {
                                      return 'Data inicial não ser pode depois da data final';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 24.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: CampoDataHora(
                                        label: 'Data inicial',
                                        controller: dataInicialController,
                                        dataHora: DataHora.data,
                                        eventoFormState: this,
                                      ),
                                    ),
                                    Expanded(
                                      child: CampoDataHora(
                                        label: 'Data final',
                                        controller: dataFinalController,
                                        dataHora: DataHora.data,
                                        eventoFormState: this,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 24.0, left: 8.0),
                          child: TextFormField(
                            focusNode: FocusNode(),
                            showCursor: false,
                            readOnly: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            validator: (_) {
                              List<bool> validacao = List();
                              diasDaSemana.forEach((dia) {
                                bool valido = false;
                                diasValidos.forEach((diaValido) {
                                  if (diaValido == dia) valido = true;
                                });
                                validacao.add(valido);
                              });
                              if (validacao.contains(false)) {
                                return 'Os dias selecionados não são válidos';
                              }
                              if (diasDaSemana.isEmpty) {
                                return 'Selecione ao menos um dia';
                              }
                              return null;
                            },
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
                      ],
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
                                var horaInicialSplit =
                                    horaInicialController.text.split(':');
                                var horaFinalSplit =
                                    horaFinalController.text.split(':');
                                var horaInicial = DateTime.now().add(Duration(
                                    hours: int.parse(horaInicialSplit[0]),
                                    minutes: int.parse(horaInicialSplit[1])));
                                var horaFinal = DateTime.now().add(Duration(
                                    hours: int.parse(horaFinalSplit[0]),
                                    minutes: int.parse(horaFinalSplit[1])));
                                if (horaFinal.isBefore(horaInicial) &&
                                    diasDaSemana.length == 1) {
                                  _eventoVirado();
                                } else {
                                  _enviaFormulario();
                                }
                              }
                            },
                          ),
                          RaisedButton(
                            onPressed: () => Navigator.of(context).pop(),
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

  void _enviaFormulario() {
    submitted = true;
    var dataInicialSplit = dataInicialController.text.split('/');

    var dataFinalSplit = dataFinalController.text.split('/');

    var horaInicialSplit = horaInicialController.text.split(':');

    var horaFinalSplit = horaFinalController.text.split(':');

    Evento eventoNew = Evento(
      0,
      _tituloController.text,
      _descricaoController.text,
      TimeOfDay(
        hour: int.parse(horaInicialSplit.elementAt(0)),
        minute: int.parse(horaInicialSplit.elementAt(1)),
      ),
      TimeOfDay(
        hour: int.parse(horaFinalSplit.elementAt(0)),
        minute: int.parse(horaFinalSplit.elementAt(1)),
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
      controladorAgendamento.salvarEventoAgendamento(
          eventoNew, context, widget.eventosDiaState.widget.dashboardState);
    } else {
      if (widget.agendamento == null) {
        eventoNew.id = widget.evento.id;

        controladorAgendamento.editarEventoAgendamento(
            eventoNew,
            widget.eventosDiaState.widget.dashboardState,
            context,
            widget.evento);
      } else {
        controladorAgendamento.editarSomenteAgendamento(
            eventoNew,
            widget.eventosDiaState.widget.dashboardState,
            context,
            widget.agendamento);
      }
    }
    Navigator.of(context).pop();
  }

  Future<void> _eventoVirado() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Atenção'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Seu evento começa em um dia e termina em outro.'),
                Text('Início: ' +
                    dataInicialController.text +
                    ' às ' +
                    horaInicialController.text),
                Text('Término: ' +
                    dataFinalController.text +
                    ' às ' +
                    horaFinalController.text),
                Text('Confirma?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Confirmar'),
              onPressed: () {
                Navigator.of(context).pop();
                _enviaFormulario();
              },
            ),
          ],
        );
      },
    );
  }

  datasListener() {
    if (dataInicialController.text != '' &&
        dataFinalController.text != '' &&
        listaSemanaButton.isNotEmpty &&
        !submitted) {
      if (widget.evento == null)
        listaSemanaButton.forEach((button) => button.desmarcaButton());
      var horaInicialSplit = horaInicialController.text.split(':');
      var horaFinalSplit = horaFinalController.text.split(':');
      var horaInicial = DateTime.now().add(Duration(
          hours: int.parse(horaInicialSplit[0]),
          minutes: int.parse(horaInicialSplit[1])));
      var horaFinal = DateTime.now().add(Duration(
          hours: int.parse(horaFinalSplit[0]),
          minutes: int.parse(horaFinalSplit[1])));
      DateTime dataInicial = formatoData.parse(dataInicialController.text);
      DateTime dataFinal = formatoData.parse(dataFinalController.text);
      var eventoVirado = false;
      if (horaInicial.isAfter(horaFinal) && dataFinal.isAfter(dataInicial)) {
        listaSemanaButton
            .firstWhere((button) => button.index == dataInicial.weekday - 1)
            .marcaButton();
        eventoVirado = true;
      }
      if (dataFinal.weekday >= dataInicial.weekday &&
          dataFinal.difference(dataInicial).inDays < 7) {
        for (int i = dataInicial.weekday; i <= dataFinal.weekday; i++) {
          if (widget.evento == null && !eventoVirado)
            listaSemanaButton
                .firstWhere((button) => button.index == i - 1)
                .marcaButton();
          diasValidos.add(Semana.values[i - 1]);
        }
      } else {
        if (dataFinal.difference(dataInicial).inDays > 7) {
          for (int i = 0; i < 7; i++) {
            if (widget.evento == null && !eventoVirado)
              listaSemanaButton.elementAt(i).marcaButton();
            diasValidos.add(Semana.values[i]);
          }
        } else {
          for (int i = dataInicial.weekday; i <= 7; i++) {
            if (widget.evento == null && !eventoVirado)
              listaSemanaButton
                  .firstWhere((button) => button.index == i - 1)
                  .marcaButton();
            diasValidos.add(Semana.values[i - 1]);
          }
          for (int i = 1; i <= dataFinal.weekday; i++) {
            if (widget.evento == null && !eventoVirado)
              listaSemanaButton
                  .firstWhere((button) => button.index == i - 1)
                  .marcaButton();
            diasValidos.add(Semana.values[i - 1]);
          }
        }
      }
    }
  }
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
          _color = Color(0xFF6599FF);
          _colorSplash = Color(0xFF6599FF);
        }
      });
    }
    widget.eventoFormState.listaSemanaButton.add(this);
  }

  void marcaButton() {
    setState(() {
      widget.eventoFormState.diasDaSemana.add(Semana.values[index]);
      _color = Color(0xFF6599FF);
      _colorSplash = Color(0xFF6599FF);
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
