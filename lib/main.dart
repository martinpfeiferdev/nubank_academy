import 'package:flutter/material.dart';
import 'package:nubank_layout/src/app_module.dart';
import 'package:sentry/sentry.dart';
import 'dart:async';

// SECURITY: Sentry DSN should be loaded from environment variables
// For now, Sentry is disabled. To enable:
// 1. Set SENTRY_DSN environment variable
// 2. Uncomment the Sentry code below
final SentryClient _sentry = null; // new SentryClient(dsn: const String.fromEnvironment('SENTRY_DSN'));

Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  // Only report to Sentry if configured
  if (_sentry != null) {
    await _sentry.captureException(
      exception: error,
      stackTrace: stackTrace,
    );
  } else {
    // In development, print to console
    debugPrint('Error: $error\nStackTrace: $stackTrace');
  }
}

void main() async {
  runZoned<Future<void>>(() async {
    runApp(AppModule());
  }, onError: (error, stackTrace) async {
    // Whenever an error occurs, call the `_reportError` function. This sends
    // Dart errors to the dev console or Sentry depending on the environment.
    await _reportError(error, stackTrace);
  });
}

