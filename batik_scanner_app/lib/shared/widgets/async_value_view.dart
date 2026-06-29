import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/app_exception.dart';

class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    super.key,
    required this.value,
    required this.data,
    this.empty,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget? empty;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        return empty ??
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(errorMessage(error), textAlign: TextAlign.center),
              ),
            );
      },
    );
  }
}
