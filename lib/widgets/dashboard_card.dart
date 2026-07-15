import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardCard extends StatelessWidget{
final String currency;
final double totalExpense;
final double monthlyIncome;
final double remainingBalance;
final bool isDarkMode;

const DashboardCard({
super.key,

required this.currency,
required this.totalExpense,
required this.monthlyIncome,
required this.remainingBalance,
required this.isDarkMode,
});
@override
  Widget build (BuildContext context) {
   Color remainingColor=Colors.green;
if(remainingBalance<=monthlyIncome*0.2){
remainingColor=const Color.fromARGB(255, 245, 2, 2);
}
else if(remainingBalance<=monthlyIncome*0.5){
  remainingColor=const Color.fromARGB(255, 247, 137, 2);
}


  return Wrap(

spacing: 10,
runSpacing: 10,
children: [
SizedBox(
width: MediaQuery.of(context).size.width*0.42,

child: Card(
elevation: 8,
color: isDarkMode? Colors.grey[900]:const Color.fromARGB(255, 196, 236, 239),



child: Padding(padding: EdgeInsets.all(12),

child: Column(

children: [
Icon(Icons.money_off,
color:isDarkMode ? const Color.fromARGB(255, 248, 246, 246):const Color.fromARGB(255, 47, 2, 248),),
SizedBox(height: 8),
Text("Total Spend",
style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color:isDarkMode? Colors.white:Colors.black,
  
  
  ),
),
Text(
"$currency ${NumberFormat('#,##,##0.00','en_In').format(totalExpense)}",

style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18,
color: isDarkMode?const Color.fromARGB(255, 245, 244, 243):const Color.fromARGB(255, 0, 0, 247),
  
  
  ),

  
),
],

),

),

),
),

SizedBox(
width: MediaQuery.of(context).size.width*0.42,
child: Card(
elevation: 8,  
color: isDarkMode? Colors.grey[900]:const Color.fromARGB(249, 224, 242, 224),

child: Padding(padding: EdgeInsets.all(12),
child: Column(
children: [
Icon(Icons.account_balance,color:isDarkMode ? const Color.fromARGB(255, 3, 250, 11):const Color.fromARGB(255, 19, 238, 4),),
SizedBox(height: 8),
Text("Income",
style:TextStyle(color:isDarkMode? const Color.fromARGB(255, 251, 251, 251):const Color.fromARGB(255, 0, 0, 0),)
),
Text(
"$currency ${NumberFormat('#,##,##0.00','en_In').format(monthlyIncome)}",
   
  style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color:isDarkMode? const Color.fromARGB(255, 3, 250, 52):const Color.fromARGB(255, 0, 240, 0),),
),
],

),

),

),
),



SizedBox(
  
width: MediaQuery.of(context).size.width*0.42,

child: Card(
elevation: 8,
color: isDarkMode? Colors.grey[900]:const Color.fromARGB(255, 248, 236, 236),

child: Padding(padding: EdgeInsets.all(12),
child: Column(
children: [
Icon(Icons.savings,
color:isDarkMode ? const Color.fromARGB(255, 248, 3, 3):const Color.fromARGB(255, 247, 59, 2),
),
SizedBox(height: 8),

Text("Remaining",
style:TextStyle(color:isDarkMode ? Colors.white:Colors.black,)
),
Text(
"$currency ${NumberFormat('#,##,##0.00','en_In').format(remainingBalance)}",
  
  style:TextStyle(fontWeight: FontWeight.bold,color: remainingColor,fontSize: 18,),
),
],

),

),

),
),


],

   );


  }
}



