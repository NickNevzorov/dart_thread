// ignore: avoid_web_libraries_in_flutter
@JS()

import 'dart:html';
import 'dart:js_interop';
import 'main.dart';

@JS('self')
external JSObject get _self;
DedicatedWorkerGlobalScope get self => _self as DedicatedWorkerGlobalScope;

void main() async {
  await TestThread().main(self);
}
