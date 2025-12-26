import 'dart:async';
import 'package:depi_app/core/utils/app_router.dart';
import 'package:depi_app/features/splash/presentation/widgets/dots_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  double _barWidth = 0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    initSlidingAnimation();
    initBarAnimation();
    navigateToOnboarding();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/kite_logo.png', width: 250, height: 250),
            const SizedBox(height: 18),
            AnimatedContainer(
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              width: _barWidth,
              height: 5,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),
            DotsWidget(controller: _controller),
          ],
        ),
      ),
    );
  }

  void initSlidingAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
  }

  void navigateToOnboarding() {
    Future.delayed(const Duration(seconds: 3), () {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        AppRouter.router.go(AppRouter.kHome);
      } else {
        AppRouter.router.go(AppRouter.kOnboardingView);
      }
    });
  }

  void initBarAnimation() {
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _barWidth = 160;
      });
    });
  }
}
