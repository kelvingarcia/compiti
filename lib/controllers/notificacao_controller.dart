import 'package:compiti/models/evento.dart';
import 'package:compiti/screens/dashboard/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificacaoController {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  BuildContext context;

  NotificacaoController(this.context) {
    this.iniciaConfigNotify();
  }

  void iniciaConfigNotify() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('compiti_logo');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  void agendaNotificacao(DateTime dataHora, Evento evento) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    evento.listaNotificar.forEach((valor) async {
      var tituloNotificacao = evento.titulo;
      if (valor != 0) {
        if (valor == 1440) {
          tituloNotificacao = tituloNotificacao + ' - daqui há 1 dia';
        } else {
          tituloNotificacao = tituloNotificacao +
              ' - daqui há ' +
              valor.toString() +
              ' minutos';
        }
      }
      await flutterLocalNotificationsPlugin.schedule(
        0,
        tituloNotificacao,
        evento.descricao,
        dataHora.subtract(Duration(minutes: valor)),
        platformChannelSpecifics,
      );
    });
  }

  Future selectNotification(String payload) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Material(child: Dashboard())),
    );
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Material(child: Dashboard()),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
