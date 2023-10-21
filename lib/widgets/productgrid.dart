import 'package:flutter/material.dart';

import '../models/productmodel.dart';
import '../view/productpage.dart';

class productgriditem extends StatelessWidget {
  const productgriditem({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductPage(product: product),
          ),
        );
      },
      child: Card(
        elevation: 4, // Add shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              child: Image(
                image: NetworkImage(product.images[0]),
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Text('Image not available');
                },
                fit: BoxFit.cover,
              ),
            ),
            Flexible(
              child: FittedBox(
                child: Text(
                  product.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Add a Spacer to create space between the two Text widgets.
            const Spacer(),
            Flexible(
              child: FittedBox(
                child: Text(
                  '\$${product.price}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
