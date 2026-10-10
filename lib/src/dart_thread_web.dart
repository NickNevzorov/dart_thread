import 'dart:convert';
import 'dart:js_interop';
import 'package:web/web.dart';
import 'dart_thread_interface.dart';

/// DartThread implementation for web
typedef DartThread = DartThreadWorker;

abstract class DartThreadWorker extends DartThreadInterface {
  Worker? worker;
  DedicatedWorkerGlobalScope? self;

  Future<void> init(NewInstance newInstance, OnMessage onGetMessage,
      {dynamic initMessage}) async {
    deInit();
    worker = new Worker((jsFileName() + '.dart.js').toJS);
    EventStreamProviders.messageEvent
        .forTarget(worker)
        .listen((MessageEvent e) {
      dynamic message = jsonDecode(e.data.toString());
      onGetMessage.call(messageToObject(message));
    });
  }

  Future<void> deInit() async {
    worker?.terminate();
  }

  void sendMessage(dynamic message) {
    String objString = jsonEncode(message);
    worker?.postMessage(objString.toJS);
  }

  Future<void> main(dynamic obj) async {
    self = obj;

    var sendMessage = (dynamic message) {
      String objString = jsonEncode(message);
      self?.postMessage(objString.toJS);
    };

    EventStreamProviders.messageEvent.forTarget(self).listen((e) async {
      dynamic message = jsonDecode(e.data.toString());
      await onGetMessage(messageToObject(message), sendMessage);
    });

    await onExecute(sendMessage);
  }
}
