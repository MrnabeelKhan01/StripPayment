import 'package:flutter/material.dart';
import 'package:strip_payment/strip_payment.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51MCg8GE7LRc7dfcRX8u4fsVRAolsIxtkqTs3VM1CFAZmExm9k7etKni6a4NJnjIJJ3g2F7f74F8S1mdq1vSesxmA00PyPMdmBA';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
     home:StripPaymentIntegration()
    );
  }
}

