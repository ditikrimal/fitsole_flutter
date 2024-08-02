// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class CustomAlertBar extends StatefulWidget {
  const CustomAlertBar.success({
    super.key,
    required this.message,
    required this.messageStatus,
    this.secondaryMessage,
    this.icon = const Icon(
      Icons.check_circle_outline,
      color: Colors.white,
      size: 25,
    ),
    this.backgroundColor = const Color.fromARGB(255, 7, 173, 93),
    this.statusColor = Colors.white,
  });

  const CustomAlertBar.info({
    super.key,
    required this.message,
    required this.messageStatus,
    this.secondaryMessage,
    this.icon = const Icon(
      Icons.info_outline_rounded,
      color: Colors.white,
      size: 25,
    ),
    this.backgroundColor = const Color.fromARGB(255, 89, 90, 90),
    this.statusColor = Colors.white,
  });

  const CustomAlertBar.error({
    super.key,
    required this.message,
    required this.messageStatus,
    this.secondaryMessage,
    this.icon = const Icon(
      Icons.error_outline,
      color: Colors.white,
      size: 25,
    ),
    this.backgroundColor = const Color.fromARGB(255, 178, 11, 11),
    this.statusColor = Colors.white,
  });
  final String message;
  final String messageStatus;
  final Widget icon;
  final Color backgroundColor;
  final Color statusColor;
  final String? secondaryMessage;

  @override
  CustomAlertBarState createState() => CustomAlertBarState();
}

class CustomAlertBarState extends State<CustomAlertBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        margin: EdgeInsets.only(top: 50),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.icon,
                SizedBox(
                  width: 5,
                ),
                Text(
                  widget.messageStatus.toUpperCase(),
                  style: TextStyle(
                      color: widget.statusColor,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      fontFamily: 'Montserrat'),
                ),
              ],
            ),
            SizedBox(
              height: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.message,
                  style: TextStyle(
                      color: widget.statusColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      fontFamily: 'Roboto'),
                ),
                Text(
                  widget.secondaryMessage ?? '',
                  style: TextStyle(
                      color: widget.statusColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      fontFamily: 'Roboto'),
                ),
              ],
            ),
          ],
        ));
  }
}
