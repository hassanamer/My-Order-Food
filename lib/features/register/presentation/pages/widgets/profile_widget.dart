import 'package:flutter/material.dart';

import '../../../data/models/register_account_model.dart';

class ProfileWidget extends StatefulWidget {
  final RegisterAccountModel registerAccountModel;
  const ProfileWidget({
    super.key,
    required this.registerAccountModel,
  });

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        editableTextField(
            label: widget.registerAccountModel.name ?? '',
            prefixIcon: const Icon(Icons.person))
      ],
    );
  }
}

Padding editableTextField({required Widget prefixIcon, required String label}) {
  return Padding(
    padding: const EdgeInsets.all(7),
    child: TextFormField(
      controller: TextEditingController(text: ''),
      enabled: false,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: label,
        prefixIcon: prefixIcon,
      ),
    ),
  );
}
