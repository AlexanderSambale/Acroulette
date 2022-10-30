import 'package:acroulette/bloc/position_administration/position_administration_bloc.dart';
import 'package:acroulette/components/posture_tree/posture_tree.dart';
import 'package:acroulette/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Positions extends StatefulWidget {
  const Positions({Key? key}) : super(key: key);

  @override
  State<Positions> createState() => _PositionsState();
}

class _PositionsState extends State<Positions> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            BlocProvider(
              create: (_) => PositionAdministrationBloc(objectbox),
              child: BlocBuilder<PositionAdministrationBloc,
                      BasePositionAdministrationState>(
                  buildWhen: (previous, current) =>
                      current is PositionAdministrationInitialState,
                  builder: (BuildContext context, state) {
                    PositionAdministrationBloc positionAdministrationBloc =
                        context.read<PositionAdministrationBloc>();
                    return PostureTree(
                        tree: state.tree,
                        onSwitched: positionAdministrationBloc.onSwitch,
                        toggleExpand: positionAdministrationBloc.toggleExpand,
                        onDeleteClick: positionAdministrationBloc.onDeleteClick,
                        onEditClick: positionAdministrationBloc.onEditClick,
                        onSaveClick: positionAdministrationBloc.onSaveClick,
                        path: const [],
                        listAllNodesRecursively:
                            positionAdministrationBloc.listAllNodesRecursively,
                        validator: positionAdministrationBloc.validator);
                  }),
            )
          ],
        ));
  }
}
