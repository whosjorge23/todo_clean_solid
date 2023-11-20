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
      category: $enumDecode(_$TodoCategoryEnumMap, json['category']),
    );

Map<String, dynamic> _$$TodoImplToJson(_$TodoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'isCompleted': instance.isCompleted,
      'dateTimestamp': instance.dateTimestamp,
      'priority': _$TodoPriorityEnumMap[instance.priority]!,
      'category': _$TodoCategoryEnumMap[instance.category]!,
    };

const _$TodoPriorityEnumMap = {
  TodoPriority.Low: 'Low',
  TodoPriority.Medium: 'Medium',
  TodoPriority.High: 'High',
  TodoPriority.Maximum: 'Maximum',
};

const _$TodoCategoryEnumMap = {
  TodoCategory.All: 'All',
  TodoCategory.Grocery: 'Grocery',
  TodoCategory.Shopping: 'Shopping',
  TodoCategory.Todo: 'Todo',
};
