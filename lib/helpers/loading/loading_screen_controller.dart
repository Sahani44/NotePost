import 'package:flutter/material.dart';

typedef CloseLoadingcreen = bool Function();
typedef UpdateLoadingcreen = bool Function(String text);

@immutable
class LoadingScreenController {
  final CloseLoadingcreen close;
  final UpdateLoadingcreen update;

  const LoadingScreenController({
    required this.close,
    required this.update,
  });
}