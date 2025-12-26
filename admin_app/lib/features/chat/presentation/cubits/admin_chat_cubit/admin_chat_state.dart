part of 'admin_chat_cubit.dart';

abstract class AdminChatState extends Equatable {
  const AdminChatState();
  @override
  List<Object> get props => [];
}

class AdminChatInitial extends AdminChatState {}

class AdminChatLoading extends AdminChatState {}

class AdminChatLoaded extends AdminChatState {
  final List<Map<String, dynamic>> users;
  const AdminChatLoaded(this.users);
  @override
  List<Object> get props => [users];
}

class AdminChatError extends AdminChatState {
  final String message;
  const AdminChatError(this.message);
}
