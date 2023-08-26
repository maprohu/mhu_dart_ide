
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mhu_shafts/proto.dart';
import 'package:mhu_shafts/src/context/render.dart';
import 'package:mhu_flutter_commons/mhu_flutter_commons.dart';

import 'src/screen/app.dart';

void main() async {
  GoogleFonts.config.allowRuntimeFetching = false;
  WidgetsFlutterBinding.ensureInitialized();
  mhuDartIdeLib.register();

  final app = flcAsyncDisposeWidget(
    waiting: nullWidget,
    builder: (disposers) async {
      // final isar = await mdiCreateIsar();

      final persistCtx = await createPersistCtx(disposers: disposers);

      final assetCtx = await createAssetCtx();

      final configCtx = await persistCtx.createConfigCtx(
        assetCtx: assetCtx,
      );

      final appCtx = await configCtx.createAppCtx(disposers: disposers);

      final windowCtx = appCtx.appObj.windowCtx;

      return MshApp(
        windowObj: windowCtx.windowObj,
      );
    },
  );

  runApp(app);
}
