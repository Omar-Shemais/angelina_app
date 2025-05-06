import 'package:angelina_app/core/utils/constants/constants.dart';
import 'package:dio/dio.dart';

class PaymobRepo {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://accept.paymob.com/api/',
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  Future<String> getAuthToken() async {
    final response = await _dio.post(
      'auth/tokens',
      data: {"api_key": AppConstants.authToken},
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return response.data['token'];
    } else {
      throw Exception('Failed to get auth token: ${response.data}');
    }
  }

  Future<String> createOrder(String token, int amountCents) async {
    final response = await _dio.post(
      'ecommerce/orders',
      data: {
        "auth_token": token,
        "delivery_needed": false,
        "amount_cents": amountCents.toString(), // ✅ convert to string
        "currency": "EGP",
        "items": [],
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return response.data['id'].toString(); // ✅ return as string
    } else {
      throw Exception('Failed to create order: ${response.data}');
    }
  }

  Future<String> getPaymentKey({
    required String token,
    required String orderId,
    required int amountCents,
  }) async {
    final response = await _dio.post(
      'acceptance/payment_keys',
      data: {
        "auth_token": token,
        "amount_cents": amountCents.toString(), // ✅ convert to string
        "expiration": 3600,
        "order_id": orderId,
        "billing_data": {
          "apartment": "NA",
          "email": "customer@example.com",
          "floor": "NA",
          "first_name": 'name',
          "street": "NA",
          "building": "NA",
          "phone_number": "01000000000",
          "shipping_method": "NA",
          "postal_code": "NA",
          "city": "NA",
          "country": "NA",
          "last_name": "Doe",
          "state": "NA",
        },
        "currency": "EGP",
        "integration_id": AppConstants.integrationId,
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return response.data['token'];
    } else {
      throw Exception('Failed to get payment key: ${response.data}');
    }
  }
}
