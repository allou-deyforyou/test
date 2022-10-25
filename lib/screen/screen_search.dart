import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '_screen.dart';

class HomeLocationSearchScreen extends StatefulWidget {
  const HomeLocationSearchScreen({super.key});

  static const path = 'search';
  static const name = 'location_search';

  @override
  State<HomeLocationSearchScreen> createState() => _HomeLocationSearchScreenState();
}

class _HomeLocationSearchScreenState extends State<HomeLocationSearchScreen> {
  /// Customs
  late final TextEditingController _searchTextController;

  void _listenSearchTextController(BuildContext context, TextEditingValue value) {
    _searchDestinationPlaces(value.text);
  }

  /// LocationService
  late final LocationService _locationService;
  StreamSubscription? _locationSubscription;
  LocationData? _myPosition;

  Future<void> _getLocation() {
    return _locationService.handle(
      const GetLocation(
        distanceFilter: 0.0,
        subscription: true,
      ),
    );
  }

  void _listenLocationState(BuildContext context, LocationState state) {
    if (state is LocationItemState) {
      _locationSubscription = state.subscription;
      _myPosition = state.data;
    }
  }

  /// PlaceService
  late final PlaceService _destinationPlaceService;
  late List<PlaceSchema> _destinationPlaceItems;

  void _searchDestinationPlaces(String query) async {
    _destinationPlaceService.handle(
      FetchPlaces(
        longitude: _myPosition?.longitude,
        latitude: _myPosition?.latitude,
        type: PlaceType.geocoding,
        locationBiasScale: 0.0,
        query: query,
        limit: 10,
        zoom: 20,
      ),
    );
  }

  void _listenDestinationPlaceService(BuildContext context, PlaceState state) {
    if (state is PlaceItemListState) {
      _destinationPlaceItems = state.data;
    }
  }

  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();

    /// LocationService
    _locationService = LocationService.instance();
    if (_locationService.value is! LocationItemState) _getLocation();

    /// PlaceService
    _destinationPlaceService = PlaceService();
    _destinationPlaceItems = List.empty(growable: true);
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableListener(
      listener: _listenLocationState,
      valueListenable: _locationService,
      child: ValueListenableListener<TextEditingValue>(
        initiated: true,
        listener: _listenSearchTextController,
        valueListenable: _searchTextController,
        child: Scaffold(
          body: CustomScrollView(
            controller: ModalScrollController.of(context),
            slivers: [
              const SliverPinnedHeader(child: CustomBar()),
              SliverPinnedHeader(
                child: HomeListTile(
                  onPressed: () {},
                  leading: const HomePrefixText(
                    "De",
                    color: CupertinoColors.activeBlue,
                  ),
                  title: const Text("Quartier Akeikoi"),
                ),
              ),
              const SliverPinnedHeader(child: CustomDivider(indent: 16.0, endIndent: 16.0)),
              SliverPinnedHeader(
                child: HomeLocationSearchTextField(
                  prefixText: HomePrefixText(
                    "À",
                    color: context.theme.indicatorColor,
                  ),
                  controller: _searchTextController,
                  placeholder: "Où aller ?",
                ),
              ),
              ValueListenableConsumer(
                listener: _listenDestinationPlaceService,
                valueListenable: _destinationPlaceService,
                builder: (context, state, child) {
                  final childCount = max(0, _destinationPlaceItems.length * 2 - 1);
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index.isEven) {
                          index ~/= 2;
                          final item = _destinationPlaceItems[index];
                          return CustomListTile(
                            title: Text(item.title!),
                          );
                        }
                        return child;
                      },
                      childCount: childCount,
                    ),
                  );
                },
                child: const Divider(indent: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
