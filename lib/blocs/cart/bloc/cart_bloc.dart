import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tienda/models/cart_model.dart';
import 'package:tienda/models/product_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState());

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    if (event is IncrementStock) {
      yield* _incrementStock(event.id);
      this.add(CalculateSubtotal());
      this.add(CalculateTotal());
    }
    if (event is DecrementStock) {
      yield* _decrementStock(event.id);
      this.add(CalculateSubtotal());
      this.add(CalculateTotal());
    }
    if (event is AddProductToCart) {
      yield state.copyWith(
          stock: state.stock + 1,
          products: state.stock == 0
              ? [CartModel(event.productModel, quantity: 1)]
              : [
                  ...state.products!,
                  CartModel(event.productModel, quantity: 1)
                ]);
      this.add(CalculateSubtotal());
      this.add(CalculateTotal());
    }

    if (event is CalculateSubtotal) {
      yield* _calculateSubtotal();
    }
    if (event is CalculateTotal) {
      yield* _calculateTotal();
    }
  }

  Stream<CartState> _incrementStock(int id) async* {
    final currentState = state.products;
    currentState!.forEach((prod) {
      if (prod.product.id == id) {
        prod.quantity = prod.quantity + 1;
      }
    });

    yield state.copyWith(products: currentState);
  }

  Stream<CartState> _decrementStock(int id) async* {
    final currentState = state.products;
    currentState!.forEach((prod) {
      if (prod.product.id == id) {
        prod.quantity = prod.quantity - 1;
      }
    });

    yield state.copyWith(products: currentState);
  }

  Stream<CartState> _calculateSubtotal() async* {
    final int subTotal = state.products!.fold(
        0,
        (previousValue, element) =>
            (previousValue + (element.product.price! * element.quantity)));

    yield state.copyWith(subtotal: subTotal);
  }

  Stream<CartState> _calculateTotal() async* {
    final int total = state.products!.fold(0, (previousValue, element) {
      final int priceByQuantity = element.product.price! * element.quantity;
      final int priceWithIVA =
          priceByQuantity + (priceByQuantity * 0.13).ceil();
      return previousValue + priceWithIVA;
    });

    yield state.copyWith(total: total);
  }
}
