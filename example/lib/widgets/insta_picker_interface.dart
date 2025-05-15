import 'dart:io';

import 'package:as_instapicker/as_instapicker.dart';
import 'package:camera/camera.dart';
import 'package:example/widgets/crop_result_view.dart';
import 'package:flutter/material.dart';

class PickerDescription {
  final String icon;
  final String label;
  final String? description;

  const PickerDescription({
    required this.icon,
    required this.label,
    this.description,
  });

  String get fullLabel => '$icon $label';
}

mixin InstaPickerInterface on Widget {
  PickerDescription get description;

  ThemeData getPickerTheme(BuildContext context) {
    return InstaAssetPicker.themeData(Colors.amber).copyWith(
      appBarTheme: const AppBarTheme(titleTextStyle: TextStyle(fontSize: 16)),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  AppBar get _appBar => AppBar(title: Text(description.fullLabel));

  /// NOTE: Exception on android when playing video recorded from the camera
  /// with [ResolutionPreset.max] after FFmpeg encoding
  ResolutionPreset get cameraResolutionPreset =>
      Platform.isAndroid ? ResolutionPreset.high : ResolutionPreset.max;

  Column pickerColumn({
    String? text,
    required VoidCallback onPressed,
  }) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              text ??
                  'The ${description.label} will push result in a new screen',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: onPressed,
            child: FittedBox(
              child: Text(
                'Open the ${description.label}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      );

  Scaffold buildLayout(
    BuildContext context, {
    required VoidCallback onPressed,
  }) =>
      Scaffold(
        appBar: _appBar,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: pickerColumn(onPressed: onPressed),
        ),
      );

  Scaffold buildCustomLayout(
    BuildContext context, {
    required Widget child,
  }) =>
      Scaffold(
        appBar: _appBar,
        body: Padding(padding: const EdgeInsets.all(16), child: child),
      );

  void pickAssets(BuildContext context, {required int maxAssets}) =>
      InstaAssetPicker.pickAssets(
        context,
        canCrop: false,
        restrictVideoDuration: true,
        restrictVideoDurationMax: 60,
        showSelectedCount: true,
        maxAssets: maxAssets,
        fit: BoxFit.contain,
        indicatorColor: Colors.red,
        confirmIcon: const Icon(Icons.check, color: Colors.red),
        indicatorTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        pickerConfig: InstaAssetPickerConfig(
          title: description.fullLabel,
          closeOnComplete: true,
          pickerTheme: getPickerTheme(context),
          actionsBuilder: (context, pickerTheme, height, unselectAll) => [],
          // skipCropOnComplete: true, // to test ffmpeg crop image
          // previewThumbnailSize: const ThumbnailSize(240, 240), // to improve thumbnails speed in crop view
        ),
        onCompleted: (Stream<InstaExportDetails> cropStream) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PickerCropResultScreen(cropStream: cropStream),
            ),
          );
        },
      );
}
