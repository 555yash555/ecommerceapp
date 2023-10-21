import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/productmodel.dart';
import '../models/category.dart';

class ProductProvider with ChangeNotifier {
  final http.Client client; // Add the client

  ProductProvider({http.Client? client}) : client = client ?? http.Client();
  List<Categoryy> category_demo = [];
  final List<Product> productsdemo = [
    Product(
      id: 1,
      title: 'Product 1',
      price: 10.0,
      description: 'Description for Product 1',
      category: Categoryy(
        id: 1,
        name: 'Category 1',
        image: 'https://picsum.photos/id/1018/400/300',
      ),
      images: ['https://picsum.photos/id/1018/400/300'],
    ),
    Product(
      id: 2,
      title: 'Product 2',
      price: 20.0,
      description: 'Description for Product 2',
      category: Categoryy(
        id: 2,
        name: 'Category 2',
        image: 'https://picsum.photos/id/1015/400/300',
      ),
      images: ['https://picsum.photos/id/1015/400/300'],
    ),
    Product(
      id: 3,
      title: 'Product 3',
      price: 30.0,
      description: 'Description for Product 3',
      category: Categoryy(
        id: 3,
        name: 'Category 3',
        image: 'https://picsum.photos/id/1019/400/300',
      ),
      images: ['https://picsum.photos/id/1019/400/300'],
    ),
    Product(
      id: 4,
      title: 'Product 4',
      price: 40.0,
      description: 'Description for Product 4',
      category: Categoryy(
        id: 4,
        name: 'Category 4',
        image: 'https://picsum.photos/id/1020/400/300',
      ),
      images: ['https://picsum.photos/id/1020/400/300'],
    ),
    Product(
      id: 5,
      title: 'Product 5',
      price: 50.0,
      description: 'Description for Product 5',
      category: Categoryy(
        id: 5,
        name: 'Category 5',
        image: 'https://picsum.photos/id/1021/400/300',
      ),
      images: ['https://picsum.photos/id/1021/400/300'],
    ),
  ];
  List<Product> get productsdemoo => productsdemo;
  final String baseUrl = 'https://api.escuelajs.co/api/v1/products';
  List<Product> catproducts = [];
  List<Product> _products = [];
  bool isloading = true;
  bool catisloading = true;

  int _offset = 0;
  int get offset => _offset;
  final int _limit = 10;
  bool get hasMore => _hasMore;
  bool _hasMore = true;

  List<Product> get products => _products;
  Future<void> fetchProductsbypage(BuildContext context) async {
    try {
      final response =
          await client.get(Uri.parse('$baseUrl?offset=$_offset&limit=$_limit'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          _hasMore = false;
        } else {
          _products = data
              .map((productData) => Product(
                    id: productData['id'],
                    title: productData['title'],
                    price: productData['price'].toDouble(),
                    description: productData['description'],
                    category: Categoryy(
                      id: productData['category']['id'],
                      name: productData['category']['name'],
                      image: productData['category']['image'],
                    ),
                    images: List<String>.from(productData['images']),
                  ))
              .toList();

          category_demo.addAll(data
              .map((productData) => Categoryy(
                    id: productData['category']['id'],
                    name: productData['category']['name'],
                    image: productData['category']['image'],
                  ))
              .toList());
          category_demo = removeDuplicates(category_demo);
        }
        isloading = false;
        notifyListeners();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${error.toString()}'),
        ),
      );
      rethrow;
    }
  }

  List<Categoryy> removeDuplicates(List<Categoryy> categories) {
    // Create a set to store unique categories.
    Set<Categoryy> uniqueCategories = {};

    // Create a new list for the result.
    List<Categoryy> result = [];

    // Iterate through the original list.
    for (var category in categories) {
      // If the category is not in the set of unique categories, add it to the result list.
      if (!uniqueCategories.contains(category)) {
        uniqueCategories.add(category);
        result.add(category);
      }
    }

    return result;
  }

  Future<void> fetchNextPage(BuildContext context) async {
    if (_hasMore) {
      _offset += _limit;

      await fetchProductsbypage(context);
    }
  }

  Future<void> fetchPreviousPage(BuildContext context) async {
    if (_hasMore) {
      _offset -= _limit;

      await fetchProductsbypage(context);
    }
  }

  Future<void> fetchProductsbycategory(
      BuildContext context, String name) async {
    try {
      final response = await client.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final filteredData = data
            .where((productData) => productData['category']['name'] == name)
            .toList();

        catproducts = filteredData.map((productData) {
          return Product(
            id: productData['id'],
            title: productData['title'],
            price: productData['price'].toDouble(),
            description: productData['description'],
            category: Categoryy(
              id: productData['category']['id'],
              name: productData['category']['name'],
              image: productData['category']['image'],
            ),
            images: List<String>.from(productData['images']),
          );
        }).toList();
        catisloading = false;
        notifyListeners();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${error.toString()}'),
        ),
      );
      rethrow;
    }
  }

  Future<void> fetchProducts(BuildContext context) async {
    try {
      final response = await client.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _products = data
            .map((productData) => Product(
                  id: productData['id'],
                  title: productData['title'],
                  price: productData['price'].toDouble(),
                  description: productData['description'],
                  category: Categoryy(
                    id: productData['category']['id'],
                    name: productData['category']['name'],
                    image: productData['category']['image'],
                  ),
                  images: List<String>.from(productData['images']),
                ))
            .toList();
        isloading = false;
        notifyListeners();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${error.toString()}'),
        ),
      );
      rethrow;
    }
  }

  Future<Product> getProductById(BuildContext context, int id) async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Product(
          id: data['id'],
          title: data['title'],
          price: data['price'].toDouble(),
          description: data['description'],
          category: Categoryy(
            id: data['category']['id'],
            name: data['category']['name'],
            image: data['category']['image'],
          ),
          images: List<String>.from(data['images']),
        );
      } else {
        throw Exception('Failed to load product');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${error.toString()}'),
        ),
      );
      rethrow;
    }
  }

  Future<Product> createProduct({
    required String title,
    required double price,
    required String description,
    required int categoryId,
    required List<String> images,
  }) async {
    final Map<String, dynamic> body = {
      'title': title,
      'price': price,
      'description': description,
      'categoryId': categoryId,
      'images': images,
    };

    try {
      final response = await client.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Product(
          id: data['id'],
          title: data['title'],
          price: data['price'].toDouble(),
          description: data['description'],
          category: Categoryy(
            id: data['category']['id'],
            name: data['category']['name'],
            image: data['category']['image'],
          ),
          images: List<String>.from(data['images']),
        );
      } else {
        throw Exception('Failed to create product');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Product> updateProduct(
    int id, {
    String? title,
    double? price,
  }) async {
    final Map<String, dynamic> body = {};

    if (title != null) body['title'] = title;
    if (price != null) body['price'] = price;

    try {
      final response = await client.put(
        Uri.parse('$baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Product(
          id: data['id'],
          title: data['title'],
          price: data['price'].toDouble(),
          description: data['description'],
          category: Categoryy(
            id: data['category']['id'],
            name: data['category']['name'],
            image: data['category']['image'],
          ),
          images: List<String>.from(data['images']),
        );
      } else {
        throw Exception('Failed to update product');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> deleteProduct(BuildContext context, int id) async {
    try {
      final response = await client.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${error.toString()}'),
        ),
      );
      rethrow;
    }
  }
}
