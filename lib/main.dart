import 'package:flutter/material.dart';
import 'package:nubank_layout/src/app_module.dart';
import 'package:sentry/sentry.dart';
import 'dart:async';

final SentryClient _sentry = new SentryClient(dsn: "https://6c48dd12e9af4055903c2662a87482c1@sentry.io/1832089"); // Replace by your own DSN

Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  await _sentry.captureException(
    exception: error,
    stackTrace: stackTrace,
  );
}

void main() async {
  runZoned<Future<void>>(() async {
    runApp(AppModule());
  }, onError: (error, stackTrace) async {
   print(error);
  // Whenever an error occurs, call the `_reportError` function. This sends
  // Dart errors to the dev console or Sentry depending on the environment.
    await _reportError(error, stackTrace);
  });
}

