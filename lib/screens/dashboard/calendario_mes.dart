import 'package:flutter/material.dart';

class CalendarioMes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GridView.builder(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        itemCount: 31,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 2.0),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 10.0,
            width: 10.0,
            color: Colors.red[200],
            child: Center(
              child: Text((index + 1).toString()),
            ),
          );
        },
      ),
    );
  }
}
