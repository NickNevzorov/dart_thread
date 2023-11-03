@JS()

import 'dart:html';
import 'dart:js_interop';
import 'dart_thread_example.dart';

@JS('self')
external DedicatedWorkerGlobalScope get self;

void main() async {

  await TestThread().main(self);

}