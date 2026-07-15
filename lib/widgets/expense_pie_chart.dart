import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpensePieChart extends StatelessWidget {
  final double food;
  final double travel;
  final double shopping;
  final double bill;
  final double other;
  final String selectedCurrency;
  final bool isDarkMode;


  const ExpensePieChart({
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
    final double total =
        food + travel + shopping + bill + other;

    if (total == 0) {
      return const SizedBox(
        height: 320,
        child: Center(
          child: Text(
            "No Expense Data Yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 320,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  centerSpaceRadius: 110,
                  sectionsSpace: 4,
                  pieTouchData: PieTouchData(
                    enabled: true,
                  ),
                  
                  sections: [
                    PieChartSectionData(
                      
                      value: food,
                      color: Colors.green,
                      radius: 60,
                      title:                   
                      (food/total*100)< 2 ? "": "${(food/total*100).toStringAsFixed(0)}%",
                    

                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),



                    PieChartSectionData(
                      value: travel,
                      color: const Color.fromARGB(255, 3, 32, 245),
                      radius: 60,
                      title:
                      (travel/total*100)<2 ? "": "${(travel/total*100).toStringAsFixed(0)}%",

                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),

                    PieChartSectionData(
                      value: shopping,
                      color: Colors.red,
                      radius: 60,
                      title:
                      (shopping/total*100)<2 ? "": "${(shopping/total*100).toStringAsFixed(0)}%",


                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),

                    PieChartSectionData(
                      value: bill,
                      color: const Color.fromARGB(255, 249, 249, 1),
                      radius: 60,
                      title:
                      (bill/total*100)<2 ? "": "${(bill/total*100).toStringAsFixed(0)}%",

                      titleStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),

                    PieChartSectionData(
                      value: other,
                      color: const Color.fromARGB(255, 239, 3, 223),
                      radius: 60,
                      title:
                      (other/total*100)<2 ? "": "${(other/total*100).toStringAsFixed(0)}%",

                      titleStyle: TextStyle(
                      color: isDarkMode? Color.fromARGB(255, 249, 249, 249):Colors.black,
                        
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // Center Total
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 15,
                      color: isDarkMode? Color.fromARGB(255, 249, 249, 249):Colors.black,
                    ),
                  ),

                  Text(
                    "$selectedCurrency ${NumberFormat('#,##,##0').format(total)}",
                    style:  TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode? Colors.white:Colors.black,
                      

                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Legend
     
      ],
    );
  }

  
  }
