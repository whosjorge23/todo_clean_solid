// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TodoImpl _$$TodoImplFromJson(Map<String, dynamic> json) => _$TodoImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool,
      dateTimestamp: json['dateTimestamp'] as String,
      priority: $enumDecode(_$TodoPriorityEnumMap, json['priority']),
      category: json['category'] as String,
    );

Map<String, dynamic> _$$TodoImplToJson(_$TodoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'isCompleted': instance.isCompleted,
      'dateTimestamp': instance.dateTimestamp,
      'priority': _$TodoPriorityEnumMap[instance.priority]!,
      'category': instance.category,
    };

const _$TodoPriorityEnumMap = {
  TodoPriority.low: 'low',
  TodoPriority.medium: 'medium',
  TodoPriority.high: 'high',
  TodoPriority.maximum: 'maximum',
};
