import 'package:acroulette/bloc/flow_administration/flow_administration_bloc.dart';
import 'package:acroulette/widgets/dialogs/flow_dialog/create_flow_dialog.dart';
import 'package:acroulette/widgets/flows/flow_view.dart';
import 'package:acroulette/main.dart';
import 'package:acroulette/models/flow_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Flows extends StatelessWidget {
  const Flows({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => FlowAdministrationBloc(objectbox),
        child: BlocBuilder<FlowAdministrationBloc, BaseFlowAdministrationState>(
            buildWhen: (previous, current) =>
                current is FlowAdministrationState,
            builder: (BuildContext context, state) {
              List<FlowNode> flows = objectbox.flowNodeBox.getAll();
              FlowAdministrationBloc bloc =
                  context.read<FlowAdministrationBloc>();
              return Stack(children: [
                Card(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: flows.length,
                      itemBuilder: (context, index) {
                        return FlowView(
                          flow: flows[index],
                          toggleExpand: bloc.toggleExpand,
                          deletePosture: bloc.deletePosture,
                          deleteFlow: bloc.deleteFlow,
                          onEditClick: bloc.onEditClick,
                          onEditFlowClick: bloc.onEditFlowClick,
                          validator: bloc.validatorFlow,
                          onSavePostureClick: bloc.onSavePostureClick,
                        );
                      }),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      child: ElevatedButton(
                          child: const Icon(Icons.add_circle_rounded),
                          onPressed: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return CreateFlow(
                                    onSaveClick: bloc.onSaveFlowClick,
                                    validator: bloc.validatorFlow,
                                  );
                                }).then((exit) {
                              if (exit) return;
                            });
                          }),
                    ))
              ]);
            }));
  }
}
