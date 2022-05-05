import 'package:equatable/equatable.dart';
import 'package:join_me/utilities/keys/message_keys.dart';

import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message extends Equatable {
  const Message({
    required this.conversationId,
    required this.createdAt,
    required this.authorId,
    required this.content,
  });
  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  //properties
  @JsonKey(name: MessageKeys.conversationId)
  final String conversationId;
  @JsonKey(name: MessageKeys.createdAt)
  final DateTime createdAt;
  @JsonKey(name: MessageKeys.authorId)
  final String authorId;
  @JsonKey(name: MessageKeys.content)
  final String content;

  Message copyWith({
    String? conversationId,
    DateTime? createdAt,
    String? authorId,
    String? content,
  }) {
    return Message(
      conversationId: conversationId ?? this.conversationId,
      createdAt: createdAt ?? this.createdAt,
      authorId: authorId ?? this.authorId,
      content: content ?? this.content,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [conversationId, createdAt, authorId, content];
}
