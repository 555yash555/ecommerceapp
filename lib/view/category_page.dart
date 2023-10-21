import 'package:ecommerceapp/models/category.dart';
import 'package:ecommerceapp/view/productpage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../controllers/productprovider.dart';

import '../widgets/productgrid.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatelessWidget {
  final Categoryy category;

  const CategoryPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false)
        .fetchProductsbycategory(context, category.name);
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        actions: const [
          CircleAvatar(
            backgroundImage:
                NetworkImage('https://picsum.photos/id/1021/400/300'),
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productprovider, child) =>
            productprovider.catisloading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: CarouselSlider(
                          items: productprovider.products.map((product) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductPage(product: product),
                                  ),
                                );
                              },
                              child: SizedBox(
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      16.0), // Adjust the radius as needed
                                  child: Image(
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return const Text('Image not available');
                                    },
                                    fit: BoxFit.fill,
                                    image: NetworkImage(product.images[0]),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            aspectRatio: 16 / 9,
                            autoPlay: true,
                            enlargeCenterPage: true,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            viewportFraction: 0.8,
                          ),
                        ),
                      ),
                      Text(
                        'All ${category.name} products',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3 / 4,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: productprovider.catproducts.length,
                          itemBuilder: (context, index) {
                            final product = productprovider.catproducts[index];
                            return productgriditem(product: product);
                          },
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
