import 'package:flutter/material.dart';
import '../widgets/expense_pie_chart.dart';

class ChartScreen extends StatelessWidget {
  final double food;
  final double travel;
  final double shopping;
  final double bill;
  final double other;
  final String selectedCurrency;
  final bool isDarkMode;

  const ChartScreen({
    super.key,
    required this.food,
    required this.travel,
    required this.shopping,
    required this.bill,
    required this.other,
    required this.selectedCurrency,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasExpenses =
        food + travel + shopping + bill + other > 0;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          "Expense Analysis",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
      ),
      body: hasExpenses
          ? SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    kToolbarHeight -
                    MediaQuery.of(context).padding.top,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ExpensePieChart(
                        food: food,
                        travel: travel,
                        shopping: shopping,
                        bill: bill,
                        other: other,
                        selectedCurrency: selectedCurrency,
                        isDarkMode: isDarkMode,
                        
                      ),

                      const SizedBox(height: 25),

                      _legendItem(
                        "Food",
                        Colors.green,
                        isDarkMode,
                      ),

                      const SizedBox(height: 10),

                      _legendItem(
                        "Travel",
                        const Color.fromARGB(255, 0, 25, 247),
                        isDarkMode,
                      ),

                      const SizedBox(height: 10),

                      _legendItem(
                        "Shopping",
                        const Color.fromARGB(255, 250, 1, 1),
                        isDarkMode,
                      ),

                      const SizedBox(height: 10),

                      _legendItem(
                        "Bill",
                        const Color.fromARGB(255, 246, 250, 1),
                        isDarkMode,
                      ),

                      const SizedBox(height: 10),_legendItem(
                        "Other",
                        const Color.fromARGB(255, 247, 2, 206),
                        isDarkMode,
                      ),

                      
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.receipt_long,
                    size: 80,
                    color: Color.fromARGB(255, 241, 2, 2),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No Expense Added",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color:
                          isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Add Your First Expense",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 111, 110, 110),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _legendItem(
    String title,
    Color color,
    bool isDarkMode,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color:
                isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}