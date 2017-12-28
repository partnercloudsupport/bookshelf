import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/collection.dart';

class NetworkImageAdvance extends ImageProvider<NetworkImageAdvance> {
  const NetworkImageAdvance(this.url, { this.scale: 1.0, this.header, this.useDiskCache: false })
      : assert(url != null),
        assert(scale != null),
        assert(useDiskCache != null);

  final String url;
  final double scale;
  final Map<String, String> header;
  final bool useDiskCache;

  @override
  Future<NetworkImageAdvance> obtainKey(ImageConfiguration configuration) {
    return new SynchronousFuture<NetworkImageAdvance>(this);
  }
  @override
  ImageStreamCompleter load(NetworkImageAdvance key) {
    return new OneFrameImageStreamCompleter(
        _loadAsync(key),
        informationCollector: (StringBuffer information) {
          information.writeln('Image provider: $this');
          information.write('Image provider: $key');
        }
    );
  }

/// NOTE: memory cache: LruMap(maximumSize: 128)
///  {
///    '$uid(image_url)': '$ImageData',
///    ...
///  }

/// NOTE: disk cache
/// CachedImageFilename: uid(part of hash hexString with imageUrl)
/// MetaDataFilename:: getApplicationDocumentsDirectory + 'imagecache/' + 'CachedImageInfo.json'
///  {
///    '$uid(image_url)': '$etag',
///    ...
///  }

  Future<ImageInfo> _loadAsync(NetworkImageAdvance key) async {
    assert(key == this);

    String uId = uid(url);

    if (imageMemoryCache != null && imageMemoryCache.containsKey(uId)) {
      if (useDiskCache) _loadFromDiskCache(key, uId);
      return await _decodeImageData(imageMemoryCache[uId]);
    }
    if (useDiskCache) return await _decodeImageData(await _loadFromDiskCache(key, uId));

    Map imageInfo = await _loadFromRemote(key, url, header);
    if (imageInfo != null) {
      imageMemoryCache[uId] = imageInfo['ImageData'];
      return await _decodeImageData(imageInfo['ImageData']);
    }

    return null;
  }

  Future<Uint8List> _loadFromDiskCache(NetworkImageAdvance key, String uId) async {
    Directory _cacheImagesDirectory = new Directory(join((await getApplicationDocumentsDirectory()).path, 'imagecache'));
    File _cacheImagesInfoFile = new File(join(_cacheImagesDirectory.path, 'CachedImageInfo.json'));
    if (_cacheImagesDirectory.existsSync()) {
      if (_cacheImagesInfoFile.existsSync()) {
        if (diskCacheInfo == null || diskCacheInfo.length == 0) {
          diskCacheInfo = JSON.decode(await _cacheImagesInfoFile.readAsString(encoding: utf8));
        }
        try {
          Map<String, String> _responseHeaders = (await http.head(url, headers: header)).headers;
          if (_responseHeaders.containsKey('etag')) {
            String _freshETag = _responseHeaders['etag'];
            if (diskCacheInfo.containsKey(uId) && (diskCacheInfo[uId]==_freshETag)) {
              return await (new File(join(_cacheImagesDirectory.path, uId))).readAsBytes();
            }
          }
        } catch(_) {
          return await (new File(join(_cacheImagesDirectory.path, uId))).readAsBytes();
        }
      }
    } else await _cacheImagesDirectory.create();

    Map imageInfo = await _loadFromRemote(key, url, header);
    if (imageInfo != null) {
      diskCacheInfo[uId] = imageInfo['Etag'];
      await (new File(join(_cacheImagesDirectory.path, uId))).writeAsBytes(imageInfo['ImageData']);
      await (new File(_cacheImagesInfoFile.path).writeAsString(JSON.encode(diskCacheInfo), mode: FileMode.WRITE, encoding: utf8));
      return imageInfo['ImageData'];
    }

    return null;
  }

  Future<Map> _loadFromRemote(NetworkImageAdvance key, String url, Map<String, String> header) async {
    http.Response _response;
    try { _response = await http.get(url, headers: header); } catch(_) { return null; }
    if (_response != null) {
      if (_response.statusCode == 200) {
        return {
          'ImageData': _response.bodyBytes,
          'Etag': _response.headers.containsKey('etag') ? _response.headers['etag'] : ''
        };
      }
    }

    return null;
  }

  Future<ImageInfo> _decodeImageData(Uint8List imageData) async {
    return new ImageInfo(image: await decodeImageFromList(imageData));
  }
  String uid(String str) {
    return md5.convert(UTF8.encode(str)).toString().toLowerCase().substring(0, 9);
  }
  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final NetworkImageAdvance typedOther = other;
    return url == typedOther.url
        && scale == typedOther.scale
        && header == typedOther.header;
  }
  @override
  int get hashCode => hashValues(url, scale, header, useDiskCache);
  @override
  String toString() => '$runtimeType("$url", scale: $scale, header: $header, useDiskCache:$useDiskCache)';
}

Map<String, String> diskCacheInfo = {};
LruMap<String, Uint8List> imageMemoryCache = new LruMap(maximumSize: 128);

/// TODO
clearDiskCachedImages() {}
