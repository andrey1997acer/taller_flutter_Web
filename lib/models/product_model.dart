class ProductModel {
  final int? id;
  final String? name;
  final String? image;
  final int? price;
  final int? stock;
  bool? intoCart;

  set setIntoCart(bool value) => this.intoCart = value;
  set getintoCart(bool value) => this.intoCart = value;

  ProductModel({
    this.id,
    this.name,
    this.image,
    this.price,
    this.stock,
    this.intoCart = false,
  });
}
