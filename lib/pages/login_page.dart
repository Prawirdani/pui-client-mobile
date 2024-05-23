import 'package:flutter/material.dart';
import 'package:flutter_application_4/providers/auth_provider.dart';
import 'package:flutter_application_4/widgets/button.dart';
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
          color: Theme.of(context).primaryColor,
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
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 32),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const LoginForm()
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
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            if (auth.loginError.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  auth.loginError,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            _loading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(),
                  )
                : Button(
                    text: "Login",
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
                  ),
          ],
        ),
      ),
    );
  }
}
