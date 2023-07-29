import 'dart:io';

import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mhu_dart_commons/commons.dart';
import 'package:mhu_dart_ide/src/app.dart';
import 'package:mhu_dart_ide/src/generated/mhu_dart_ide.pbfield.dart';
import 'package:mhu_dart_proto/mhu_dart_proto.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';



PfeConfig mdiSettingsEditorConfig({
  required MdiAppBits appBits,
}) {
  return PfeConfig().rebuild((builder) {
    // MdiDirectoryMsg$.path.configure(builder)
    //
    // ..fieldEditor((editor, input) {
    //   return MdiDirectoryMsg$.path.fieldKey.calc.access.listTile()
    // })
    //   ..createCollectionItem((editor, input) async {
    //     var path = await FilePicker.platform.getDirectoryPath(
    //       dialogTitle: "Select root directory to add",
    //       lockParentWindow: true,
    //       initialDirectory:
    //           appBits.configBits.config.read().latestDirectoryPathOpt,
    //     );
    //
    //     if (path == null) {
    //       return null;
    //     }
    //
    //     path = Directory(path).absolute.path;
    //
    //     if (input.mfw.read().rootPaths.contains(path)) {
    //       appBits.ui.messenger.showMessage("Root path already added.");
    //       return null;
    //     }
    //
    //     input.addToCollection(path);
    //
    //     return path;
    //   });
  });
}
