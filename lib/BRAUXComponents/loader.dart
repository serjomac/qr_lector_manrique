import 'package:flutter/material.dart';

class LoadingInvitationsPage extends StatelessWidget {
  const LoadingInvitationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Loader();
  }
}

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
