import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/zocial_icons.dart';
import 'package:tienda/blocs/cart/bloc/cart_bloc.dart';
import 'package:tienda/blocs/product/bloc/product_bloc.dart';
import 'package:tienda/blocs/user/bloc/user_bloc.dart';
import 'package:tienda/models/product_model.dart';
import 'package:tienda/pages/cart_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      return Scaffold(
        key: _scaffoldkey,
        drawer: DrawerWidget(),
        endDrawer: endDrawerWidget(state, context),
        appBar: buildAppBarWidget(state, context),
        body: ContenedorWidget(),
      );
    });
  }

  Drawer endDrawerWidget(CartState state, BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Products into cart',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
              if (state.products != null)
                Column(
                  children: [
                    for (var cart in state.products!)
                      ProductCartListTile(
                        parentContext: context,
                        cart: cart,
                      ),
                  ],
                ),
              Container(
                margin: EdgeInsets.only(top: 50),
                padding: EdgeInsets.all(20),
                height: 300,
                width: double.infinity,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(),
                    Text(
                      'Subtotal \$ ${state.subtotal}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    Text(
                      'IVA 13%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    Text('Total \$ ${state.total}',
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                    Divider(),
                    CupertinoButton.filled(onPressed: () {}, child: Text('Buy'))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBarWidget(CartState state, BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF2E3035),
      elevation: 1,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20, top: 5),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                  icon: Icon(Zocial.cart),
                  onPressed: () async {
                    if (state.stock == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Row(
                        children: [
                          Icon(
                            Icons.error,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text('This cart is empty'),
                        ],
                      )));
                    } else {
                      _scaffoldkey.currentState!.openEndDrawer();
                    }
                  }),
              Positioned(
                right: 0,
                top: 0,
                child: ClipOval(
                  child: Container(
                    padding: EdgeInsets.all(2),
                    width: '${state.stock}'.length > 1 ? 20 : 18,
                    height: '${state.stock}'.length > 1 ? 20 : 18,
                    decoration: BoxDecoration(color: Colors.red),
                    child: Text(
                      '${state.stock}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Drawer(
          child: Padding(
            padding: EdgeInsets.only(top: 50),
            child: Column(
              children: [
                Image(
                  width: 200,
                  height: 200,
                  image: NetworkImage(state.user!.url),
                ),
                SizedBox(height: 10),
                Text(
                  'Hi!',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  state.user!.name,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ContenedorWidget extends StatelessWidget {
  const ContenedorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final md = MediaQuery.of(context).size;
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state.state == STATE.loading || state.state == STATE.initial) {
          return Center(child: CupertinoActivityIndicator());
        }
        return Container(
            color: Color(0xFFF1F1F1),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              horizontal: (md.width < 900)
                  ? 10
                  : (md.width < 1600)
                      ? 20
                      : 300,
            ),
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleWidget(context),
                    Center(
                      child: Wrap(
                        children: [
                          for (var item in state.products!)
                            GestureDetector(
                              onTap: () async {
                                await showDialog(
                                    context: context,
                                    builder: (_context) {
                                      return producDetails(
                                          context, context, item);
                                    });
                              },
                              child: CardInfoProductDetails(item: item),
                            ),
                        ],
                      ),
                    ),
                    optionsPagination(state, context)
                  ],
                ),
              ),
            ));
      },
    );
  }

  Container optionsPagination(ProductState state, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 63, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
              onPressed: (0 > state.offset - 6)
                  ? null
                  : () {
                      BlocProvider.of<ProductBloc>(context)
                          .add(PreviousOffset());
                    },
              child: Text('Previous')),
          SizedBox(
            width: 10,
          ),
          ElevatedButton(
              onPressed: (state.stock <= state.offset + 6)
                  ? null
                  : () {
                      BlocProvider.of<ProductBloc>(context).add(NextOffset());
                    },
              child: Text('Next'))
        ],
      ),
    );
  }

  Text titleWidget(BuildContext context) {
    return Text(
      'PRODUCTS',
      style: Theme.of(context)
          .textTheme
          .headline4!
          .copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class CardInfoProductDetails extends StatelessWidget {
  const CardInfoProductDetails({
    Key? key,
    required this.item,
  }) : super(key: key);

  final ProductModel item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 400,
        height: 350,
        child: Card(
          elevation: 0,
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: '${item.id}',
                  child: FadeInImage(
                      repeat: ImageRepeat.noRepeat,
                      width: 400,
                      height: 200,
                      placeholder: AssetImage('assets/loader.gif'),
                      fit: BoxFit.contain,
                      image: NetworkImage(
                        '${item.image}',
                      )),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  item.name!,
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Price: '),
                    Text(
                      '\$ ${item.price!}',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: (item.intoCart!)
                      ? Bounce(
                          infinite: false,
                          child: Icon(
                            Elusive.basket,
                            color: Colors.green,
                            size: 20,
                          ),
                        )
                      : Icon(
                          Elusive.basket,
                          color: Colors.grey,
                          size: 20,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget producDetails(
    BuildContext context, BuildContext _context, ProductModel item) {
  return AlertDialog(
    title: Text('Product details'),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(),
        Hero(
          tag: '${item.id}',
          child: Image(
            image: NetworkImage('${item.image!}'),
            fit: BoxFit.cover,
            width: 200,
          ),
        ),
        Divider(),
        Text(item.name!),
        Divider(),
        Text(
          'Stock: ${item.stock!}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Divider(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Price: '),
            Text(
              '\$ ${item.price!}',
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    ),
    actions: [
      CupertinoButton(
        child: Text('Cancel'),
        onPressed: () => Navigator.pop(context),
      ),
      CupertinoButton.filled(
        child: Text('Add to cart'),
        onPressed: () async {
          Navigator.pop(context);

          await showDialog(
              context: context,
              builder: (ctx) {
                return CupertinoAlertDialog(
                  title: Text('Hi!'),
                  content: Text('Do you would like add product to cart?'),
                  actions: [
                    CupertinoActionSheetAction(
                      onPressed: () {
                        Navigator.maybePop(ctx);
                      },
                      child: Text(
                        'No',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: () {
                        BlocProvider.of<CartBloc>(context)
                            .add(AddProductToCart(item));
                        BlocProvider.of<ProductBloc>(context)
                            .add(ProductIntoCart(item));
                        Navigator.maybePop(ctx);
                      },
                      child: Text('Yes, I like'),
                    ),
                  ],
                );
              });
        },
      ),
    ],
  );
}
