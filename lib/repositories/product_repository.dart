import 'package:tienda/models/product_model.dart';
import 'package:tienda/repositories/db/product.dart';

class ProductRepository {
  final List<ProductModel> products = productsDB;

  List<ProductModel> getProducts() {
    return products;
  }

  List<ProductModel> getProductsWithLimitAndOffset(int offset, int limmit) {
    final List<ProductModel> newProducts = products.sublist(offset, limmit);
    return newProducts;
  }

  ProductModel getProductById(int id) {
    return products.firstWhere((element) => element.id == id);
  }

  int countProducts() {
    return products.length;
  }
}
