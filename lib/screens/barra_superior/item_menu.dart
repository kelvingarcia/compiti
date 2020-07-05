import 'package:flutter/material.dart';

class ItemMenu extends StatelessWidget {
  BorderSide borderTop;
  final bool hasTop;
  final IconData icone;
  final String texto;
  Function onPressed;

  ItemMenu(
      {@required this.hasTop,
      @required this.icone,
      @required this.texto,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (hasTop) {
      borderTop = BorderSide(
        color: Colors.white,
        width: 1.0,
      );
    } else {
      borderTop = BorderSide.none;
    }
    if (onPressed == null) {
      onPressed = () {};
    }
    return Material(
      color: Color(0xFF6599FF),
      shadowColor: Colors.white,
      child: InkWell(
        splashColor: Colors.white,
        onTap: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: borderTop,
              bottom: BorderSide(
                color: Colors.white,
                width: 1.0,
              ),
            ),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.08,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(
                    this.icone,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    this.texto,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
