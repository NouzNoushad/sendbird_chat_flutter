import 'package:flutter/material.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class CreateChatListScreen extends StatefulWidget {
  const CreateChatListScreen({super.key});

  @override
  State<CreateChatListScreen> createState() => _CreateChatListScreenState();
}

class _CreateChatListScreenState extends State<CreateChatListScreen> {
  TextEditingController createController = TextEditingController();

  @override
  void dispose() {
    createController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Chat'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Chat User Id'),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: createController,
                  decoration: InputDecoration(
                    hintText: 'Enter user id',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          final openChannel = await OpenChannel.createChannel(
                              OpenChannelCreateParams()
                                ..name = createController.text
                                ..operatorUserIds = [
                                  SendbirdChat.currentUser!.userId
                                ]);
                          Navigator.pop(context, openChannel);
                        },
                        child: const Text('Create')))
              ]),
        ),
      ),
    );
  }
}
