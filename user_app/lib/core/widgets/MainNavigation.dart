import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/profile/manager/user_profile_cubit.dart';

class MainNavigation extends StatefulWidget {
  final Widget child;
  const MainNavigation({required this.child, super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final List<String> _tabs = ['/home', '/favoriteScreen', '/cart', '/profile'];

  int _currentIndex = 0;

  Widget _buildBottomNavBar(
    BuildContext context,
    UserProfileCubit profileCubit,
  ) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.4),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(icon: Icons.home_filled, index: 0, label: "Home"),
          _navItemWithBadge(
            icon: Icons.favorite,
            index: 1,
            label: "Favorites",
            stream: profileCubit.getUserFavoriteCountStream(),
          ),
          _navItemWithBadge(
            icon: Icons.shopping_cart,
            index: 2,
            label: "Cart",
            stream: profileCubit.getUserCartCountStream(),
          ),
          _navItem(icon: Icons.person, index: 3, label: "Profile"),
        ],
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required int index,
    required String label,
  }) {
    bool isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        context.go(_tabs[index]);
        setState(() => _currentIndex = index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 250),
            padding: EdgeInsets.all(isActive ? 6 : 4),
            decoration: BoxDecoration(
              color: isActive ? Colors.white70 : Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: isActive ? 28 : 24,
              color: isActive ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ?  Colors.white70 :Theme.of(context).cardColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItemWithBadge({
    required IconData icon,
    required int index,
    required String label,
    required Stream<int> stream,
  }) {
    bool isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        context.go(_tabs[index]);
        setState(() => _currentIndex = index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 250),
                padding: EdgeInsets.all(isActive ? 6 : 4),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white70 : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: isActive ? 28 : 24,
                  color:
                      isActive
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardColor,
                ),
              ),

              /// Badge
              Positioned(
                right: -4,
                top: -4,
                child: StreamBuilder<int>(
                  stream: stream,
                  builder: (context, snapshot) {
                    final value = snapshot.data ?? 0;
                    if (value == 0) return SizedBox();

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "$value",
                        style: TextStyle(
                          color: Theme.of(context).cardColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ?  Colors.white60 : Theme.of(context).cardColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    final profileCubit = context.read<UserProfileCubit>();
    final state = router.state;
    final currentPath = state.uri.path;
    final tabIndex = _tabs.indexWhere((path) => currentPath.startsWith(path));
    if (tabIndex >= 0 && tabIndex != _currentIndex) {
      _currentIndex = tabIndex;
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: _buildBottomNavBar(context, profileCubit),
    );
  }
}


      // bottomNavigationBar: ConvexAppBar(
      //   key: ValueKey(_currentIndex),
      //   style: TabStyle.fixed,
      //   // backgroundColor: Theme.of(context).cardColor,
      //   activeColor: Colors.black,
      //   color: Colors.white,
      //   shadowColor: Colors.black26,
      //   elevation: 5,
      //   initialActiveIndex: _currentIndex,

      //   gradient: LinearGradient(
      //     colors: [Theme.of(context).hintColor, Theme.of(context).primaryColor],
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //   ),
      //   items: [
      //     const TabItem(
      //       icon: Icon(Icons.home_filled, color: Colors.white),
      //       title: 'Home',
      //     ),
      //     TabItem(
      //       icon: Stack(
      //         clipBehavior: Clip.none,
      //         children: [
      //           const Icon(Icons.favorite, color: Colors.white),
      //           Positioned(
      //             right: -4,
      //             top: -4,
      //             child: Container(
      //               padding: const EdgeInsets.all(4),
      //               decoration: const BoxDecoration(
      //                 color: Colors.red,
      //                 shape: BoxShape.circle,
      //               ),
      //               child: StreamBuilder<int>(
      //                 stream: profileCubit.getUserFavoriteCountStream(),
      //                 builder: (context, snapshot) {
      //                   return Text(
      //                     snapshot.data?.toString() ?? "0",
      //                     style: const TextStyle(
      //                       color: Colors.white,
      //                       fontSize: 10,
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   );
      //                 },
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //       title: 'Favorites',
      //     ),
      //     TabItem(
      //       icon: Stack(
      //         clipBehavior: Clip.none,
      //         children: [
      //           const Icon(Icons.shopping_cart, color: Colors.white),
      //           Positioned(
      //             right: -4,
      //             top: -4,
      //             child: Container(
      //               padding: const EdgeInsets.all(4),
      //               decoration: const BoxDecoration(
      //                 color: Colors.red,
      //                 shape: BoxShape.circle,
      //               ),
      //               child: StreamBuilder<int>(
      //                 stream: profileCubit.getUserCartCountStream(),
      //                 builder: (context, snapshot) {
      //                   return Text(
      //                     snapshot.data?.toString() ?? "0",
      //                     style: const TextStyle(
      //                       color: Colors.white,
      //                       fontSize: 10,
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   );
      //                 },
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //       title: 'Cart',
      //     ),
      //     const TabItem(
      //       icon: Icon(Icons.person, color: Colors.white),
      //       title: 'Profile',
      //     ),
      //   ],

      //   onTap: (index) {
      //     if (index != _currentIndex) {
      //       context.go(_tabs[index]);
      //     }
      //     setState(() {
      //       _currentIndex = index;
      //     });
      //   },
      // ),