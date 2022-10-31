import 'package:args/args.dart';
import 'package:dart_amqp/dart_amqp.dart';
import 'package:rabbitmq_consumer/fanout.dart';
import 'package:rabbitmq_consumer/round_robin.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()..addOption('type');

  final argResults = parser.parse(arguments);
  final type = argResults['type'] as String?;

  final settings = ConnectionSettings(
    host: '127.0.0.1',
    port: 5672,
    authProvider: PlainAuthenticator(
      'admin',
      'admin12345',
    ),
  );

  switch (type) {
    case 'fanout':
      await receiveFanOutMessages(settings);
      break;
    default:
      await receiveQueuedMessages(settings);
  }
}
