/// Classic thread implementation (such as TThread in Delphi).
/// Easy to use, single code for all platforms (mapping to isolate on desktop or to worker on web).

library dart_thread;

import 'src/dart_thread_isolate.dart'
    if (dart.library.js) 'src/dart_thread_web.dart' as dart_thread;

// debug
// import 'src/dart_thread_isolate.dart' as dart_thread;
// import 'src/dart_thread_web.dart' as dart_thread;

/// Mapping DartThread to DartThreadIsolate or DartThreadWeb
typedef DartThread = dart_thread.DartThread;
