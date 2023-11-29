typedef OnMessage = Function(dynamic message);
typedef OnGetMessage = Function(dynamic message, OnMessage);
typedef OnExecute = Function(OnMessage);
typedef NewInstance = DartThreadInterface Function();

/// DartThread interface for all platforms
abstract class DartThreadInterface {
  /// init new isolate or worker
  Future<void> init(NewInstance newInstance, OnMessage onGetMessage);

  /// kill isolate or stop worker
  Future<void> deInit();

  /// send message from main thread to isolate or worker
  void sendMessage(dynamic message);

  /// receive message in isolate or worker from main thread
  Future<void> onGetMessage(
      dynamic message, Function(dynamic message) sendMessage) async {}

  /// running once in isolate or worker after starting
  Future<void> onExecute(Function(dynamic message) sendMessage) async {}

  /// converting message to dart object, only for web
  dynamic messageToObject(dynamic message) {
    return message;
  }

  /// starting new thread in worker, only for web
  Future<void> main(dynamic obj) async {}
}
