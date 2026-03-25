import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grit/core/routes/app_routes.dart';
import 'package:grit/features/authentication/data/repository/auth_repository.dart';
import 'package:grit/features/trainer/viewmodel/trainer_home_viewmodel.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';
import 'package:grit/shared/widgets/dialogs/confirm_dialog.dart';

class TrainerTopBar extends ConsumerWidget {
  const TrainerTopBar({super.key});

  String _getInitials(String name) {
    if (name.isEmpty) return 'T';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(trainerHomeProvider);
    final trainerName = state.trainerName.isNotEmpty ? state.trainerName : 'Trainer';

    return Padding(
      padding: EdgeInsets.only(top: AppSizes.height(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LEFT: Greeting
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppTexts.trainerGreeting,
                style: AppTextStyles.font12RegularMuted,
              ),
              SizedBox(height: AppSizes.height(2)),
              Text(
                trainerName.split(' ')[0], // Just first name
                style: AppTextStyles.font22Bold.copyWith(
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),

          // RIGHT: Notifications & Signout & Avatar
          Row(
            children: [
              // Signout button
              IconButton(
                onPressed: () {
                  ConfirmDialog.show(
                    context,
                    title: 'Sign Out',
                    message: 'Are you sure you want to sign out?',
                    confirmText: 'Sign Out',
                    confirmColor: AppColors.red,
                    onConfirm: () async {
                      await ref.read(authRepositoryProvider).signOut();
                      if (context.mounted) {
                        context.go(AppRoutes.signin);
                      }
                    },
                  );
                },
                icon: Icon(
                  Icons.logout_rounded,
                  color: AppColors.muted,
                  size: AppSizes.font(20),
                ),
              ),
              SizedBox(width: AppSizes.width(8)),
              // Notification bell
              Stack(
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    color: AppColors.muted,
                    size: AppSizes.font(24),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: AppSizes.width(8),
                      height: AppSizes.width(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.red,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: AppSizes.width(16)),
              // Avatar
              Container(
                width: AppSizes.width(44),
                height: AppSizes.width(44),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface2,
                  border: Border.all(
                    color: AppColors.amber,
                    width: AppSizes.width(2),
                  ),
                ),
                child: Center(
                  child: Text(
                    _getInitials(trainerName),
                    style: AppTextStyles.font15Medium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
