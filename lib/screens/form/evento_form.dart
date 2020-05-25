import 'package:compiti_2/database/evento_dao.dart';
import 'package:compiti_2/models/evento.dart';
import 'package:compiti_2/models/evento_status.dart';
import 'package:compiti_2/screens/dashboard/eventos_dia.dart';
import 'package:compiti_2/screens/dashboard/todos_eventos.dart';
import 'package:flutter/material.dart';

class EventoForm extends StatefulWidget {
  final TodosEventosState todosEventosState;
  final EventosDiaState eventosDiaState;

  EventoForm(this.todosEventosState, this.eventosDiaState);

  @override
  _EventoFormState createState() => _EventoFormState();
}

class _EventoFormState extends State<EventoForm> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _horaInicialController = TextEditingController();
  final TextEditingController _horaFinalController = TextEditingController();
  final TextEditingController _dataInicialController = TextEditingController();
  final TextEditingController _dataFinalController = TextEditingController();
  final EventoDao _dao = EventoDao();

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
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: TextField(
                      controller: _tituloController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Título',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: TextField(
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
                          child: TextField(
                            controller: _horaInicialController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Hora inicial',
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _horaFinalController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Hora final',
                            ),
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
                          child: TextField(
                            controller: _dataInicialController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Data inicial',
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _dataFinalController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Data final',
                            ),
                          ),
                        ),
                      ],
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
                            var dataInicialSplit =
                                _dataInicialController.text.split('/');
                            var dataFinalSplit =
                                _dataFinalController.text.split('/');
                            var horaInicialSplit =
                                _horaInicialController.text.split(':');
                            var horaFinalSplit =
                                _horaFinalController.text.split(':');
                            _dao
                                .save(
                                  Evento(
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
                                      hour: int.parse(
                                          horaFinalSplit.elementAt(0)),
                                      minute: int.parse(
                                          horaFinalSplit.elementAt(1)),
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
                                    EventoStatus.agendado,
                                  ),
                                )
                                .then((id) {
                                  widget.eventosDiaState.atualizaLista();
                                  widget.todosEventosState.atualizaLista();
                                  Navigator.pop(context);
                                });
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
      ],
    );
  }
}
