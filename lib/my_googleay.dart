import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:pay/pay.dart';


class GooglePay extends StatefulWidget {
  final total;
  const GooglePay({Key? key, this.total}) : super(key: key);

  @override
  State<GooglePay> createState() => _GooglePayState();
}

class _GooglePayState extends State<GooglePay> {
   
 
// In your Widget build() method

 
 
// In your Stateless Widget class or State
void onGooglePayResult(paymentResult) {
  // Send the resulting Google Pay token to your server or PSP
}
  @override
  Widget build(BuildContext context) {
    return GooglePayButton(
  paymentConfigurationAsset: 'sample_payment_configuration.json',
  paymentItems: [
  PaymentItem(
    label: 'Total',
    amount: widget.total,
    status: PaymentItemStatus.final_price,
  )
],
  style: GooglePayButtonStyle.black,
  type: GooglePayButtonType.pay,
  onPaymentResult: onGooglePayResult,
);
    
  }
}


 
