import 'dart:io';
import 'dart:math';

import 'package:dart_thread/dart_thread.dart';

class TestThread extends DartThread {

  static TestThread newInstance() => TestThread(); // Need to mapping Class to super.init, because dart did not allow override a static method

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

main() async {

  TestThread testThread = TestThread();

  await testThread.init(TestThread.newInstance, (message) {

    print(message);

  });

  testThread.sendMessage('echo');

  await Future.delayed(Duration(seconds: 10));

  testThread.deInit();

  exit(0);

}
