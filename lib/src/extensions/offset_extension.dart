import 'package:flutter/material.dart';

extension OffsetExtension on Offset {
  Map<String, dynamic> toMap() {
    return {'dx': dx, 'dy': dy};
  }

  static Offset fromMap(Map<String, dynamic> map) {
    return Offset(
      double.tryParse("${(map['dx'] ?? 0)}")?.toDouble() ?? 0,
      double.tryParse("${(map['dy'] ?? 0)}")?.toDouble() ?? 0,
    );
  }
}
