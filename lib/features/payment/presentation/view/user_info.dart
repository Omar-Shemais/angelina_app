import 'package:angelina_app/core/utils/validator_utils/validator_utils.dart';
import 'package:angelina_app/core/widgets/app_app_bar.dart';
import 'package:angelina_app/core/widgets/custom_button.dart';
import 'package:angelina_app/core/widgets/custom_text_field.dart';
import 'package:angelina_app/core/widgets/snack_bar.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_cubit.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_state.dart';
import 'package:angelina_app/features/payment/presentation/view/payment_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserInfoPage extends StatefulWidget {
  final int totalPriceCents;

  const UserInfoPage({required this.totalPriceCents});

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressLineController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetNameController = TextEditingController();
  final _floorNumberController = TextEditingController();
  final _buildingNumberController = TextEditingController();
  final _apartmentNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 50.h),
                AppAppBar(title: 'معلومات المستخدم'),
                SizedBox(height: 20.h),
                CustomTextField(
                  hint: ' الاسم الاول',
                  hasUnderline: true,
                  controller: _firstNameController,
                  validator: ValidatorUtils.name,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  hint: 'الاسم التاني',
                  hasUnderline: true,
                  controller: _lastNameController,
                  validator: ValidatorUtils.name,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  hint: 'البريد الالكتروني',
                  hasUnderline: true,
                  controller: _emailController,
                  validator: ValidatorUtils.email,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  hint: 'رقم الهاتف',
                  hasUnderline: true,
                  controller: _phoneController,
                  validator: ValidatorUtils.phone,
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  hint: 'العنوان',
                  hasUnderline: true,
                  controller: _addressLineController,
                  validator: ValidatorUtils.standered,
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextField(
                      hint: 'المدينه',
                      hasUnderline: true,
                      controller: _cityController,
                      width: 140.w,
                      height: 45.h,
                      validator: ValidatorUtils.standered,
                    ),
                    CustomTextField(
                      hint: 'الدوله',
                      hasUnderline: true,
                      controller: _countryController,
                      width: 140.w,
                      height: 45.h,
                      validator: ValidatorUtils.standered,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextField(
                      hint: 'رقم المبنى',
                      hasUnderline: true,
                      controller: _buildingNumberController,
                      keyboardType: TextInputType.numberWithOptions(),
                      width: 140.w,
                      height: 45.h,
                      validator: ValidatorUtils.standered,
                    ),
                    CustomTextField(
                      hint: 'اسم الشارع',
                      hasUnderline: true,
                      controller: _streetNameController,
                      width: 140.w,
                      height: 45.h,
                      validator: ValidatorUtils.standered,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextField(
                      hint: 'رقم الدور',
                      hasUnderline: true,
                      controller: _floorNumberController,
                      keyboardType: TextInputType.numberWithOptions(),
                      width: 140.w,
                      height: 45.h,
                      validator: ValidatorUtils.standered,
                    ),
                    CustomTextField(
                      hint: 'رقم الشقه',
                      hasUnderline: true,
                      controller: _apartmentNumberController,
                      width: 140.w,
                      height: 45.h,
                      keyboardType: TextInputType.numberWithOptions(),
                      validator: ValidatorUtils.standered,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                AppButton(
                  width: double.infinity,
                  btnText: 'متابعة للدفع',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      final state = context.read<CartCubit>().state;

                      if (state is CartLoaded) {
                        final cartItems = state.items;

                        final lineItems =
                            cartItems
                                .map(
                                  (item) => {
                                    "product_id": item.id,
                                    "quantity": item.quantity,
                                  },
                                )
                                .toList();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => PaymentWebViewPage(
                                  firstName: _firstNameController.text,
                                  lastName: _lastNameController.text,
                                  email: _emailController.text,
                                  phone: _phoneController.text,
                                  address1: _addressLineController.text,
                                  city: _cityController.text,
                                  country: _countryController.text,
                                  totalPriceCents: widget.totalPriceCents,
                                  lineItems: lineItems,
                                ),
                          ),
                        );
                      } else {
                        showSnackBar('السلة غير جاهزة بعد');
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
