class OrderModel {
  String firstName;
  String lastName;
  String mobileNo;

  String street;

  String city;

  String pinCode;


  OrderModel({
    
    required this.city,
    required this.firstName,
    
    required this.lastName,
    required this.mobileNo,
    required this.pinCode,
    required this.street,
 
  });
}