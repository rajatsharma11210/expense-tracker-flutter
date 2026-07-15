import 'package:flutter/material.dart';



class OnboardingScreen extends StatelessWidget{
final VoidCallback onFinish;



const OnboardingScreen ({super.key,
required this.onFinish, 
});

@override
  Widget build(BuildContext context) {

return Scaffold( 
  body:SafeArea(child: Padding(padding: const EdgeInsets.all(24),
child:Column(mainAxisAlignment: MainAxisAlignment.center,
children: [



Image.asset(
  'lib/assets/icon.png',
  width:120,
  height:120,

),

const SizedBox(height: 30),
const Text("Welcome To Money Tracker",textAlign: TextAlign.center,
style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color:Color.fromARGB(255, 3, 245, 11,),),

),
const SizedBox(height: 20),
const Text ("Track Your Money and Daily Expenses With Expense Tracker ",textAlign: TextAlign.center,),

const SizedBox(height: 40),

SizedBox(width:double.infinity,
child:ElevatedButton(onPressed: (){
  onFinish();

},
child: const Text("Next"),
),),

],
),



),),


);

  }

}