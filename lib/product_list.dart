import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'api_service/api.dart';
import 'model/product.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  // get all products from server
  Future<List<Product>> getAllProducts() async {
    List<Product> productList = [];

    try {
      final url = Uri.parse(Api.getAllProducts);
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        for (var eachRecord in (responseData as List)) {
          productList.add(Product.fromJson(eachRecord));
        }
      } else {
        Fluttertoast.showToast(msg: "Error loading products.");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error loading products.");
    }

    return productList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            FutureBuilder(
                future: getAllProducts(),
                builder: (context, AsyncSnapshot<List<Product>> dataSnapShot) {
                  if (dataSnapShot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (dataSnapShot.data == null || dataSnapShot.data!.isEmpty) {
                    return Center(
                      child: Text("No data found!"),
                    );
                  }
                  if (dataSnapShot.data!.isNotEmpty) {
                    return Column(
                      children: dataSnapShot.data!.map((eachProduct) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Hero(
                                  tag: eachProduct.image!,
                                  child: CachedNetworkImage(
                                    imageUrl: eachProduct.image!,
                                    placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                    fadeInDuration:
                                    const Duration(milliseconds: 500),
                                    fadeOutDuration:
                                    const Duration(milliseconds: 200),
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  eachProduct.title!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Price: Tk ${eachProduct.price}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Center(
                      child: Text("No products available."),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
