import 'package:flutter/material.dart';
import 'package:compiti_2/screens/dashboard/dashboard.dart';

class BarraSuperior extends StatefulWidget {
  final DashboardState parent;

  BarraSuperior({this.parent});

  @override
  _BarraSuperiorState createState() => _BarraSuperiorState();
}

class _BarraSuperiorState extends State<BarraSuperior> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
                      if (this.widget.parent.topCorpo == 100.0) {
                        this.widget.parent.setState(() {
                          this.widget.parent.topCorpo = 400.0;
                        });
                      } else {
                        this.widget.parent.setState(() {
                          this.widget.parent.topCorpo = 100.0;
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
    );
  }
}