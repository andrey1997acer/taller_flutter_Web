part of 'product_bloc.dart';

@immutable
class ProductState {
  final List<ProductModel>? products;
  final ProductModel? product;
  final STATE state;
  final int limmit;
  final int offset;
  final int stock;

  ProductState(
      {this.products,
      this.product,
      this.state = STATE.initial,
      this.limmit = 6,
      this.offset = 0,
      this.stock = 0});

  ProductState copyWith({
    List<ProductModel>? products,
    ProductModel? product,
    STATE? state,
    int? limmit,
    int? offset,
    int? stock,
  }) =>
      ProductState(
        products: products ?? this.products,
        product: product ?? this.product,
        state: state ?? this.state,
        limmit: limmit ?? this.limmit,
        offset: offset ?? this.offset,
        stock: stock ?? this.stock,
      );
}

enum STATE { initial, loading, error, data }
