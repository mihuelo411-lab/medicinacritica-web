import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/app/app.dart';
import 'package:nutrivigil/core/di/dependencies.dart';
import 'package:nutrivigil/core/notifications/notification_service.dart';
import 'package:nutrivigil/domain/alerts/alert_engine.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  // Initialization moved to SplashPage
  runApp(const NutriVigilApp());
}
