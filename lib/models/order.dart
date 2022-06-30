class Order {
  int totalPrice;
  String address, documentId;
  bool isConfirmed;

  Order({required this.totalPrice, required this.address, required this.documentId, required this.isConfirmed});
}
