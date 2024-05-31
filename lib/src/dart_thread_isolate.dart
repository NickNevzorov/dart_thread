import 'dart:async';
import 'dart:isolate';
import 'dart_thread_interface.dart';

/// DartThread implementation for desktop platform
typedef DartThread = DartThreadIsolate;

abstract class DartThreadIsolate extends DartThreadInterface {
  Isolate? isolate;
  SendPort? sendMessagePort;

  String jsFileName() {
    return this.runtimeType.toString();
  }

  Future<void> init(NewInstance newInstance, OnMessage onGetMessage) async {
    await deInit();

    final ReceivePort port = ReceivePort();

    List<dynamic> params = [];
    params.add(port.sendPort);
    params.add(newInstance);
    //params.add(onExecute);
    //params.add(onGetMessage);
    isolate = await Isolate.spawn(start, params, errorsAreFatal: false);

    Completer c = new Completer();

    port.listen((dynamic message) async {
      if (message is SendPort) {
        sendMessagePort = message;
        c.complete();
      } else {
        onGetMessage(message);
      }
    });

    await c.future;
  }

  static void start(List<dynamic> params) async {
    final SendPort sendPort = params[0];
    final DartThread dartThread = params[1]();
    //OnExecute onExecute = params[1];
    //OnGetMessage onGetMessage = params[2];

    final isolateReceivePort = ReceivePort();

    var sendMessage = (dynamic message) {
      sendPort.send(message);
    };

    isolateReceivePort.listen((message) async {
      await dartThread.onGetMessage(message, sendMessage);
    });

    sendMessage(isolateReceivePort.sendPort);
    await dartThread.onExecute(sendMessage);
  }

  Future<void> deInit() async {
    isolate?.kill(priority: Isolate.immediate);
  }

  void sendMessage(dynamic message) {
    sendMessagePort?.send(message);
  }
}
