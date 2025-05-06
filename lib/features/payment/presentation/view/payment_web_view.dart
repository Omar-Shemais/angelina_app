import 'package:angelina_app/core/utils/app_colors/app_colors.dart';
import 'package:angelina_app/core/widgets/snack_bar.dart';
import 'package:angelina_app/features/cart/manger/cubit/cart_cubit.dart';
import 'package:angelina_app/features/payment/data/repo/paymob_repo.dart';
import 'package:angelina_app/features/payment/data/repo/user_info_request.dart';
import 'package:angelina_app/features/payment/manger/payment_cubit/payment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewPage extends StatefulWidget {
  final String firstName, lastName, email, phone, address1, city, country;
  final List<Map<String, dynamic>> lineItems;

  final int totalPriceCents;

  const PaymentWebViewPage({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address1,
    required this.city,
    required this.country,
    required this.totalPriceCents,
    required this.lineItems,
  });

  @override
  _PaymentWebViewPageState createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final PaymentCubit cubit;
  WebViewController? _controller;

  Future<void> sendOrder() async {
    final success = await OrderRepo.sendOrder(
      firstName: widget.firstName,
      lastName: widget.lastName,
      email: widget.email,
      phone: widget.phone,
      address1: widget.address1,
      city: widget.city,
      country: widget.country,
      lineItems: widget.lineItems,
    );

    if (success) {
      // print("✅ Order placed");
      await Future.delayed(Duration(seconds: 3));
      _navigateToCart(
        clearCart: true,
        message: 'تم الدفع بنجاح',
        isError: false,
      );
    } else {
      // print("❌ Order failed");
    }
  }

  @override
  void initState() {
    super.initState();
    cubit = PaymentCubit(PaymobRepo());
    cubit.startPayment(widget.totalPriceCents);
  }

  void _navigateToCart({
    required bool clearCart,
    required String message,
    required bool isError,
  }) {
    if (clearCart) {
      context.read<CartCubit>().saveCart([]);
    }
    showSnackBar(message, isError: isError);
    Future.delayed(Duration(milliseconds: 300), () {
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الدفع'), backgroundColor: AppColors.white),
      body: BlocConsumer<PaymentCubit, PaymentState>(
        bloc: cubit,
        listener: (context, state) async {
          if (state is PaymentSuccess) {
            final url =
                "https://accept.paymob.com/api/acceptance/iframes/916101?payment_token=${state.paymentKey}";

            _controller =
                WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onPageFinished: (url) async {
                        // print("📄 Finished loading URL: $url");

                        try {
                          if (url.toLowerCase().contains("success")) {
                            await sendOrder();
                            await Future.delayed(Duration(seconds: 3));
                            _navigateToCart(
                              clearCart: true,
                              message: 'تم الدفع بنجاح',
                              isError: false,
                            );
                          } else if (url.toLowerCase().contains("fail") ||
                              url.toLowerCase().contains("error")) {
                            // print("❌ Payment failure detected via URL");
                            _navigateToCart(
                              clearCart: false,
                              message: 'فشلت عملت الدفع',
                              isError: true,
                            );
                            await Future.delayed(Duration(seconds: 3));
                            // showSnackBar('فشلت عمليه الدفع');
                          } else {
                            final jsResult = await _controller!
                                .runJavaScriptReturningResult(
                                  "window.document.body.innerText",
                                );
                            final bodyText = jsResult.toString().toLowerCase();
                            // print("🧾 JS Result: $bodyText");

                            if (bodyText.contains("success")) {
                              _navigateToCart(
                                clearCart: true,
                                message: 'تم الدفع بنجاح',
                                isError: false,
                              );
                            } else if (bodyText.contains("failed")) {
                              _navigateToCart(
                                clearCart: false,
                                message: 'فشلت عملت الدفع',
                                isError: true,
                              );
                            }
                          }
                        } catch (e) {
                          print("⚠️ Error reading payment result: $e");
                        }
                      },
                    ),
                  )
                  ..loadRequest(Uri.parse(url));

            setState(() {});
          }
        },
        builder: (context, state) {
          if (state is PaymentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PaymentSuccess && _controller != null) {
            return WebViewWidget(controller: _controller!);
          } else if (state is PaymentError) {
            return Center(child: Text('فشل الدفع: ${state.message}'));
          }
          return Container();
        },
      ),
    );
  }
}
