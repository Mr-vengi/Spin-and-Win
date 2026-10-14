import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/app_state.dart';
import 'screens/address_screen.dart';
import 'screens/auth_screens.dart';
import 'screens/home_screen.dart';
import 'screens/levels_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/refer_screen.dart';
import 'screens/spin_wheel_screen.dart';
import 'screens/tracking_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/app_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final appState = AppState(prefs);
  await appState.load();
  runApp(
    ChangeNotifierProvider.value(value: appState, child: const BagulApp()),
  );
}

class BagulApp extends StatelessWidget {
  const BagulApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isSignedIn = context.select<AppState, bool>(
      (state) => state.isLoggedIn,
    );

    return MaterialApp(
      title: 'Bagul Spin & Win',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: isSignedIn ? '/home' : '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/forgot-password': (_) => const ForgotPasswordScreen(),
        '/home': (_) => AppShell(selectedIndex: 0, child: const HomeScreen()),
        '/levels': (_) =>
            AppShell(selectedIndex: 1, child: const LevelsScreen()),
        '/refer': (_) => AppShell(selectedIndex: 2, child: const ReferScreen()),
        '/profile': (_) =>
            AppShell(selectedIndex: 3, child: const ProfileScreen()),
        '/tracking': (_) => const TrackingScreen(),
        '/address': (_) => const AddressScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/spin-wheel') {
          final config = settings.arguments is SpinConfig
              ? settings.arguments! as SpinConfig
              : const SpinConfig(entryFee: 20, guaranteedWin: true);
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => SpinWheelScreen(config: config),
          );
        }
        return null;
      },
    );
  }
}
