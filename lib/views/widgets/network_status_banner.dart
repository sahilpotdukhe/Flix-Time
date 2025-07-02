import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkStatusBanner extends StatefulWidget {
  const NetworkStatusBanner({super.key});

  @override
  State<NetworkStatusBanner> createState() => _NetworkStatusBannerState();
}

class _NetworkStatusBannerState extends State<NetworkStatusBanner> with SingleTickerProviderStateMixin {
  bool isOffline = false;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();

    _connectivity.onConnectivityChanged.listen((event) {
      final result = event.isNotEmpty ? event.first : ConnectivityResult.none;
      if (!mounted) return;
      setState(() {
        isOffline = result == ConnectivityResult.none;
      });
    });

    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    if (!mounted) return;
    setState(() {
      isOffline = result == ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      child: isOffline
          ? Container(
        key: const ValueKey("offline_banner"),
        width: double.infinity,
        color: Colors.red[600],
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: const SafeArea(
          bottom: false,
          child: Text(
            'You are offline',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      )
          : const SizedBox.shrink(
        key: ValueKey("online_banner"),
      ),
    );
  }
}
