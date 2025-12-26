import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/utils/app_router.dart';
import 'package:depi_app/core/widgets/custom_button.dart';
import 'package:depi_app/core/widgets/custom_form_text_field.dart';
import 'package:depi_app/core/widgets/show_snack_bar.dart';
import 'package:depi_app/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final List<TextEditingController> _addressControllers = [];

  bool _isLoadingData = true;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        _nameController.text = data['fullName'] ?? '';
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phone'] ?? '';

        final List addresses = data['address'] ?? [];
        for (var addr in addresses) {
          _addressControllers.add(TextEditingController(text: addr.toString()));
        }
        if (_addressControllers.isEmpty) {
          _addressControllers.add(TextEditingController());
        }
      }
      setState(() {
        _isLoadingData = false;
      });
    } catch (e) {
      showSnackBar(context, "Failed to load profile data", Colors.red);
    }
  }

  void _addAddressField() {
    setState(() {
      _addressControllers.add(TextEditingController());
    });
  }

  void _removeAddressField(int index) {
    setState(() {
      _addressControllers[index].dispose();
      _addressControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    late final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            AppRouter.router.go(AppRouter.kProfile);
          },
        ),
      ),
      body:
          _isLoadingData
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      CustomFormTextField(
                        controller: _nameController,
                        labelText: "Full Name",
                        hintText: "Enter your name",
                        prefixIcon: Iconsax.user_copy,
                        fieldType: FieldType.name,
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      CustomFormTextField(
                        controller: _emailController,
                        labelText: "Email",
                        hintText: "Enter your email",
                        prefixIcon: Iconsax.sms_copy,
                        fieldType: FieldType.email,
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      CustomFormTextField(
                        controller: _phoneController,
                        labelText: "Phone Number",
                        hintText: "Enter your phone",
                        prefixIcon: Iconsax.call_copy,
                        fieldType: FieldType.phone,
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Addresses",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Iconsax.add_circle_copy,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: _addAddressField,
                          ),
                        ],
                      ),

                      ...List.generate(_addressControllers.length, (index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomFormTextField(
                                  controller: _addressControllers[index],
                                  labelText: "Address ${index + 1}",
                                  hintText: "Enter address details",
                                  prefixIcon: Iconsax.location_copy,
                                  fieldType: FieldType.name,
                                ),
                              ),
                              if (_addressControllers.length > 1)
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _removeAddressField(index),
                                ),
                            ],
                          ),
                        );
                      }),

                      SizedBox(height: screenHeight * 0.04),

                      BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) {
                          if (state is AuthSuccess) {
                            showSnackBar(
                              context,
                              "Profile Updated Successfully",
                              Colors.green,
                            );
                            Navigator.pop(context);
                          } else if (state is AuthError) {
                            showSnackBar(context, state.message, Colors.red);
                          }
                        },
                        builder: (context, state) {
                          return CustomButton(
                            text: "Save Changes",
                            backgroundColor: theme.primaryColor,
                            isLoading: state is AuthLoading,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                List<String> addresses =
                                    _addressControllers
                                        .map((c) => c.text.trim())
                                        .where((s) => s.isNotEmpty)
                                        .toList();

                                context.read<AuthCubit>().updateUserProfile(
                                  uid: uid,
                                  fullName: _nameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  phone: _phoneController.text.trim(),
                                  addresses: addresses,
                                );
                              }
                            },
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
