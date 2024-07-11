import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../common_widgets/text_widget.dart';
import '../resources/color.dart';
import '../resources/image.dart';
import '../resources/strings.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? iconImage;
  final String? prefixTextName, prefixIcon;
  final bool? shouldShowBackButton;
  final bool? showLogoTitle;
  final PreferredSizeWidget? bottom;
  final bool? isPrefixIcon;
  final Widget? leading;
  final Widget? prefixWidget;
  final bool automaticallyImplyLeading;
  final GestureTapCallback? onTapPrefix;
  final GestureTapCallback? onPressBack;
  final Color? statusBarColor, backgroundColor, textColor;
  final GestureTapCallback? onTapAction;
  final double? toolbarHeight, titleSpacing;
  final Brightness? statusBarIconBrightness;
  final Brightness? statusBarBrightness;
  final bool? centerTitle;
  final Widget? flexibleSpace;
  final Widget? titleWidget;

  const CommonAppBar(
      {super.key,
      this.title,
      this.shouldShowBackButton = true,
      this.showLogoTitle = false,
      this.bottom,
      this.isPrefixIcon,
      this.prefixIcon,
      this.prefixTextName,
      this.toolbarHeight,
      this.onTapPrefix,
      this.iconImage,
      this.onPressBack,
      this.automaticallyImplyLeading = true,
      this.leading,
      this.statusBarColor,
      this.prefixWidget,
      this.backgroundColor,
      this.textColor,
      this.onTapAction,
      this.statusBarBrightness,
      this.centerTitle = true,
      this.flexibleSpace,
      this.titleSpacing,
      this.statusBarIconBrightness,
      this.titleWidget});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
          statusBarBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        backgroundColor: backgroundColor ?? colorTransparent,
        surfaceTintColor: Colors.transparent,
        // elevation: 5.0,
        // shadowColor: colorWhite.withOpacity(0.1),
        automaticallyImplyLeading: automaticallyImplyLeading,
        toolbarHeight: toolbarHeight ?? 56.h,
        title: titleWidget ??
            Padding(
              padding: const EdgeInsets.only(bottom: 1.0),
              child: iconImage ??
                  TextWidget(
                    text: title ?? '',
                    color: textColor ?? colorBlack,
                    fontSize: 18.sp,
                    textHeight: 1,
                    fontWeight: FontWeight.w600,
                    fontFamily: strFontName,
                  ),
            ),
        titleSpacing: titleSpacing ?? 0,
        centerTitle: centerTitle,
        leading: (shouldShowBackButton ?? true)
            ? leading ??
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onPressBack ??
                      () {
                        if (Navigator.canPop(context)) Navigator.pop(context);
                      },
                  child: Container(
                    height: 40.h,
                    width: 40.w,
                    margin: const EdgeInsets.only(left: 20),
                    padding: const EdgeInsets.only(right: 0),
                    child: Image.asset(
                      PNGImages.imgBack,
                      height: 40.h,
                      width: 40.w,
                    ),
                  ),
                  // Container(
                  //   height: 42.h,
                  //   width: 42.w,
                  //   margin: const EdgeInsets.only(left: 16),
                  //   padding: const EdgeInsets.only(right: 8),
                  //   child:
                  //   SvgPicture.asset(
                  //     SVGImg.icBack,
                  //     color: colorPrimary,
                  //     height: 42.h,
                  //     width: 42.w,
                  //   ),
                  // ),
                )
            : Container(),
        leadingWidth: 55,
        actions: [
          prefixTextName != null
              ? Container(
                  margin: EdgeInsets.only(right: 15.w),
                  padding: const EdgeInsets.only(right: 5, left: 5, top: 0),
                  child: TextWidget(
                    text: prefixTextName,
                    fontSize: 14.sp,
                    color: color894A1F,
                    fontWeight: FontWeight.w600,
                    onTap: onTapAction,
                  ),
                )
              : prefixIcon != null
                  ? GestureDetector(
                      onTap: onTapAction,
                      child: Container(
                        margin: const EdgeInsets.only(
                          right: 22,
                          bottom: 5,
                        ), // padding:  EdgeInsets.only(right: 5, left),
                        child: SvgPicture.asset(
                          prefixIcon!,
                          width: 24.w,
                          height: 24.h,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    )
                  : prefixWidget ?? const SizedBox.shrink(),
        ],
        bottom: bottom,
        flexibleSpace: flexibleSpace);
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? 52.h);
}
