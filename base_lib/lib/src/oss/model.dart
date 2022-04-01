part of aliyun_oss_flutter;

class Credentials {
  Credentials({
    required this.accessKeyId,
    required this.accessKeySecret,
    this.securityToken,
    this.expiration,
  }) {
    if (!useSecurityToken) {
      clearSecurityToken();
    }
  }

  factory Credentials.fromJson(String str) =>
      Credentials.fromMap(json.decode(str) as Map<String, dynamic>);

  factory Credentials.fromMap(Map<String, dynamic> json) {
    return Credentials(
      accessKeyId: json['access_key_id'] as String,
      accessKeySecret: json['access_key_secret'] as String,
      securityToken: json['security_token'] as String,
      expiration: json['expiration'] != null
          ? DateTime.parse(json['expiration'] as String)
          : null,
    );
  }

  final String accessKeyId;
  final String accessKeySecret;
  String? securityToken;
  DateTime? expiration;

  bool get useSecurityToken => securityToken != null && expiration != null;

  void clearSecurityToken() {
    securityToken = null;
    expiration = null;
  }
}

/**
 * 上传回调
 */
typedef PutSendProgress = Function(int count, int total);

abstract class OSSObject {
  OSSObject._({
    required this.bytes,
    MediaType? mediaType,
    this.uuid,
    this.dataString,
  }) : _mediaType = mediaType ?? MediaType('application', 'octet-stream');

  final Uint8List bytes;

  final MediaType _mediaType;

  MediaType get mediaType => _mediaType;

  final String? uuid;

  String? dataString;

  String url = '';

  int? statusCode;

  int get size => bytes.lengthInBytes;

  PutSendProgress? putSendProgress;

  String get type => _mediaType == MediaType('application', 'octet-stream')
      ? 'file'
      : _mediaType.type;

  String get name =>
      (uuid ?? Uuid().v1()) + (type == 'file' ? '' : '.${_mediaType.subtype}');

  String get folderPath => [
        type,
      ].join('/');

  String resourcePath(String? path) => '${path ?? folderPath}/$name';

  String filePath(String? path) =>
      (path != null && path.length > 0) ? '${path}/$name' : '$name';

  void setUploadUrl(String url) {
    this.url = url;
  }

  void setStatusCode(int? statusCode) {
    this.statusCode = statusCode;
  }
}

/// 支持所有文件
class OSSFileObject extends OSSObject {
  OSSFileObject._({
    required Uint8List bytes,
    required MediaType mediaType,
    String? uuid,
  }) : super._(bytes: bytes, mediaType: mediaType, uuid: uuid);

  factory OSSFileObject.fromFile({
    required File file,
    String? uuid,
  }) {
    String subtype = path.extension(file.path).toLowerCase();
    subtype = subtype.isNotEmpty ? subtype.replaceFirst('.', '') : '*';

    return OSSFileObject._(
      bytes: file.readAsBytesSync(),
      mediaType: MediaType(contentTypeByFilename(file.path), subtype),
      uuid: uuid,
    );
  }
}

/// * [quality] 压缩存在问题，如果当图片没有exif将无法压缩
class OSSImageObject extends OSSObject {
  OSSImageObject._({
    required Uint8List bytes,
    required MediaType mediaType,
    required this.width,
    required this.height,
    String? uuid,
    this.quality,
  }) : super._(bytes: bytes, mediaType: mediaType, uuid: uuid);

  factory OSSImageObject.fromBytes({
    required Uint8List bytes,
    required MediaType mediaType,
    int quality = 60,
    String? uuid,
  }) {
    final img.Image image = img.decodeImage(bytes)!;
    if (quality < 100) {
      try {
        final List<int> compress = img.encodeJpg(image, quality: quality);
        bytes = compress as Uint8List;
        mediaType = MediaType('image', 'jpeg');
      } catch (e) {
        rethrow;
      }
    }
    return OSSImageObject._(
      width: image.width,
      height: image.height,
      bytes: bytes,
      mediaType: mediaType,
      uuid: uuid,
      quality: quality,
    );
  }

  factory OSSImageObject.fromFile({
    required File file,
    int quality = 60,
    String? uuid,
  }) {
    Uint8List bytes = file.readAsBytesSync();
    String subtype = path.extension(file.path).toLowerCase();
    subtype = subtype.isNotEmpty ? subtype.replaceFirst('.', '') : '*';

    MediaType mediaType = MediaType('image', subtype);

    final img.Image image = img.decodeImage(bytes)!;
    if (quality < 100) {
      try {
        final List<int> result = img.encodeJpg(image, quality: quality);
        bytes = result as Uint8List;
        mediaType = MediaType('image', 'jpeg');
      } catch (e) {
        rethrow;
      }
    }
    return OSSImageObject._(
      width: image.width,
      height: image.height,
      bytes: bytes,
      mediaType: mediaType,
      uuid: uuid,
      quality: quality,
    );
  }

  final int width;
  final int height;
  final int? quality;
}

/// * [length] 秒为单位
class OSSAudioObject extends OSSObject {
  OSSAudioObject._({
    required Uint8List bytes,
    required MediaType mediaType,
    required this.length,
    String? uuid,
  }) : super._(bytes: bytes, mediaType: mediaType, uuid: uuid);

  factory OSSAudioObject.fromBytes({
    required Uint8List bytes,
    required MediaType mediaType,
    required int length,
    String? uuid,
  }) {
    return OSSAudioObject._(
      length: length,
      bytes: bytes,
      mediaType: mediaType,
      uuid: uuid,
    );
  }

  factory OSSAudioObject.fromFile({
    required File file,
    required int length,
    String? uuid,
  }) {
    String subtype = path.extension(file.path).toLowerCase();
    subtype = subtype.isNotEmpty ? subtype.replaceFirst('.', '') : '*';

    return OSSAudioObject._(
      length: length,
      bytes: file.readAsBytesSync(),
      mediaType: MediaType('audio', subtype),
      uuid: uuid,
    );
  }

  final int length;
}

/// * [length] 秒为单位
class OSSVideoObject extends OSSObject {
  OSSVideoObject._({
    required Uint8List bytes,
    required MediaType mediaType,
    required this.length,
    String? uuid,
  }) : super._(bytes: bytes, mediaType: mediaType, uuid: uuid);

  factory OSSVideoObject.fromBytes({
    required Uint8List bytes,
    required MediaType mediaType,
    required int length,
    String? uuid,
  }) {
    return OSSVideoObject._(
      length: length,
      bytes: bytes,
      mediaType: mediaType,
      uuid: uuid,
    );
  }

  factory OSSVideoObject.fromFile({
    required File file,
    required int length,
    String? uuid,
  }) {
    String subtype = path.extension(file.path).toLowerCase();
    subtype = subtype.isNotEmpty ? subtype.replaceFirst('.', '') : '*';

    return OSSVideoObject._(
      length: length,
      bytes: file.readAsBytesSync(),
      mediaType: MediaType('audio', subtype),
      uuid: uuid,
    );
  }

  final int length;
}
