import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class EmptyChatStateWidget extends StatelessWidget {
  const EmptyChatStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.message_question_copy,
            size: size.width * 0.2,
            color: Colors.grey,
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            'How can we help you today?',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: size.width * 0.045,
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  group('Chat Empty State Test (No Mocking)', () {
    
    testWidgets('Should display the "How can we help you today?" message and question icon', (WidgetTester tester) async {
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyChatStateWidget(), 
          ),
        ),
      );

      
      expect(find.text('How can we help you today?'), findsOneWidget); 
      
      expect(find.byIcon(Iconsax.message_question_copy), findsOneWidget); 
    
    });
  });
}