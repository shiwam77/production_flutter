import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationItem> notifications = [
    NotificationItem(
      title: 'plastic',
      message: '20% more in plastic product',
      time: DateTime.now().subtract(Duration(minutes: 10)),
      isRead: false,
    ),
    NotificationItem(
      title: 'Account updated',
      message: 'your password was updated',
      time: DateTime.now().subtract(Duration(hours: 2)),
      isRead: false,
    ),
    NotificationItem(
      title: 'electronic',
      message: '10% off in electronic product',
      time: DateTime.now().subtract(Duration(days: 1)),
      isRead: true,
    ),
  ];

  bool _selectAll = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor:
            Color(0xFF89cc4f).withOpacity(0.8), // Transparent green color
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context); // Add the navigation logic here
          },
        ),
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
              popupMenuTheme: PopupMenuThemeData(
                color: Colors.white,
              ),
            ),
            child: PopupMenuButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onSelected: (value) {
                if (value == 'delete') {
                  _deleteSelectedNotifications();
                } else if (value == 'mark_as_read') {
                  _markSelectedAsRead();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete All'),
                ),
                PopupMenuItem(
                  value: 'mark_as_read',
                  child: Text('Mark as Read'),
                ),
                // Add more options as per your requirement
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15), // Add appropriate gap after app bar
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Container(
              decoration: BoxDecoration(
                color: Color(0xFF89cc4f).withOpacity(0.2),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteNotification(index);
                      },
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.isRead ? 'Read' : 'Received',
                      style: TextStyle(
                        fontSize: 16,
                        color: notification.isRead ? Colors.green : Colors.red,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      notification.message,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${DateFormat('dd MMM yyyy hh:mm a').format(notification.time)}',
                      style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 107, 107, 107)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _deleteSelectedNotifications() {
    setState(() {
      notifications.clear();
    });
  }

  void _markSelectedAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isRead = true;
      }
    });
  }

  void _deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }
}

class NotificationItem {
  String title;
  String message;
  DateTime time;
  bool isRead;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
  });
}
