import 'package:flutter/material.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class ChatRoomScreen extends StatefulWidget {
  final String channelUrl;
  const ChatRoomScreen({super.key, required this.channelUrl});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  TextEditingController messageController = TextEditingController();
  List<BaseMessage> messageList = [];
  OpenChannel? openChannel;
  String title = '';
  late PreviousMessageListQuery query;

  @override
  void initState() {
    OpenChannel.getChannel(widget.channelUrl).then((value) {
      openChannel = value;
      setState(() {
        title = value.name;
      });
      value.enter().then((_) => initialize());
    });
    super.initState();
  }

  initialize() {
    OpenChannel.getChannel(widget.channelUrl).then((value) {
      query = PreviousMessageListQuery(
          channelType: ChannelType.open, channelUrl: widget.channelUrl)
        ..next().then((value) {
          setState(() {
            messageList
              ..clear()
              ..addAll(value);
          });
        });
    });
  }

  @override
  void dispose() {
    OpenChannel.getChannel(widget.channelUrl).then((value) => value.exit());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(children: [
        Expanded(
            child: messageList.isNotEmpty
                ? ListView.separated(
                    padding: const EdgeInsets.all(10),
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 5,
                        ),
                    itemCount: messageList.length,
                    itemBuilder: (context, index) {
                      final message = messageList[index];
                      return ListTile(
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        title: Text(
                          message.message,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Expanded(
                              child: Text(
                                message.sender?.userId ?? '',
                              ),
                            ),
                            Text(
                              DateTime.fromMillisecondsSinceEpoch(
                                      message.createdAt)
                                  .toString(),
                            ),
                          ],
                        ),
                      );
                    })
                : Container()),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Enter message',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                SizedBox(
                    height: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          if (messageController.text.isEmpty) return;
                          openChannel?.sendUserMessage(
                              UserMessageCreateParams(
                                  message: messageController.text),
                              handler: (message, e) async {
                            OpenChannel.getChannel(widget.channelUrl)
                                .then((value) {
                              setState(() {
                                messageList.add(message);
                              });
                            });
                          });
                          FocusManager.instance.primaryFocus?.unfocus();
                          messageController.clear();
                        },
                        child: const Icon(Icons.send)))
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
