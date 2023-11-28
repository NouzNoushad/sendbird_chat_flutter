import 'package:flutter/material.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';
import 'package:sendbird_flutter/presentation/chat_room.dart';
import 'package:sendbird_flutter/presentation/create_chat_list.dart';
import 'package:sendbird_flutter/presentation/login_screen.dart';
import 'package:sendbird_flutter/service/user_service.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late OpenChannelListQuery query;

  List<OpenChannel> channelList = [];
  @override
  void initState() {
    query = OpenChannelListQuery()
      ..next().then((value) {
        setState(() {
          channelList.addAll(value);
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => const CreateChatListScreen()))
              .then((openChannel) {
            if (openChannel != null) {
              setState(() {
                channelList.insert(0, openChannel);
              });
            }
          });
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Chat List'),
        actions: [
          IconButton(
              onPressed: () async {
                var logout = await UserService.removeLoginUserId();
                if (logout) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Logout')));
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LoginScreen()));
                }
              },
              icon: const Icon(Icons.power_settings_new))
        ],
      ),
      body: channelList.isNotEmpty
          ? ListView.separated(
              padding: const EdgeInsets.all(8),
              separatorBuilder: (context, index) => const SizedBox(
                    height: 5,
                  ),
              itemCount: channelList.length,
              itemBuilder: (context, index) {
                final channel = channelList[index];
                return ListTile(
                  tileColor: Colors.white,
                  title: Text(
                    channel.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    DateTime.fromMillisecondsSinceEpoch(
                            channel.createdAt! * 1000)
                        .toString(),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ChatRoomScreen(channelUrl: channel.channelUrl)));
                  },
                );
              })
          : Container(),
    );
  }
}
