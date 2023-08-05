part of 'notifications_bloc.dart';

class NotificationsState extends Equatable {
  const NotificationsState({
    this.status = AuthorizationStatus.notDetermined, 
    this.notifications = const [],
  });
  
  final AuthorizationStatus status;
  // TODO: Create notifications model
  final List<dynamic> notifications;
  
  @override
  List<Object> get props => [ status, notifications ];

  NotificationsState copyWith({
    AuthorizationStatus? status, 
    List<dynamic>? notifications,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
    );
  }
}