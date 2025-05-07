import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/core/widgets/custom_button.dart';
import 'package:angelina_app/core/widgets/custom_text.dart';
import 'package:angelina_app/core/widgets/snack_bar.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_cubit.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_state.dart';
import 'package:angelina_app/features/product_details/presentation/view/widgets/Custom_counter.dart';
import 'package:angelina_app/features/product_details/presentation/view/widgets/custom_drop_menu.dart';
import 'package:angelina_app/features/product_details/presentation/view/widgets/product_details_image.dart';
import 'package:flutter/material.dart';
import 'package:angelina_app/features/home/data/model/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsViewBody extends StatefulWidget {
  final ProductModel product;
  const ProductDetailsViewBody({super.key, required this.product});

  @override
  State<ProductDetailsViewBody> createState() => _ProductDetailsViewBodyState();
}

class _ProductDetailsViewBodyState extends State<ProductDetailsViewBody> {
  int quantity = 1;
  String dropdownvalue = '';
  String calculateDiscount(String regular, String sale) {
    final double regularPrice = double.tryParse(regular) ?? 0;
    final double salePrice = double.tryParse(sale) ?? 0;
    if (regularPrice == 0) return '0';
    final discount = ((regularPrice - salePrice) / regularPrice) * 100;
    return discount.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40.h),

          // Product Image
          if (widget.product.imageUrls.isNotEmpty)
            ProductDetailsImag(product: widget.product)
          else
            Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported, size: 100),
            ),

          const SizedBox(height: 16),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 23.w),
            child: Column(
              children: [
                // Product Name
                AppText(
                  title: widget.product.name,
                  fontSize: 21,
                  textAlign: TextAlign.right,
                ),

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Dropdown
                    CustomDropMenu(colors: widget.product.colors),
                    CustomCounter(
                      quantity: quantity,
                      onQuantityChanged: (newQuantity) {
                        setState(() {
                          quantity = newQuantity;
                        });
                      },
                    ),
                  ],
                ),

                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppText(
                      title: 'وصف المنتج',
                      textAlign: TextAlign.right,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                SizedBox(height: 15.h),

                AppText(
                  title:
                      widget.product.description.isNotEmpty
                          ? cleanDescription(widget.product.description)
                          : 'لا يوجد وصف متاح لهذا المنتج.',
                  fontSize: 12,
                  color: AppColors.lightTextColor,
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 20.h),
                // Product Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<CartCubit, CartState>(
                      builder: (context, state) {
                        return AppButton(
                          btnText: 'اضافة الى السلة',
                          height: 45.h,
                          width: 190.w,
                          onTap: () {
                            context.read<CartCubit>().addToCart(
                              widget.product,
                              quantity: quantity,
                            );
                            showSnackBar('تمت إضافة المنتج إلى السلة');
                          },
                        );
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (widget.product.salePrice.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              AppText(
                                title:
                                    'ر.س${(double.parse(widget.product.salePrice) * quantity).toStringAsFixed(2)}',
                                fontSize: 22,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'ر.س${(double.parse(widget.product.regularPrice) * quantity).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: AppText(
                                  title:
                                      '%${calculateDiscount(widget.product.regularPrice, widget.product.salePrice)} خصم',
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        else
                          AppText(
                            title:
                                'ر.س${(double.parse(widget.product.price) * quantity).toStringAsFixed(2)}',
                            fontSize: 22,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to clean the description
  String cleanDescription(String htmlText) {
    // Remove HTML tags
    String cleanedText = htmlText.replaceAll(RegExp(r'<[^>]*>'), '');

    // Replace multiple spaces with a single space and trim leading/trailing spaces
    cleanedText = cleanedText.replaceAll(RegExp(r'\s+'), ' ').trim();

    return cleanedText;
  }
}
