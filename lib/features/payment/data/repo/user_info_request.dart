import 'dart:convert';
import 'package:angelina_app/core/utils/constants/constants.dart';
import 'package:dio/dio.dart';

class OrderRepo {
  static Future<bool> sendOrder({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String address1,
    required String city,
    required String country,
    required List<Map<String, dynamic>> lineItems,
  }) async {
    final dio = Dio();
    String username = AppConstants.authUserName;
    String password = AppConstants.authPassword;
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';

    final orderData = {
      "payment_method": "cod",
      "payment_method_title": "Cash on delivery",
      "set_paid": true,
      "billing": {
        "first_name": firstName,
        "last_name": lastName,
        "address_1": address1,
        "address_2": "",
        "city": city,
        "state": "",
        "postcode": "12345",
        "country": country,
        "email": email,
        "phone": phone,
      },
      "line_items": lineItems,
    };

    try {
      final response = await dio.post(
        AppConstants.postBaseUrl,
        data: orderData,
        options: Options(
          headers: {
            'Authorization': basicAuth,
            'Content-Type': 'application/json',
          },
        ),
      );

      return response.statusCode == 201;
    } catch (e) {
      print("⚠️ OrderRepo Error: $e");
      return false;
    }
  }
}
