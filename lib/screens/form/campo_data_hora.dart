import 'package:compiti/screens/form/evento_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'data_hora.dart';

class CampoDataHora extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final EventoFormState eventoFormState;
  final DataHora dataHora;

  CampoDataHora(
      {@required this.label,
      @required this.controller,
      @required this.dataHora,
      @required this.eventoFormState});

  @override
  _CampoDataHoraState createState() => _CampoDataHoraState();
}

class _CampoDataHoraState extends State<CampoDataHora> {
  final DateFormat formatoData = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    var dateTime = DateTime.now();
    var timeOfDay = TimeOfDay.now();
    if (widget.controller.text == '') {
      if (widget.dataHora == DataHora.data)
        widget.controller.text = formatoData.format(dateTime);
      else
        widget.controller.text = timeOfDay.hour.toString() + ':00';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: FocusNode(),
      showCursor: true,
      readOnly: true,
      onTap: () {
        if (widget.dataHora == DataHora.data)
          mostraDatePicker();
        else
          mostraTimePicker();
      },
      controller: widget.controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: widget.label,
      ),
    );
  }

  void mostraDatePicker() async {
    var date = await showDatePicker(
      context: context,
      initialDate: formatoData.parse(widget.controller.text),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) widget.controller.text = formatoData.format(date);
  }

  void mostraTimePicker() async {
    var horaSplit = widget.controller.text.split(':');
    var time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(horaSplit[0]),
        minute: int.parse(horaSplit[1]),
      ),
    );
    if (time != null) widget.controller.text = time.format(context);
  }
}
