import 'package:flutter/material.dart';
import '../providers/audio_manager.dart';
import '../providers/route_observer.dart';

/// Widget que cambia el modo de musica al montarse y al volver a la
/// pantalla (cuando se hace pop de una pantalla hija).
///
/// Uso:
/// ```dart
/// return BgmScope(
///   mode: BgmMode.menu,
///   child: Scaffold(...),
/// );
/// ```
class BgmScope extends StatefulWidget {
  final BgmMode mode;
  final Widget child;

  const BgmScope({super.key, required this.mode, required this.child});

  @override
  State<BgmScope> createState() => _BgmScopeState();
}

class _BgmScopeState extends State<BgmScope> with RouteAware {
  ModalRoute<dynamic>? _route;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AudioManager.setMode(widget.mode);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null && route != _route) {
      if (_route != null) {
        routeObserver.unsubscribe(this);
      }
      _route = route;
      routeObserver.subscribe(this, route as PageRoute);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  /// Se llama cuando vuelves a esta pantalla (pop de una hija).
  @override
  void didPopNext() {
    AudioManager.setMode(widget.mode);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}