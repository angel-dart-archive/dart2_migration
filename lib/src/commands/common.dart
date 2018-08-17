import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import 'package:pubspec_parse/pubspec_parse.dart';

abstract class HaloCommand<T> extends Command<T> {
  Stream<HaloProject> get allProjects {
    var file = new File('projects.txt');
    return file
        .openRead()
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .map(Uri.parse)
        .map((gitUrl) => HaloProject(gitUrl))
        .where(
            (p) => argResults.rest.isEmpty || argResults.rest.contains(p.name));
  }
}

class HaloProject {
  final Uri gitUrl;

  HaloProject(this.gitUrl);

  String get name => p.basenameWithoutExtension(gitUrl.path);

  Directory get directory =>
      new Directory(p.join('.dart_tool', 'halo', 'projects', name));

  static Future _expectExitCodeZero(Process p) async {
    var code = await p.exitCode;

    if (code != 0) {
      throw new StateError('Process ${p.pid} terminated with exit code $code.');
    }
  }

  Future<Pubspec> parsePubspec() async {
    var file =
        new File.fromUri(p.toUri(p.join(directory.path, 'pubspec.yaml')));
    return Pubspec.parse(await file.readAsString(), sourceUrl: file.uri);
  }

  void enter() {
    print('Entering project $name...');
  }

  Future clone() async {
    enter();
    await _expectExitCodeZero(await Process.start(
        'git', ['clone', gitUrl.toString(), directory.absolute.path],
        mode: ProcessStartMode.inheritStdio));
  }

  Future update() async {
    enter();
    await _expectExitCodeZero(await Process.start(
        'git', ['pull', 'origin', 'master'],
        workingDirectory: directory.absolute.path,
        mode: ProcessStartMode.inheritStdio));

//    await _expectExitCodeZero(await Process.start('pub', ['upgrade'],
//        workingDirectory: directory.absolute.path,
//        mode: ProcessStartMode.inheritStdio));
  }
}
