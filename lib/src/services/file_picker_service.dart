import 'package:file_picker/file_picker.dart';

class FilePickerService {
  static final FilePickerService _instance = FilePickerService._internal();
  static final FilePickerService instance = FilePickerService();

  FilePickerService._internal();

  factory FilePickerService() {
    return _instance;
  }

  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    dynamic Function(FilePickerStatus)? onFileLoading,

    int compressionQuality = 0,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      allowedExtensions: allowedExtensions,
      compressionQuality: compressionQuality,
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,
      lockParentWindow: lockParentWindow,
      onFileLoading: onFileLoading,
      readSequential: readSequential,
      type: type,
      withData: withData,
      withReadStream: withReadStream,
    );

    return result;
  }
}
