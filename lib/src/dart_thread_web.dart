import 'dart:convert';
import 'dart:html';
import 'dart_thread_interface.dart';

typedef DartThread = DartThreadWorker;

abstract class DartThreadWorker  extends DartThreadInterface {

  Worker? worker;
  DedicatedWorkerGlobalScope? self;

  Future<void> init(NewInstance newInstance, OnMessage onGetMessage) async {

    deInit();
    worker = new Worker(this.runtimeType.toString() + '.dart.js');
    worker?.onMessage.listen((MessageEvent e) {

      print('Message received from worker: ${e.data}');
      dynamic message = jsonDecode(e.data);
      onGetMessage.call(messageToObject(message));

    });

  }

  Future<void> deInit() async {
    worker?.terminate();
  }

  void sendMessage(dynamic message) {
    String objString = jsonEncode(message);
    worker?.postMessage(objString);
  }

  Future<void> main(dynamic obj) async {

    self = obj;

    var sendMessage = (dynamic message) {
      String objString = jsonEncode(message);
      self?.postMessage(objString);
    };

    self?.onMessage.listen((e) async {
      print('Message received: ${e.data}');
      dynamic message = jsonDecode(e.data);
      await onGetMessage(messageToObject(message), sendMessage);
    });

    await onExecute(sendMessage);

  }

}