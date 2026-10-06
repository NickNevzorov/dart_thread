import 'dart_thread_interface.dart';

/// DartThread implementation stub
typedef DartThread = DartThreadStub;

abstract class DartThreadStub extends DartThreadInterface {
  Future<void> init(NewInstance newInstance, OnMessage onGetMessage,
      {dynamic initMessage}) async {}

  static void start(List<dynamic> params) async {}

  Future<void> deInit() async {}

  void sendMessage(dynamic message) {}
}
