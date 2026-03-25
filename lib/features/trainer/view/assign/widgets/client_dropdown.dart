import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class ClientDropdown extends StatefulWidget {
  final List<Map<String, dynamic>> clients;
  final int? selectedIndex;
  final ValueChanged<int> onChanged;

  const ClientDropdown({
    super.key,
    required this.clients,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  State<ClientDropdown> createState() => _ClientDropdownState();
}

class _ClientDropdownState extends State<ClientDropdown> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Selected / placeholder row
        GestureDetector(
          onTap: () => setState(() => _isOpen = !_isOpen),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.width(16),
              vertical: AppSizes.height(14),
            ),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: _isOpen
                  ? BorderRadius.vertical(top: Radius.circular(AppSizes.radius(12)))
                  : BorderRadius.circular(AppSizes.radius(12)),
              border: Border.all(color: AppColors.borderDefault, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.selectedIndex == null)
                  Text(
                    'Select a client',
                    style: AppTextStyles.font14Regular.copyWith(color: AppColors.dim),
                  )
                else
                  Row(
                    children: [
                      Container(
                        width: AppSizes.width(32),
                        height: AppSizes.width(32),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surface,
                          border: Border.all(color: AppColors.amber, width: 1.5),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.clients[widget.selectedIndex!]['initials'],
                          style: AppTextStyles.font12Regular.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.amber,
                          ),
                        ),
                      ),
                      SizedBox(width: AppSizes.width(10)),
                      Text(
                        widget.clients[widget.selectedIndex!]['name'],
                        style: AppTextStyles.font14Regular,
                      ),
                    ],
                  ),
                Icon(
                  _isOpen ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.muted,
                  size: AppSizes.font(20),
                ),
              ],
            ),
          ),
        ),

        // Dropdown list
        if (_isOpen)
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppSizes.radius(12))),
              border: Border.merge(
                const Border(top: BorderSide.none),
                Border.all(color: AppColors.borderDefault, width: 1),
              ),
            ),
            child: Column(
              children: widget.clients.asMap().entries.map((e) {
                final isLast = e.key == widget.clients.length - 1;
                return GestureDetector(
                  onTap: () {
                    setState(() => _isOpen = false);
                    widget.onChanged(e.key);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.width(16),
                      vertical: AppSizes.height(12),
                    ),
                    decoration: BoxDecoration(
                      border: isLast
                          ? null
                          : const Border(
                              bottom: BorderSide(color: AppColors.borderDefault, width: 1),
                            ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: AppSizes.width(32),
                          height: AppSizes.width(32),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.surface,
                            border: Border.all(color: AppColors.amber, width: 1.5),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            e.value['initials'],
                            style: AppTextStyles.font12Regular.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.amber,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSizes.width(10)),
                        Expanded(
                          child: Text(
                            e.value['name'],
                            style: AppTextStyles.font14Regular,
                          ),
                        ),
                        if (e.key == widget.selectedIndex)
                          Icon(
                            Icons.check_rounded,
                            color: AppColors.amber,
                            size: AppSizes.font(16),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
