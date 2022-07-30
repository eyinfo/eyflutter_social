import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eyflutter_social/eyflutter_social.dart';

void main() {
  const MethodChannel channel = MethodChannel('eyflutter_social');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await EyflutterSocial.platformVersion, '42');
  });
}
