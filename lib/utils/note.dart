// ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColor.primary,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 40,
//                       vertical: 15,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onPressed: () async {
//                     try {
//                       final userId = await PreferenceHandler.getUserId();
//                       if (userId == null) {
//                         if (!mounted) return;
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text("The user is not logged in"),
//                           ),
//                         );
//                         return;
//                       }

//                       final response =
//                           await AuthenticationApiCheckOut.addCheckout(
//                             userId: userId, // sudah int
//                             items: [
//                               Item(
//                                 product: BuyNow(
//                                   id: p.id,
//                                   name: p.name,
//                                   price: p.price,
//                                 ),
//                                 quantity: quantity.toString(),
//                               ),
//                             ],
//                             total: totalPrice,
//                           );

//                       if (!mounted) return;
//                       ScaffoldMessenger.of(
//                         context,
//                       ).showSnackBar(SnackBar(content: Text(response.message)));
//                     } catch (e) {
//                       if (!mounted) return;
//                       print("Checkout process error: $e");

//                       ScaffoldMessenger.of(
//                         context,
//                       ).showSnackBar(SnackBar(content: Text("Error: $e")));
//                     }
//                   },

//                   child: Text(
//                     "Buy Now",
//                     style: TextStyle(
//                       fontFamily: "Montserrat",
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
