import 'package:flutter/material.dart';
import 'package:guild_chat/ui/homepage/better_home_viewmodel.dart';

class BetterHomeScreen extends StatefulWidget {

  const BetterHomeScreen({
    super.key,
    required this.title,
    required this.viewModel,
  });

  final String title;
  final BetterHomeViewmodel viewModel;

  @override
  State<BetterHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<BetterHomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_updateUI);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_updateUI);
    super.dispose();
  }

  void _updateUI() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Current number of users in DB:'),
            Text(
              '${widget.viewModel.userCount}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.viewModel.setCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}