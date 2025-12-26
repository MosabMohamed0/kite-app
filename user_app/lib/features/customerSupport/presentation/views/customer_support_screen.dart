import 'package:depi_app/core/utils/app_router.dart';
import 'package:flutter/material.dart';

class CustomerSupportScreen extends StatelessWidget {
  const CustomerSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leadingWidth: screenWidth * 0.25,
        leading: GestureDetector(
          child: Row(
            children: [
              SizedBox(width: screenWidth * 0.01),
              Icon(Icons.arrow_back),
              SizedBox(width: screenWidth * 0.01),
              Text('Profile', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          onTap: () {
            AppRouter.router.go(AppRouter.kProfile);
          },
        ),
        title: Text(
          'Customer Support',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Column(
          children: [
            Card(
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.03),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      child: Row(
                        spacing: 10,
                        children: [
                          Icon(Icons.chat_bubble_outline_rounded),
                          Text(
                            "Contact Methods",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      child: Card(
                        elevation: 0.5,
                        color: Theme.of(context).cardColor,
                        shadowColor: Colors.grey,
                        child: ListTile(
                          leading: Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: Text(
                            "Live Chat",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          subtitle: Text(
                            "Available 24/7",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          trailing: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            color: Theme.of(context).primaryColor,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                "Available",
                                style: TextStyle(
                                  color: Theme.of(context).cardColor,
                                  fontSize: screenWidth * 0.03,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 0.5,
                      color: Theme.of(context).cardColor,
                      shadowColor: Colors.grey,
                      child: ListTile(
                        leading: Icon(
                          Icons.local_phone_outlined,
                          color: Colors.blue,
                        ),
                        title: Text(
                          "Phone Support",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "9 AM - 9 PM",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Text(
                              "+201234567890",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                        trailing: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              "Available",
                              style: TextStyle(
                                color: Theme.of(context).cardColor,
                                fontSize: screenWidth * 0.03,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 0.5,
                      color: Theme.of(context).cardColor,
                      shadowColor: Colors.grey,
                      child: ListTile(
                        leading: Icon(
                          Icons.email_outlined,
                          color: Colors.purple[800],
                        ),
                        title: Text(
                          "Email Support",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Response within 24 hours",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Text(
                              "support@kite.com",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                        trailing: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              "Available",
                              style: TextStyle(
                                color: Theme.of(context).cardColor,
                                fontSize: screenWidth * 0.03,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Card(
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      "Quick Tips",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      leading: Text(
                        '💡',
                        style: TextStyle(fontSize: screenWidth * 0.05),
                      ),
                      title: Text(
                        "Be specific in your description",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      subtitle: Text(
                        "Include details like order number, date of issue, and error message",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                    ListTile(
                      leading: Text(
                        '📸',
                        style: TextStyle(fontSize: screenWidth * 0.05),
                      ),
                      title: Text(
                        "Attach images if possible",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      subtitle: Text(
                        "Images help us understand your issue better",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
