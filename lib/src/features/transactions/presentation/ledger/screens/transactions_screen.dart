// ignore_for_file: unused_element_parameter

import 'package:mahafez_design_system/mahafez_design_system.dart';
import 'package:flutter/material.dart';

import '../navigation/transactions_route_data.dart';
import '../widgets/transactions_filter_icon_button.dart';
import '../widgets/transactions_screen_body.dart';
import '../widgets/transactions_screen_title.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key, required this.transactionsContext});

  final TransactionsRouteData transactionsContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TransactionsScreenTitle(routeData: transactionsContext),
        centerTitle: true,
        actions: [
          TransactionsFilterIconButton(routeData: transactionsContext),
          MahafezSpacing.lg.horizontalSpace,
        ],
      ),
      body: SafeArea(
        child: TransactionsScreenBody(routeData: transactionsContext),
      ),
    );
  }
}
