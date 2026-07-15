import 'package:flutter/material.dart';


class PrivacyPolicyScreen extends StatelessWidget{
const PrivacyPolicyScreen({super.key});

@override
  Widget build(BuildContext context) {
  return Scaffold(
appBar: AppBar(

title: const Text("Privacy Policy")

),


body : const SingleChildScrollView(
  padding: EdgeInsets.all(16),
  child: Text('''    
  Expense Tracker Pro Respect Your Privacy,

  All Expenses data,Income information, and settings are Stored 
  locally on your device.

  We do not Sell or share your personal data with any 3 parties.

  Futuure Version May include Advertisements and premium features
  
  Last Updated june 2026
     ''',),
),

);
  }




}