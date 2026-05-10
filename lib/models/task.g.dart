// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      tag: json['tag'] as String?,
      due: json['due'] == null ? null : DateTime.parse(json['due'] as String),
      done: json['done'] as bool? ?? false,
      archived: json['archived'] as bool? ?? false,
    );

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'createdAt': instance.createdAt.toIso8601String(),
      'tag': instance.tag,
      'due': instance.due?.toIso8601String(),
      'done': instance.done,
      'archived': instance.archived,
    };
