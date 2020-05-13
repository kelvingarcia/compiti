import 'package:compiti_2/screens/dashboard/barra_superior.dart';
import 'package:compiti_2/screens/dashboard/corpo_dashboard.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double topCorpo = 100;

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
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 40.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            if(topCorpo == 100.0){
                              setState(() {
                                topCorpo = 400.0;
                              });
                            } else {
                              setState(() {
                                topCorpo = 100.0;
                              });
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 32.0,
                            ),
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
                  Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Item Menu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'Item Menu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'Item Menu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'Item Menu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 400),
          top: topCorpo,
          left: 0,
          child: CorpoDashboard(),
        )
      ],
    );
  }
}

