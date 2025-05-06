import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/features/Favorite/manger/cubit/favorite_cubit.dart';
import 'package:angelina_app/features/Favorite/presentation/view/favourite_view.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_cubit.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_state.dart';
import 'package:angelina_app/features/cart/presentation/view/cart_view.dart';
import 'package:angelina_app/features/home/presentatioin/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeNavigationBar extends StatefulWidget {
  const HomeNavigationBar({super.key, this.selectedIndex = 0});
  final int selectedIndex;

  @override
  State<HomeNavigationBar> createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<HomeNavigationBar> {
  late int _selectedIndex;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    context.read<CartCubit>().loadCart();
    context.read<FavoriteCubit>().loadFavorites();
  }

  final List<Widget> _pages = [
    const HomeView(),
    const FavouriteView(),
    CartView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, cartState) {
          return BlocBuilder<FavoriteCubit, FavoriteState>(
            builder: (context, favState) {
              int cartCount = 0;
              int favCount = 0;

              if (cartState is CartLoaded) {
                cartCount = cartState.items.fold(
                  0,
                  (sum, item) => sum + item.quantity,
                );
              }

              if (favState is FavoriteLoaded) {
                favCount = favState.favorites.length;
              }

              return BottomNavigationBar(
                backgroundColor: Colors.white,
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.purple,
                unselectedItemColor: Colors.grey,
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Stack(
                      children: [
                        const Icon(Icons.favorite_border),
                        if (favCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: CircleAvatar(
                              radius: 7,
                              backgroundColor: AppColors.primaryColor,
                              child: Text(
                                '$favCount',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    label: 'Favourite',
                  ),
                  BottomNavigationBarItem(
                    icon: Stack(
                      children: [
                        const Icon(Icons.shopping_cart_outlined),
                        if (cartCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: CircleAvatar(
                              radius: 7,
                              backgroundColor: AppColors.primaryColor,
                              child: Text(
                                '$cartCount',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    label: 'Cart',
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
