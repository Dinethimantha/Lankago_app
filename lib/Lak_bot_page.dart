import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lanka_go/constance/colors.dart';

class LakBot extends StatefulWidget {
  const LakBot({super.key});

  @override
  State<LakBot> createState() => _LakBotState();
}

class _LakBotState extends State<LakBot> {
  final TextEditingController _userMessage = TextEditingController();

  // Your Groq API Key
  static const String apiKey =
      "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";

  final List<Message> _messages = [];
  bool isLoading = false;

  Future<void> sendMessage() async {
    final message = _userMessage.text.trim();

    if (message.isEmpty) return;

    _userMessage.clear();

    setState(() {
      _messages.add(
        Message(isUser: true, message: message, date: DateTime.now()),
      );
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("https://api.groq.com/openai/v1/chat/completions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "llama-3.3-70b-versatile",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are LAKBOT, a helpful tourism assistant for Sri Lanka. "
                  "Reply briefly, clearly, politely, and in an attractive user-friendly way. "
                  "Only in the first chat, greet the user with 'Ayubowan 🙏' at the beginning. "
                  "After the first message, do not repeat the greeting unless the conversation restarts. "
                  "Provide useful travel tips, local recommendations, and friendly assistance for tourists in Sri Lanka.",
            },
            {"role": "user", "content": message},
          ],
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final botReply =
            data["choices"][0]["message"]["content"] ?? "No response";

        setState(() {
          _messages.add(
            Message(isUser: false, message: botReply, date: DateTime.now()),
          );
        });
      } else {
        setState(() {
          _messages.add(
            Message(
              isUser: false,
              message: "Error: ${response.statusCode}",
              date: DateTime.now(),
            ),
          );
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(
          Message(
            isUser: false,
            message: "Something went wrong: $e",
            date: DateTime.now(),
          ),
        );
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _userMessage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(140, 147, 0, 161),
                Color.fromARGB(163, 24, 35, 157),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.asset(
                  "assets/lakbot.jpg",
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text("LAKBOT", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];

                return Messages(
                  isUser: message.isUser,
                  message: message.message,
                  date: DateFormat('HH:mm').format(message.date),
                );
              },
            ),
          ),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),

          Padding(
            padding: const EdgeInsets.fromLTRB(10, 6, 10, 25),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _userMessage,
                    decoration: InputDecoration(
                      hintText: "Ask LAKBOT...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [kpurple, kblue]),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;

  const Messages({
    super.key,
    required this.isUser,
    required this.message,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
        left: isUser ? 80 : 10,
        right: isUser ? 10 : 80,
      ),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: isUser
            ? const LinearGradient(
                colors: [kpurple, kblue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(colors: [Colors.grey.shade300, kTextGray]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              color: isUser ? Colors.white : Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            date,
            style: TextStyle(
              fontSize: 12,
              color: isUser ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  Message({required this.isUser, required this.message, required this.date});
}
