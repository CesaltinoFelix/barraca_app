class Product {
  String? id;
  final String name;
  final String description;
  final double price;
  final String img;
  String? createdAt;
  String? updatedAt;

  Product(
      {this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.img,
      this.createdAt,
      this.updatedAt});
}
