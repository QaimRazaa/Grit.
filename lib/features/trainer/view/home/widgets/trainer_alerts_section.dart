import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';
import 'package:go_router/go_router.dart';
import 'package:grit/core/routes/app_routes.dart';
import 'package:grit/features/trainer/data/models/client_profile_model.dart';

class TrainerAlertsSection extends StatelessWidget {
  final List<ClientProfileModel> clients;

  const TrainerAlertsSection({super.key, required this.clients});

  @override
  Widget build(BuildContext context) {
    if (clients.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppTexts.trainerProgressAlerts,
              style: AppTextStyles.font16Bold,
            ),
            Text(
              '${clients.length} alerts',
              style: AppTextStyles.font12Regular.copyWith(
                color: AppColors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.height(14)),
        ...clients.map((client) => _AlertCard(
              clientId: client.id,
              name: client.fullName,
              initials: client.initials,
              message: "Hasn't logged in ${client.streak?.daysSinceLastLog ?? 0} days",
              timeAgo: '${client.streak?.daysSinceLastLog ?? 0}d ago',
              severity: (client.streak?.daysSinceLastLog ?? 0) > 3 ? 'urgent' : 'warning',
            )),
      ],
    );
  }
}


class _AlertCard extends StatelessWidget {
  final String clientId;
  final String name;
  final String initials;
  final String message;
  final String timeAgo;
  final String severity;

  const _AlertCard({
    required this.clientId,
    required this.name,
    required this.initials,
    required this.message,
    required this.timeAgo,
    required this.severity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.height(10)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radius(16)),
        border: Border.all(color: AppColors.borderDefault, width: 1),
      ),
      child: Stack(
        children: [
          // Left accent bar
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: AppSizes.width(3),
              decoration: BoxDecoration(
                color: severity == 'urgent' ? AppColors.red : AppColors.amber,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSizes.radius(16)),
                  bottomLeft: Radius.circular(AppSizes.radius(16)),
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.only(
              left: AppSizes.width(19), // 3 bar + 16 padding
              right: AppSizes.width(16),
              top: AppSizes.height(14),
              bottom: AppSizes.height(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                Container(
                  width: AppSizes.width(40),
                  height: AppSizes.width(40),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: severity == 'urgent'
                        ? AppColors.red.withValues(alpha: 0.1)
                        : AppColors.amber.withValues(alpha: 0.1),
                    border: Border.all(
                      color: severity == 'urgent'
                          ? AppColors.red.withValues(alpha: 0.35)
                          : AppColors.amber.withValues(alpha: 0.35),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: AppTextStyles.font13Regular.copyWith(
                        color:
                            severity == 'urgent' ? AppColors.red : AppColors.amber,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: AppSizes.width(12)),

                // Message
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppTextStyles.font14Regular),
                      SizedBox(height: AppSizes.height(3)),
                      Text(
                        message,
                        style: AppTextStyles.font12RegularMuted,
                      ),
                      SizedBox(height: AppSizes.height(4)),
                      Text(
                        timeAgo,
                        style: AppTextStyles.font11RegularDim,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: AppSizes.width(12)),

                // Review button
                GestureDetector(
                  onTap: () => context.push('${AppRoutes.clientProfile}/$clientId'),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.width(12),
                      vertical: AppSizes.height(7),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(AppSizes.radius(20)),
                      border: Border.all(
                        color: AppColors.amber.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      AppTexts.trainerReview,
                      style: AppTextStyles.font10SemiBold.copyWith(
                        color: AppColors.amber,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
