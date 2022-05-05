import 'package:equatable/equatable.dart';
import 'package:join_me/utilities/keys/conversation_keys.dart';
import 'package:json_annotation/json_annotation.dart';

part 'conversation.g.dart';

enum ConversationType {
  @JsonValue('dm')
  directMessage,
  @JsonValue('group')
  group,
  unknown,
}

@JsonSerializable()
class Conversation extends Equatable {
  const Conversation({
    required this.id,
    required this.createdAt,
    required this.creator,
    required this.type,
    required this.members,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationToJson(this);
  //Properties
  @JsonKey(name: ConversationKeys.id)
  final String id;
  @JsonKey(name: ConversationKeys.createdAt)
  final DateTime createdAt;
  @JsonKey(name: ConversationKeys.creator)
  final String creator;
  @JsonKey(name: ConversationKeys.type)
  final ConversationType type;
  @JsonKey(name: ConversationKeys.members)
  final List<String> members;

  @override
  List<Object> get props {
    return [id, createdAt, creator, type, members];
  }
}
