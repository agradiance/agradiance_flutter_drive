// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

// import 'package:image_picker/image_picker.dart';

class XFileData {
  final Uint8List bytes;
  final String? name;
  final String? path;
  XFileData({required this.bytes, this.name, this.path});

  Uint8List get data => bytes;
  static Future<XFileData> fromXFile(XFile file) async {
    return XFileData(bytes: await file.readAsBytes(), name: file.name, path: file.path);
  }

  XFileData copyWith({Uint8List? bytes, String? name, String? path}) {
    return XFileData(bytes: bytes ?? this.bytes, name: name ?? this.name, path: path ?? this.path);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'bytes': bytes, 'name': name, 'path': path};
  }

  factory XFileData.fromMap(Map<String, dynamic> map) {
    return XFileData(
      bytes: Uint8List.fromList(map['bytes'] ?? []),
      name: map['name'] != null ? map['name'] as String : null,
      path: map['path'] != null ? map['path'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory XFileData.fromJson(String source) => XFileData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'XFileData(bytes: ${bytes.lengthInBytes}, name: $name, path: $path)';

  @override
  bool operator ==(covariant XFileData other) {
    if (identical(this, other)) return true;

    return other.bytes == bytes && other.name == name && other.path == path;
  }

  @override
  int get hashCode => bytes.hashCode ^ name.hashCode ^ path.hashCode;
}
