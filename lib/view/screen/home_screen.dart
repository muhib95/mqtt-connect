import 'package:flutter/material.dart';

import '../../utils/mqtt_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


@override

class _HomeScreenState extends State<HomeScreen> {
  late MqttService mqttService = MqttService();

  void initState() {

    super.initState();
    // mqttService = MqttService();
    statusPublish();


  }
  void statusPublish() async{
   await mqttService.connect();
    // mqttService.publishStatus('online');
   mqttService.startPublishingStatus();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Mqtt'),
        centerTitle: true,
      ),
    );
  }
}
