import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_glucosa/core/utils/crash_log.dart';
import 'package:flutter_glucosa/core/utils/crash_reporter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('plugins.flutter.io/path_provider');
  late Directory tempDir;
  bool shouldThrowPathProvider = false;

  setUp(() {
    shouldThrowPathProvider = false;
    tempDir = Directory.systemTemp.createTempSync('crash_reporter_test_');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (shouldThrowPathProvider) {
            throw Exception('Platform channel failed');
          }
          if (methodCall.method == 'getApplicationDocumentsDirectory') {
            return tempDir.path;
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('AppCrashReporter', () {
    test(
      'recordError writes formatted entry with reason to crash log file',
      () async {
        await AppCrashReporter.recordError(
          Exception('Network timeout'),
          StackTrace.current,
          reason: 'Sync worker failure',
          fatal: false,
        );

        final file = File('${tempDir.path}/$crashLogFileName');
        expect(file.existsSync(), isTrue);

        final content = await file.readAsString();
        expect(content, contains('Exception: Network timeout'));
        expect(content, contains('[Reason: Sync worker failure]'));
      },
    );

    test(
      'recordError works with null stack and null reason and fatal true',
      () async {
        await AppCrashReporter.recordError(
          'Critical fatal crash',
          null,
          fatal: true,
        );

        final file = File('${tempDir.path}/$crashLogFileName');
        expect(file.existsSync(), isTrue);

        final content = await file.readAsString();
        expect(content, contains('Critical fatal crash'));
      },
    );

    test('writeCrashLog appends consecutive entries to the file', () async {
      final file = File('${tempDir.path}/$crashLogFileName');

      await AppCrashReporter.writeCrashLog('First error', StackTrace.empty);
      await AppCrashReporter.writeCrashLog('Second error', StackTrace.empty);

      expect(file.existsSync(), isTrue);
      final content = await file.readAsString();
      expect(content, contains('First error'));
      expect(content, contains('Second error'));
    });

    test('trims crash log file when size exceeds 1 MB', () async {
      final file = File('${tempDir.path}/$crashLogFileName');

      // Pre-fill file with over 1MB of log text
      final largeChunk = 'A' * (1024 * 512);
      await file.writeAsString('$largeChunk\n\n$largeChunk\n\n', flush: true);
      expect(await file.length(), greaterThan(1024 * 1024));

      // Trigger write which checks size and trims
      await AppCrashReporter.writeCrashLog(
        'New error after trim',
        StackTrace.empty,
      );

      final trimmedContent = await file.readAsString();
      expect(trimmedContent, contains('New error after trim'));
      expect(await file.length(), lessThan(1024 * 1024));
    });

    test('gracefully handles path provider errors without throwing', () async {
      shouldThrowPathProvider = true;

      expect(
        () async => AppCrashReporter.recordError(
          Exception('Uncaught'),
          StackTrace.current,
        ),
        returnsNormally,
      );
    });
  });
}
