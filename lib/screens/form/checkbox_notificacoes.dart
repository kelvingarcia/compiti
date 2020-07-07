import 'package:flutter/material.dart';

class CheckboxNotificacoes extends StatefulWidget {
  List<int> notifica;

  CheckboxNotificacoes(this.notifica);

  @override
  _CheckboxNotificacoesState createState() => _CheckboxNotificacoesState();
}

class _CheckboxNotificacoesState extends State<CheckboxNotificacoes> {
  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: <Widget>[
        CheckboxListTile(
          onChanged: (value) {
            setState(() {
              if (!widget.notifica.contains(0))
                widget.notifica.add(0);
              else
                widget.notifica.remove(0);
            });
          },
          title: Text('Na hora'),
          value: widget.notifica.contains(0),
        ),
        CheckboxListTile(
          onChanged: (value) {
            setState(() {
              if (!widget.notifica.contains(5))
                widget.notifica.add(5);
              else
                widget.notifica.remove(5);
            });
          },
          title: Text('5 minutos antes'),
          value: widget.notifica.contains(5),
        ),
        CheckboxListTile(
          onChanged: (value) {
            setState(() {
              if (!widget.notifica.contains(10))
                widget.notifica.add(10);
              else
                widget.notifica.remove(10);
            });
          },
          title: Text('10 minutos antes'),
          value: widget.notifica.contains(10),
        ),
        CheckboxListTile(
          onChanged: (value) {
            setState(() {
              if (!widget.notifica.contains(15))
                widget.notifica.add(15);
              else
                widget.notifica.remove(15);
            });
          },
          title: Text('15 minutos antes'),
          value: widget.notifica.contains(15),
        ),
        CheckboxListTile(
          onChanged: (value) {
            setState(() {
              if (!widget.notifica.contains(30))
                widget.notifica.add(30);
              else
                widget.notifica.remove(30);
            });
          },
          title: Text('30 minutos antes'),
          value: widget.notifica.contains(30),
        ),
        CheckboxListTile(
          onChanged: (value) {
            setState(() {
              if (!widget.notifica.contains(60))
                widget.notifica.add(60);
              else
                widget.notifica.remove(60);
            });
          },
          title: Text('1 hora antes'),
          value: widget.notifica.contains(60),
        ),
        CheckboxListTile(
          onChanged: (value) {
            setState(() {
              if (!widget.notifica.contains(120))
                widget.notifica.add(120);
              else
                widget.notifica.remove(120);
            });
          },
          title: Text('2 horas antes'),
          value: widget.notifica.contains(120),
        ),
        CheckboxListTile(
          onChanged: (value) {
            setState(() {
              if (!widget.notifica.contains(1440))
                widget.notifica.add(1440);
              else
                widget.notifica.remove(1440);
            });
          },
          title: Text('1 dia antes'),
          value: widget.notifica.contains(1440),
        ),
        CheckboxListTile(
          onChanged: (value) {
            setState(() {
              if (widget.notifica.isNotEmpty) widget.notifica = List();
            });
          },
          title: Text('Não notificar'),
          value: widget.notifica.isEmpty,
        ),
      ],
    );
  }
}
