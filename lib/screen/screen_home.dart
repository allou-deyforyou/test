import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:maplibre_gl/mapbox_gl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const path = '/';
  static const name = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  /// MapService
  MaplibreMapController? _mapController;

  void _goToSearch() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return const HomeLocationSearchScreen();
      },
    );
  }

  @override
  void initState() {
    super.initState();

    /// LocationService
    _locationService = LocationService.instance();
    if (_locationService.value is! LocationItemState) _getLocation();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
      side: const BorderSide(color: CupertinoColors.systemFill),
    );
    return ValueListenableListener(
      listener: _listenLocationState,
      valueListenable: _locationService,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: const HomeLocationAppBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: FloatingActionButton.small(
          shape: shape,
          elevation: 0.8,
          onPressed: () {
            if (_myPosition != null) {
              _mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(
                  LatLng(_myPosition!.latitude!, _myPosition!.longitude!),
                  14,
                ),
              );
            }
          },
          backgroundColor: context.theme.colorScheme.surface,
          child: const Icon(Icons.my_location_rounded),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 60.0, left: 16.0, right: 16.0),
          child: CustomFloatingButton(
            shape: shape,
            elevation: 8.0,
            onPressed: _goToSearch,
            child: const Padding(
              padding: EdgeInsets.all(5.0),
              child: HomeSearchTextField(
                placeholder: "Hi, Où aller ?",
                enabled: false,
              ),
            ),
          ),
        ),
        body: HomeLocationMap(
          onMapCreated: (controller) {
            _mapController = controller;
          },
        ),
      ),
    );
  }
}
