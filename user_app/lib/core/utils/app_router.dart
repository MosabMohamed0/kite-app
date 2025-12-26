import 'package:depi_app/features/auth/presentation/views/login_view.dart';
import 'package:depi_app/features/auth/presentation/views/register_view.dart';
import 'package:depi_app/features/auth/presentation/views/reset_password_view.dart';
import 'package:depi_app/features/cart/presentation/views/cart_screen.dart';
import 'package:depi_app/features/checkout/presentation/views/checkout_screen.dart';
import 'package:depi_app/features/customerSupport/presentation/views/customer_support_screen.dart';
import 'package:depi_app/features/onboarding/presentation/onboarding_view.dart';
import 'package:depi_app/features/orderDetails/presentation/views/order_details.dart';
import 'package:depi_app/features/orderSummary/presentation/order_summary.dart';
import 'package:depi_app/core/models/product.dart';
import 'package:depi_app/core/widgets/MainNavigation.dart';
import 'package:depi_app/features/HomeScreen/presentation/home_screen.dart';
import 'package:depi_app/features/favorite_screen/FavoriteScreen.dart';
import 'package:depi_app/features/productDetails/presentation/product_details.dart';
import 'package:depi_app/features/chat/presentation/view/chat_screen.dart';
import 'package:depi_app/features/settings/presentation/edit_profile_view.dart';
import 'package:depi_app/features/settings/presentation/settings_view.dart';
import 'package:depi_app/features/splash/presentation/splash_view.dart';
import 'package:depi_app/features/viewAllOrders/presentation/views/view_all_orders.dart';
import 'package:go_router/go_router.dart';

import '../../features/profile/presentation/views/profile_screen.dart';
import '../models/order.dart';

abstract class AppRouter {
  static const kOnboardingView = '/onboardingView';
  static const kSplash = '/';
  static const kLogin = '/loginView';
  static const kRegister = '/registerView';
  static const kForgotPassword = '/forgotPasswordView';
  static const kResetPassword = '/resetPasswordView';
  static const kProductDetails = '/ProductDetails';
  static const kFavoriteScreen = '/favoriteScreen';
  static const kHome = '/home';

  static const kCart = '/cart';
  static const kCustomerSupport = '/customerSupport';
  static const kCheckout = '/checkout';
  static const kProfile = '/profile';
  static const kOrderSummary = '/orderSummary';
  static const kViewAllOrders = '/viewAllOrders';
  static const kOrderDetails = '/orderDetails';

  static const kSettings = '/settings';
  static const kEditProfile = '/editProfile';
  static const kUserChat = '/userChat';
  static final router = GoRouter(
    routes: [
      GoRoute(path: kSplash, builder: (context, state) => const SplashView()),
      GoRoute(
        path: kOnboardingView,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(path: kLogin, builder: (context, state) => LoginView()),
      GoRoute(
        path: kRegister,
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: kForgotPassword,
        builder: (context, state) => const ForgotPasswordView(),
      ),
      GoRoute(
        path: kResetPassword,
        builder:  (context, state) => const ForgotPasswordView(),
      ),

      GoRoute(
        path: kCustomerSupport,
        builder: (context, state) => const CustomerSupportScreen(),
      ),
      GoRoute(
        path: kCheckout,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: kOrderSummary,
        builder: (context, state) {
          final order = state.extra as MyOrder;
          return OrderSummary(order: order);
        },
      ),
      GoRoute(
        path: kOrderDetails,
        builder: (context, state) {
          final order = state.extra as MyOrder;
          return OrderDetailsScreen(order: order);
        },
      ),
      GoRoute(
        path: kViewAllOrders,
        builder: (context, state) => const ViewAllOrders(),
      ),
      GoRoute(
        path: AppRouter.kProductDetails,
        builder: (context, state) {
          final product = state.extra as Product;
          return ProductDetails(product: product);
        },
      ),

      GoRoute(
        path: kSettings,
        builder: (context, state) => const SettingsView(),
      ),
      GoRoute(
        path: kEditProfile,
        builder: (context, state) => const EditProfileView(),
      ),
      GoRoute(
        path: kUserChat,
        builder: (context, state) => const UserChatScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) => MainNavigation(child: child),
        routes: [
          GoRoute(
            path: kHome,
            pageBuilder:
                (context, state) => NoTransitionPage(child: const HomeScreen()),
          ),
          GoRoute(
            path: kFavoriteScreen,
            pageBuilder:
                (context, state) =>
                    NoTransitionPage(child: const FavoritesScreen()),
          ),
          GoRoute(
            path: kCart,
            pageBuilder:
                (context, state) => NoTransitionPage(child: const CartScreen()),
          ),
          GoRoute(
            path: kProfile,
            pageBuilder:
                (context, state) =>
                    NoTransitionPage(child: const ProfileScreen()),
          ),
        ],
      ),
    ],
  );
}
