import 'package:flutter/material.dart';

class ReportarProblema extends StatelessWidget {
  final TextEditingController problemaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Reportar problema'),
        backgroundColor: Color(0xFF6599FF),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: problemaController,
              decoration: InputDecoration(labelText: 'Descreva o problema'),
              validator: (value) {
                if (value.isEmpty) return 'O problema não pode estar vazio';
                return null;
              },
            ),
            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text('O problema foi enviado!'),
                    ),
                  );
                }
              },
              child: Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
