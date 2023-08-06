part of 'notifications_bloc.dart';

abstract class NotificationsEvent  {
  const NotificationsEvent();
}

class NotificationsStatusChanged extends NotificationsEvent {
  NotificationsStatusChanged(this.status);
  final AuthorizationStatus status;
}