import 'package:flutter/material.dart';
import 'package:order/core/theming/styles.dart';
import 'package:order/core/widgets/app_bar_widget.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        pageName: 'About Us',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Welcome Text with Decoration
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: <Color>[Colors.blue, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'Welcome to Our App!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Summary Header with Decoration
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: <Color>[Colors.blue, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Summary', style: TextStyles.font22WhiteBold),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Our app is designed to streamline the food ordering process at work, \nmaking it more efficient and convenient. With features like real-time updates, notifications, and a user-friendly interface, we aim to enhance your ordering experience and save you time.',
              style: TextStyles.font18DarkBlueBold,
            ),
            const SizedBox(height: 24),
            // Version Header with Decoration
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: <Color>[Colors.blue, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Version', style: TextStyles.font22WhiteBold),
              ),
            ),
            const SizedBox(height: 8),
            const Text('1.0.1', // Replace with your actual app version
                style: TextStyles.font18DarkBlueBold),
            const SizedBox(height: 24),
            // Contact Us Text
            const Text(
              'Contact Us:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'If you have any questions or feedback, please reach out to us at support@yourapp.com.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add action for button press if needed
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Learn More'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
