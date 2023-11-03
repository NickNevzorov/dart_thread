import 'dart:math';
import 'package:dart_thread/dart_thread.dart';

class TestThread extends DartThread {

  // Need to mapping Class to super.init,
  // because dart did not allow override a static method
  static TestThread newInstance() => TestThread();

  @override
  Future<void> onExecute(Function(dynamic message) sendMessage) async {

    while (true) {
      sendMessage(Random().nextInt(100));
      await Future.delayed(Duration(seconds: 1));
    }

  }

  @override
  Future<void> onGetMessage(message, Function(dynamic message) sendMessage) async {

    sendMessage(message);

  }

}

void main() async {

  TestThread testThread = TestThread();

  await testThread.init(TestThread.newInstance, (message) {

    print(message);

  });

  testThread.sendMessage('echo');

  await Future.delayed(Duration(seconds: 10));

  testThread.deInit();

}