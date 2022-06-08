part of 'messages_bloc.dart';

abstract class MessagesState extends Equatable {
  const MessagesState();
  
  @override
  List<Object> get props => [];
}

class MessagesInitial extends MessagesState {}
