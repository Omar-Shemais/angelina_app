import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/core/widgets/app_loading_indicator.dart';
import 'package:angelina_app/core/widgets/custom_button.dart';
import 'package:angelina_app/core/widgets/custom_text.dart';
import 'package:angelina_app/core/widgets/shimmer_grid_loader.dart';
import 'package:angelina_app/features/home/data/repo/product_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:angelina_app/features/home/manger/cubit/product_cubit.dart';
import 'package:angelina_app/features/home/presentatioin/view/widgets/product_conatiner.dart';
import 'package:angelina_app/core/utils/route_utils/route_utils.dart';
import 'package:angelina_app/features/product_details/presentation/view/product_details_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductCategoryView extends StatelessWidget {
  final int categoryId;
  final String categoryName;

  const ProductCategoryView({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: AppColors.white,
      ),
      body: BlocProvider(
        create:
            (context) =>
                ProductCubit(ProductRepository())
                  ..fetchProductsForCategory(categoryId),
        child: SingleChildScrollView(
          child: BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(child: ShimmerGridLoader());
              } else if (state is ProductSuccess) {
                final filteredProducts =
                    state.products
                        .where(
                          (product) => product.categoryIds.contains(categoryId),
                        )
                        .toList();

                if (filteredProducts.isEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {});
                  return Column(
                    children: [
                      Center(
                        child: AppText(
                          title: 'لا توجد منتجات',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10.h,
                          crossAxisSpacing: 10.w,
                          childAspectRatio: 159 / 304,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
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
                      if (state.hasMore)
                        Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child:
                              state.isLoadingMore
                                  ? const Center(child: AppLoadingIndicator())
                                  : AppButton(
                                    btnText: 'عرض المزيد',
                                    width: 250.w,
                                    onTap: () {
                                      context
                                          .read<ProductCubit>()
                                          .fetchProductsForCategory(categoryId);
                                    },
                                  ),
                        ),
                    ],
                  ),
                );
              } else if (state is ProductFailure) {
                return Center(child: Text('خطأ: ${state.error}'));
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
