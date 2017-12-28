import 'dart:async';
import 'dart:io' as io;
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// TODO: cache required
/// 1. memory lru cache
/// 2. disk cache

class NetworkImageAdvance extends ImageProvider<NetworkImageAdvance> {
  const NetworkImageAdvance(this.url, { this.scale: 1.0, this.header, this.fetchStrategy: defaultFetchStrategy })
      : assert(url != null),
        assert(scale != null),
        assert(fetchStrategy != null);

  static final io.HttpClient _client = new io.HttpClient();
  final String url;
  final double scale;
  final Map<String, String> header;
  final FetchStrategy fetchStrategy;
  static final FetchStrategy _defaultFetchStrategyFunction = const FetchStrategyBuilder().build();

  static Future<FetchInstructions> defaultFetchStrategy(Uri uri, FetchFailure failure) {
    return _defaultFetchStrategyFunction(uri, failure);
  }

  @override
  Future<NetworkImageAdvance> obtainKey(ImageConfiguration configuration) {
    return new SynchronousFuture<NetworkImageAdvance>(this);
  }
  @override
  ImageStreamCompleter load(NetworkImageAdvance key) {
    return new OneFrameImageStreamCompleter(
        _loadWithRetry(key),
        informationCollector: (StringBuffer information) {
          information.writeln('Image provider: $this');
          information.write('Image key: $key');
        }
    );
  }

  void _debugCheckInstructions(FetchInstructions instructions) {
    assert(() {
      if (instructions == null) {
        if (fetchStrategy == defaultFetchStrategy) {
          throw new StateError(
              'The default FetchStrategy returned null FetchInstructions. This\n'
                  'is likely a bug in $runtimeType. Please file a bug at\n'
                  'https://github.com/flutter/flutter/issues.'
          );
        } else {
          throw new StateError(
              'The custom FetchStrategy used to fetch $url returned null\n'
                  'FetchInstructions. FetchInstructions must never be null, but\n'
                  'instead instruct to either make another fetch attempt or give up.'
          );
        }
      }
      return true;
    });
  }





  Future<ImageInfo> _loadWithRetry(NetworkImageAdvance key) async {
    assert(key == this);

    final Stopwatch stopwatch = new Stopwatch()..start();
    final Uri resolved = Uri.base.resolve(key.url);
    FetchInstructions instructions = await fetchStrategy(resolved, null);
    _debugCheckInstructions(instructions);
    int attemptCount = 0;
    FetchFailure lastFailure;

    while (!instructions.shouldGiveUp) {
      attemptCount += 1;
      io.HttpClientRequest request;
      try {
        request = await _client.getUrl(instructions.uri).timeout(instructions.timeout);
        if (this.header != null) {
          request.headers.set(this.header.keys.first, this.header.values.first);
        }
        final io.HttpClientResponse response = await request.close().timeout(instructions.timeout);

        if (response == null || response.statusCode != 200) {
          throw new FetchFailure._(
            totalDuration: stopwatch.elapsed,
            attemptCount: attemptCount,
            httpStatusCode: response.statusCode,
          );
        }

        final _Uint8ListBuilder builder = await response.fold(
          new _Uint8ListBuilder(),
              (_Uint8ListBuilder buffer, List<int> bytes) => buffer..add(bytes),
        ).timeout(instructions.timeout);

        final Uint8List bytes = builder.data;

        if (bytes.lengthInBytes == 0)
          return null;

        final ui.Image image = await decodeImageFromList(bytes);
        if (image == null)
          return null;

        return new ImageInfo(
          image: image,
          scale: key.scale,
        );
      } catch (error) {
        request?.close();
        lastFailure = error is FetchFailure
            ? error
            : new FetchFailure._(
          totalDuration: stopwatch.elapsed,
          attemptCount: attemptCount,
          originalException: error,
        );
        instructions = await fetchStrategy(instructions.uri, lastFailure);
        _debugCheckInstructions(instructions);
      }
    }

    if (instructions.alternativeImage != null)
      return instructions.alternativeImage;

    assert(lastFailure != null);

    FlutterError.onError(new FlutterErrorDetails(
      exception: lastFailure,
      library: 'package:flutter_image',
      context: '$runtimeType failed to load ${instructions.uri}',
    ));

    return null;
  }





  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType)
      return false;
    final NetworkImageAdvance typedOther = other;
    return url == typedOther.url
        && scale == typedOther.scale
        && header == typedOther.header;
  }
  @override
  int get hashCode => hashValues(url, scale, header);
  @override
  String toString() => '$runtimeType("$url", scale: $scale, header: $header)';
}












typedef Future<FetchInstructions> FetchStrategy(Uri uri, FetchFailure failure);


@immutable
class FetchInstructions {
  const FetchInstructions.giveUp({
    @required this.uri,
    this.alternativeImage,
  })
      : shouldGiveUp = true,
        timeout = null;

  const FetchInstructions.attempt({
    @required this.uri,
    @required this.timeout,
  }) : shouldGiveUp = false,
        alternativeImage = null;

  final bool shouldGiveUp;
  final Duration timeout;
  final Uri uri;
  final Future<ImageInfo> alternativeImage;

  @override
  String toString() {
    return '$runtimeType(\n'
        '  shouldGiveUp: $shouldGiveUp\n'
        '  timeout: $timeout\n'
        '  uri: $uri\n'
        '  alternativeImage?: ${alternativeImage != null ? 'yes' : 'no'}\n'
        ')';
  }
}

@immutable
class FetchFailure implements Exception {
  const FetchFailure._({
    @required this.totalDuration,
    @required this.attemptCount,
    this.httpStatusCode,
    this.originalException,
  }) : assert(totalDuration != null),
        assert(attemptCount > 0);

  final Duration totalDuration;
  final int attemptCount;
  final int httpStatusCode;
  final dynamic originalException;

  @override
  String toString() {
    return '$runtimeType(\n'
        '  attemptCount: $attemptCount\n'
        '  httpStatusCode: $httpStatusCode\n'
        '  totalDuration: $totalDuration\n'
        '  originalException: $originalException\n'
        ')';
  }
}


class _Uint8ListBuilder {
  static const int _kInitialSize = 100000;  // 100KB-ish

  int _usedLength = 0;
  Uint8List _buffer = new Uint8List(_kInitialSize);

  Uint8List get data => new Uint8List.view(_buffer.buffer, 0, _usedLength);

  void add(List<int> bytes) {
    _ensureCanAdd(bytes.length);
    _buffer.setAll(_usedLength, bytes);
    _usedLength += bytes.length;
  }

  void _ensureCanAdd(int byteCount) {
    final int totalSpaceNeeded = _usedLength + byteCount;

    int newLength = _buffer.length;
    while (totalSpaceNeeded > newLength) {
      newLength *= 2;
    }

    if (newLength != _buffer.length) {
      final Uint8List newBuffer = new Uint8List(newLength);
      newBuffer.setAll(0, _buffer);
      newBuffer.setRange(0, _usedLength, _buffer);
      _buffer = newBuffer;
    }
  }
}


typedef bool TransientHttpStatusCodePredicate(int statusCode);


class FetchStrategyBuilder {
  static const List<int> defaultTransientHttpStatusCodes = const <int>[
    0,   // Network error
    408, // Request timeout
    500, // Internal server error
    502, // Bad gateway
    503, // Service unavailable
    504  // Gateway timeout
  ];

  const FetchStrategyBuilder({
    this.timeout: const Duration(seconds: 30),
    this.totalFetchTimeout: const Duration(minutes: 1),
    this.maxAttempts: 5,
    this.initialPauseBetweenRetries: const Duration(seconds: 1),
    this.exponentialBackoffMultiplier: 2,
    this.transientHttpStatusCodePredicate: defaultTransientHttpStatusCodePredicate,
  }) : assert(timeout != null),
        assert(totalFetchTimeout != null),
        assert(maxAttempts != null),
        assert(initialPauseBetweenRetries != null),
        assert(exponentialBackoffMultiplier != null),
        assert(transientHttpStatusCodePredicate != null);

  final Duration timeout;
  final Duration totalFetchTimeout;
  final int maxAttempts;
  final Duration initialPauseBetweenRetries;
  final num exponentialBackoffMultiplier;
  final TransientHttpStatusCodePredicate transientHttpStatusCodePredicate;
  static bool defaultTransientHttpStatusCodePredicate(int statusCode) {
    return defaultTransientHttpStatusCodes.contains(statusCode);
  }

  FetchStrategy build() {
    return (Uri uri, FetchFailure failure) async {
      if (failure == null) {
        return new FetchInstructions.attempt(
          uri: uri,
          timeout: timeout,
        );
      }

      final bool isRetriableFailure = transientHttpStatusCodePredicate(failure.httpStatusCode) ||
          failure.originalException is io.SocketException;

      if (!isRetriableFailure ||  // retrying will not help
          failure.totalDuration > totalFetchTimeout ||  // taking too long
          failure.attemptCount > maxAttempts) {  // too many attempts
        return new FetchInstructions.giveUp(uri: uri);
      }

      final Duration pauseBetweenRetries = initialPauseBetweenRetries * math.pow(exponentialBackoffMultiplier, failure.attemptCount - 1);
      await new Future<Null>.delayed(pauseBetweenRetries);

      return new FetchInstructions.attempt(
        uri: uri,
        timeout: timeout,
      );
    };
  }
}
