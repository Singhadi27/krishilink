import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localvue/firebase_options.dart';
import 'package:localvue/homepage/eccomerse/cart_provider.dart'; // Import CartProvider
import 'package:localvue/views/onboarding_screen.dart';
import 'package:provider/provider.dart'; // Import Provider package
import 'homepage/add_trade_page.dart';
import 'homepage/krishilinkHomepage.dart';
import 'homepage/mytrade_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()), // Register CartProvider
        // Add more providers if needed
      ],
      child: GetMaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        title: 'KrishiLink',
        home: const AuthenticationWrapper(),
        routes: {
          '/addtrade': (context) => AddTradePage(),
          '/tradedetail': (context) => TradeDetailPage(
            tradeData: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
          ),
          // Add other routes here...
        },
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // User is logged in, navigate to home page
          return HomePage();
        } else {
          // User is logged out, navigate to onboarding screen
          return const OnBoardingScreen();
        }
      },
    );
  }
}
