import 'package:ecommerceapp/view/category_page.dart';
import 'package:ecommerceapp/view/productpage.dart';
import 'package:ecommerceapp/widgets/panigation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../controllers/productprovider.dart';

import '../widgets/productgrid.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false)
        .fetchProductsbypage(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ecommerce App'),
        actions: const [
          CircleAvatar(
            backgroundImage:
                NetworkImage('https://picsum.photos/id/1021/400/300'),
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productprovider, child) => productprovider.isloading
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
                                    Object exception, StackTrace? stackTrace) {
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
                  SizedBox(
                    height:
                        150.0, // Set the desired height for the horizontal list
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: productprovider.category_demo.length,
                      itemBuilder: (context, index) {
                        final category = productprovider.category_demo[index];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CategoryPage(category: category),
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  onBackgroundImageError: (Object exception,
                                      StackTrace? stackTrace) {},
                                  radius:
                                      35.0, // Set the desired radius for the avatar
                                  backgroundImage: NetworkImage(category.image),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                category.name,
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
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
                      itemCount: productprovider.products.length,
                      itemBuilder: (context, index) {
                        final product = productprovider.products[index];
                        return productgriditem(product: product);
                      },
                    ),
                  ),
                  buildPaginationWidget(productprovider, context),
                ],
              ),
      ),
    );
  }
}
