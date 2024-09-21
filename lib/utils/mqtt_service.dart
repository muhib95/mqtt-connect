import 'dart:async';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  late MqttServerClient client;
  Timer? _statusTimer; // Timer for status publishing


  Future<MqttClient> connect() async {
    client = MqttServerClient.withPort('broker.emqx.io', 'flutter_client', 1883);
    client.logging(on: true);
    client.keepAlivePeriod = 60;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onUnsubscribed = onUnsubscribed;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;

    // Security context
//  SecurityContext context = new SecurityContext()
//    ..useCertificateChain('path/to/my_cert.pem')
//    ..usePrivateKey('path/to/my_key.pem', password: 'my_key_password')
//    ..setClientAuthorities('path/to/client.crt', password: 'password');
//  client.secure = true;
//  client.securityContext = context;

    final connMess = MqttConnectMessage()
        .authenticateAs("username", "password")
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMess;
    try {
      print('Connecting');
      await client.connect();
      print('connected');
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }
    print("connected");

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMessage = c![0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);

      print('Received message:$payload from topic: ${c[0].topic}');
    });

    return client;
  }

// Connected callback
  void onConnected() {
    print('Connected');
  }

// Disconnected callback
  void onDisconnected() {
    print('Disconnected');
  }

// Subscribed callback
  void onSubscribed(String topic) {
    print('Subscribed topic: $topic');
  }

// Subscribed failed callback
  void onSubscribeFail(String topic) {
    print('Failed to subscribe $topic');
  }

// Unsubscribed callback
  void onUnsubscribed(String? topic) {
    print('Unsubscribed topic: $topic');
  }

// Ping callback
  void pong() {
    print('Ping response client callback invoked');
  }


  // Method to start publishing status every 25 seconds
  void startPublishingStatus() {
    _statusTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      publishStatus('online'); // Publish the current status
    });
  }



  // Method to publish a status message
  void publishStatus(String status) {
    const String statusTopic = 'your/status/topic'; // Change to your desired topic

    final builder = MqttClientPayloadBuilder();
    builder.addString(status); // Add the status message

    // Publish the message
    client.publishMessage(statusTopic, MqttQos.atLeastOnce, builder.payload!);
    print('Published status: $status to topic: $statusTopic');
  }

}
