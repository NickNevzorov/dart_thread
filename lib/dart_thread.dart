library dart_thread;

import 'src/dart_thread_isolate.dart'
    if (dart.library.js) 'src/dart_thread_web.dart' as dart_thread;

// debug
// import 'src/dart_thread_isolate.dart' as dart_thread;
// import 'src/dart_thread_web.dart' as dart_thread;

typedef DartThread = dart_thread.DartThread;
