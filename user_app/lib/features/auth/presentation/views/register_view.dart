import 'package:depi_app/core/utils/app_router.dart';
import 'package:depi_app/core/widgets/custom_button.dart';
import 'package:depi_app/core/widgets/custom_form_text_field.dart';
import 'package:depi_app/core/widgets/show_snack_bar.dart';
import 'package:depi_app/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.06,
              vertical: size.height * 0.02,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Register',
                      style: theme.textTheme.displaySmall,
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  CustomFormTextField(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    fieldType: FieldType.name,
                    prefixIcon: Icons.person_outline,
                    controller: fullNameController,
                  ),
                  SizedBox(height: size.height * 0.015),
                  CustomFormTextField(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    fieldType: FieldType.email,
                    prefixIcon: Icons.email_outlined,
                    controller: emailController,
                  ),
                  SizedBox(height: size.height * 0.015),
                  CustomFormTextField(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    fieldType: FieldType.password,
                    prefixIcon: Icons.lock_outline,
                    controller: passwordController,
                  ),
                  SizedBox(height: size.height * 0.015),
                  CustomFormTextField(
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    fieldType: FieldType.password,
                    prefixIcon: Icons.lock_outline,
                    controller: confirmPasswordController,
                    originalPassword: passwordController,
                  ),
                  SizedBox(height: size.height * 0.03),
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthError) {
                        showSnackBar(context, state.message, Colors.red);
                      } else if (state is AuthSuccess) {
                        showSnackBar(
                          context,
                          "Registration Successful",
                          Colors.green,
                        );
                        AppRouter.router.go(AppRouter.kLogin);
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        children: [
                          CustomButton(
                            backgroundColor: theme.primaryColor,
                            text: 'Register',
                            isLoading:
                                state is AuthLoading && !state.isGoogleLogin,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthCubit>().signUp(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                  fullNameController.text.trim(),
                                );
                              }
                            },
                          ),
                          SizedBox(height: size.height * 0.025),
                          Text(
                            '----------------------- OR -----------------------',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.grey,
                              fontSize: size.width * 0.035,
                            ),
                          ),
                          SizedBox(height: size.height * 0.025),
                          CustomButton(
                            icon: FontAwesomeIcons.google,
                            backgroundColor: theme.primaryColor,
                            text: 'Sign in with Google',
                            isLoading:
                                state is AuthLoading && state.isGoogleLogin,
                            onPressed: () {
                              context.read<AuthCubit>().signInWithGoogle(
                                context,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: size.width * 0.032,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          AppRouter.router.go(AppRouter.kLogin);
                        },
                        child: Text(
                          '  Login',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontSize: size.width * 0.032,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
