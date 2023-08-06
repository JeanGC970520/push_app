part of 'notifications_bloc.dart';

abstract class NotificationsEvent  {
  const NotificationsEvent();
}

class NotificationsStatusChanged extends NotificationsEvent {
  NotificationsStatusChanged(this.status);
  final AuthorizationStatus status;
}

// * event to notify that a notification arraived
class NotificationReceived extends NotificationsEvent {
  NotificationReceived(this.notification);
  final PushMessage notification;
}