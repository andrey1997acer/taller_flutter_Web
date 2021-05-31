part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

class IncrementStock extends CartEvent {
  final int id;

  IncrementStock(this.id);
}

class DecrementStock extends CartEvent {
  final int id;

  DecrementStock(this.id);
}

class AddProductToCart extends CartEvent {
  final ProductModel productModel;

  AddProductToCart(this.productModel);
}

class CalculateSubtotal extends CartEvent {}

class CalculateTotal extends CartEvent {}
