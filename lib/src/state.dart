import 'package:mhu_dart_ide/proto.dart';


final mdiDefaultState = MdiStateMsg$.create()..freeze();

class StateCalc {
  final MdiStateMsg state;

  StateCalc(this.state);
}
