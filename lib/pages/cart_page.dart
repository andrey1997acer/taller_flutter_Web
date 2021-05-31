import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/blocs/cart/bloc/cart_bloc.dart';
import 'package:tienda/models/cart_model.dart';

class ProductCartListTile extends StatefulWidget {
  final CartModel? cart;
  final BuildContext? parentContext;

  const ProductCartListTile(
      {Key? key, @required this.cart, @required this.parentContext})
      : super(key: key);

  @override
  _ProductCartListTileState createState() => _ProductCartListTileState();
}

class _ProductCartListTileState extends State<ProductCartListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image(
        width: 50,
        height: 50,
        image: NetworkImage(widget.cart!.product.image!),
      ),
      title: Text(widget.cart!.product.name!),
      subtitle: Text('\$ ${widget.cart!.product.price!}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              if (widget.cart!.quantity > 1) {
                BlocProvider.of<CartBloc>(widget.parentContext!)
                    .add(DecrementStock(widget.cart!.product.id!));
              }
            },
          ),
          Text(
            '${widget.cart!.quantity}',
            style: Theme.of(context).textTheme.headline6,
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              if (widget.cart!.quantity > 0) {
                BlocProvider.of<CartBloc>(widget.parentContext!)
                    .add(IncrementStock(widget.cart!.product.id!));
              }
            },
          )
        ],
      ),
    );
  }
}
