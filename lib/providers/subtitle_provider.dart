import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tri_task/constants/app_constants.dart';

part 'subtitle_provider.g.dart';

// ランダムなサブタイトルを提供するプロバイダー
@riverpod
String randomSubtitle(Ref ref) {
  final random = Random();
  final index = random.nextInt(AppConstants.appSubtitles.length);
  return AppConstants.appSubtitles[index];
}
