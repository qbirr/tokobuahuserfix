class CartItem {
  final String productId;
  final double price;
  int quantity;

  CartItem({
    required this.productId,
    required this.price,
    required this.quantity,
  });

  @override
  String toString() {
    return 'CartItem{productId: $productId, price: $price, quantity: $quantity}';
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'],
      price: map['price'].toDouble(),
      quantity: map['quantity'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'price': price,
      'quantity': quantity,
    };
  }
}
