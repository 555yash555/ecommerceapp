import 'package:ecommerceapp/controllers/productprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements Client {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('ProductProvider', () {
    late ProductProvider provider;
    late MockClient client;

    setUp(() {
      client = MockClient();
      provider = ProductProvider(client: client);
    });

    test('fetchProducts should update products list', () async {
      final mockContext = MockBuildContext();
      when(client.get(Uri.parse('https://api.escuelajs.co/api/v1/products')))
          .thenAnswer((_) async => Response('''
          [
            {
              "id": 1,
              "title": "Product 1",
              "price": 10.0,
              "description": "Description for Product 1",
              "category": {
                "id": 1,
                "name": "Category 1",
                "image": "https://picsum.photos/id/1018/400/300"
              },
              "images": ["https://picsum.photos/id/1018/400/300"]
            },
            {
              "id": 2,
              "title": "Product 2",
              "price": 20.0,
              "description": "Description for Product 2",
              "category": {
                "id": 2,
                "name": "Category 2",
                "image": "https://picsum.photos/id/1015/400/300"
              },
              "images": ["https://picsum.photos/id/1015/400/300"]
            }
          ]
        ''', 200));

      // Act
      await provider.fetchProducts(mockContext);

      // Assert
      expect(provider.products.length, 2);
      expect(provider.products[0].id, 1);
      expect(provider.products[0].title, 'Product 1');
      expect(provider.products[0].price, 10.0);
      expect(provider.products[0].description, 'Description for Product 1');
      expect(provider.products[0].category.id, 1);
      expect(provider.products[0].category.name, 'Category 1');
      expect(provider.products[0].category.image,
          'https://picsum.photos/id/1018/400/300');
      expect(provider.products[0].images.length, 1);
      expect(provider.products[0].images[0],
          'https://picsum.photos/id/1018/400/300');
      expect(provider.products[1].id, 2);
      expect(provider.products[1].title, 'Product 2');
      expect(provider.products[1].price, 20.0);
      expect(provider.products[1].description, 'Description for Product 2');
      expect(provider.products[1].category.id, 2);
      expect(provider.products[1].category.name, 'Category 2');
      expect(provider.products[1].category.image,
          'https://picsum.photos/id/1015/400/300');
      expect(provider.products[1].images.length, 1);
      expect(provider.products[1].images[0],
          'https://picsum.photos/id/1015/400/300');
    });

    test('getProductById should return a product', () async {
      final mockContext = MockBuildContext();
      // Arrange
      when(client.get(Uri.parse('${provider.baseUrl}/1')))
          .thenAnswer((_) async => Response('''
          {
            "id": 1,
            "title": "Product 1",
            "price": 10.0,
            "description": "Description for Product 1",
            "category": {
              "id": 1,
              "name": "Category 1",
              "image": "https://picsum.photos/id/1018/400/300"
            },
            "images": ["https://picsum.photos/id/1018/400/300"]
          }
        ''', 200));

      // Act
      final product = await provider.getProductById(mockContext, 1);

      // Assert
      expect(product.id, 1);
      expect(product.title, 'Product 1');
      expect(product.price, 10.0);
      expect(product.description, 'Description for Product 1');
      expect(product.category.id, 1);
      expect(product.category.name, 'Category 1');
      expect(product.category.image, 'https://picsum.photos/id/1018/400/300');
      expect(product.images.length, 1);
      expect(product.images[0], 'https://picsum.photos/id/1018/400/300');
    });

    test('createProduct should create a product', () async {
      // Arrange
      when(client.post(
        Uri.parse(provider.baseUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => Response('''
          {
            "id": 1,
            "title": "Product 1",
            "price": 10.0,
            "description": "Description for Product 1",
            "category": {
              "id": 1,
              "name": "Category 1",
              "image": "https://picsum.photos/id/1018/400/300"
            },
            "images": ["https://picsum.photos/id/1018/400/300"]
          }
        ''', 201));

      // Act
      final product = await provider.createProduct(
        title: 'Product 1',
        price: 10.0,
        description: 'Description for Product 1',
        categoryId: 1,
        images: ['https://picsum.photos/id/1018/400/300'],
      );

      // Assert
      expect(product.id, 1);
      expect(product.title, 'Product 1');
      expect(product.price, 10.0);
      expect(product.description, 'Description for Product 1');
      expect(product.category.id, 1);
      expect(product.category.name, 'Category 1');
      expect(product.category.image, 'https://picsum.photos/id/1018/400/300');
      expect(product.images.length, 1);
      expect(product.images[0], 'https://picsum.photos/id/1018/400/300');
    });

    test('updateProduct should update a product', () async {
      // Arrange
      when(client.put(
        Uri.parse('${provider.baseUrl}/1'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => Response('''
          {
            "id": 1,
            "title": "Product 1 Updated",
            "price": 20.0,
            "description": "Description for Product 1 Updated",
            "category": {
              "id": 1,
              "name": "Category 1",
              "image": "https://picsum.photos/id/1018/400/300"
            },
            "images": ["https://picsum.photos/id/1018/400/300"]
          }
        ''', 200));

      // Act
      final product = await provider.updateProduct(
        1,
        title: 'Product 1 Updated',
        price: 20.0,
      );

      // Assert
      expect(product.id, 1);
      expect(product.title, 'Product 1 Updated');
      expect(product.price, 20.0);
      expect(product.description, 'Description for Product 1 Updated');
      expect(product.category.id, 1);
      expect(product.category.name, 'Category 1');
      expect(product.category.image, 'https://picsum.photos/id/1018/400/300');
      expect(product.images.length, 1);
      expect(product.images[0], 'https://picsum.photos/id/1018/400/300');
    });

    test('deleteProduct should delete a product', () async {
      final mockContext = MockBuildContext();
      // Arrange
      when(client.delete(Uri.parse('${provider.baseUrl}/1')))
          .thenAnswer((_) async => Response('', 200));

      // Act
      final result = await provider.deleteProduct(mockContext, 1);

      // Assert
      expect(result, true);
    });
  });
}
