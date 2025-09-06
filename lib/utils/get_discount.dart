import 'package:blenzo/models/cart/get_cart.dart';

int getDiscountedPrice(Product product) {
  final int price = int.tryParse(product.price) ?? 0;
  final int discount = int.tryParse(product.discount) ?? 0;
  if (discount > 0) {
    return price - ((price * discount) ~/ 100);
  }
  return price;
}
