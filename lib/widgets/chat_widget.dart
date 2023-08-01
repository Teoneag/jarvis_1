import 'package:flutter/material.dart';
import '/methdos/chat/chat_methods.dart';
import '/utils.dart';

class ChatWidget extends StatefulWidget {
  final String chatName;
  final ChatObj cO;
  final SyncObj sO;
  final BoolW isRespondWaited;

  const ChatWidget(this.chatName, this.cO, this.sO, this.isRespondWaited,
      {super.key});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final messageC = TextEditingController();
  final focusNode = FocusNode();
  final messageIndex = IntW(-1);

  @override
  void dispose() {
    super.dispose();
    messageC.dispose();
    focusNode.dispose();
  }

  // TODO: handle new line: flutter simplest way to achive the whatsapp enter function: when pressing normal enter, send the message, when pressing it while holding shift, add /n to the text
  // TODO: show date of messages

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: widget.cO.messages.length,
            itemBuilder: (context, index) {
              final message = widget.cO.messages[index];
              return ListTile(
                contentPadding: message.isAux ? const EdgeInsets.all(50) : null,
                title: Align(
                    alignment: message.isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(message.text)),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (event) => ChatM.handleKeyPress(
                event, messageIndex, messageC, widget.cO.messages),
            child: TextField(
                autofocus: true,
                focusNode: focusNode,
                controller: messageC,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () => ChatM.sendMessageMe(
                        messageC, widget.chatName, widget.cO, widget.sO),
                    icon: const Icon(Icons.send),
                  ),
                ),
                onSubmitted: (_) {
                  ChatM.sendMessageMe(
                      messageC, widget.chatName, widget.cO, widget.sO);
                  focusNode.requestFocus(); // TODO: Make it autoscroll
                }),
          ),
        ),
      ],
    );
  }
}
