import 'package:angelina_app/core/utils/route_utils/route_utils.dart';
import 'package:angelina_app/core/widgets/shimmer_grid_loader.dart';
import 'package:angelina_app/features/home/manger/cubit/product_cubit.dart';
import 'package:angelina_app/features/home/presentatioin/view/widgets/custom_categories.dart';
import 'package:angelina_app/features/home/presentatioin/view/widgets/custom_home_banner.dart';
import 'package:angelina_app/features/home/presentatioin/view/widgets/home_app_bar.dart';
import 'package:angelina_app/features/home/presentatioin/view/widgets/product_conatiner.dart';
import 'package:angelina_app/features/home/presentatioin/view/widgets/see_more_home.dart';
import 'package:angelina_app/features/home/presentatioin/view/widgets/see_more_product.dart';
import 'package:angelina_app/features/product_details/presentation/view/product_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 40.h),
            HomeAppBar(),
            SizedBox(height: 20.h),
            CustomHomeBanner(),
            SizedBox(height: 20.h),
            SeeMoreHome(title: 'الاقسام'),
            SizedBox(height: 20.h),
            CustomCategories(),
            SizedBox(height: 20.h),
            SeeMoreHome(
              title: 'احدث المنتجات',
              onTap: () => RouteUtils.push(SeeMoreProduct()),
            ),

            // ProductContainer(),
            BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(child: ShimmerGridLoader());
                } else if (state is ProductSuccess) {
                  return Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.h,
                        crossAxisSpacing: 10.w,
                        childAspectRatio: 159 / 304,
                      ),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return ProductContainer(
                          imageUrl:
                              product.imageUrls.isNotEmpty
                                  ? product.imageUrls.first
                                  : '',
                          name: product.name,
                          category:
                              product.categories.isNotEmpty
                                  ? product.categories.first
                                  : '',
                          price: product.price,
                          onTap: () {
                            RouteUtils.push(
                              ProductDetailsView(product: product),
                            );
                          },
                          product: product,
                        );
                      },
                    ),
                  );
                } else if (state is ProductFailure) {
                  print(state.error);
                  return Center(child: Text('خطأ: ${state.error}'));
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
