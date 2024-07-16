// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'loading.dart';

Future<T?> handlerRequestApi<T>({
  required BuildContext context,
  required Future<T> Function() body,
}) async {
  FocusScope.of(context).unfocus();
  FocusManager.instance.primaryFocus?.unfocus();
  try {
    LoadingHandler.loadingDialog(context);
    final data = await body();
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
    return data;
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
  return null;
}
