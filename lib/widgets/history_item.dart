import 'package:flutter/material.dart';
import '../models/expense.dart';

class HistoryItem extends StatelessWidget {

  

final Expense expense;
final String currency;

const HistoryItem({
super.key,
required this.expense,
required this.currency,
});

@override
Widget build(BuildContext context){

return Card(
  child: ListTile(
title: Text("$currency ${expense.amount} - ${expense.category}",),
subtitle: Text(expense.dateTime.toString(),),

  ),

);












}

}