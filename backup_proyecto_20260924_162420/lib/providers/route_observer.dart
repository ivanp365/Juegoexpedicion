import 'package:flutter/material.dart';

/// Observer global para detectar cambios de ruta.
/// Se registra en MaterialApp(navigatorObservers: [routeObserver]).
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();