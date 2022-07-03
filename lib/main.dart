import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ropstam/global/constants.dart';
import 'package:ropstam/screens/home_screen.dart';
import 'package:ropstam/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ropstam/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Ropstam',
        theme: ThemeData(
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checkUserSession() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');

    await Future.delayed(Duration(milliseconds: 1500));
    token == null
        // ignore: use_build_context_synchronously
        ? Navigator.pushReplacement(
            context, MaterialPageRoute(builder: ((context) => LoginScreen())))
        // ignore: use_build_context_synchronously
        : Navigator.pushReplacement(
            context, MaterialPageRoute(builder: ((context) => HomeScreen())));
  }

  @override
  void initState() {
    // TODO: implement initState

    checkUserSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
            child: Image.asset(
          'assets/images/ropstam.png',
          fit: BoxFit.fill,
        )),
      ),
    );
  }
}
