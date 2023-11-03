typedef OnMessage = Function(dynamic message);
typedef OnGetMessage = Function(dynamic message, OnMessage);
typedef OnExecute = Function(OnMessage);
typedef NewInstance = DartThreadInterface Function();

abstract class DartThreadInterface {

  Future<void> init(NewInstance newInstance, OnMessage onGetMessage);
  Future<void> deInit();

  void sendMessage(dynamic message);
  Future<void> onGetMessage(dynamic message, Function(dynamic message) sendMessage);
  Future<void> onExecute(Function(dynamic message) sendMessage);

  dynamic messageToObject(dynamic message) {
    return message;
  }

  Future<void> main(dynamic obj) async {

  }

}