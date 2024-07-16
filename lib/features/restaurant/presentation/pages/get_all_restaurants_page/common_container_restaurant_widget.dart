import 'package:flutter/material.dart';

class CommonContainerRestaurantWidget extends StatelessWidget {
  final String text;
  final IconData iconData;
  final bool isShowEndicon;
  final TextStyle textStyle;

  const CommonContainerRestaurantWidget({
    Key? key,
    required this.text,
    required this.iconData,
    required this.isShowEndicon,
    this.textStyle = const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Offstage(offstage: !isShowEndicon, child: Icon(iconData)),
          const SizedBox(width: 6),
          Text(
            text,
            textAlign: TextAlign.left,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
