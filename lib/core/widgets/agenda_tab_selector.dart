import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/fonts.dart';

class AgendaTabSelector extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const AgendaTabSelector({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color:
                    selected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: Fonts.avenir,
              fontSize: 14,
              color: selected
                  ? AppColors.primary
                  : AppColors.textSubtle,
              fontWeight:
                  selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}