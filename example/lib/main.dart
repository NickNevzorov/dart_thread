import 'package:dart_thread/dart_thread.dart';

class TestThread extends DartThread {

  // Need to mapping Class to super.init,
  // because dart did not allow override a static method
  static TestThread newInstance() => TestThread();

  @override
  messageToObject(message) {

    if (message is Map<String, dynamic>) {

      if (message['runtimeType'] == 'CustomClass') return CustomClass.fromJson(message);

    }

    return super.messageToObject(message);
  }

  @override
  Future<void> onExecute(Function(dynamic message) sendMessage) async {
    int counter = 0;
    while (true) {
      sendMessage(++counter);
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  Future<void> onGetMessage(message, Function(dynamic message) sendMessage) async {
    print('Receive message from main thread: $message');
    sendMessage(message);
  }

}

class CustomClass {
  final int i;
  final String s;
  final double d;

  CustomClass(this.i, this.s, this.d);

  String toString() {
    return '$i, $s, $d';
  }

  Map<String, dynamic> toJson() => {
    'runtimeType': 'CustomClass',
    'i': i,
    's': s,
    'd' : d,
  };

  CustomClass.fromJson(Map<String, dynamic> json) :
        i = json['i'],
        s = json['s'],
        d = json['d'];

}

void main() async {

  TestThread testThread1 = TestThread();
  TestThread testThread2 = TestThread();

  await testThread1.init(TestThread.newInstance, (message) {
    print('Receive message from testThread1: $message');
  });

  await testThread2.init(TestThread.newInstance, (message) {
    print('Receive message from testThread2: $message');
  });

  testThread1.sendMessage('echo');
  testThread2.sendMessage('echo');

  CustomClass customClass = CustomClass(1, '1', 1.0);
  testThread1.sendMessage(customClass);
  testThread2.sendMessage(customClass);

  await Future.delayed(Duration(seconds: 10));

  testThread1.deInit();
  testThread2.deInit();

}
