import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget{
final bool isDarkMode;
const AboutScreen({super.key,
required this.isDarkMode,
});
@override
  Widget
   build(BuildContext context) {

return Scaffold(
  backgroundColor: isDarkMode ? Colors.black : Colors.white,

  appBar: AppBar(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    title: const Text("About"),
  ),

  body: Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Expense Tracker 2.0",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            "Track Your Money And MANAGE It",
            style: TextStyle(
              color: isDarkMode
                  ? Colors.white
                  : const Color.fromARGB(255, 234, 18, 2),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            "Made with Love by Rajat",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDarkMode
                  ? Colors.white
                  : const Color.fromARGB(255, 251, 4, 86),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "Version 1.0.0",
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.grey,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            "THANK YOU FOR USING APP",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode
                  ? Colors.white
                  : const Color.fromARGB(255, 249, 2, 241),
            ),
          ),
        ],
      ),
    ),
  ),
);
   }
}