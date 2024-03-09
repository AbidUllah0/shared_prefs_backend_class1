import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_shared_prefs_backend/Widgets/custom_text.dart';
import 'package:modal_shared_prefs_backend/models/product.dart';
import 'package:modal_shared_prefs_backend/presentation/assignment_one/added_products.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssignmentOne extends StatefulWidget {
  const AssignmentOne({super.key});

  @override
  State<AssignmentOne> createState() => _AssignmentOneState();
}

class _AssignmentOneState extends State<AssignmentOne> {
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Modal Classes & Shared Prefs Assignment',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddedProducts()));
            },
            icon: Icon(Icons.print),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: idController,
              decoration: const InputDecoration(
                hintText: 'Enter Product ID',
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Enter Product Name',
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(
                hintText: 'Enter Product Price',
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: quantityController,
              decoration: const InputDecoration(
                hintText: 'Enter Product Quantity',
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                String id = idController.text;
                String name = nameController.text;
                double price = double.parse(priceController.text);
                double quantity = double.parse(quantityController.text);

                Product product = Product(
                    id: id, name: name, price: price, quantity: quantity);
                saveProduct(product).then((value) {
                  print('Saved');
                });
                showSnackBar();
                idController.clear();
                nameController.clear();
                priceController.clear();
                quantityController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(width, height * 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: CustomText(
                text: 'Add Product',
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveProduct(Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? products = prefs.getStringList('products');
    // products ??= [];
    if (products == null) {
      products = [];
    }
    var json = product.toJson();
    products.add(jsonEncode(json));

    await prefs.setStringList('products', products);
  }

  void showSnackBar() {
    final snackBar = SnackBar(
      content: Text('Product Added'),
      backgroundColor: Colors.blue,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Not want to add',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
