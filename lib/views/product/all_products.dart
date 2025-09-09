import 'package:blenzo/extensions/navigations.dart';
import 'package:blenzo/models/product/get_product.dart';
import 'package:blenzo/services/api/product_api.dart';
import 'package:blenzo/utils/app_color.dart';
import 'package:blenzo/utils/currency_format.dart';
import 'package:blenzo/views/product/product_detail.dart';
import 'package:flutter/material.dart';

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({super.key});
  static const id = "/all_product_page";

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  late Future<GetProdukModel> futureProduct;
  String query = "";
  String selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    futureProduct = AuthenticationApiProduct.getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: Text(
          "All Products",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
            color: AppColor.text,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<GetProdukModel>(
        future: futureProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColor.primary),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return Center(child: Text("No Products found"));
          }

          var productList = List<Datum>.from(snapshot.data!.data);

          // filter by search
          if (query.isNotEmpty) {
            productList = productList
                .where((p) => (p.name ?? "").toLowerCase().contains(query))
                .toList();
          }

          // filter by harga
          if (selectedFilter == "Lowest") {
            productList.sort(
              (a, b) =>
                  (int.parse(a.price) ?? 0).compareTo(int.parse(b.price) ?? 0),
            );
          } else if (selectedFilter == "Highest") {
            productList.sort(
              (a, b) =>
                  (int.parse(b.price) ?? 0).compareTo(int.parse(a.price) ?? 0),
            );
          }

          return Column(
            children: [
              // Search box
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search any Products...",
                    hintStyle: TextStyle(
                      fontFamily: "Montserrat",
                      color: AppColor.text2,
                    ),
                    prefixIcon: Icon(Icons.search, color: AppColor.text2),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      query = value.toLowerCase();
                    });
                  },
                ),
              ),

              // Dropdown filter
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      "Filter: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    SizedBox(width: 8),
                    DropdownButton<String>(
                      value: selectedFilter,
                      items: [
                        DropdownMenuItem(
                          value: "All",
                          child: Text("All Product"),
                        ),
                        DropdownMenuItem(
                          value: "Lowest",
                          child: Text("Lowest Price"),
                        ),
                        DropdownMenuItem(
                          value: "Highest",
                          child: Text("Highest Price"),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedFilter = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),

              // Produk list
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: productList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.60,
                  ),
                  itemBuilder: (context, index) {
                    final p = productList[index];
                    final discount = int.tryParse(p.discount ?? "0") ?? 0;

                    return GestureDetector(
                      onTap: () {
                        context.push(ProductDetailPage(product: p));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.neutral,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: p.imageUrls.isNotEmpty
                                        ? Image.network(
                                            p.imageUrls[0],
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            color: Colors.grey[300],
                                            child: Icon(Icons.image, size: 50),
                                          ),
                                  ),
                                ),
                                if (discount > 0)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppColor.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        "-$discount%",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColor.text,
                                    ),
                                  ),
                                  if (discount > 0)
                                    Text(
                                      formatRupiah(p.price),
                                      style: TextStyle(
                                        fontSize: 15,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  Text(
                                    discount > 0
                                        ? formatRupiah(
                                            (int.parse(p.price) *
                                                    (100 - discount) ~/
                                                    100)
                                                .toString(),
                                          )
                                        : formatRupiah(p.price),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
