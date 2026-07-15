class Expense{
double amount=0;
 DateTime dateTime;
String category;
Expense({
required this.amount,
required this.dateTime,
required this.category,
});
Map<String, dynamic> toJson(){
return{
'amount':amount,
'dateTime':dateTime.toIso8601String(),
'category':category,

};

}

factory Expense.fromJson(Map<dynamic,dynamic> json){
return Expense(
amount: json['amount'],
dateTime: DateTime.parse(json['dateTime']),
category: json['category'],
);

}
}