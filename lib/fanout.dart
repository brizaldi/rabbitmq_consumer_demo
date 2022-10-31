import 'dart:io';

import 'package:dart_amqp/dart_amqp.dart';

Future<void> receiveFanOutMessages(ConnectionSettings settings) async {
  final client = Client(settings: settings);

  ProcessSignal.sigint.watch().listen((_) async {
    await client.close();
    exit(0);
  });

  final channel = await client.channel();

  const exchangeName = 'amq.fanout';
  const exchangeType = ExchangeType.FANOUT;

  final exchange1 = await channel.exchange(
    exchangeName,
    exchangeType,
    durable: true,
  );
  final exchange2 = await channel.exchange(
    exchangeName,
    exchangeType,
    durable: true,
  );
  final exchange3 = await channel.exchange(
    exchangeName,
    exchangeType,
    durable: true,
  );
  final exchange4 = await channel.exchange(
    exchangeName,
    exchangeType,
    durable: true,
  );

  final consumer1 = await exchange1.bindPrivateQueueConsumer(['*.broadcast']);
  final consumer2 = await exchange2.bindPrivateQueueConsumer(['*.broadcast']);
  final consumer3 = await exchange3.bindPrivateQueueConsumer(['*.broadcast']);
  final consumer4 = await exchange4.bindPrivateQueueConsumer(['*.broadcast']);

  print(
      ' [*] Waiting for logs on exchange $exchangeName:$exchangeType private queue ${consumer1.queue.name}. To exit, press CTRL+C');
  print(
      ' [*] Waiting for logs on exchange $exchangeName:$exchangeType private queue ${consumer2.queue.name}. To exit, press CTRL+C');
  print(
      ' [*] Waiting for logs on exchange $exchangeName:$exchangeType private queue ${consumer3.queue.name}. To exit, press CTRL+C');
  print(
      ' [*] Waiting for logs on exchange $exchangeName:$exchangeType private queue ${consumer4.queue.name}. To exit, press CTRL+C');

  var counter = 1;

  consumer1.listen((message) {
    print(' [$counter] [consumer1] Received ${message.payloadAsString}');
    counter++;
  });
  consumer2.listen((message) {
    print(' [$counter] [consumer2] Received ${message.payloadAsString}');
    counter++;
  });
  consumer3.listen((message) {
    print(' [$counter] [consumer3] Received ${message.payloadAsString}');
    counter++;
  });
  consumer4.listen((message) {
    print(' [$counter] [consumer4] Received ${message.payloadAsString}');
    counter++;
  });
}
