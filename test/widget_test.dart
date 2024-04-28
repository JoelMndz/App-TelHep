// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tel_help/firebase/firebase_options.dart';
import 'package:tel_help/widgets/form_consulta.dart';

void main() {
  testWidgets('Verificar widgets', (WidgetTester tester) async {

    // WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform
    // );
    await tester.pumpWidget(FormConsulta());

    expect(true, isTrue);
  });
}
