import 'dart:io';

import 'package:dart_amqp/dart_amqp.dart';

Future<void> receiveQueuedMessages(ConnectionSettings settings) async {
  final client = Client(settings: settings);

  ProcessSignal.sigint.watch().listen((_) async {
    await client.close();
    exit(0);
  });

  final channel = await client.channel();

  const queueName = 'myqueue';
  final queue = await channel.queue(queueName, durable: true);

  final consumer = await queue.consume(noAck: false);

  print(' [*] Waiting for logs on queue ${consumer.queue.name}. To exit, press CTRL+C');

  var counter = 1;

  consumer.listen((message) {
    message.ack();
    print(' [$counter] Received ${message.payloadAsString}');
    counter++;
  });
}
