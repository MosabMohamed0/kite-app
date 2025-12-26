import 'package:depi_app/core/utils/app_router.dart';
import 'package:depi_app/core/widgets/custom_button.dart';
import 'package:depi_app/core/widgets/custom_form_text_field.dart';
import 'package:depi_app/core/widgets/show_custom_alert_dialog.dart';
import 'package:depi_app/core/widgets/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depi_app/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().resetPassword(_emailCtrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeftLong),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              AppRouter.router.go(AppRouter.kLogin);
            }
          },
        ),
        title: Text('Reset Password', style: theme.textTheme.headlineMedium),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.06,
            vertical: size.height * 0.03,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: size.width * 0.1,
                backgroundColor: theme.primaryColor.withOpacity(0.1),
                child: Icon(
                  Icons.mail_outline,
                  color: theme.primaryColor,
                  size: size.width * 0.1,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Text(
                "Reset your password",
                style: theme.textTheme.headlineMedium,
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                'Enter your email and we will send you a link to reset your password.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: size.width * 0.035,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.04),
              Form(
                key: _formKey,
                child: CustomFormTextField(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  fieldType: FieldType.email,
                  prefixIcon: Icons.email_outlined,
                  controller: _emailCtrl,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthError) {
                    showSnackBar(context, state.message, Colors.red);
                  } else if (state is AuthPasswordReset) {
                    showCustomAlertDialog(context, _emailCtrl.text.trim());
                  }
                },
                builder: (context, state) {
                  final isLoading = state is AuthLoading;
                  return Column(
                    children: [
                      CustomButton(
                        backgroundColor: theme.primaryColor,
                        text: "Send reset email",
                        onPressed: _submit,
                        isLoading: isLoading,
                      ),
                      SizedBox(height: size.height * 0.02),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
