import 'package:admin_app/features/chat/data/repositories/chat_repository.dart';
import 'package:admin_app/features/chat/presentation/cubits/admin_chat_cubit/admin_chat_cubit.dart';
import 'package:admin_app/features/dashboard/presentation/dashboard_cubit/dashboard_cubit.dart';
import 'package:admin_app/features/orders/presentation/order_cubit/order_cubit.dart';
import 'package:admin_app/features/products/presentation/product_cubit/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/presentation/view/dashboard_screen.dart';
import 'features/products/data/repositories/firebase_product_repository.dart';
import 'features/users/data/repositories/firebase_user_repository.dart';
import 'features/orders/data/repositories/firebase_order_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  runApp(const KiteAdminApp());
}

class KiteAdminApp extends StatelessWidget {
  const KiteAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => FirebaseProductRepository()),
        RepositoryProvider(create: (context) => FirebaseUserRepository()),
        RepositoryProvider(
          create:
              (context) => FirebaseOrderRepository(
                // context.read<FirebaseUserRepository>(),
              ),
        ),
        RepositoryProvider(create: (context) => ChatRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => DashboardCubit()),
          BlocProvider(
            create:
                (context) =>
                    ProductCubit(context.read<FirebaseProductRepository>()),
          ),
          BlocProvider(
            create:
                (context) =>
                    OrderCubit(context.read<FirebaseOrderRepository>()),
          ),
          BlocProvider(
            create: (context) => AdminChatCubit(context.read<ChatRepository>()),
          ),
        ],
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            return MaterialApp(
              title: 'Kite Admin',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: state.themeMode,
              locale: const Locale('en', 'US'),
              supportedLocales: const [Locale('en', 'US')],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: const DashboardScreen(),
            );
          },
        ),
      ),
    );
  }
}
