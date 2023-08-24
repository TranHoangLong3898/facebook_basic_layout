import 'package:cloud_functions/cloud_functions.dart';
import 'package:facebook_basic_layout/controller/user_service.dart';
import 'package:facebook_basic_layout/view/authentication_screen/log_in_view.dart';
import 'package:facebook_basic_layout/view/home_screen/home_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBMmb-Gh7fJeKkrLO4N82wjwP3rSLAlr0Q",
          authDomain: "facebook-app-54110.firebaseapp.com",
          projectId: "facebook-app-54110",
          storageBucket: "facebook-app-54110.appspot.com",
          messagingSenderId: "284781204952",
          appId: "1:284781204952:web:391b34190228274de44ead"));
  FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  runApp(const MyfacebookApp());
}

class MyfacebookApp extends StatelessWidget {
  const MyfacebookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => UserService(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Facebook basic layout',
          theme: ThemeData(
              primarySwatch: Colors.teal,
              primaryColorLight: const Color.fromARGB(255, 89, 197, 186)),
          home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const HomePage();
                } else {
                  return const LogIn();
                }
              }),
        ));
  }
}
