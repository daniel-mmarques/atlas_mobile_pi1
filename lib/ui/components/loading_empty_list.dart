import 'package:flutter/material.dart';

class LoadingEmptyList<T> extends StatelessWidget {
  const LoadingEmptyList({
    super.key,
    required this.stream,
    required this.emptyMessage,
    required this.itemBuilder,
    this.emptyPadding = const EdgeInsets.symmetric(vertical: 32),
    this.loadingPadding = const EdgeInsets.all(24),
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.separatorBuilder,
    this.keyBuilder,
  });

  final Stream<List<T>> stream;
  final String emptyMessage;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final EdgeInsetsGeometry emptyPadding;
  final EdgeInsetsGeometry loadingPadding;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final Key Function(T item)? keyBuilder;

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
          if (emptyMessage.isEmpty) return const SizedBox.shrink();
          return Padding(
            padding: emptyPadding,
            child: Center(child: Text(emptyMessage)),
          );
        }

        if (separatorBuilder != null) {
          return ListView.separated(
            padding: padding,
            shrinkWrap: shrinkWrap,
            physics: physics,
            itemCount: items.length,
            separatorBuilder: separatorBuilder!,
            itemBuilder: (context, index) {
              final item = items[index];
              return KeyedSubtree(
                key: keyBuilder?.call(item),
                child: itemBuilder(context, item),
              );
            },
          );
        }

        return ListView.builder(
          padding: padding,
          shrinkWrap: shrinkWrap,
          physics: physics,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Padding(
              padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 14),
              child: KeyedSubtree(
                key: keyBuilder?.call(item),
                child: itemBuilder(context, item),
              ),
            );
          },
        );
      },
    );
  }
}
