// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyPlanImpl _$$DailyPlanImplFromJson(Map<String, dynamic> json) =>
    _$DailyPlanImpl(
      date: json['date'] as String,
      mainTaskId: json['mainTaskId'] as String?,
      subTaskIds: (json['subTaskIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      completedMain: json['completedMain'] as bool? ?? false,
      streakCount: (json['streakCount'] as num?)?.toInt() ?? 0,
      plantStage: (json['plantStage'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DailyPlanImplToJson(_$DailyPlanImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'mainTaskId': instance.mainTaskId,
      'subTaskIds': instance.subTaskIds,
      'completedMain': instance.completedMain,
      'streakCount': instance.streakCount,
      'plantStage': instance.plantStage,
    };
