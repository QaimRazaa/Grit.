import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';
import 'package:grit/core/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class ClientProgramCard extends StatelessWidget {
  final String assignmentId;
  final String clientName;
  final String clientInitials;
  final String programName;
  final String status;
  final int currentDay;
  final int totalDays;

  const ClientProgramCard({
    super.key,
    required this.assignmentId,
    required this.clientName,
    required this.clientInitials,
    required this.programName,
    required this.status,
    required this.currentDay,
    required this.totalDays,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = status == 'active';
    final int totalWeeks = totalDays ~/ 7;

    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.height(10)),
      padding: AppSizes.paddingAll(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radius(16)),
        border: Border.all(color: AppColors.borderDefault, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Avatar
                  Container(
                    width: AppSizes.width(36),
                    height: AppSizes.width(36),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface2,
                      border: Border.all(color: AppColors.amber, width: 1.5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      clientInitials,
                      style: AppTextStyles.font12Regular.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.amber,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.width(10)),
                  Text(
                    clientName,
                    style: AppTextStyles.font14Regular.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              // Status chip
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.width(12),
                  vertical: AppSizes.height(5),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.radius(20)),
                  color: isActive ? AppColors.green.withOpacity(0.1) : AppColors.amber.withOpacity(0.1),
                  border: Border.all(
                    color: isActive ? AppColors.green.withOpacity(0.4) : AppColors.amber.withOpacity(0.4),
                  ),
                ),
                child: Text(
                  isActive ? 'Active' : 'Pending',
                  style: AppTextStyles.font10SemiBold.copyWith(
                    color: isActive ? AppColors.green : AppColors.amber,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.height(10)),
          Text(
            programName,
            style: AppTextStyles.font13RegularMuted,
          ),
          SizedBox(height: AppSizes.height(10)),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radius(4)),
            child: Stack(
              children: [
                Container(
                  height: AppSizes.height(4),
                  color: AppColors.surface2,
                  width: double.infinity,
                ),
                FractionallySizedBox(
                  widthFactor: totalDays == 0 ? 0 : currentDay / totalDays,
                  child: Container(
                    height: AppSizes.height(4),
                    color: AppColors.amber,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.height(6)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Day $currentDay of $totalDays ($totalWeeks Weeks)',
                style: AppTextStyles.font11RegularDim,
              ),
              GestureDetector(
                onTap: () => context.push('${AppRoutes.clientProgramDetail}/$assignmentId'),
                child: Text(
                  'View',
                  style: AppTextStyles.font12Regular.copyWith(color: AppColors.amber),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

