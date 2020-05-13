import 'package:flutter/material.dart';

class ItemEvento extends StatefulWidget {
  @override
  _ItemEventoState createState() => _ItemEventoState();
}

class _ItemEventoState extends State<ItemEvento> {
  double _toggleLeft = 95.0;
  String _status = 'Agendado';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.9,
//        height: MediaQuery.of(context).size.height * 0.3,
        color: Color(0xFF626262),
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.07,
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
                          Icons.category,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'Teste Evento',
                            style:
                            TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.delete,
                          color: Colors.white,
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
                    'Mai 15',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    '08:00',
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
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
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
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.05,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: 8,
                        left: 20,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _toggleLeft = 2;
                              _status = 'Feito';
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
                            setState(() {
                              _toggleLeft = 95;
                              _status = 'Agendado';
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
                            setState(() {
                              _toggleLeft = 202;
                              _status = 'Não feito';
                            });
                          },
                          child: Text('Não feito'),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 300),
                        top: 1.5,
                        left: _toggleLeft,
                        child: GestureDetector(
                          onHorizontalDragUpdate: (dragInfo) {
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
                              if (_toggleLeft == 202 && _status == 'Feito') {
                                _toggleLeft = 95;
                                _status = 'Agendado';
                              } else {
                                if (_toggleLeft == 202 && _status == 'Agendado'){
                                  _status = 'Não feito';
                                } else {
                                  if(_toggleLeft == 95 && (_status == 'Feito' || _status == 'Não feito')){
                                    _status = 'Agendado';
                                  } else {
                                    if(_toggleLeft == 02 && _status == 'Agendado'){
                                      _status = 'Feito';
                                    } else {
                                      if(_toggleLeft == 02 && _status == 'Não feito'){
                                        _toggleLeft = 95;
                                        _status = 'Agendado';
                                      }
                                    }
                                  }
                                }
                              }
                            });
                          },
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            child: SizedBox(
                              height:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.045,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.3,
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
}