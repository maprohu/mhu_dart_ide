part of 'config.dart';

ProtoCustomizer configProtoCustomizer({
  required ShaftCalcBuildBits shaftCalcBuildBits,
}) {
  final protoCustomizer = ProtoCustomizer();

  protoCustomizer.mapEntryLabel.put(
    MdiConfigMsg$.workspaces,
    (mapEntry) => mapEntry.value.name.orIfBlank(
      () => "(${mapEntry.key})",
    ),
  );

  final ids = shaftCalcBuildBits.configFw.ids;
  int nextId() {
    ids.update((v) => v + 1);
    return ids.read();
  }

  protoCustomizer.mapDefaultKey.put(
    MdiConfigMsg$.workspaces,
    nextId,
  );

  protoCustomizer.messageEditOptions.put(
    MdiWorkspaceMsg.getDefault(),
    (messageEditingBits) {
      return (shaftBuilderBits) {
        final message = messageEditingBits.watchValue();
        if (message == null) {
          return [];
        }
        return [
            MenuItem(
              label: "Scan for Dart Packages",
              callback: () {
                shaftBuilderBits.longRunningTasksController.addLongRunningTask(
                  (taskIdentifier) {
                    return LongRunningTaskBuildBits.create<int>(
                      taskIdentifier: taskIdentifier,
                      future: Future.delayed(
                        const Duration(
                          seconds: 3,
                        ),
                      ).then((_) => 0),
                      longTermBusy: ComposedLongTermBusy(
                        buildShaftContent: (sizedBits) => [],
                        watchLabel: () {
                          final name = messageEditingBits.watchValue()?.name ??
                              "<missing>";
                          return "Scanning for Dart Packages: $name";
                        },
                      ),
                      longTermComplete: ComposedLongTermComplete(
                        buildLongTermCompleteView:
                            (sizedShaftBuilderBits, value) {
                          return [];
                        },
                        watchLongTermCompleteLabel: (value) {
                          final name = messageEditingBits.watchValue()?.name ??
                              "<missing>";
                          return "Finished Scanning for Dart Packages: $name";
                        },
                      ),
                    );
                    // return ComposedLongRunningTaskBuildBits(
                    //   longRunningTaskMenuItem: (shaftCalcBuildBits) {
                    //     return DynamicMenuItem(
                    //       labelBuilder: (size) {
                    //         final sizedBits =
                    //             ComposedSizedShaftBuilderBits.shaftBuilderBits(
                    //           shaftBuilderBits: shaftBuilderBits,
                    //           size: size,
                    //         );
                    //         return sizedBits.itemText.centerLeft(
                    //           "Scanning for Dart Packages: ${message.name}",
                    //         );
                    //       },
                    //       opCallbackIndirect: () => null,
                    //     );
                    //   },
                    // );
                  },
                );
              },
            ),
          ];
      };
    },
  );

  return protoCustomizer;
}
