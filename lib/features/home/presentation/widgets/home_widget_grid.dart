import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/home/domain/entities/home_widget.dart';
import 'package:atlas_mobile_pi1/features/home/presentation/widgets/home_add_widget_card.dart';
import 'package:atlas_mobile_pi1/features/home/presentation/widgets/home_widget_shell.dart';
import 'package:atlas_mobile_pi1/features/home/presentation/widgets/tiles/home_widget_tile.dart';
import 'package:flutter/material.dart';

class _PlacedWidget {
  const _PlacedWidget({
    required this.instance,
    required this.col,
    required this.row,
  });

  final HomeWidgetInstance instance;
  final int col;
  final int row;
}

class HomeWidgetGrid extends StatelessWidget {
  const HomeWidgetGrid({
    super.key,
    required this.widgets,
    required this.onAdd,
    required this.onEditStyle,
    required this.onEditSize,
    required this.onRemove,
    this.onEditName,
    this.userId,
  });

  final List<HomeWidgetInstance> widgets;
  final VoidCallback onAdd;
  final void Function(HomeWidgetInstance) onEditStyle;
  final void Function(HomeWidgetInstance) onEditSize;
  final void Function(HomeWidgetInstance) onRemove;
  final void Function(HomeWidgetInstance)? onEditName;
  final String? userId;

  static const int columns = 2;
  static const double gap = AppSpacing.md;

  List<_PlacedWidget> _pack(List<HomeWidgetInstance> items) {
    final occupied = <String>{};
    final placed = <_PlacedWidget>[];

    bool fits(int row, int col, int h, int w) {
      if (col + w > columns) return false;
      for (var r = row; r < row + h; r++) {
        for (var c = col; c < col + w; c++) {
          if (occupied.contains('$r:$c')) return false;
        }
      }
      return true;
    }

    void occupy(int row, int col, int h, int w) {
      for (var r = row; r < row + h; r++) {
        for (var c = col; c < col + w; c++) {
          occupied.add('$r:$c');
        }
      }
    }

    for (final item in items) {
      final size = item.size.clampedToMax;
      final h = size.height;
      final w = size.width;
      var placedItem = false;
      for (var row = 0; !placedItem; row++) {
        for (var col = 0; col < columns; col++) {
          if (fits(row, col, h, w)) {
            occupy(row, col, h, w);
            placed.add(
              _PlacedWidget(
                instance: item.copyWith(size: size),
                col: col,
                row: row,
              ),
            );
            placedItem = true;
            break;
          }
        }
      }
    }

    // Place add card 1x1 at first free slot after widgets.
    var addPlaced = false;
    for (var row = 0; !addPlaced; row++) {
      for (var col = 0; col < columns; col++) {
        if (fits(row, col, 1, 1)) {
          occupy(row, col, 1, 1);
          placed.add(
            _PlacedWidget(
              instance: const HomeWidgetInstance(
                id: '__add__',
                type: HomeWidgetType.streak,
                style: HomeWidgetStyle.number,
                size: HomeWidgetSize.s1x1,
                order: 9999,
                name: '',
              ),
              col: col,
              row: row,
            ),
          );
          addPlaced = true;
          break;
        }
      }
    }

    return placed;
  }

  int _rowCount(List<_PlacedWidget> placed) {
    var max = 0;
    for (final p in placed) {
      final end = p.row +
          (p.instance.id == '__add__' ? 1 : p.instance.size.height);
      if (end > max) max = end;
    }
    return max;
  }

  @override
  Widget build(BuildContext context) {
    final placed = _pack(widgets);
    final rows = _rowCount(placed);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalGap = gap * (columns - 1);
        // Square cells: row height == column width.
        final cellSize = (constraints.maxWidth - totalGap) / columns;
        final height = rows * cellSize + (rows > 0 ? (rows - 1) * gap : 0);

        return SizedBox(
          height: height,
          child: Stack(
            children: [
              for (final p in placed)
                Positioned(
                  left: p.col * (cellSize + gap),
                  top: p.row * (cellSize + gap),
                  width: (p.instance.id == '__add__'
                          ? 1
                          : p.instance.size.width) *
                          cellSize +
                      ((p.instance.id == '__add__'
                                  ? 1
                                  : p.instance.size.width) -
                              1) *
                          gap,
                  height: (p.instance.id == '__add__'
                          ? 1
                          : p.instance.size.height) *
                          cellSize +
                      ((p.instance.id == '__add__'
                                  ? 1
                                  : p.instance.size.height) -
                              1) *
                          gap,
                  child: p.instance.id == '__add__'
                      ? HomeAddWidgetCard(onTap: onAdd)
                      : HomeWidgetShell(
                          instance: p.instance,
                          onEditStyle: () => onEditStyle(p.instance),
                          onEditSize: () => onEditSize(p.instance),
                          onRemove: () => onRemove(p.instance),
                          onEditName: onEditName == null
                              ? null
                              : () => onEditName!(p.instance),
                          child: HomeWidgetTile(
                            instance: p.instance,
                            userId: userId,
                          ),
                        ),
                ),
            ],
          ),
        );
      },
    );
  }
}
