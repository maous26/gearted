import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock conversation data
    final conversations = [
      {
        'name': 'Alexandre Martin',
        'lastMessage': 'Salut, est-ce que la gearbox est toujours disponible ?',
        'timestamp': '14:30',
        'unreadCount': 2,
        'isOnline': true,
        'avatar': 'A',
      },
      {
        'name': 'Sophie Dubois',
        'lastMessage': 'Parfait ! Je prends le RDS. On peut se voir demain ?',
        'timestamp': '12:15',
        'unreadCount': 0,
        'isOnline': false,
        'avatar': 'S',
      },
      {
        'name': 'Lucas Bernard',
        'lastMessage': 'Merci pour la transaction rapide 👍',
        'timestamp': 'Hier',
        'unreadCount': 0,
        'isOnline': true,
        'avatar': 'L',
      },
      {
        'name': 'Marine Leroy',
        'lastMessage': 'Tu as d\'autres photos du gilet tactique ?',
        'timestamp': 'Mar',
        'unreadCount': 1,
        'isOnline': false,
        'avatar': 'M',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search in conversations
            },
          ),
        ],
      ),
      body: conversations.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aucun message pour le moment',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Vos conversations apparaîtront ici',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                return _buildConversationTile(context, conversation);
              },
            ),
    );
  }

  Widget _buildConversationTile(
      BuildContext context, Map<String, dynamic> conversation) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.blue.shade100,
            child: Text(
              conversation['avatar'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
          ),
          if (conversation['isOnline'])
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              conversation['name'],
              style: TextStyle(
                fontWeight: conversation['unreadCount'] > 0
                    ? FontWeight.bold
                    : FontWeight.w500,
              ),
            ),
          ),
          Text(
            conversation['timestamp'],
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                conversation['lastMessage'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: conversation['unreadCount'] > 0
                      ? Colors.black87
                      : Colors.grey.shade600,
                  fontWeight: conversation['unreadCount'] > 0
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
              ),
            ),
            if (conversation['unreadCount'] > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${conversation['unreadCount']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
      onTap: () {
        // Navigate to individual chat conversation
        context.push(
            '/chat/${conversation['name'].replaceAll(' ', '_')}/${conversation['name']}/${conversation['avatar']}');
      },
    );
  }
}
