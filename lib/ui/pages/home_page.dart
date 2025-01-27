import 'package:flutter/material.dart';
import 'package:flutter_base/models/response/get_user_model.dart';
import 'package:flutter_base/models/user_model.dart';

import 'package:flutter_base/network/api_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomePage extends StatefulWidget {
  final UserModel currentUser;
  const HomePage({Key? key, required this.currentUser}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  late IO.Socket socket;
  List<GetUsersModelDataPerson>? users;
  List<dynamic> messages = [];
  final TextEditingController _messageController = TextEditingController();
  GetUsersModelDataPerson? selectedUser;

  @override
  void initState() {
    super.initState();
    _apiService.setToken(widget.currentUser.data.token);
    _initSocket();
    _loadUsers();
  }

  void _initSocket() {
    socket = IO.io(
      ApiService.wsUrl,
      IO.OptionBuilder().setTransports(['websocket']).setAuth(
          {'token': widget.currentUser.data.token}).build(),
    );

    socket.onConnect((_) {
      print('WebSocket bağlantısı başarılı');
    });

    socket.on('message', (data) {
      if (mounted &&
          selectedUser != null &&
          (data['senderId'] == selectedUser!.id ||
              data['receiverId'] == selectedUser!.id)) {
        setState(() {
          messages.add(data);
        });
      }
    });

    socket.connect();
  }

  Future<void> _loadUsers() async {
    try {
      final response = await _apiService.getUsers();
      if (mounted) {
        setState(() {
          users = response.data.data;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  Future<void> _loadConversation(GetUsersModelDataPerson user) async {
    try {
      final conversation = await _apiService.getConversation(user.id);
      if (mounted) {
        setState(() {
          selectedUser = user;
          messages = conversation;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty && selectedUser != null) {
      final message = {
        'receiverId': selectedUser!.id,
        'content': _messageController.text,
      };
      socket.emit('message', message);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mesajlaşma'),
      ),
      body: Row(
        children: [
          // Kullanıcı listesi
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[200],
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<GetUsersModelDataPerson>(
                      value: selectedUser,
                      decoration: const InputDecoration(
                        labelText: 'Kullanıcı Seçin',
                        border: OutlineInputBorder(),
                      ),
                      items: users?.map((user) {
                        return DropdownMenuItem(
                          value: user,
                          child: Text(
                            user.firstName,
                          ),
                        );
                      }).toList(),
                      onChanged: (user) {
                        if (user != null) {
                          _loadConversation(user);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Mesajlar ve mesaj gönderme alanı
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // Mesajlar listesi
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final bool isMe = message['senderId'] ==
                          widget.currentUser.data.user.id;

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[100] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['content'] ?? '',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateTime.parse(message['createdAt'])
                                    .toLocal()
                                    .toString()
                                    .split('.')[0],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Mesaj gönderme alanı
                if (selectedUser != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: 'Mesajınızı yazın...',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: _sendMessage,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
