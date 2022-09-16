import 'package:acroulette/constants/nodes.dart';
import 'package:acroulette/database/objectbox.g.dart';
import 'package:acroulette/models/acro_node.dart';
import 'package:acroulette/models/node.dart';
import 'package:acroulette/objectboxstore.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'position_administration_event.dart';
part 'position_administration_state.dart';

class PositionAdministrationBloc
    extends Bloc<PositionAdministrationEvent, BasePositionAdministrationState> {
  PositionAdministrationBloc(this.objectbox)
      : super(PositionAdministrationInitialState()) {
    QueryBuilder<Node> builder = objectbox.nodeBox.query();
    builder.link(
        Node_.value,
        AcroNode_.predefined.equals(true) &
            AcroNode_.label.equals(BASIC_POSTURES));
    Query<Node> query = builder.build();
    Node? tmpTree = query.findUnique();
    query.close();
    // Error handling ToDo
    if (tmpTree == null) {
      throw Error();
    }
    tree = tmpTree;

    on<PositionsBDStartChangeEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<PositionsDBIsChangingEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<PositionsDBIsIdleEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  late ObjectBox objectbox;
  late Node tree;

  /// Depending on [isSwitched] we enable or disable recursive [acroNodes] from
  /// this [tree].
  ///
  /// Here is a table, what to do in which case.
  ///
  /// state | toEnable | toDisable
  /// ----|----|----
  /// enabled switch on| /| disabled on, disable others
  /// disable switch on| enable on, enable others| /
  /// enabled switch off| /| disable off, nothing else
  /// disable switch off| enable off, nothing else|/
  void enableOrDisableAndAddAcroNodes(
      List<AcroNode> acroNodes, Node tree, bool isSwitched) {
    for (var node in tree.children) {
      AcroNode acroNode = node.value.target!;
      if (acroNode.isSwitched) {
        enableOrDisableAndAddAcroNodes(acroNodes, node, isSwitched);
      }
      acroNode.isEnabled = isSwitched;
      acroNodes.add(acroNode);
    }
  }

  void onSwitch(bool switched, Node tree) {
    AcroNode acroNode = tree.value.target!;
    acroNode.isSwitched = switched;
    List<AcroNode> acroNodes = [];
    enableOrDisableAndAddAcroNodes(acroNodes, tree, switched);
    acroNodes.add(acroNode);
    objectbox.putManyAcroNodes(acroNodes);
    objectbox.putNode(tree);
  }

  void toggleExpand(Node tree) {
    tree.isExpanded = !tree.isExpanded;
    objectbox.putNode(tree);
  }
}
