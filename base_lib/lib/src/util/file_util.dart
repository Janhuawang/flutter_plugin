import 'dart:io';

/*
 * 文件处理工具
 * 参考：https://fiissh.tech/2019/flutter-use-file-by-dart-io.html
 */
class FileTools {
  /*
   * 文件是否有效，存在并字节大于0
   */
  static Future<bool> isFileValid(String filePath) async {
    File? file = await FileTools.getFile(filePath);
    return file != null && await file.length() > 0;
  }

  /*
   * 文件是否存在
   */
  static Future<bool> exists(String? fileName) async {
    if (fileName == null) {
      return false;
    }
    var file = new File(fileName);
    return await file.exists();
  }

  /*
   * 获取一个文件 返回null说明文件有问题
   */
  static Future<File?> getFile(String? fileName) async {
    if (fileName == null) {
      return null;
    }
    var file = new File(fileName);
    return await file.exists() ? file : null;
  }

  /*
   * 创建一个文件
   */
  static Future<File?> create(String? fileName) async {
    if (fileName == null) {
      return null;
    }
    var file = new File(fileName);
    return await file.create();
  }

  /*
   * 删除一个文件
   */
  static Future<FileSystemEntity?> delete(String? fileName) async {
    if (fileName == null) {
      return null;
    }
    var file = new File(fileName);
    return await file.delete();
  }

  /*
   * 删除一个文件夹
   */
  static bool deleteDirectory(String dirName) {
    var directory = new Directory(dirName);
    if (directory.existsSync()) {
      List<FileSystemEntity> fileList = directory.listSync();
      if (fileList.isNotEmpty) {
        fileList.forEach((element) {
          if (element.existsSync()) {
            element.deleteSync();
          }
        });
      }
      directory.deleteSync();
      return true;
    }
    return false;
  }
}
