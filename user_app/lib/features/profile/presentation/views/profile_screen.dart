import 'package:depi_app/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/manager/app_settings_cubit.dart';
import '../../../../core/models/order.dart';
import '../../../../core/utils/app_router.dart';
import '../../../checkout/presentation/manager/checkout_cubit.dart';
import '../../manager/user_profile_cubit.dart';
import '../widgets/order_item.dart';
import '../widgets/stat_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String getFirstAndLastInitial(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return parts.first[0].toUpperCase() + parts.last[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    const String _fontFamily = 'Montserrat';
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return BlocListener<UserProfileCubit, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: BlocBuilder<UserProfileCubit, UserProfileState>(
        builder: (context, state) {
          if (state is UserProfileLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is UserProfileError) {
            return Scaffold(
              body: Center(
                child: Text(
                  "Failed to load user profile",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          }

          if (state is UserProfileLoaded) {
            final checkoutCubit = context.read<CheckoutCubit>();
            final profileCubit = context.read<UserProfileCubit>();

            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF272C27)
                              : const Color(0xFFC9E6CB),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.04),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Profile",
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              IconButton(
                                onPressed: () {
                                  AppRouter.router.push(AppRouter.kEditProfile);
                                },
                                icon: Icon(Icons.edit),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Row(
                            children: [
                              state.photoUrl != null &&
                                      state.photoUrl!.isNotEmpty
                                  ? CircleAvatar(
                                    radius: screenWidth * 0.072,
                                    backgroundImage: NetworkImage(
                                      state.photoUrl!,
                                    ),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                  )
                                  : CircleAvatar(
                                    radius: screenWidth * 0.072,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    child: Text(
                                      getFirstAndLastInitial(state.name),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.050,
                                      ),
                                    ),
                                  ),
                              SizedBox(width: screenWidth * 0.03),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.name,
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.headlineSmall,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    state.email,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      fontSize: screenWidth * 0.025,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Text(
                                    "Member since ${DateFormat('d MMMM yyyy', 'en_US').format(state.createdAt)}",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      fontSize: screenWidth * 0.025,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.01),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StreamBuilder<int>(
                            stream: checkoutCubit.getUserOrdersCountStream(),
                            builder: (context, snapshot) {
                              return buildStatCard(
                                context,
                                snapshot.data?.toString() ?? "0",
                                "Orders",
                                () {
                                  AppRouter.router.go(AppRouter.kViewAllOrders);
                                },
                              );
                            },
                          ),
                          StreamBuilder<int>(
                            stream: profileCubit.getUserFavoriteCountStream(),
                            builder: (context, snapshot) {
                              return buildStatCard(
                                context,
                                snapshot.data?.toString() ?? "0",
                                "Favorites",
                                () {
                                  AppRouter.router.go(
                                    AppRouter.kFavoriteScreen,
                                  );
                                },
                              );
                            },
                          ),
                          StreamBuilder<int>(
                            stream: profileCubit.getUserCartCountStream(),
                            builder: (context, snapshot) {
                              return buildStatCard(
                                context,
                                snapshot.data?.toString() ?? "0",
                                "In Cart",
                                () {
                                  AppRouter.router.go(AppRouter.kCart);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.015),

                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      child: Card(
                        color: Theme.of(context).cardColor,
                        elevation: 0.5,
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.shopping_bag_outlined),
                                      const SizedBox(width: 5),
                                      Text(
                                        "My Orders",
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.headlineSmall,
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      AppRouter.router.go(
                                        AppRouter.kViewAllOrders,
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "View All",
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodyMedium,
                                        ),
                                        SizedBox(width: screenWidth * 0.02),
                                        Icon(Icons.arrow_forward_ios, size: 10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              StreamBuilder<List<MyOrder>>(
                                stream:
                                    checkoutCubit.getLastThreeOrdersStream(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return Padding(
                                      padding: EdgeInsets.all(
                                        screenWidth *
                                            0.3, // -----------------------
                                      ),
                                      child: Text(
                                        "No Orders Yet",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  }

                                  final orders = snapshot.data!;

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: orders.length,
                                    itemBuilder: (context, index) {
                                      final order = orders[index];
                                      final date = order.date.toDate();
                                      final products = order.products;

                                      return Column(
                                        children: [
                                          const SizedBox(height: 8),
                                          InkWell(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            onTap: () {
                                              AppRouter.router.push(
                                                AppRouter.kOrderDetails,
                                                extra: order,
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(
                                                screenWidth * 0.02,
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                    Theme.of(context).cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 8,
                                                    spreadRadius: 1,
                                                    offset: const Offset(0, 2),
                                                    color: Colors.black
                                                        .withOpacity(0.05),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  (order.status ==
                                                              Status
                                                                  .processing ||
                                                          order.status ==
                                                              Status.pending)
                                                      ? IconButton(
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder: (context) {
                                                              return Dialog(
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        screenWidth *
                                                                            0.03,
                                                                      ),
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsets.all(
                                                                    screenWidth *
                                                                        0.03,
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Container(
                                                                        decoration: const BoxDecoration(
                                                                          color: Color(
                                                                            0xFFFAE3E3,
                                                                          ),
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        ),
                                                                        padding: EdgeInsets.all(
                                                                          screenWidth *
                                                                              0.03,
                                                                        ),
                                                                        child: const Icon(
                                                                          Icons
                                                                              .delete_forever,
                                                                          size:
                                                                              45,
                                                                          color:
                                                                              Colors.redAccent,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            screenHeight *
                                                                            0.03,
                                                                      ),

                                                                      Text(
                                                                        "Delete Order",
                                                                        style:
                                                                            Theme.of(
                                                                              context,
                                                                            ).textTheme.displayMedium,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            screenHeight *
                                                                            0.03,
                                                                      ),
                                                                      Text(
                                                                        "Are you sure you want to delete your order?",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            Theme.of(
                                                                              context,
                                                                            ).textTheme.titleMedium,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            screenHeight *
                                                                            0.03,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child: TextButton(
                                                                              onPressed:
                                                                                  () => Navigator.pop(
                                                                                    context,
                                                                                  ),
                                                                              child: Text(
                                                                                "Cancel",
                                                                                style:
                                                                                    Theme.of(
                                                                                      context,
                                                                                    ).textTheme.titleSmall,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child: ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor:
                                                                                    Colors.red,
                                                                              ),
                                                                              onPressed: () {
                                                                                Navigator.pop(
                                                                                  context,
                                                                                );
                                                                                checkoutCubit.updateOrderStatus(
                                                                                  order.id,
                                                                                  Status.canceled,
                                                                                );
                                                                              },
                                                                              child: Text(
                                                                                "Delete",
                                                                                style: TextStyle(
                                                                                  fontFamily:
                                                                                      _fontFamily,
                                                                                  color:
                                                                                      Colors.white,
                                                                                  fontWeight:
                                                                                      FontWeight.w600,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        icon: const Icon(
                                                          Icons.delete_forever,
                                                          color:
                                                              Colors.redAccent,
                                                        ),
                                                      )
                                                      : const SizedBox(),
                                                  // main details
                                                  Expanded(
                                                    child: buildOrderItem(
                                                      context: context,
                                                      id: order.id,
                                                      date:
                                                          "${DateFormat('yyyy-MM-dd').format(date)} • ${products.length} items",
                                                      price:
                                                          "\$${order.totalPrice.toStringAsFixed(1)}",
                                                      status:
                                                          order.status
                                                              .toString()
                                                              .split('.')
                                                              .last,
                                                      color:
                                                          order.status ==
                                                                  Status
                                                                      .delivered
                                                              ? const Color(
                                                                0xFF087248,
                                                              )
                                                              : order.status ==
                                                                  Status.shipped
                                                              ? Colors.blue
                                                              : order.status ==
                                                                  Status
                                                                      .processing
                                                              ? Colors.orange
                                                              : order.status ==
                                                                  Status.pending
                                                              ? Colors.grey
                                                              : order.status ==
                                                                  Status
                                                                      .canceled
                                                              ? Colors.red
                                                              : Colors.purple,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                      ),
                      child: Card(
                        color: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.settings_outlined),
                              title: Text(
                                "Settings",
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ),

                            const Divider(),

                            ListTile(
                              leading: const Icon(Icons.language),
                              title: Text(
                                "Language",
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              subtitle: const Text("English"),
                              trailing: InkWell(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.03,
                                    vertical: screenHeight * 0.01,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? const Color(0xFF2D2D2D)
                                            : const Color(0xFFD6EFD8),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    "عر",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                onTap: () {},
                              ),
                            ),

                            const Divider(),

                            ListTile(
                              leading: const Icon(Icons.dark_mode_outlined),
                              title: Text(
                                "Dark Mode",
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              subtitle: Text(
                                "Toggle dark theme",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              trailing: Transform.scale(
                                scale: 0.7,
                                child: Switch(
                                  value:
                                      context
                                          .watch<AppSettingsCubit>()
                                          .state
                                          .isDarkMode,
                                  onChanged: (value) {
                                    context
                                        .read<AppSettingsCubit>()
                                        .toggleDarkMode(value);
                                  },
                                ),
                              ),
                            ),

                            const Divider(),

                            ListTile(
                              leading: Icon(Icons.history),
                              title: Text(
                                "Order History",
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              subtitle: Text(
                                "View all your past orders",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              trailing: Icon(Icons.chevron_right),
                              onTap: () {},
                            ),

                            const Divider(),

                            ListTile(
                              leading: const Icon(Icons.star_border),
                              title: Text(
                                "My Reviews",
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              subtitle: Text(
                                "Manage your ratings and reviews",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {},
                            ),
                            const Divider(),

                            InkWell(
                              child: ListTile(
                                leading: Icon(Icons.support_agent),
                                title: Text(
                                  "Customer Support",
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                subtitle: Text(
                                  "Contact our support team",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                trailing: Icon(Icons.chevron_right),
                              ),
                              onTap: () {
                                AppRouter.router.go(AppRouter.kCustomerSupport);
                              },
                            ),

                            const Divider(),

                            ListTile(
                              leading: Icon(Icons.help_outline),
                              title: Text(
                                "Help & Support",
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              subtitle: Text(
                                "FAQs and general assistance",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              trailing: Icon(Icons.chevron_right),
                            ),

                            const Divider(),

                            ListTile(
                              leading: const Icon(Icons.notifications_none),
                              title: Text(
                                "Notifications",
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              subtitle: Text(
                                "Get updates about your orders",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              trailing: Transform.scale(
                                scale: 0.7,
                                child: Switch(value: true, onChanged: (v) {}),
                              ),
                            ),
                            const Divider(),
                            ListTile(
                              leading: Icon(
                                Iconsax.lock_copy,
                                color: Theme.of(context).primaryColor,
                              ),
                              title: Text(
                                "Reset Password",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                              onTap: () {
                                GoRouter.of(
                                  context,
                                ).push(AppRouter.kResetPassword);
                              },
                            ),

                            const Divider(),

                            ListTile(
                              leading: const Icon(
                                Icons.logout,
                                color: Colors.red,
                              ),
                              title: const Text(
                                "Logout",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          screenWidth * 0.03,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          screenWidth * 0.03,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFFAE3E3),
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(
                                                screenWidth * 0.02,
                                              ),
                                              child: Icon(
                                                Icons.logout,
                                                size: screenWidth * 0.12,
                                                color: Colors.red,
                                              ),
                                            ),
                                            SizedBox(
                                              height: screenHeight * 0.03,
                                            ),

                                            Text(
                                              "Logout",
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.displayMedium,
                                            ),
                                            SizedBox(
                                              height: screenHeight * 0.02,
                                            ),
                                            Text(
                                              "Are you sure you want to logout?",
                                              textAlign: TextAlign.center,
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.titleMedium,
                                            ),
                                            SizedBox(
                                              height: screenHeight * 0.03,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                        ),
                                                    child: Text(
                                                      "Cancel",
                                                      style:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .titleSmall,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: BlocListener<
                                                    AuthCubit,
                                                    AuthState
                                                  >(
                                                    listener: (context, state) {
                                                      // TODO: implement listener
                                                      if (state
                                                          is AuthSignedOut) {
                                                        while (GoRouter.of(
                                                          context,
                                                        ).canPop()) {
                                                          GoRouter.of(
                                                            context,
                                                          ).pop();
                                                        }
                                                        GoRouter.of(
                                                          context,
                                                        ).pushReplacement(
                                                          AppRouter.kLogin,
                                                        );
                                                      }
                                                    },
                                                    child: ElevatedButton(
                                                      style:
                                                          ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors.red,
                                                          ),
                                                      onPressed: () async {
                                                        final prefs =
                                                            await SharedPreferences.getInstance();
                                                        await prefs.clear();
                                                        context
                                                            .read<AuthCubit>()
                                                            .signOut();
                                                      },
                                                      child: Text(
                                                        "Logout",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              _fontFamily,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Something went wrong.\nPlease try again.",
                    style: TextStyle(fontSize: 18, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UserProfileCubit>().loadUserProfile();
                    },
                    child: Text(
                      "Reload",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
