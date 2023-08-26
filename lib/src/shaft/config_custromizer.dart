part of 'config.dart';

ProtoCustomizer configProtoCustomizer({
  required ShaftCalcBuildBits shaftCalcBuildBits,
}) {
  final protoCustomizer = ProtoCustomizer();

  protoCustomizer.mapEntryLabel.put(
    MshConfigMsg$.workspaces,
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
    MshConfigMsg$.workspaces,
    nextId,
  );

  protoCustomizer.mapEntryExtraContent.put(
    MshConfigMsg$.workspaces,
    (mapEntry) {
      return (sizedBits) {
        final workspaceIdentifier = mapEntry.key;

        return sizedBits.menu([
          MenuItem(
            label: "Scan for Dart Packages",
            callback: () {
              final taskIdentifier =
                  sizedBits.ensureScanWorkspaceForDartPackages(
                workspaceIdentifier: workspaceIdentifier,
              );

              sizedBits.openLongRunningTaskShaft(
                shaftCalc: sizedBits,
                taskIdentifier: taskIdentifier,
              );
            },
          )
        ]).toSingleElementIterable;
      };
    },
  );

  return protoCustomizer;
}
