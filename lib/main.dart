import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/expense.dart';
import 'widgets/summary_card.dart';
import 'widgets/dashboard_card.dart';
import 'widgets/history_item.dart';
import 'screens/settings_screen.dart';
import 'screens/history_screen.dart';
import 'screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/about_screen.dart';
import 'screens/chart_screen.dart';
import 'package:flutter/services.dart';
import 'utils/budget_alerts.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,]);

  await Hive.initFlutter();
  await Hive.openBox('expenses');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
const MyApp({super.key});

@override
State<MyApp> createState()=> _MyAppState();
}


class _MyAppState extends State<MyApp>{
String formatAmount(double amount){
return NumberFormat('#,##,##0.00','en_IN').format(amount);

}

final TextEditingController amountController=TextEditingController(); 
final TextEditingController categoryController=TextEditingController();  //amountcontrolleer
final TextEditingController incomeController=TextEditingController();


Future<void> saveCurrency()async{
final prefs =await SharedPreferences.getInstance();
await prefs.setString('currency' ,selectedCurrrency);

}
Future<void> loadCurrency()async{
final prefs =await SharedPreferences.getInstance();
setState(() {
  selectedCurrrency=prefs.getString('currency') ?? '₹';

});
}

Future<void> saveIncome()async{
final prefs =await SharedPreferences.getInstance();
await prefs.setDouble('monthlyIncome' ,monthlyIncome);

}

Future<void> loadIncome()async{
final prefs =await SharedPreferences.getInstance();

setState(() {
  monthlyIncome=prefs.getDouble('monthlyIncome') ?? 0;
});

remainingBalance=monthlyIncome-totalExpense;
}

Future<void> saveExpenses()async{
final box=Hive.box('expenses');
await box.put(
  'expenseList',
  expenses.map((e)=> e.toJson()).toList(),
);
}

Future<void> loadExpense()async{
final box =Hive.box('expenses');
final data =box.get('expenseList');

if(data!=null){

  expenses=(data as List).map((e) => 
  Expense.fromJson(Map<String, dynamic>.from(e))).toList();

recalculateTotals();
}
}


Future<void> initData() async {
  await loadIncome();
  await loadExpense();
  setState(() {
    recalculateTotals();
  });
}

Color getBudgetColor(){
if(budgetPercentage>=1.0){
  return Colors.red;
}
else if(budgetPercentage>=0.9){
  return Colors.orange;
}

else{
  return const Color.fromARGB(255, 3, 251, 11);
}
}

String getBudgetMessage(){
if(monthlyIncome<=0){
  return "set Income";
}
if(budgetPercentage>=1.0){
  return " Budget Excedded";
}
if(budgetPercentage>=0.9){
  return " Budget 90% used ";
}
if(budgetPercentage>=0.7){
  return " 70% Budget Excedded";
}
else{
return "Budget Healthy";
}
}

IconData getBudgetIcon(){
if(budgetPercentage>=1.0){
  return Icons.crisis_alert;
}
else if(budgetPercentage>=0.9){
  return Icons.warning_amber_rounded;
}
else if(budgetPercentage>=0.7){
  return Icons.info_outline;
}
else{
  return Icons.check_circle;
}
}



void recalculateTotals(){
totalExpense=0;
foodTotal=0;
billTotal=0;
travelTotal=0;
shoppingTotal=0;
otherTotal=0;
for(var expense in expenses){
 totalExpense+=expense.amount;
if(expense.category =="Food"){
  foodTotal+=expense.amount;
}
else if(expense.category =="Bill"){
  billTotal+=expense.amount;
}
 else if(expense.category =="Travel"){
  travelTotal+=expense.amount;
}
else if(expense.category =="Shopping"){
  shoppingTotal+=expense.amount;
}
else{
  otherTotal += expense.amount;
}
}

remainingBalance =monthlyIncome-totalExpense;


if(monthlyIncome>0){
  budgetPercentage=totalExpense / monthlyIncome;
}
else{
  budgetPercentage=0;
}



}

@override
void initState(){
  super.initState();
  loadCurrency();
  initData();
  }

List <Expense> expenses=[]; //heart of history system
double totalExpense=0;
int? editingIndex;
String ?selectedCategory;
double foodTotal=0;
double travelTotal=0;
double shoppingTotal =0;
double billTotal=0;
Set<int> alertedThresholds = {};
bool showHistory=true;
bool showSummary=true;
bool isDarkMode=false;
String selectedCurrrency="₹"; 
double monthlyIncome=0;
double remainingBalance=0;
int selectedIndex=0;
double otherTotal=0;
bool showOnboarding=true;
String selectedHistoryCategory ="All";
double budgetPercentage =0;



  @override
  Widget build(BuildContext context){
return MaterialApp(
debugShowCheckedModeBanner:false,

home:showOnboarding ? //change
 OnboardingScreen(
  onFinish: () {

setState(() {
  showOnboarding=false;
});


  },
 ):
Builder
(
  builder:(context) =>Scaffold(
  backgroundColor: isDarkMode? Colors.black26:Colors.white,
  appBar: AppBar(title:const Text("Expense Tracker"),
  backgroundColor:isDarkMode? Colors.grey.shade900:Colors.blue,centerTitle:true,
  foregroundColor: Colors.white,),

drawer: Drawer(
  backgroundColor: isDarkMode ? Colors.grey.shade900:Colors.white,
  child:ListView(
    
    children: [
      DrawerHeader(
decoration: BoxDecoration(color:Colors.blue),
 
child:Column(
crossAxisAlignment: CrossAxisAlignment.start,

children: [


Icon(
Icons.account_box,
size:60,
color:Colors.white,
),



SizedBox(height: 15,),
Text("Expense Tracker Pro",style: TextStyle(
  color:Color.fromARGB(255, 50, 248, 0),fontSize:24,fontWeight: FontWeight.bold,
) , ),

Text ("Track Every Spending",style: TextStyle(color:Color.fromARGB(255, 251, 249, 249),
fontSize: 16,fontWeight: FontWeight.bold),

)
],

),

      ),
// charts and pdf icon
      ListTile(
  leading :  Icon(Icons.bar_chart,
color:isDarkMode ? const Color.fromARGB(255, 3, 244, 19):const Color.fromARGB(255, 6, 6, 6)
  
  ),



  title: Text("Chart",
  style: TextStyle(color: isDarkMode ? const Color.fromARGB(255, 3, 240, 19):Colors.black,),
  
  ),
  onTap :()  {
Navigator.push(
context,
MaterialPageRoute(builder: (context) => ChartScreen(food: foodTotal
, travel: travelTotal, shopping: shoppingTotal, bill: billTotal, other: otherTotal,selectedCurrency: selectedCurrrency,
isDarkMode: isDarkMode,
),),

);

  },
  ),

ListTile(
  leading: Icon(Icons.picture_as_pdf,color:isDarkMode ? const Color.fromARGB(255, 5, 245, 13) :Colors.black,),
  title: Text("PDF",
  style: TextStyle(color: isDarkMode ? const Color.fromARGB(255, 3, 233, 76):Colors.black,),
  ),
  onTap:(){
showDialog(context: context, builder: (_) => AlertDialog(
title: const Text("PDF"),
content: const Text("Comin Soon , STAY TUNED!"),
actions: [
  TextButton(onPressed:
  () => Navigator.pop(context),
  child: const Text("Ok"),
  
  ),
],



));


  } ,
  ), //end
const Divider(),
ListTile(
leading: Icon(Icons.dark_mode,color:isDarkMode? Colors.white:Colors.black),
title: Text("Dark Mode",
  style: TextStyle(color: isDarkMode ? Colors.white:Colors.black,),
),
onTap:(){
setState(() {
  isDarkMode=!isDarkMode;
 
});
},

),

ListTile(
  leading:  Icon(Icons.star_rate,color:isDarkMode? Colors.amber:Colors.black,),
  title:Text("Rate App",
  style: TextStyle(color: isDarkMode ? Colors.white:Colors.black,),
  ),
  onTap:(){
showDialog(context: context, builder: (_) => AlertDialog(
title: const Text("Rate App"),
content: const Text("Comin Soon"),
actions: [
  TextButton(onPressed:
  () => Navigator.pop(context),
  child: const Text("Ok"),
  
  
  ),
],

));

  },
  ),

  ListTile(
leading: const Icon(Icons.workspace_premium,color:Color.fromARGB(255, 249, 187, 3)),
title: Text("Go Pro",
  style: TextStyle(color: isDarkMode ? Colors.white:Colors.black,),
),
onTap:(){
showDialog(context: context, builder: (_) => AlertDialog(
title: const Text("Go Pro"),
content: const Text("Comin Soon...\n"
"Remove ADS..\n"
"Adavanced Feature\n"
"Full Support"
),
actions: [
  TextButton(onPressed:
  () => Navigator.pop(context),
  child: const Text("Ok"),
    
  ),
],

));

},
  ),

  //setting
ListTile(
leading: Icon(Icons.settings,
color:isDarkMode ? Colors.greenAccent: Color.fromARGB(255, 3, 3, 3)

),
title: Text("Setting",
  style: TextStyle(color: isDarkMode ? Colors.white:Colors.black,),
),

onTap: () {
Navigator.push(context,MaterialPageRoute(builder: (_) => SettingsScreen(
  selectedCurrency:  selectedCurrrency,
  monthlyIncome: monthlyIncome,
  isDarkMode: isDarkMode,
  onIncomeChanged: (income) async{
setState(() {
  monthlyIncome=income;
  recalculateTotals();

});
await saveIncome();
  },
onCurrencyChanged: (currency) async{
setState(() {
  selectedCurrrency=currency;
});

await saveCurrency();
}


  )
  ),
);
}
),


  const Divider(),
  ListTile(
leading: Icon(Icons.info,color:isDarkMode? const Color.fromARGB(255, 250, 249, 249):Colors.black,),
title: Text("About",
  style: TextStyle(color: isDarkMode ? Colors.white:Colors.black,),
),
onTap:(){
  
Navigator.push(
context,MaterialPageRoute(builder: (context) =>  AboutScreen(

  isDarkMode:isDarkMode,
),

),


);

},

  ),
const SizedBox(height:20),
const Center(child: Text(
  "Version 1.0.0",
  style:TextStyle(color:Colors.grey),),),
],),
),


body:selectedIndex==0

? SingleChildScrollView(
child:Padding (
  padding:const EdgeInsets.all(16),
child:Column(
children:[

if(showHistory)


Container(

width: double.infinity,
margin: const EdgeInsets.symmetric(vertical: 10),
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(color: const Color.fromARGB(255, 104, 23, 244),
borderRadius: BorderRadius.circular(20),),
child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [

   Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    const Text("Total Balance",style: TextStyle(color: Color.fromARGB(252, 255, 255, 255),fontSize: 16),),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(getBudgetIcon(), color: getBudgetColor(), size: 18),
          const SizedBox(width: 6),
          Text(
            "${(budgetPercentage * 100).toStringAsFixed(0)}%",
            style: TextStyle(color: getBudgetColor(), fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    ),
  ],
),

const SizedBox(height: 8),
Text("$selectedCurrrency ${formatAmount(totalExpense)}",
style: const TextStyle(color:Colors.white,fontSize: 32,fontWeight: FontWeight.bold,),

),


const SizedBox(height: 8),
LinearProgressIndicator(
value: budgetPercentage.clamp(0.0, 1.0),
minHeight: 8,
borderRadius:BorderRadius.only(),
color: getBudgetColor(),

),
const SizedBox(height: 6),
Text(
  "${(budgetPercentage * 100).toStringAsFixed(0)}% Used",
  style: const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  ),

),

  ],



),

),

if(showSummary)

Wrap(
  spacing:8,
  runSpacing: 8,
  children: [

SummaryCard(
  
  title:"Food",

amount: foodTotal,
icon:Icons.fastfood,
iconColor: Colors.deepOrange,
isDarkMode: isDarkMode,
),

SummaryCard(
  title:"Travel",
amount: travelTotal,
icon:Icons.flight,
iconColor: const Color.fromARGB(255, 204, 240, 3),
isDarkMode: isDarkMode,


),

SummaryCard(
  title:"Shopping",
amount: shoppingTotal,
icon:Icons.shopping_bag,
iconColor: const Color.fromARGB(255, 1, 241, 25),
isDarkMode: isDarkMode,



),

SummaryCard(
  title:"Bill",
amount: billTotal,
icon:Icons.receipt,
iconColor: const Color.fromARGB(255, 31, 3, 247),
isDarkMode: isDarkMode,


),

SummaryCard(
  title:"Other",
amount: otherTotal,
icon:Icons.category,
iconColor: const Color.fromARGB(255, 249, 2, 175),
isDarkMode: isDarkMode,


),

],),



const SizedBox(height:15),

Container(
padding: const EdgeInsets.symmetric(horizontal: 12),
decoration: BoxDecoration(color: isDarkMode? Colors.grey.shade900:Colors.white,
borderRadius: BorderRadius.circular(8),
border: Border.all(color: isDarkMode? Colors.white24:Colors.grey,),
),

child:DropdownButton<String>(
value:[
"Food",
"Travel",
"Shopping",
"Bill",
"Other",

].contains(selectedCategory) ?
selectedCategory:null,
hint:Text("select Category",
style: TextStyle(color:isDarkMode?const Color.fromARGB(255, 249, 249, 249):Colors.black54,),
),
menuMaxHeight: 250,
dropdownColor: isDarkMode? Colors.grey.shade900:const Color.fromARGB(255, 95, 235, 235),
style: TextStyle(
color:isDarkMode? const Color.fromARGB(255, 255, 255, 255):Colors.black,

),

isExpanded:true,
underline: const SizedBox(),
items:  [

  

DropdownMenuItem(value:"Food",child:Text("Food", 
style:TextStyle(color:isDarkMode ?const Color.fromARGB(255, 245, 244, 244):Colors.black,),
),

),
DropdownMenuItem(value:"Travel",child:Text("Travel"),),
DropdownMenuItem(value:"Shopping",child:Text("Shopping"),),
DropdownMenuItem(value:"Bill",child:Text("Bill"),),
DropdownMenuItem(value:"Other",child:Text("Other"),),
],
onChanged: (value){
setState((){
selectedCategory=value!;


}
);
saveCurrency();
},

),
),


if(selectedCategory=="Other")
TextField(
style:TextStyle(color:isDarkMode? Colors.white:Colors.black),
  controller:categoryController,
  decoration:const InputDecoration(
    labelText: "Custom Category",
  ) ,

),



const SizedBox(height: 20),


DashboardCard(

currency:selectedCurrrency,
totalExpense: totalExpense,
monthlyIncome: monthlyIncome,
remainingBalance: remainingBalance,
isDarkMode: isDarkMode,
),
const SizedBox(height: 20),

TextField(
style:TextStyle(color:isDarkMode? Colors.white:Colors.black,),

controller:amountController,

keyboardType: TextInputType.number,
decoration: InputDecoration(
  focusColor: Colors.amber,
labelText:"Amount",
labelStyle: TextStyle(color:isDarkMode? Colors.white:Colors.black),

prefixIcon: Icon(Icons.wallet,color: isDarkMode? Colors.white:Color.fromARGB(255, 10, 2, 249)),

border:OutlineInputBorder(),

),
),

//buttonn

const SizedBox(height: 15),

ElevatedButton(
  style:ElevatedButton.styleFrom(
    elevation: 8,
backgroundColor:const Color.fromARGB(255, 2, 241, 10),
foregroundColor:Colors.black87,
minimumSize: const Size(double.infinity,40),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
  ),
  onPressed:() async {
if(monthlyIncome<=0){
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text("PLEASE ADD Valid MONTHLY/SPENDING Income First From SETTING",),
  duration: Duration(seconds: 2),backgroundColor: Colors.red,),
snackBarAnimationStyle: AnimationStyle(),

);
return;
}



double enteredAmount=double.parse(amountController.text);

if(enteredAmount <=0){
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text("PLEASE ADD Valid Amount",),
  duration: Duration(seconds: 2),backgroundColor: Colors.red,),
snackBarAnimationStyle: AnimationStyle(),

);
return;
}

String finalCategory=selectedCategory ?? "";



if(selectedCategory=="Other"){
if(categoryController.text.trim().isEmpty) {
finalCategory="Other";
}
else{

  finalCategory=categoryController.text.trim();
}



}
setState ((){
recalculateTotals();


  if(editingIndex == null){

    if (selectedCategory == null || selectedCategory!.isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        "PLEASE SELECT CATEGORY",
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red,
    ),
  );
  return;
}

expenses.insert(0,

Expense(

  amount: enteredAmount,dateTime:DateTime.now(),


category:finalCategory,
),);

  totalExpense += enteredAmount; 
  if(finalCategory=="Food"){
  foodTotal+=enteredAmount;
}
else if(finalCategory=="Travel"){
  travelTotal+=enteredAmount;
}
else if(finalCategory=="Shopping"){
  shoppingTotal+=enteredAmount;
}
else if(finalCategory=="Bill"){
  billTotal+=enteredAmount;
}

else {
  otherTotal+=enteredAmount;
}
  
/////////////
remainingBalance = monthlyIncome-totalExpense;
if(monthlyIncome>0){
  budgetPercentage=totalExpense / monthlyIncome;
}
else{
  budgetPercentage=0;
}
}//null

else{
String oldCategory = expenses[editingIndex!].category;
double oldAmount = expenses[editingIndex!].amount;

if(oldCategory=="Food"){
foodTotal-=oldAmount;
}
else if(oldCategory=="Travel"){
travelTotal-=oldAmount;
}
else if(oldCategory=="Shopping"){
shoppingTotal-=oldAmount;
}
else if(oldCategory=="Bill"){
billTotal-=oldAmount;
}
else{
  otherTotal-=oldAmount;
}
if(finalCategory=="Food"){
  foodTotal+=enteredAmount;
}
else if(finalCategory=="Travel"){
  travelTotal+=enteredAmount;
}
else if(finalCategory=="Shopping"){
  shoppingTotal+=enteredAmount;
}
else if(finalCategory=="Bill"){
  billTotal+=enteredAmount;
}

else {
  otherTotal+=enteredAmount;
}

totalExpense =totalExpense - oldAmount + enteredAmount;
remainingBalance = monthlyIncome-totalExpense;
if(monthlyIncome>0){
  budgetPercentage=totalExpense / monthlyIncome;
}
else{
  budgetPercentage=0;
}

expenses[editingIndex!]=Expense(amount:enteredAmount,dateTime: DateTime.now(),
category:finalCategory,

);

editingIndex =null;
}
}
);  


checkBudgetAlerts(              // <-- moved here, now runs AFTER totals update
  context,
  budgetPercentage: budgetPercentage,
  alertedThresholds: alertedThresholds,
  isDarkMode: isDarkMode,
);
amountController.clear();
print(expenses);
await saveExpenses();

  },
  
child: const Text("Add Expense", style:TextStyle (fontSize: 20,fontWeight: FontWeight.bold,),),
),

//RESET BUTTON
Align(
  alignment: Alignment.centerRight,
  child: TextButton(
    onPressed: () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            "This Will Reset All Your Data Permanently",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  expenses.clear();
                  totalExpense = 0;
                  editingIndex = null;
                  amountController.clear();
                  foodTotal = 0;
                  billTotal = 0;
                  shoppingTotal = 0;
                  travelTotal = 0;
                otherTotal=0;
                budgetPercentage=0;

               
                  remainingBalance = monthlyIncome;
                });
                   await saveExpenses();

                Navigator.pop(context);
              },
              child: const Text(
                "Reset ALL",
                style: TextStyle(
                  
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 14, 1, 247),
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      );
    },
    child: const Text(
      "Reset ALL",
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: Color.fromARGB(255, 1, 133, 241),
        fontSize: 18,
      ),
    ),
  ),
),


ElevatedButton(
onPressed: (){
setState(() {
  showSummary=!showSummary;
});
},

child: Text(showSummary? "Hide Summar": "Show Summary",
style: TextStyle(color:Color.fromARGB(255, 249, 5, 188,)),
),
),

],
),   
)
) 
 :HistoryScreen(
expenses:expenses,
currency: selectedCurrrency,
selectedCategory: selectedHistoryCategory,
isDarkMode: isDarkMode,
onDelete: (index) async {
setState((){
final expense =expenses[index];
final deletedAmount=expense.amount;
if(expense.category=="Food"){
  foodTotal-= deletedAmount;
}
else if(expense.category=="Travel"){
  travelTotal-=deletedAmount;
}
else if(expense.category=="Shopping"){
shoppingTotal-=deletedAmount;
}
else if(expense.category=="Bill"){
billTotal-=deletedAmount;
}
else {
otherTotal-=deletedAmount;
}

totalExpense -= deletedAmount;
remainingBalance=monthlyIncome-totalExpense;
if(monthlyIncome>0){
  budgetPercentage=totalExpense / monthlyIncome;
}
else{
  budgetPercentage=0;
}
if(totalExpense.abs()<0.01) totalExpense=0;
if(foodTotal.abs()<0.01) foodTotal=0;
if(travelTotal.abs()<0.01) travelTotal=0;
if(shoppingTotal.abs()<0.01) shoppingTotal=0;
if(billTotal.abs()<0.01) billTotal=0;
if(otherTotal.abs()<0.01) otherTotal=0;


expenses.removeAt(index);

checkBudgetAlerts(                    // <-- ADD THIS
  context,
  budgetPercentage: budgetPercentage,
  alertedThresholds: alertedThresholds,
  isDarkMode: isDarkMode,
);

});
await saveExpenses();

},
onEdit: (index){
setState(() {
  
  amountController.text=expenses[index].amount.toString();

String category =expenses[index].category;
if(category=="Food"||
category=="Travel"|| 
category=="Shopping"|| 
category=="Bill"
)
{
selectedCategory=category;
categoryController.clear();
}
else{
selectedCategory="Other";
categoryController.text=category;

}
  editingIndex = index;
  selectedIndex=0;

});

}

 ),

bottomNavigationBar: BottomNavigationBar(currentIndex: selectedIndex,
onTap: (index){
setState(() {
  selectedIndex=index;
});
},
items:[
BottomNavigationBarItem(icon: Icon(Icons.home,),
label :"HOME",

),
BottomNavigationBarItem(icon: Icon(Icons.history),
label:"History",
),
] ,
),

)),
);
  }
}