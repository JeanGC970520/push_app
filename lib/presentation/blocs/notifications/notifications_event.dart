part of 'notifications_bloc.dart';

abstract class NotificationsEvent  {
  const NotificationsEvent();
}

class NotificationsStatusChanged extends NotificationsEvent {
  NotificationsStatusChanged(this.status);
  final AuthorizationStatus status;
}

//TODO: 2. create NotificationReceived with an argument PushMessage
class NotificationReceived extends NotificationsEvent {
  NotificationReceived(this.notification);
  final PushMessage notification;
}