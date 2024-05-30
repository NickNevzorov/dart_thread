import 'dart:convert';
import 'dart:html';
import 'dart_thread_interface.dart';

/// DartThread implementation for web
typedef DartThread = DartThreadWorker;

abstract class DartThreadWorker extends DartThreadInterface {
  Worker? worker;
  DedicatedWorkerGlobalScope? self;

  /// js script file name
  String jsFileName();

  Future<void> init(NewInstance newInstance, OnMessage onGetMessage) async {
    deInit();
    worker = new Worker(jsFileName()  + '.dart.js');
    worker?.onMessage.listen((MessageEvent e) {
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
      dynamic message = jsonDecode(e.data);
      await onGetMessage(messageToObject(message), sendMessage);
    });

    await onExecute(sendMessage);
  }
}
