part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class GetProducts extends ProductEvent {}

class GetProductsWithOffsetAndLimit extends ProductEvent {
  final int offset;
  final int limmit;

  GetProductsWithOffsetAndLimit({this.offset = 0, this.limmit = 5});
}

class GetProductById extends ProductEvent {
  final int id;
  GetProductById({this.id = 0});
}

class ProductIntoCart extends ProductEvent {
  final ProductModel productModel;

  ProductIntoCart(this.productModel);
}

class NextOffset extends ProductEvent {}

class PreviousOffset extends ProductEvent {}
