import 'package:compiti/models/agendamento.dart';
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

  Future<void> agendaNotificacao(
      DateTime dataHora, Agendamento agendamento) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    agendamento.evento.listaNotificar.forEach((valor) async {
      var tituloNotificacao = agendamento.evento.titulo;
      if (valor != 0) {
        if (valor == 1440) {
          tituloNotificacao = tituloNotificacao + ' - daqui há 1 dia';
        } else {
          if (valor == 60) {
            tituloNotificacao = tituloNotificacao + ' - daqui há 1 hora';
          } else {
            if (valor == 120) {
              tituloNotificacao = tituloNotificacao + ' - daqui há 2 horas';
            } else {
              tituloNotificacao = tituloNotificacao +
                  ' - daqui há ' +
                  valor.toString() +
                  ' minutos';
            }
          }
        }
      }
      int id = dataHora.hashCode + valor;
      await flutterLocalNotificationsPlugin.schedule(
        id,
        tituloNotificacao,
        agendamento.evento.descricao,
        dataHora.subtract(Duration(minutes: valor)),
        platformChannelSpecifics,
      );
      agendamento.notificacoes.add(id);
    });
  }

  void removeNotificacoes(Agendamento agendamento) async {
    agendamento.notificacoes.forEach((id) async {
      await flutterLocalNotificationsPlugin.cancel(id);
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
