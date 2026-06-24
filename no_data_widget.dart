import 'package:flutter/material.dart';
import 'package:gscflutterappv3/core/comman_widgets/sized_box_widget.dart';
import 'package:gscflutterappv3/core/constants/app_colors.dart';
import 'package:gscflutterappv3/core/constants/app_dimensions.dart';
import 'package:gscflutterappv3/core/constants/app_font.dart';
import 'package:gscflutterappv3/core/constants/app_image.dart';

class NoDataWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final String? imagePath;
  final Color? titleColor;
  final Color? messageColor;
  final double? titleFontSize;
  final double? messageFontSize;
  final FontWeight? titleFontWeight;
  final FontWeight? messageFontWeight;

  const NoDataWidget({
    super.key,
    this.title,
    this.message,
    this.imagePath,
    this.titleColor,
    this.messageColor,
    this.titleFontSize,
    this.messageFontSize,
    this.titleFontWeight,
    this.messageFontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath ?? AppImage.noImage),
          Text(
            title ?? 'No data found',
            textAlign: TextAlign.center,
            style: AppFonts.subtitle1.copyWith(
              fontSize: titleFontSize ?? DeviceDimensions.titleMedimbodyText,
              color: titleColor ?? AppColors.redColor,
              fontWeight: titleFontWeight ?? FontWeight.w700,
            ),
          ),
          Space(h: 1),

          Text(
            message ??
                'There is no data to show you right now.\nMaybe try later!',
            textAlign: TextAlign.center,
            style: AppFonts.subtitle1.copyWith(
              fontSize: messageFontSize ?? DeviceDimensions.bodyTitleText,
              color: messageColor ?? AppColors.gray600,
              fontWeight: messageFontWeight ?? FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
