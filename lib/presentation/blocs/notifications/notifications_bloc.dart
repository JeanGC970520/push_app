import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:push_app/firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(const NotificationsState()) {

    on<NotificationsStatusChanged>(_notificationsStatusChanged);

    // Checking the notifications permissions
    _initialStatusCheck();
    // Listen Firebase Cloude message on Foreground case
    _onForegroundMessage();

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

  void _handleRemoteMessage( RemoteMessage message ) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification == null) return;
   
    print('Message also contained a notification: ${message.notification}');
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
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
