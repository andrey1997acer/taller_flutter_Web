import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tienda/models/product_model.dart';
import 'package:tienda/repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  ProductBloc(this.productRepository) : super(ProductState());

  @override
  Stream<ProductState> mapEventToState(
    ProductEvent event,
  ) async* {
    if (event is GetProductsWithOffsetAndLimit) {
      yield* _getProductsWithOffsetAndLimit(event.limmit, event.offset);
    }
    if (event is GetProductById) {
      yield* _getProductById(event.id);
    }
    if (event is GetProducts) {
      yield* _getProducts();
    }

    if (event is ProductIntoCart) {
      yield* _productIntoCart(event.productModel);
    }

    if (event is NextOffset) {
      yield state.copyWith(limmit: state.limmit + 6, offset: state.offset + 6);

      yield* _getProductsWithOffsetAndLimit(state.limmit, state.offset);
    }

    if (event is PreviousOffset) {
      yield state.copyWith(limmit: state.limmit - 6, offset: state.offset - 6);
      yield* _getProductsWithOffsetAndLimit(state.limmit, state.offset);
    }
  }

  Stream<ProductState> _getProducts() async* {
    try {
      await Future.delayed(Duration(seconds: 3));
      final products = productRepository.getProducts();

      yield state.copyWith(products: products, state: STATE.data);
    } catch (e) {
      yield state.copyWith(state: STATE.error);
    }
  }

  Stream<ProductState> _getProductsWithOffsetAndLimit(
      int limmit, int offset) async* {
    try {
      yield state.copyWith(state: STATE.loading);
      await Future.delayed(Duration(milliseconds: 500));

      final count = productRepository.countProducts();
      final products =
          productRepository.getProductsWithLimitAndOffset(offset, limmit);

      yield state.copyWith(products: products, state: STATE.data, stock: count);
    } catch (e) {
      yield state.copyWith(state: STATE.error);
    }
  }

  Stream<ProductState> _getProductById(int id) async* {
    final product = productRepository.getProductById(id);

    yield state.copyWith(product: product, state: STATE.data);
  }

  Stream<ProductState> _productIntoCart(ProductModel productModel) async* {
    final products = state.products;
    try {
      products!.forEach((element) {
        if (element.id == productModel.id) {
          element.intoCart = true;
        }
      });
    } catch (e) {}
    yield state.copyWith(products: products, state: STATE.data);
  }
}
