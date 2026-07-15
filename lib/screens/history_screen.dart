import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  final List expenses;
  final String currency;
  final Function(int) onDelete;
  final Function(int) onEdit;
  final String selectedCategory;
  final bool isDarkMode;

  const HistoryScreen({
    super.key,
    required this.expenses,
    required this.currency,
    required this.onDelete,
    required this.onEdit,
    required this.selectedCategory,
    required this.isDarkMode,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String selectedCategory = "All";
  String searchText = "";
  DateTime? selectedDate;

  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDarkMode;

    final Color backgroundColor =
        isDark ? Colors.black : Colors.white;
    final Color cardColor =
        isDark ? Colors.grey.shade900 : Colors.white;
    final Color textColor =
        isDark ? Colors.white : Colors.black;
    final Color hintColor =
        isDark ? Colors.white70 : Colors.black54;

    final filteredExpenses = widget.expenses.where((expense) {
      final expenseDate =
          DateFormat('dd-MM-yyyy').format(expense.dateTime);

      final matchesSearch =
          expense.category
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              expenseDate.contains(searchText);

      final matchesCategory = selectedCategory == "All"
          ? true
          : expense.category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                filled: true,
                fillColor: cardColor,
                hintText: "Search category or date",
                hintStyle: TextStyle(color: hintColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: textColor,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Calendar Picker
                    IconButton(
                      icon: Icon(
                        Icons.calendar_month,
                        color: textColor,
                      ),
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                            searchController.text =
                                DateFormat('dd-MM-yyyy')
                                    .format(pickedDate);
                            searchText = searchController.text;
                          });
                        }
                      },
                    ),

                    // Clear Search
                    IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: textColor,
                      ),
                      onPressed: () {
                        setState(() {
                          searchController.clear();
                          searchText = "";
                          selectedDate = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),

          // Category Dropdown
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: DropdownButton<String>(
                value: selectedCategory,
                isExpanded: true,
                dropdownColor: cardColor,
                underline: const SizedBox(),
                iconEnabledColor: textColor,
                style: TextStyle(color: textColor),
                items: [
                  "All",
                  "Food",
                  "Travel",
                  "Shopping",
                  "Bill",
                  "Other",
                ].map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(color: textColor),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Empty State
          if (filteredExpenses.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.receipt_long,
                      size: 80,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No Spending Yet",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Add Your First Expense",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: filteredExpenses.length,
                itemBuilder: (context, index) {
                  final expense = filteredExpenses[index];

                  IconData categoryIcon = Icons.category;
                  Color categoryColor = Colors.pink;

                  switch (expense.category) {
                    case "Food":
                      categoryIcon = Icons.fastfood;
                      categoryColor = const Color.fromARGB(255, 30, 163, 3);
                      break;

                    case "Travel":
                      categoryIcon = Icons.flight;
                      categoryColor = const Color.fromARGB(255, 18, 0, 212);
                      break;

                    case "Shopping":
                      categoryIcon = Icons.shopping_bag;
                      categoryColor = const Color.fromARGB(255, 254, 91, 3);
                      break;

                    case "Bill":
                      categoryIcon = Icons.receipt_long;
                      categoryColor = const Color.fromARGB(255, 4, 248, 244);
                      break;
                  }

                  return Card(
                    color: cardColor,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            categoryColor.withAlpha(19),
                        child: Icon(
                          categoryIcon,
                          color: categoryColor,
                        ),
                      ),
                      title: Text(
                        expense.category,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: categoryColor,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat(
                          'dd-MM-yyyy hh:mm a',
                        ).format(expense.dateTime),
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${widget.currency} ${expense.amount}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: categoryColor,
                            ),
                          ),

                          // Edit
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              final originalIndex =
                                  widget.expenses
                                      .indexOf(expense);

                              widget.onEdit(
                                originalIndex,
                              );
                            },
                          ),

                          // Delete
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor:
                                        cardColor,
                                    title: Text(
                                      "Delete Expense",
                                      style: TextStyle(
                                        color: textColor,
                                      ),
                                    ),
                                    content: Text(
                                      "Are you sure you want to delete this expense?",
                                      style: TextStyle(
                                        color: textColor,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(
                                                context),
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                            color:
                                                textColor,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          final originalIndex =
                                              widget
                                                  .expenses
                                                  .indexOf(
                                                      expense);

                                          widget.onDelete(
                                            originalIndex,
                                          );

                                          Navigator.pop(
                                              context);
                                        },
                                        child: const Text(
                                          "Delete",
                                          style:
                                              TextStyle(
                                            color:
                                                Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}