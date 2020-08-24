



























import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ktg_client/controller/api_handler.dart';
import 'package:ktg_client/model/session.dart';
import 'package:ktg_client/view/login_page.dart';
import 'package:provider/provider.dart';
import 'package:sentry/sentry.dart';
import 'package:ktg_client/env_variables.dart';

Session currentSession;

final SentryClient _sentry = SentryClient(dsn: dsn);

bool get isInDebugMode {
  // Assume you're in production mode.
  bool inDebugMode = false;

  // Assert expressions are only evaluated during development. They are ignored
  // in production. Therefore, this code only sets `inDebugMode` to true
  // in a development environment.
  assert(inDebugMode = true);

  return inDebugMode;
}

/// Reports [error] along with its [stackTrace] to Sentry.io.
Future<void> _reportError(dynamic error, dynamic stackTrace) async {
  print('Caught error: $error');
  // Errors thrown in development mode are unlikely to be interesting. You can
  // check if you are running in dev mode using an assertion and omit sending
  // the report.
  if (isInDebugMode) {
    print(stackTrace);
    print('In dev mode. Not sending report to Sentry.io.');
    return;
  }

  print('Reporting to Sentry.io...');

  final SentryResponse response = await _sentry.captureException(
    exception: error,
    stackTrace: stackTrace,
  );

  if (response.isSuccessful) {
    print('Success! Event ID: ${response.eventId}');
  } else {
    print('Failed to report to Sentry.io: ${response.error}');
  }
}

Future<void> main() async {
  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone to report to
      // Sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  runZoned<Future<void>>(() async {
    runApp(MyApp());
  }, onError: (Object error, dynamic stackTrace) async {
    await _reportError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (isInDebugMode) {
      currServerPath = stageServerPath;
    } else {
      currServerPath = prodServerPath;
    }

    currentSession = Session();
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider<ApiHandler>(
            create: (BuildContext context) => ApiHandler())
      ],
      child: MaterialApp(
          title: 'Title',
          home: const LoginPage(),
          theme: ThemeData(
            primaryColor: Colors.blue,
            textTheme: TextTheme(
                title: const TextStyle(fontFamily: 'Poppins').copyWith(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600),
                headline: const TextStyle(fontFamily: 'Poppins').copyWith(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400),
                body1: const TextStyle(fontFamily: 'Poppins').copyWith(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400)),
          )),
    );
  }
}
