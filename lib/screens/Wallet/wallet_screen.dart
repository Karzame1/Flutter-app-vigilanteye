import 'package:fieldmanager_hrms_flutter/screens/Wallet/wallet_approved.dart';
import 'package:fieldmanager_hrms_flutter/screens/Wallet/wallet_cashout.dart';
import 'package:fieldmanager_hrms_flutter/screens/Wallet/wallet_decline.dart';
import 'package:fieldmanager_hrms_flutter/screens/Wallet/wallet_pending.dart';
import 'package:fieldmanager_hrms_flutter/screens/Wallet/wallet_wallet.dart';
import 'package:fieldmanager_hrms_flutter/utils/app_colors.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        FocusScope.of(context).unfocus(); // This will hide the keyboard
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: DefaultTabController(
          length: 5, // Number of tabs
          child: Column(
            children: [
              // TabBar widget inside body
              TabBar(
                controller: _tabController,
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.transparent,
                indicatorColor: opPrimaryColor,
                isScrollable: true,
                tabs: const [
                  Tab(
                      child: Text(
                    'Wallet',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  Tab(
                      child: Text(
                    'Cashout',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  Tab(
                      child: Text(
                    'Approved',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  Tab(
                      child: Text(
                    'Pending',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  Tab(
                      child: Text(
                    'Decline',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ],
              ),
              // TabBarView to show content corresponding to each tab
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      WalletWallet(),
                      WalletCashout(),
                      WalletApproved(),
                      WalletPending(),
                      WalletDecline(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
