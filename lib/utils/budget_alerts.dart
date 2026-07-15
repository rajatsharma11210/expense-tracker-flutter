import 'package:flutter/material.dart';

void checkBudgetAlerts(
  BuildContext context, {
  required double budgetPercentage,
  required Set<int> alertedThresholds,
  required bool isDarkMode,
}) {
  final int currentPercent = (budgetPercentage * 100).floor();

  final List<Map<String, dynamic>> thresholds = [
    {"value": 50, "color": Colors.blue, "message": "50% of budget used"},
    {"value": 70, "color": Colors.orange, "message": "70% of budget used"},
    {"value": 90, "color": Colors.deepOrange, "message": "⚠ 90% of budget used"},
  ];

  for (var t in thresholds) {
    if (currentPercent >= t["value"] && !alertedThresholds.contains(t["value"])) {
      alertedThresholds.add(t["value"]);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t["message"]),
          backgroundColor: t["color"],
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // 100%+ gets a dialog instead of a snackbar
  if (currentPercent >= 100 && !alertedThresholds.contains(100)) {
    alertedThresholds.add(100);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: Icon(Icons.crisis_alert),
        title: const Text("Budget Exceeded"),
        content: const Text("You have crossed your monthly budget limit."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }
}