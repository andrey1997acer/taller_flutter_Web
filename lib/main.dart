import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tienda/blocs/cart/bloc/cart_bloc.dart';
import 'package:tienda/blocs/product/bloc/product_bloc.dart';
import 'package:tienda/blocs/user/bloc/user_bloc.dart';
import 'package:tienda/pages/home_page.dart';
import 'package:tienda/pages/login.dart';
import 'package:tienda/repositories/product_repository.dart';
import 'package:tienda/repositories/user_repository.dart';

void main() => runApp(GetProviders());

class GetProviders extends StatelessWidget {
  const GetProviders({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
            create: (context) => ProductBloc(new ProductRepository())
              ..add(GetProductsWithOffsetAndLimit(offset: 0, limmit: 6))),
        BlocProvider<CartBloc>(create: (context) => CartBloc()),
        BlocProvider<UserBloc>(
            create: (context) => UserBloc(new UserRepository())),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tienda in Flutter',
      // home: LoginPage(),
      initialRoute: '/',
      routes: {
        '/home': (context) => HomePage(),
        '/': (context) => LoginPage(),
      },
    );
  }
}
