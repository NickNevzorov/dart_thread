@JS()

import 'dart:html';
import 'dart:js_interop';
import 'main.dart';

@JS('self')
external DedicatedWorkerGlobalScope get self;

void main() async {

  await TestThread().main(self);

}