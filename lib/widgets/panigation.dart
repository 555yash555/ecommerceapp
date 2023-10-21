import 'package:flutter/material.dart';

import '../controllers/productprovider.dart';

Widget buildPaginationWidget(
    ProductProvider productProvider, BuildContext context) {
  final currentPage = (productProvider.offset) ~/ 10;

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      if (productProvider.offset >= 10)
        ElevatedButton(
          onPressed: () {
            productProvider.fetchPreviousPage(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
      const SizedBox(width: 20),
      Text(
        '$currentPage',
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
      ),
      const SizedBox(width: 20),
      ElevatedButton(
        onPressed: () {
          productProvider.fetchNextPage(context);
        },
        child: const Icon(Icons.arrow_forward),
      ),
    ],
  );
}
