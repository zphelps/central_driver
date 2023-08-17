import 'package:camera/camera.dart';
import 'package:central_driver/routes/routes.dart';
import 'package:central_driver/views/home/home.dart';
import 'package:central_driver/views/login/login.dart';
import 'package:central_driver/views/services/details.dart';
import 'package:central_driver/widgets/auth/auth_widget.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';

const supabaseUrl = 'https://tajllccgqcblogdfsmgr.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRhamxsY2NncWNibG9nZGZzbWdyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODY5NzE4NDIsImV4cCI6MjAwMjU0Nzg0Mn0.W32PE62gK5fZjcHrWoGscHkphUHMQVXaLAr3aCR2xw4';

Future<void> main() async {
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  cameras = await availableCameras();
  runApp(const ProviderScope(child: MyApp()));
}

final supabase = Supabase.instance.client;
late List<CameraDescription> cameras;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Central Driver',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xff0A76C6),
        colorScheme: const ColorScheme(
          primary: Color(0xff0A76C6),
          background: Color(0XFF212845),
          secondary: Color(0xff6E6E70),
          surface: Colors.white,
          onSurface: Colors.white,
          brightness: Brightness.light,
          onError: Colors.red,
          onBackground: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          error: Colors.red,
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          menuStyle: MenuStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                side: BorderSide(color: Color(0xffdddddd)),
              ),
            ),
          ),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,

        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal),
          bodyMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
          bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
          labelLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          labelMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          labelSmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xfffafafa),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffdddddd)),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xfffafafa)),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey.shade300),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
      ),
      // home: const Home(),
      // routes: routes,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) => const AuthWidget());
            case '/login':
              return MaterialPageRoute(builder: (_) => const Login());
            case '/home':
              return MaterialPageRoute(builder: (_) => const Home());
            case '/service_details':
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) => ServiceDetails(initialService: args['service']),
              );
            default:
              throw Exception('Invalid route: ${settings.name}');
          }
        }
    );
  }
}