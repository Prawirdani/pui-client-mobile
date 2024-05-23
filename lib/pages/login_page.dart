import 'package:flutter/material.dart';
import 'package:flutter_application_4/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          color: Colors.blue,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Card(
                shadowColor: Colors.black,
                elevation: 8,
                child: Container(
                  alignment: Alignment.center,
                  height: 400,
                  width: 350,
                  padding: const EdgeInsets.all(12),
                  child: const Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        LoginForm()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var _loading = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  _setLoading(bool v) {
    setState(() {
      _loading = v;
    });
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Masukkan username anda";
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: "Username",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Masukkan password anda";
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: "Password",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          if (auth.loginError.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                auth.loginError,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _setLoading(true);
                await auth.login(
                  _usernameController.text,
                  _passwordController.text,
                );
                _setLoading(false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            child: _loading
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(),
                  )
                : const Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ],
      ),
    );
  }
}
