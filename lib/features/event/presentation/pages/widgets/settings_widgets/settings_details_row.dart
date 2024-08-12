import 'package:flutter/material.dart';

class SettingsDetailsRow extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isShowEndicon;
  final VoidCallback onTap;

  const SettingsDetailsRow({
    required this.text,
    required this.icon,
    required this.onTap,
    super.key,
    this.isShowEndicon = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Icon(icon),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(text,
                style: const TextStyle(color: Color.fromRGBO(41, 45, 50, 1))),
          ),
          Offstage(
            offstage: !isShowEndicon,
            child: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
