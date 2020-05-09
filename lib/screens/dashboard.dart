import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.cyan,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 32.0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 95.0),
                      child: Text(
                        'Compiti',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 100,
          left: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: Color(0xFF383838),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                )),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(top: 24.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Eventos',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.cyan, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                            child: Text(
                              'Dia',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Mês',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 16.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: MediaQuery.of(context).size.height * 0.3,
                                color: Color(0xFF626262),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height * 0.07,
                                      color: Color(0xFF121212),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: 8.0,
                                          right: 8.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                    style: TextStyle(
                                                        color: Colors.white, fontSize: 16.0),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 16.0),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.3,
                              color: Color(0xFF626262),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height * 0.07,
                                    color: Color(0xFF121212),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                                  style: TextStyle(
                                                      color: Colors.white, fontSize: 16.0),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 16.0),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

