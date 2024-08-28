import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    super.key,
    required this.title,
    required this.body,
    required this.time,
    required this.iconPath
  });
  final String title;
  final String body;
  final String time;
  final String iconPath;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 1.0),
        )
      ),
      child: Row(
        children: [
          Center(
            child: Expanded(
              flex: 2,
              child: Image.asset(iconPath,
              fit: BoxFit.cover,
              width: 30,
              height: 30,
              )
            ),
          ),
          const SizedBox(width: 10,),
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                      ),
                    ),
                    Text(time,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10,
                ),
                Text(body,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey
                  ),
                )
              ],
            ) 
          )
        ],
      ),
    );
  }
}