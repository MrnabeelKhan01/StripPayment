import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class StripPaymentIntegration extends StatefulWidget {
   const StripPaymentIntegration({Key? key}) : super(key: key);

  @override
  State<StripPaymentIntegration> createState() => _StripPaymentIntegrationState();
}

class _StripPaymentIntegrationState extends State<StripPaymentIntegration> {
Map<String,dynamic>?paymentIntent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      body:Column(
        mainAxisAlignment:MainAxisAlignment.center,
        children: [
        Row(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){
              makePayment();
            }, child:const Text("Perform Transactions")),
          ],
        )
      ],),
    );
  }

Future<void> makePayment() async {
  try {
    paymentIntent = await createPaymentIntent('5', 'USD');
    //Payment Sheet
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent!['client_secret'],
            style: ThemeMode.light,
            merchantDisplayName: 'Ali')).then((value){
    });


    ///now finally display payment sheet
    displayPaymentSheet();
  } catch (e, s) {
    print('exception:$e$s');
  }
}

displayPaymentSheet() async {

  try {
    await Stripe.instance.presentPaymentSheet(
    ).then((value){
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.green,),
                    Text("Payment Successful"),
                  ],
                ),
              ],
            ),
          ));
      paymentIntent = null;

    }).onError((error, stackTrace){
      print('Error is:--->$error $stackTrace');
    });


  } on StripeException catch (e) {
    print('Error is:---> $e');
    showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text("Cancelled "),
        ));
  } catch (e) {
    print('$e');
  }
}

//  Future<Map<String, dynamic>>
createPaymentIntent(String amount, String currency) async {
  try {
    Map<String, dynamic> body = {
      'amount': calculateAmount(amount),
      'currency': currency,
      'payment_method_types[]': 'card'
    };

    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization': 'Bearer sk_test_51MCg8GE7LRc7dfcRj7fxG0go5RWlpm4LBChq0XJd4lEgarpIn90Hr7TsSDMXLRolcOhSYLfoopsyJWun9vgOwtnO00RLJx3NoZ',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body,
    );
    // ignore: avoid_print
    print('Payment Intent Body->>> ${response.body.toString()}');
    return jsonDecode(response.body);
  } catch (err) {
    // ignore: avoid_print
    print('err charging user: ${err.toString()}');
  }
}

calculateAmount(String amount) {
  final calculatedAmount = (int.parse(amount)) * 224 ;
  return calculatedAmount.toString();
}
}
