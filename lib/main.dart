import 'package:flutter/material.dart';
import 'package:flutter_application_4/pages/login_page.dart';
import 'package:flutter_application_4/pages/wrapper.dart';
import 'package:flutter_application_4/providers/auth_provider.dart';
import 'package:flutter_application_4/providers/meja_provider.dart';
import 'package:flutter_application_4/providers/menu_provider.dart';
import 'package:flutter_application_4/providers/payment_provider.dart';
import 'package:flutter_application_4/providers/pesanan_form.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, MejaProvider>(
          create: (context) => MejaProvider(),
          update: (context, authP, mejaP) {
            mejaP ??= MejaProvider();
            mejaP.registerToken(authP.token);
            return mejaP;
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, MenuProvider>(
          create: (context) => MenuProvider(),
          update: (context, authP, menuP) {
            menuP ??= MenuProvider();
            menuP.registerToken(authP.token);
            return menuP;
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, PaymentProvider>(
          create: (context) => PaymentProvider(),
          update: (context, authP, paymentP) {
            paymentP ??= PaymentProvider();
            paymentP.registerToken(authP.token);
            return paymentP;
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, PesananForm>(
          create: (context) => PesananForm(),
          update: (context, authP, pesananForm) {
            pesananForm ??= PesananForm();
            pesananForm.registerToken(authP.token);
            return pesananForm;
          },
        ),
      ],
      builder: (context, child) => Consumer<AuthProvider>(
        builder: (context, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'POS Prototype',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF357EEB),
                primary: const Color(0xFF357EEB)),
            useMaterial3: true,
          ),
          home: auth.isAuthed()
              ? const Main()
              : FutureBuilder(
                  future: auth.persistLogin(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return const LoginPage();
                  },
                ),
          routes: {'/home': (context) => const Main()},
        ),
      ),
    );
  }
}
