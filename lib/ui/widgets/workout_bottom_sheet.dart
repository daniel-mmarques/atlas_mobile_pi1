import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

class WorkoutBottomSheet extends StatelessWidget {
  const WorkoutBottomSheet({
    super.key,
    required this.workoutName,
    this.onDelete,
    this.onEdit,
    this.onDuplicate,
    this.onShare,
  });

  final String workoutName;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onDuplicate;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.fromLTRB(35, 8, 35, 35),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
              color: AppColors.border(context),
              borderRadius: AppRadii.pill,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            workoutName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _circleAction(
                context,
                icon: Icons.copy_rounded,
                label: 'Duplicate',
                onTap: onDuplicate,
              ),
              _circleAction(
                context,
                icon: Icons.edit_outlined,
                label: 'Edit',
                onTap: onEdit,
              ),
              _circleAction(
                context,
                icon: Icons.ios_share_rounded,
                label: 'Share',
                onTap: onShare,
              ),
            ],
          ),
          const SizedBox(height: 30),
          SlideAction(
            outerColor: const Color(0xFF8E0000),
            innerColor: const Color(0xFFB71C1C),
            sliderRotate: false,
            elevation: 0,
            text: 'Swipe to delete >>',
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.onError,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
            sliderButtonIcon: Icon(
              Icons.delete_outline_rounded,
              color: Theme.of(context).colorScheme.onError,
            ),
            onSubmit: () {
              onDelete?.call();
              return null;
            },
          ),
        ],
      ),
    );
  }

  static Widget _circleAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        InkWell(
          borderRadius: AppRadii.pill,
          onTap: onTap,
          child: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.component(context),
            ),
            child: Icon(icon, size: 26),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
