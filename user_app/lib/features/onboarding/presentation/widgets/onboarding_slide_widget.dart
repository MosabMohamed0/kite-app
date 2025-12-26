import 'package:depi_app/core/utils/app_router.dart';
import 'package:depi_app/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class OnboardingSlideWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const OnboardingSlideWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Padding(
        key: ValueKey(title),

        padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () => AppRouter.router.go(AppRouter.kLogin),
                    child: Text('Skip', style: AppStyles.styleMedium16Dark),
                  ),
                ),

                SizedBox(height: size.height * 0.03),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOutBack,
                  width: size.width * 0.28,
                  height: size.width * 0.28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),

                  child: Icon(icon, size: size.width * 0.12, color: color),
                ),

                SizedBox(height: size.height * 0.05),

                Text(
                  title,
                  style: AppStyles.styleBold24Dark.copyWith(
                    fontSize: size.width * 0.065,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: size.height * 0.02),

                Text(
                  subtitle,
                  style: AppStyles.styleRegular16Muted.copyWith(
                    fontSize: size.width * 0.04,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
