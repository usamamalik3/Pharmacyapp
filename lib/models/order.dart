class OrderModel {
  String firstName;
  String lastName;
  String mobileNo;
  final List product;
  final double totalprice;
 
  String street;

  String city;

  String orderno;


  OrderModel(  {
   required this.product,
   required this.totalprice,
    required this.city,
    required this.firstName,
    
    required this.lastName,
    required this.mobileNo,
    required this.orderno,
    required this.street,
 
  });
}