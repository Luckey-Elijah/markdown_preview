import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:markdown_preview/markdown_preview.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_static/shelf_static.dart';

class ServeCommand extends Command<int> {
  ServeCommand(this.logger);

  final Logger logger;

  @override
  Future<int> run() async {
    final handler = Cascade()
        .add((req) => markdownHandler(req, logger))
        .add(
          createStaticHandler(
            current,
            defaultDocument: 'index.html',
            listDirectories: true,
          ),
        )
        .handler;
    try {
      await serve(handler, Platform.localHostname, 8080).then(
        (server) => logger.success(
          'Serving at ${styleBold.wrap(
            'http://${server.address.host}'
            ':${server.port}',
          )}',
        ),
      );
      return 0;
    } catch (_) {
      return 1;
    }
  }

  @override
  String get description => 'Start the web server tat render the markdown.';

  @override
  String get name => 'serve';
}
