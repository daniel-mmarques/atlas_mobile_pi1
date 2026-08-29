import 'package:flutter/material.dart';

class LoadingEmptyList<T> extends StatelessWidget {
  const LoadingEmptyList({
    super.key,
    required this.stream,
    required this.emptyMessage,
    required this.itemBuilder,
    this.emptyPadding = const EdgeInsets.symmetric(vertical: 32),
    this.loadingPadding = const EdgeInsets.all(24),
    this.separator,
  });

  final Stream<List<T>> stream;
  final String emptyMessage;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final EdgeInsetsGeometry emptyPadding;
  final EdgeInsetsGeometry loadingPadding;
  final Widget Function(BuildContext context, List<T> items)? separator;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<T>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: loadingPadding,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return Padding(
            padding: emptyPadding,
            child: Center(child: Text(emptyMessage)),
          );
        }

        if (separator != null) {
          return separator!(context, items);
        }

        return Column(
          spacing: 14,
          children: items.map((item) => itemBuilder(context, item)).toList(),
        );
      },
    );
  }
}
