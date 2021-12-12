import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graph_login/graph_login.dart';

void main() {
  const MethodChannel channel = MethodChannel('graph_login');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
