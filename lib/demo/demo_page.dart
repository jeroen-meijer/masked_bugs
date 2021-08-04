import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:masked_bugs/demo/demo.dart';

/// {@template date_input_formatter}
/// A masked `TextInputFormatter` for dates.
///
/// Uses the format "MM/DD/YYYY".
/// {@endtemplate}
class DateInputFormatter extends MaskTextInputFormatter {
  /// {@macro date_input_formatter}
  DateInputFormatter({
    String? initialValue,
  }) : super(
          mask: '##/##/####',
          filter: {'#': RegExp('[0-9]')},
          initialText: initialValue,
        );
}

class DemoPage extends StatefulWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final _controller = PageController(
    viewportFraction: 0.8,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Masked Text Bug Demo'),
      ),
      body: PageView(
        controller: _controller,
        children: <Widget>[
          _PageCard(
            color: Colors.green,
            child: _GoodStatefulExample(
              triggerRebuild: () => setState(() {}),
            ),
          ),
          _PageCard(
            color: Colors.green,
            child: _GoodStatefulBlocExample(
              triggerRebuild: () => setState(() {}),
            ),
          ),
          _PageCard(
            color: Colors.green,
            child: _GoodStatelessBlocExample(
              triggerRebuild: () => setState(() {}),
            ),
          ),
          _PageCard(
            color: Colors.red,
            child: _BadStatelessExample(
              triggerRebuild: () => setState(() {}),
            ),
          ),
          _PageCard(
            color: Colors.red,
            child: _BadBlocExample(
              triggerRebuild: () => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageCard extends StatelessWidget {
  const _PageCard({
    Key? key,
    required this.color,
    required this.child,
  }) : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4.0),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: color,
          width: 2.0,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}

class _GoodStatefulExample extends StatefulWidget {
  const _GoodStatefulExample({
    Key? key,
    required this.triggerRebuild,
  }) : super(key: key);

  final VoidCallback triggerRebuild;

  @override
  __GoodStatefulExampleState createState() => __GoodStatefulExampleState();
}

class __GoodStatefulExampleState extends State<_GoodStatefulExample> {
  final formatter = DateInputFormatter();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good stateful example',
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(height: 4.0),
          Text(
            'This example shows a properly working masked text input '
            'formatter in a stateful widget.\n\n'
            'Try editing the text and triggering rebuilds while doing so. '
            'The formatter will be identical between rebuilds.\n\n'
            'Formatter hashcode: ${formatter.hashCode}',
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  inputFormatters: [formatter],
                ),
              ),
              const SizedBox(width: 8.0),
              OutlinedButton(
                onPressed: widget.triggerRebuild,
                child: const Text('Rebuild'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoodStatefulBlocExample extends StatefulWidget {
  const _GoodStatefulBlocExample({
    Key? key,
    required this.triggerRebuild,
  }) : super(key: key);

  final VoidCallback triggerRebuild;

  @override
  __GoodStatefulBlocExampleState createState() =>
      __GoodStatefulBlocExampleState();
}

class __GoodStatefulBlocExampleState extends State<_GoodStatefulBlocExample> {
  final formatter = DateInputFormatter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoCubit(),
      child: BlocBuilder<DemoCubit, String>(
        builder: (context, value) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good stateful Bloc example',
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(height: 4.0),
                Text(
                  'This example shows a properly working masked text input '
                  'formatter in a stateful widget using a Bloc to save the '
                  'text value.\n\n'
                  'Even though it is rebuilt on every keystore, the input '
                  'formatter value is preserved.\n\n'
                  'Formatter hashcode: ${formatter.hashCode}\n'
                  'Current value: "$value"',
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: value,
                        inputFormatters: [formatter],
                        onChanged: (value) =>
                            context.read<DemoCubit>().setState(value),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    OutlinedButton(
                      onPressed: widget.triggerRebuild,
                      child: const Text('Rebuild'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GoodStatelessBlocExample extends StatelessWidget {
  const _GoodStatelessBlocExample({
    Key? key,
    required this.triggerRebuild,
  }) : super(key: key);

  final VoidCallback triggerRebuild;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoCubit(),
      child: BlocBuilder<DemoCubit, String>(
        builder: (context, value) {
          final formatter = DateInputFormatter(initialValue: value);
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good stateless Bloc example',
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(height: 4.0),
                Text(
                  'This example shows a properly working masked text input '
                  'formatter in a stateless widget using a Bloc to save the '
                  'text value.\n\n'
                  'This implementation works because the input formatter '
                  'created in the build method is supplied with the latest '
                  'value as its initialText.\n\n'
                  'Formatter hashcode: ${formatter.hashCode}\n'
                  'Current value: "$value"',
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: value,
                        inputFormatters: [formatter],
                        onChanged: (value) =>
                            context.read<DemoCubit>().setState(value),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    OutlinedButton(
                      onPressed: triggerRebuild,
                      child: const Text('Rebuild'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BadStatelessExample extends StatelessWidget {
  const _BadStatelessExample({
    Key? key,
    required this.triggerRebuild,
  }) : super(key: key);

  final VoidCallback triggerRebuild;

  @override
  Widget build(BuildContext context) {
    final formatter = DateInputFormatter();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bad example',
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(height: 4.0),
          Text(
            'This example shows a malfunctioning masked text input '
            'formatter in a stateless widget.\n\n'
            'Try editing the text and triggering rebuilds while doing so. '
            'The formatter will be different between rebuilds, after which '
            'editing the form field will remove the old value.\n\n'
            'Formatter hashcode: ${formatter.hashCode}',
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  inputFormatters: [formatter],
                ),
              ),
              const SizedBox(width: 8.0),
              OutlinedButton(
                onPressed: triggerRebuild,
                child: const Text('Rebuild'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BadBlocExample extends StatelessWidget {
  const _BadBlocExample({
    Key? key,
    required this.triggerRebuild,
  }) : super(key: key);

  final VoidCallback triggerRebuild;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoCubit(),
      child: BlocBuilder<DemoCubit, String>(
        builder: (context, value) {
          final formatter = DateInputFormatter();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bad Bloc example',
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(height: 4.0),
                Text(
                  'This example shows a malfunctioning masked text input '
                  'formatter in a stateless widget using a Bloc to save the '
                  'text value.\n\n'
                  'It contains the same issues as the previous example, but '
                  'has additional unintended behavior since the widget is '
                  'rebuilt on every keystroke.\n\n'
                  'Formatter hashcode: ${formatter.hashCode}\n'
                  'Current value: "$value"',
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: value,
                        inputFormatters: [formatter],
                        onChanged: (value) =>
                            context.read<DemoCubit>().setState(value),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    OutlinedButton(
                      onPressed: triggerRebuild,
                      child: const Text('Rebuild'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
