import 'package:flutter/material.dart';
import '../clases/user_msg_chat.dart'; // Make sure this file has User, Message, Conversation classes

class Testtlg extends StatefulWidget {
  const Testtlg({super.key});

  @override
  State<Testtlg> createState() => _TesttlgState();
}

class _TesttlgState extends State<Testtlg> {
  TextEditingController searchController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  String searchQuery = "";

  List<User> allUsers = [
    User(id: "1", name: "Amina", avatarUrl: "https://i.pravatar.cc/150?img=1"),
  
  ];

  User? selectedUser;
  List<Conversation> conversations = [];

  List<User> get filteredUsers {
    return allUsers.where((user) {
      return user.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  Conversation? getConversationForUser(String userId) {
    try {
      return conversations.firstWhere((conv) => conv.id == userId);
    } catch (_) {
      return null;
    }
  }

  void createConversationIfNotExists(User user) {
    if (getConversationForUser(user.id) == null) {
      conversations.add(
        Conversation(
          id: user.id,
          userName: user.name,
          userAvatar: user.avatarUrl,
          messages: [
          
          ],
        ),
      );
    }
  }

  void sendMessage(String text) {
    if (selectedUser == null || text.trim().isEmpty) return;

    final conversation = getConversationForUser(selectedUser!.id);
    if (conversation != null) {
      setState(() {
        conversation.messages.add(
          Message(
            text: text.trim(),
            isMe: true,
            timestamp: DateTime.now(),
          ),
        );
        messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Profile & Settings',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(title: Text('Profile')),
            ListTile(title: Text('Settings')),
            ListTile(title: Text('Logout')),
          ],
        ),
      ),
      body: Row(
        children: [
          // LEFT PANEL - User List
          Container(
            width: 300,
            color: Colors.grey[200],
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Row(
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            labelText: 'Search for user',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return ListTile(
                        title: Text(user.name),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.avatarUrl),
                        ),
                        onTap: () {
                          createConversationIfNotExists(user);
                          setState(() {
                            selectedUser = user;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // RIGHT PANEL - Chat Area
          Expanded(
            child: selectedUser == null
                ? const Center(child: Text('No conversation selected'))
                : Builder(builder: (_) {
                    final conversation = getConversationForUser(selectedUser!.id);
                    return conversation == null
                        ? const Center(child: Text('No messages yet'))
                        : Column(
                            children: [
                              // Chat header
                              Container(
                                padding: const EdgeInsets.all(16),
                                color: Colors.blue[50],
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(selectedUser!.avatarUrl),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      selectedUser!.name,
                                      style: const TextStyle(
                                          fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),

                              // Message List
                              Expanded(
                                child: ListView.builder(
                                  itemCount: conversation.messages.length,
                                  itemBuilder: (context, index) {
                                    final msg = conversation.messages[index];
                                    return Align(
                                      alignment: msg.isMe
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: msg.isMe
                                              ? Colors.blue[100]
                                              : Colors.grey[300],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(msg.text),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // Message Input Field
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: messageController,
                                        decoration: const InputDecoration(
                                          hintText: ' message',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.send),
                                      onPressed: () => sendMessage(messageController.text),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                  }),
          ),
        ],
      ),
    );
  }
}
