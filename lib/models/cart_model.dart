import 'package:tienda/models/product_model.dart';

class CartModel {
  final ProductModel product;
  late int quantity;

  CartModel(this.product, {this.quantity = 1});
}
