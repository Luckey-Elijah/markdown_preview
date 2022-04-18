import 'package:args/command_runner.dart';
import 'package:markdown_preview/markdown_preview.dart';
import 'package:mason_logger/mason_logger.dart';

Future<int?> main(List<String> args) async {
  final logger = Logger();
  final runner = CommandRunner<int>(
    'markdown_preview',
    'A starting point for a command line/console program.',
  )..addCommand(ServeCommand(logger));

  return runner.run(args);
}
