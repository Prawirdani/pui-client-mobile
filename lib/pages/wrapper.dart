import 'package:flutter/material.dart';
import 'package:flutter_application_4/pages/home_page.dart';
import 'package:flutter_application_4/providers/auth_provider.dart';
import 'package:flutter_application_4/widgets/button.dart';
import 'package:provider/provider.dart';

class PesananPage extends StatelessWidget {
  const PesananPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Pesanan Page");
  }
}

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Setting Page");
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _selectedIndex = 0;

  void _setIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    late Widget page;
    late Widget pageTitle;
    switch (_selectedIndex) {
      case 0:
        page = const HomePage();
        pageTitle = const PageTitle(title: "Daftar Meja");
      case 1:
        page = const PesananPage();
        pageTitle = const PageTitle(title: "Daftar Pesanan");
      case 2:
        page = const SettingPage();
        pageTitle = const PageTitle(title: "Pengaturan");
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Row(
          children: [
            /*
                Sidebar Navigation
            */
            NavigationRail(
              selectedIndex: _selectedIndex,
              labelType: NavigationRailLabelType.none,
              onDestinationSelected: (value) => {_setIndex(value)},
              backgroundColor: Theme.of(context).primaryColor,
              unselectedIconTheme: const IconThemeData(color: Colors.white),
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: LogoutDialog(
                      logoutHandler: auth.logout,
                    ),
                  ),
                ),
              ),
              indicatorShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text("Home"),
                    padding: EdgeInsets.only(top: 10, bottom: 10)),
                NavigationRailDestination(
                    icon: Icon(Icons.receipt_long),
                    label: Text("Transaksi"),
                    padding: EdgeInsets.only(top: 10, bottom: 10)),
                NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text("Setting"),
                    padding: EdgeInsets.only(top: 10, bottom: 10)),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            /*
                Main Content
              */
            Expanded(
              child: Column(
                children: [
                  Material(
                    elevation: 4,
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            pageTitle,
                            Text(
                              auth.user!.nama,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(36),
                      child: page,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LogoutDialog extends StatefulWidget {
  const LogoutDialog({super.key, required this.logoutHandler});
  final Future<void> Function() logoutHandler;

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  Future<void> _handleLogout(BuildContext ctx) async {
    try {
      await widget.logoutHandler();
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      // Handle error
      debugPrint('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Keluar dari aplikasi?",
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Button(
                      onPressed: () async {
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        await _handleLogout(context);
                      },
                      text: "Ya",
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      icon: const Icon(
        Icons.logout,
        color: Colors.white,
      ),
    );
  }
}

class PageTitle extends StatelessWidget {
  final String title;
  const PageTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
