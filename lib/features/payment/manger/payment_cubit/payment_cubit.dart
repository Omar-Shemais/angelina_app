import 'package:angelina_app/features/payment/data/repo/paymob_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymobRepo paymobRepo;

  PaymentCubit(this.paymobRepo) : super(PaymentInitial());
  Future<void> startPayment(int totalPriceInCents) async {
    emit(PaymentLoading());
    try {
      // 1. Get Auth Token
      final token = await paymobRepo.getAuthToken();
      // print('✅ Auth Token: $token');

      // 2. Create Order
      final orderId = await paymobRepo.createOrder(token, totalPriceInCents);
      // print('✅ Order ID: $orderId');

      // 3. Get Payment Key
      final paymentKey = await paymobRepo.getPaymentKey(
        token: token,
        orderId: orderId,
        amountCents: totalPriceInCents,
      );
      // print('✅ Payment Key: $paymentKey');

      emit(PaymentSuccess(paymentKey));
    } catch (e) {
      // print('❌ Payment Error: $e');
      emit(PaymentError(e.toString()));
    }
  }
}
