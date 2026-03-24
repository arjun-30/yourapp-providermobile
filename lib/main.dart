import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'config/router.dart';
import 'providers/auth_provider.dart';
import 'providers/provider_state.dart';
import 'providers/job_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RoundUProviderApp());
}

class RoundUProviderApp extends StatelessWidget {
  const RoundUProviderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadToken()),
        ChangeNotifierProvider(create: (_) => ProviderState()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          final router = createRouter(auth);
          return MaterialApp.router(
            title: 'RoundU Provider',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
