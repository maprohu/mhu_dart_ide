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
      final message = messageEditingBits.watchValue();
      if (message == null) {
        return null;
      }
      return (shaftBuilderBits) => [
            MenuItem(
              label: "Scan for Dart Packages",
              callback: () {
                shaftBuilderBits.longRunningTasksController.addLongRunningTask(
                  (identifier) {
                    return ComposedLongRunningTaskBuildBits(
                      longRunningTaskMenuItem: (shaftCalcBuildBits) {
                        return DynamicMenuItem(
                          labelBuilder: (size) {
                            final sizedBits =
                                ComposedSizedShaftBuilderBits.shaftBuilderBits(
                              shaftBuilderBits: shaftBuilderBits,
                              size: size,
                            );
                            return sizedBits.itemText.centerLeft(
                              "Scanning for Dart Packages: ${message.name}",
                            );
                          },
                          opCallbackIndirect: () => null,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ];
    },
  );

  return protoCustomizer;
}
