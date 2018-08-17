import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

Stream<HaloProject> get allProjects {
  var file = new File('projects.txt');
  return file
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .map(Uri.parse)
      .map((gitUrl) => HaloProject(gitUrl));
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
      throw new StateError(
          'Process ${p.pid} terminated with exit code ${p.exitCode}.');
    }
  }

  Future clone() async {
    await _expectExitCodeZero(await Process.start(
        'git', ['clone', gitUrl.toString(), directory.absolute.path],
        mode: ProcessStartMode.inheritStdio));
  }

  Future update() async {
    await _expectExitCodeZero(await Process.start(
        'git', ['pull', 'origin', 'master'],
        workingDirectory: directory.absolute.path,
        mode: ProcessStartMode.inheritStdio));

    await _expectExitCodeZero(await Process.start('pub', ['upgrade'],
        workingDirectory: directory.absolute.path,
        mode: ProcessStartMode.inheritStdio));
  }
}
