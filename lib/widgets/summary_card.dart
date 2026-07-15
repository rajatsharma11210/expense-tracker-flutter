import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {

final String title;
final double amount;
final IconData icon;
final Color iconColor;
final bool isDarkMode;

const SummaryCard({
super.key,
required this.title,
required this.amount,
required this.icon,
required this.iconColor,
required this.isDarkMode,
});

@override
Widget build(BuildContext context){
return
 SizedBox(

width: MediaQuery.of(context).size.width*0.43,
child:Card(
elevation: 4,

color: isDarkMode? Colors.grey[900]:Colors.white,

shape:RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(16),
),

  child: ListTile(
leading: Icon(icon,size:28,color: iconColor,),
title: Text
(title,
style:TextStyle(fontWeight: FontWeight.bold,

color: isDarkMode? Colors.white:Colors.black,



),),
subtitle: Text(amount.toStringAsFixed(2),
style:TextStyle(
color: isDarkMode? Colors.white70:Colors.black45,


),

),


  ),


),



);




}
}