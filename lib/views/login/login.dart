import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController = TextEditingController();

  Future<void> _signIn() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        _emailController.clear();
        _passwordController.clear();
      }
    } on AuthException catch (error) {
      print(error.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Unexpected error occurred'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          children: [
            const Image(
                image: AssetImage('assets/Central Logo-1.jpg'),
                height: 125,
            ),
            const SizedBox(height: 36),
            Text(
                'Sign In',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _isLoading ? null : _signIn,
              child: Text(_isLoading ? 'Loading' : 'Login'),
            ),
          ],
        ),
      ),
    );
  }
}