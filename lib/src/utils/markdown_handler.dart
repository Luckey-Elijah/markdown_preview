import 'dart:io';

import 'package:markdown/markdown.dart';
import 'package:markdown_preview/markdown_preview.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart';
import 'package:recase/recase.dart';
import 'package:shelf/shelf.dart';

Response markdownHandler(Request request, Logger logger) {
  final fileExtension = url.extension(request.url.path).toLowerCase();
  if (!markdownExtensions.contains(fileExtension)) {
    return Response.notFound('This is not a markdown file');
  }

  var header = '';
  final path = joinAll([current, ...request.url.pathSegments]);
  final mdContent = File(path).readAsStringSync();
  final body = markdownToHtml(mdContent);
  var title = basenameWithoutExtension(path);
  final match = titlePattern.firstMatch(mdContent);
  if (match != null) {
    title = match[1]!;
  } else {
    header = '<h1>$title</h1>\n';
  }

  final html = template
      .replaceAll('{{title}}', title.titleCase)
      .replaceAll('{{header}}', header)
      .replaceAll('{{body}}', body);
  final headers = {HttpHeaders.contentTypeHeader: 'text/html'};

  logger.success('Serving $title');
  return Response.ok(html, headers: headers);
}
