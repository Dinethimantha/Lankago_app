import 'package:flutter/material.dart';
import 'footer.dart'; // ✅ Import your custom footer

class SuggestionsPage extends StatefulWidget {
  const SuggestionsPage({super.key});

  @override
  State<SuggestionsPage> createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'ai',
      'text':
          "Hi there! 👋 I'm your AI travel assistant. I can help you find hotels, restaurants, activities, and more. What are you looking for?",
      'time': 'Just now',
    },
    {
      'sender': 'user',
      'text': 'Find hotels in Kandy under \$30',
      'time': '2:34 PM',
    },
    {
      'sender': 'ai',
      'text':
          "I found 3 budget-friendly hotels in Kandy under \$30:\n• Kandy City Hotel \$25/night ⭐4.2\n• Mountain View Inn \$28/night ⭐4.6\nView all hotels →",
      'time': '2:34 PM',
    },
    {
      'sender': 'user',
      'text': 'Where can I rent a bike near Ella?',
      'time': '2:35 PM',
    },
    {
      'sender': 'ai',
      'text':
          "Here are the best bike rental places near Ella:\n• Ella Adventure Bikes \$8/day • 0.2 km away\n• Mountain Cycle Rental \$10/day • 0.5 km away",
      'time': '2:38 PM',
    },
  ];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        'sender': 'user',
        'text': _controller.text,
        'time': 'Now',
      });
      _messages.add({
        'sender': 'ai',
        'text': "AI response for: ${_controller.text}",
        'time': 'Now',
      });
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        iconTheme: const IconThemeData(color: Colors.brown),
        title: const Text(
          'LAK BOT ASSISTANT 🤖',
          style: TextStyle(color: Colors.brown),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                bool isUser = message['sender'] == 'user';
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: isUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.yellow[700] : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          message['text'],
                          style: TextStyle(
                            color: isUser ? Colors.brown : Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message['time'],
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ✅ Message Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.yellow[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.brown),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),

      // ✅ Custom Footer
      bottomNavigationBar: const Footer(selectedIndex: 0),
    );
  }
}
