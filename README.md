## dart_thread

Classic thread implementation (such as TThread in Delphi). Easy to use, single code for all platforms (mapping to isolates on desktop or to workers on web).

## Features

Class DartThread has an onExecute method, which executing on thread start, and onGetMessage, which triggered when main thread send a message. 
DartThread also can send a messages to main thread.

Web platform have restriction while sending variables from main thread to worker. 
JS allow sends only primitives, not a custom classed and other structures. 
For communication with worker DartThread has an messageToObject method, witch allow implements unpacking custom variables from json. 
For packing data custom class will have an toJson and fromJson methods.

## Usage

```dart
class TestThread extends DartThread {

  // Need to mapping Class to super.init, 
  // because dart did not allow override a static method
  static TestThread newInstance() => TestThread(); 

  @override
  // Running once in isolate or worker 
  Future<void> onExecute(Function(dynamic message) sendMessage) async {

    while (true) {
      sendMessage(Random().nextInt(100));
      await Future.delayed(Duration(seconds: 1));
    }

  }

  @override
  // Triggered on each sendMessage from main thread  
  Future<void> onGetMessage(message, Function(dynamic message) sendMessage) async {

    sendMessage(message);

  }

}
```

In app:
```dart

main() async {

  TestThread testThread = TestThread();

  await testThread.init(TestThread.newInstance, (message) {

    // Receive from isolate or worker
    print(message);

  });

  // Send message to isolate or worker
  testThread.sendMessage('echo');

  await Future.delayed(Duration(seconds: 10));

  testThread.deInit();

  exit(0);

}

```

## Prepare web worker

1. Create web worker dart file with name of a class, for example TestThread.dart:

```dart
@JS()

import 'dart:html';
import 'dart:js_interop';
import 'main.dart';

@JS('self')
external DedicatedWorkerGlobalScope get self;

void main() async {

  await TestThread().main(self);

}
```

2. Compile dart file to js using command-line in web folder of project:

```cmd
set "dart_path=D:\sdk\flutter\bin\cache\dart-sdk\bin"
set "flutter_web_sdk=D:\sdk\flutter\bin\cache\flutter_web_sdk"

call "%dart_path%\dart" compile js -O2 --libraries-spec="%flutter_web_sdk"\libraries.json -o web/TestThread.dart.js lib/TestThread.dart || pause
```

## Send custom classes to web worker

```dart

class CustomClass {
  Map<String, dynamic> toJson() => {
    'runtimeType': 'CustomClass',
    // other properties
  };
}

class TestThread extends DartThread {
  @override
  dynamic messageToObject(dynamic message) {
    if (message is Map<String, dynamic>) {
      if (message['runtimeType'] == 'CustomClass') 
        return CustomClass.fromJson(message);
    }
    return super.messageToObject(message);
  }
}

```

