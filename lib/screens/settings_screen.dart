import 'package:flutter/material.dart';
import 'privacy_policy_screen.dart';

List<Map<String, String>> currencies = [
  {"symbol": "₹", "name": "India (INR)", "flag": "🇮🇳"},
  {"symbol": "\$", "name": "United States (USD)", "flag": "🇺🇸"},
  {"symbol": "€", "name": "Europe (EUR)", "flag": "🇪🇺"},
  {"symbol": "£", "name": "United Kingdom (GBP)", "flag": "🇬🇧"},
  {"symbol": "¥", "name": "Japan (JPY)", "flag": "🇯🇵"},
  {"symbol": "C\$", "name": "Canada (CAD)", "flag": "🇨🇦"},
  {"symbol": "A\$", "name": "Australia (AUD)", "flag": "🇦🇺"},
  {"symbol": "CHF", "name": "Switzerland (CHF)", "flag": "🇨🇭"},
  {"symbol": "¥", "name": "China (CNY)", "flag": "🇨🇳"},
  {"symbol": "₩", "name": "South Korea (KRW)", "flag": "🇰🇷"},
  {"symbol": "₽", "name": "Russia (RUB)", "flag": "🇷🇺"},
  {"symbol": "R\$", "name": "Brazil (BRL)", "flag": "🇧🇷"},
  {"symbol": "₺", "name": "Turkey (TRY)", "flag": "🇹🇷"},
  {"symbol": "د.إ", "name": "UAE (AED)", "flag": "🇦🇪"},
  {"symbol": "SAR", "name": "Saudi Arabia (SAR)", "flag": "🇸🇦"},
  {"symbol": "฿", "name": "Thailand (THB)", "flag": "🇹🇭"},
  {"symbol": "₫", "name": "Vietnam (VND)", "flag": "🇻🇳"},
  {"symbol": "₦", "name": "Nigeria (NGN)", "flag": "🇳🇬"},
  {"symbol": "₱", "name": "Philippines (PHP)", "flag": "🇵🇭"},
  {"symbol": "ZAR", "name": "South Africa (ZAR)", "flag": "🇿🇦"},
];

final TextEditingController incomeController = TextEditingController();

class SettingsScreen extends StatelessWidget {
  final Function(double) onIncomeChanged;
  final Function(String) onCurrencyChanged;
  final String selectedCurrency;
  final double monthlyIncome;
  final bool isDarkMode;

  const SettingsScreen({
    super.key,
    required this.onIncomeChanged,
    required this.onCurrencyChanged,
    required this.selectedCurrency,
    required this.monthlyIncome,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,

      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        title: const Text("Settings"),
      ),

      body: Card(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        margin: const EdgeInsets.all(10),

        child: Column(
          children: [

            // ================= CURRENCY =================
            ListTile(
              leading: Icon(
                Icons.currency_exchange,
                color: isDarkMode ? Colors.white : Colors.black,
              ),

              title: Text(
                "Change Currency",
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),

              subtitle: Text(
                "Current selected: $selectedCurrency",
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),

              onTap: () {
                String searchQuery = "";

                showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setStateDialog) {
                        final filtered = currencies.where((c) {
                          return c["name"]!
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase());
                        }).toList();

                        return AlertDialog(
                          backgroundColor:
                              isDarkMode ? Colors.grey[900] : Colors.white,

                          title: Text(
                            "Select Currency",
                            style: TextStyle(
                              color:
                                  isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),

                          content: SizedBox(
                            width: double.maxFinite,
                            height: 400,
                            child: Column(
                              children: [

                                // ===== SEARCH BOX =====
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: "Search currency...",
                                    prefixIcon: const Icon(Icons.search),
                                    hintStyle: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setStateDialog(() {
                                      searchQuery = value;
                                    });
                                  },
                                ),

                                const SizedBox(height: 10),

                                // ===== LIST =====
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: filtered.length,
                                    itemBuilder: (context, index) {
                                      final item = filtered[index];

                                      return ListTile(
                                        leading: Text(
                                          item["flag"]!,
                                          style: const TextStyle(fontSize: 22),
                                        ),

                                        title: Text(
                                          "${item["symbol"]} ${item["name"]}",
                                          style: TextStyle(
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),

                                        trailing:
                                            selectedCurrency ==
                                                    item["symbol"]
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Colors.green,
                                                  )
                                                : null,

                                        onTap: () {
                                          onCurrencyChanged(
                                              item["symbol"]!);
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),

            const Divider(height: 1),

            // ================= INCOME =================
            ListTile(
              leading: Icon(
                Icons.account_balance_wallet,
                color: isDarkMode ? Colors.white : Colors.black,
              ),

              title: Text(
                "Monthly Income",
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),

              subtitle: Text(
                monthlyIncome == 0
                    ? "Tap To Set Monthly Income"
                    : "$selectedCurrency ${monthlyIncome.toStringAsFixed(0)}",
                style: TextStyle(
                  color:
                      isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),

              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor:
                          isDarkMode ? Colors.grey[900] : Colors.white,

                      title: Text(
                        "Monthly Income",
                        style: TextStyle(
                          color:
                              isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),

                    content: TextField(
  controller: incomeController,
  keyboardType: TextInputType.number,
  style: TextStyle(
    color: isDarkMode ? Colors.white : Colors.black,
  ),
  cursorColor: isDarkMode ? Colors.white : Colors.black,
  decoration: InputDecoration(
    hintText: "Enter Income",
    hintStyle: TextStyle(
      color: isDarkMode
          ? Colors.white70
          : Colors.black54,
    ),
  ),
),


                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            double income = double.tryParse(
                                    incomeController.text) ??
                                0;

                            onIncomeChanged(income);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            const Divider(height: 1),

ListTile(
  leading:  Icon(Icons.privacy_tip,
                color: isDarkMode ? Colors.white : Colors.black,
  ),
  title: Text("Privacy Policy",style: TextStyle(

                color: isDarkMode ? Colors.white : Colors.black,
    
    

  ),
  ),
  trailing: const Icon(Icons.arrow_forward_ios,size: 16,),

  onTap: (){

Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
);


  },
),

          ],
        ),
      ),
    );
  }
}