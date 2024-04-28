import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tel_help/firebase/firebase_options.dart';
import 'package:tel_help/providers/consulta.dart';
import 'package:tel_help/screens/detalle.dart';
import 'package:tel_help/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ConsultaProvider())],
      builder: (context, child) => 
        MaterialApp(
          title: 'Tel Help',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.light(
              primary: Color(0xffB12C00),
              background: Color(0xffF8D6CC),
              onPrimary: Colors.white,
            ),
            useMaterial3: true,
            appBarTheme: AppBarTheme(
              backgroundColor: Color(0xffB12C00),
              foregroundColor: Colors.white,
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(left: 10, right: 10, bottom: 15, top: 15)
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffB12C00),
                foregroundColor: Colors.white
              )
            )
            
          ),
          initialRoute: HomeScreen.name,
          routes: {
            HomeScreen.name:(context) => HomeScreen(),
            DetalleScreen.name: (context) => DetalleScreen(),
          },
        ),
    );
  }
}