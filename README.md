Mapping isolates and web workers to single interface

## Features

Provides one interface to writing isolates for desktop and web workers to web platform.

You need to create a new class extend DartThread and override methods:

1. onGetMessage - for receiving a messages from main thread
2. onExecute - for execution task in thread
3. messageToObject - for mapping custom class to web worker

## Usage

```dart
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
```

In app:
```dart

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

```

## Prepare web worker

1. Create web worker dart file with name of a class, for example TestThread.dart:

```dart
@JS()

import 'dart:html';
import 'dart:js_interop';
import 'dart_thread_example.dart';

@JS('self')
external DedicatedWorkerGlobalScope get self;

void main() async {

  await TestThread().main(self);

}
```

2. Compile dart file to js using command-line:

```cmd
set "dart_path=D:\sdk\flutter\bin\cache\dart-sdk\bin"
set "flutter_web_sdk=D:\sdk\flutter\bin\cache\flutter_web_sdk"

call "%dart_path%\dart" compile js -O2 --libraries-spec="%flutter_web_sdk"\libraries.json -o web/TestThread.dart.js lib/TestThread.dart || pause
```

3. Move dart.js file in web folder of Flutter app  
 
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

