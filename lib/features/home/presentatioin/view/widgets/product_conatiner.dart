import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/core/widgets/custom_button.dart';
import 'package:angelina_app/core/widgets/custom_text.dart';
import 'package:angelina_app/features/Favorite/manger/cubit/favorite_cubit.dart';
import 'package:angelina_app/features/home/data/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductContainer extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String category;
  final String price;
  final VoidCallback onTap;
  final ProductModel product;

  const ProductContainer({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.category,
    required this.price,
    required this.onTap,
    required this.product,
  });

  @override
  State<ProductContainer> createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 304.h,
      width: 159.w,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                height: 150.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        widget.imageUrl.isNotEmpty
                            ? NetworkImage(widget.imageUrl)
                            : const AssetImage(
                                  'assets/images/product_placeholder.png',
                                )
                                as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              Positioned(
                top: 5.h,
                right: 5.w,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.8),
                  radius: 15.r,
                  child: BlocBuilder<FavoriteCubit, FavoriteState>(
                    builder: (context, state) {
                      final cubit = context.read<FavoriteCubit>();
                      bool isFav = cubit.isFavorite(widget.product);
                      return GestureDetector(
                        onTap: () {
                          context.read<FavoriteCubit>().toggleFavorite(
                            widget.product,
                          );
                          setState(() {});
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.8),
                          child: Icon(
                            size: 20.sp,
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          SizedBox(
            height: 30.h,
            child: AppText(
              title: widget.name,
              fontSize: 10,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w700,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 5.h),
          AppText(
            title: widget.category,
            fontSize: 8.5,
            textAlign: TextAlign.center,
            color: AppColors.lightTextColor,
          ),
          SizedBox(height: 5.h),
          AppText(
            title: '${widget.price} ر.س',
            fontSize: 9.5,
            textAlign: TextAlign.center,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 5.h),
          AppButton(
            btnText: 'تحديد أحد الخيارات',
            fontSize: 9.sp,
            height: 24.h,
            width: 98.w,
            onTap: widget.onTap,
          ),
        ],
      ),
    );
  }
}
