import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';

import '_service.dart';

class PlaceService extends ValueNotifier<PlaceState> {
  PlaceService([
    PlaceState value = const InitPlaceState(),
  ]) : super(value);

  static PlaceService? _instance;
  static PlaceService instance([
    PlaceState value = const InitPlaceState(),
  ]) {
    return _instance ??= PlaceService(value);
  }

  Future<void> handle(PlaceEvent event) => event._execute(this);
}

abstract class PlaceEvent {
  const PlaceEvent();

  Future<void> _execute(PlaceService service);
}

class FetchPlaces extends PlaceEvent {
  const FetchPlaces({
    this.type = PlaceType.geocoding,
    this.locationBiasScale,
    this.queryStringFilter,
    this.distanceSort,
    this.boundingBox,
    this.longitude,
    this.latitude,
    this.osmTags,
    this.layers,
    this.radius,
    this.limit,
    this.query,
    this.debug,
    this.zoom,
  });

  /// Expected format is minLon,minLat,maxLon,maxLat.
  final List<double>? boundingBox;

  /// Expected values are house , street, locality, district, city, county,
  /// state, country
  final List<String>? layers;

  final List<String>? queryStringFilter;
  final double? locationBiasScale;
  final List<String>? osmTags;
  final bool? distanceSort;
  final double? longitude;
  final double? latitude;
  final double? radius;
  final String? query;
  final bool? debug;
  final int? limit;
  final int? zoom;

  /// Expected params for [PlaceType.reverseGeocoding] are [query_string_filter,
  /// limit, distance_sort, lon, lang, radius, lat, layer, debug]
  /// Expected params for [PlaceType.geocoding] are [q, debug, bbox, lat, layer,
  ///  limit, osm_tag, lon, zoom, lang, location_bias_scale]
  final PlaceType type;

  String get _url => 'https://photon.komoot.io/$_path?$params';

  String get _path => type.isGeocoding() ? 'api' : 'reverse';

  String get params {
    var language = window.locale.languageCode.toLowerCase();
    var values = ['lang=$language'];
    if (query != null) {
      values.add('q=$query');
    }
    if (zoom != null) {
      values.add('zoom=$zoom');
    }
    if (debug != null) {
      values.add('debug=$debug');
    }
    if (limit != null) {
      values.add('limit=$limit');
    }
    if (radius != null) {
      values.add('radius=$radius');
    }
    if (distanceSort != null) {
      values.add('distance_sort=$distanceSort');
    }
    if (longitude != null && latitude != null) {
      values.add('lat=$latitude&lon=$longitude');
    }
    if (boundingBox != null) {
      values.add("bbox=${boundingBox!.join(',')}");
    }
    if (locationBiasScale != null) {
      values.add('location_bias_scale=$locationBiasScale');
    }
    if (layers != null) {
      values.add(layers!.map((e) => 'layer=$e').join('&'));
    }
    if (osmTags != null) {
      values.add(osmTags!.map((e) => 'osm_tag=$e').join('&'));
    }
    if (queryStringFilter != null) {
      values.add(
        queryStringFilter!.map((e) => 'query_string_filter=$e').join('&'),
      );
    }
    return values.join('&');
  }

  static HttpClientRequest? _request;

  @override
  Future<void> _execute(PlaceService service) async {
    service.value = const PendingPlaceState();
    _request?.abort();
    if (query != null && query!.isEmpty) {
      service.value = PlaceItemListState(data: List.empty());
    } else {
      _request = await HttpClient().getUrl(Uri.parse(_url));
      await _request?.close().then((response) async {
        final body = await response.transform(utf8.decoder).join();
        final data = await compute(PlaceSchema.fromRawJsonList, body);
        service.value = PlaceItemListState(data: data);
      }, onError: (error) {
        log(error.toString());
        service.value = FailurePlaceState(
          message: error.toString(),
          event: this,
        );
      });
    }
  }
}
