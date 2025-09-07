import 'package:blenzo/models/product/get_product.dart';

class CheckoutWithProduct {
  final int checkoutId;
  final bool isReviewed;
  final Datum product;

  CheckoutWithProduct({
    required this.checkoutId,
    required this.isReviewed,
    required this.product,
  });
}
