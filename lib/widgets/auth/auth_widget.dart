import 'dart:async';

import 'package:central_driver/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../views/camera/camera.dart';
import '../../views/demo-camera/demo_camera.dart';
import '../../views/home/home.dart';
import '../../views/login/login.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  bool _redirecting = false;
  late final StreamSubscription<AuthState> _authStateSubscription;

  @override
  void initState() {
    super.initState();
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      print('auth state changed');
      setState(() {});
    });
  }

  @override
  void dispose() {
    print('disposing auth widget');
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: supabase.auth.currentSession != null ? const DemoCamera() : const Login(),
    );
  }
}
