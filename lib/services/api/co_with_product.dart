import 'package:blenzo/models/co_with_product.dart';
import 'package:blenzo/services/api/checkout_api.dart';
import 'package:blenzo/services/api/product_api.dart';

class CheckoutService {
  Future<List<CheckoutWithProduct>> getCheckoutsWithProducts() async {
    final checkouts = await AuthenticationApiCheckOut.getCheckout();
    final products = await AuthenticationApiProduct.getProduct();

    List<CheckoutWithProduct> result = [];

    for (var c in checkouts.data) {
      for (var item in c.items) {
        final product = products.data.firstWhere(
          (p) => p.id == item.product.id, // match by product.id
          orElse: () =>
              throw Exception("Product not found for checkout ${c.id}"),
        );

        result.add(
          CheckoutWithProduct(
            checkoutId: c.id,
            isReviewed: item.hasReviewed, // pakai hasReviewed dari Stuff
            product: product,
          ),
        );
      }
    }

    return result;
  }
}
