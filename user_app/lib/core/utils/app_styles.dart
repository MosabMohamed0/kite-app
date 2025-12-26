import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // لازم تعمل import

abstract class AppStyles {
  static const String _fontFamily = 'Montserrat';

  // ملاحظة: شيلنا const وبقينا نستخدم .sp

  // 12px
  static TextStyle styleRegular12Muted = TextStyle(
    fontSize: 12.sp, // هنا السحر، الخط بيكبر ويصغر حسب الشاشة
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    color: const Color(0xFF4B5563),
  );

  static TextStyle styleMedium12Dark = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    color: const Color(0xFF1A1A1A),
  );

  static TextStyle styleSemiBold12Red = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamily,
    color: const Color(0xFFDC2626),
  );

  // 14px
  static TextStyle styleRegular14Muted = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    color: const Color(0xFF4B5563),
  );

  static TextStyle styleMedium14Dark = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    color: const Color(0xFF1A1A1A),
  );

  static TextStyle styleMedium14Primary = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    color: const Color(0xFF80AF81),
  );

  // 16px
  static TextStyle styleMedium16Dark = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    color: const Color(0xFF1A1A1A),
  );

  static TextStyle styleRegular16Muted = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    color: const Color(0xFF4B5563),
  );

  static TextStyle styleMedium16Green = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    color: const Color(0xFF16A34A),
  );

  // 18px
  static TextStyle styleSemiBold18Dark = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamily,
    color: const Color(0xFF1A1A1A),
  );

  static TextStyle styleMedium18Muted = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    color: const Color(0xFF4B5563),
  );

  // 20px
  static TextStyle styleSemiBold20Dark = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamily,
    color: const Color(0xFF1A1A1A),
  );

  static TextStyle styleBold20Primary = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    color: const Color(0xFF80AF81),
  );

  // 24px
  static TextStyle styleSemiBold24Dark = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    fontFamily: _fontFamily,
    color: const Color(0xFF1A1A1A),
  );

  static TextStyle styleBold24Dark = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    color: const Color(0xFF1A1A1A),
  );

  // 30px
  static TextStyle styleBold30Primary = TextStyle(
    fontSize: 30.sp,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    color: const Color(0xFF80AF81),
  );
}
