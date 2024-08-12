import 'package:flutter/material.dart';

class CommonContainerRestaurantWidget extends StatelessWidget {
  final String text;
  final IconData iconData;
  final bool isShowEndicon;
  final TextStyle textStyle;

  const CommonContainerRestaurantWidget({
    required this.text,
    required this.iconData,
    required this.isShowEndicon,
    super.key,
    this.textStyle = const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
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
