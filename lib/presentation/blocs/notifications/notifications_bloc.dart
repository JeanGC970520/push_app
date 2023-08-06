import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:push_app/firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(const NotificationsState()) {

    on<NotificationsStatusChanged>(_notificationsStatusChanged);

    // Checking the notifications permissions
    _initialStatusCheck();

  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _notificationsStatusChanged(
    NotificationsStatusChanged event, Emitter<NotificationsState> emit
  ) {
    emit(
      state.copyWith(
        status: event.status,
      )
    );
    _getFCMToken();
  }

  void _initialStatusCheck() async {
    final setting = await messaging.getNotificationSettings();
    add( NotificationsStatusChanged(setting.authorizationStatus) );
  }

  // Get token Firebase Cloud Messaging
  void _getFCMToken() async {
    if( state.status != AuthorizationStatus.authorized ) return; 

    final token = await messaging.getToken();
    print(token); // The token is unique on every app installation
  }

  void requesPermission() async {

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    add( NotificationsStatusChanged(settings.authorizationStatus) );
  }

}
