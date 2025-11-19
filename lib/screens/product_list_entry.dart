import 'package:flutter/material.dart';
import 'package:i_wear_soccer/models/product_entry.dart';
import 'package:i_wear_soccer/widgets/left_drawer.dart';
import 'package:i_wear_soccer/screens/product_detail.dart';
import 'package:i_wear_soccer/widgets/product_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ProductEntryListPage extends StatefulWidget {
  final bool myProduct;
  const ProductEntryListPage({super.key, this.myProduct=false});

  @override
  State<ProductEntryListPage> createState() => _ProductEntryListPageState();
}

class _ProductEntryListPageState extends State<ProductEntryListPage> {
  Future<List<Shop>> fetchProduct(CookieRequest request) async {
    // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
    // If you using chrome,  use URL http://localhost:8000

    final response = await request.get('http://localhost:8000/json/');
    final userData = await request.get(
      'http://localhost:8000/auth/user-id/',
    );
    int userId = userData['user_id'];
    // Decode response to json format
    var data = response;

    // Convert json data to Shop objects
    List<Shop> listProduct = [];
    for (var d in data) {
      if (d != null ) {
        if (widget.myProduct && Shop.fromJson(d).userId == userId){
          listProduct.add(Shop.fromJson(d));
        }

        else if (!widget.myProduct){
          listProduct.add(Shop.fromJson(d));
        }
      }
    }
    return listProduct;
  }

  Future<void> _refreshProducts() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(title: const Text('All Products')),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchProduct(request),
        builder: (context, AsyncSnapshot<List<Shop>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error.toString()}'),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return RefreshIndicator(
                onRefresh: _refreshProducts,
                child: ListView(
                  children: const [
                    SizedBox(height: 120),
                    Center(
                      child: Text(
                        'There are no products yet.',
                        style:
                            TextStyle(fontSize: 18, color: Color(0xff59A5D8)),
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: _refreshProducts,
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) => ProductEntryCard(
                    product: snapshot.data![index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailPage(product: snapshot.data![index]),
                        ),
                      );
                    },
                  ),
                ),
              );
            }
          } else {
            return const Center(
              child: Text('No data received from server.'),
            );
          }
        },
      ),
    );
  }
}
