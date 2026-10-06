set "dart_path=D:\sdk\flutter\bin\cache\dart-sdk\bin"
set "flutter_web_sdk=D:\sdk\flutter\bin\cache\flutter_web_sdk"

call "%dart_path%\dart" compile js -O2 --libraries-spec="%flutter_web_sdk"\libraries.json -o web/TestThread.dart.js lib/TestThread.dart || pause