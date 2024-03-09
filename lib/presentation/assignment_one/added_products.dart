import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_shared_prefs_backend/Widgets/custom_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/product.dart';

class AddedProducts extends StatefulWidget {
  const AddedProducts({super.key});

  @override
  State<AddedProducts> createState() => _AddedProductsState();
}

class _AddedProductsState extends State<AddedProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: 'Added Product'),
      ),
      body: FutureBuilder<List<Product>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('There is an Error in Leading the Data'));
          } else if (snapshot.hasData) {
            List<Product> products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                Product product = products[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: CustomText(text: 'Name : ${product.name}'),
                      subtitle: CustomText(
                          text:
                              'ID : ${product.id} , Quantity : ${product.quantity} , Price : ${product.price}'),
                      trailing: IconButton(
                        onPressed: () async {
                          SharedPreferences sp =
                              await SharedPreferences.getInstance();
                          setState(() {
                            sp.clear();
                          });
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('No products found'),
            );
          }
        },
      ),
    );
  }

  Future<List<Product>> fetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? productStrings = prefs.getStringList('products');
    if (productStrings != null) {
      List<Product> products = productStrings.map((jsonString) {
        Map<String, dynamic> json = jsonDecode(jsonString);
        return Product.fromJson(json);
      }).toList();
      return products;
    } else {
      return [];
    }
  }
}
