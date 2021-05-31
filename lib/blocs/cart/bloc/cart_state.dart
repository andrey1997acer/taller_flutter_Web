part of 'cart_bloc.dart';

class CartState {
  final int stock;
  final List<CartModel>? products;
  int subtotal;
  int total;

  CartState({this.stock = 0, this.products, this.subtotal = 0, this.total = 0});

  CartState copyWith(
          {int? stock, List<CartModel>? products, int? total, int? subtotal}) =>
      CartState(
        stock: stock ?? this.stock,
        products: products ?? this.products,
        total: total ?? this.total,
        subtotal: subtotal ?? this.subtotal,
      );
}
