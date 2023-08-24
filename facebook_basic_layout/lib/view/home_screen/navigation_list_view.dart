import 'package:facebook_basic_layout/controller/navigation_item_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NaviagtionList extends StatelessWidget {
  const NaviagtionList({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NavigationItemController>.value(
      value: NavigationItemController(),
      child: Consumer<NavigationItemController>(
        builder: (context, snapshot, child) => ListView(
            padding: const EdgeInsets.only(top: 10),
            children: snapshot.items
                .map((item) => Container(
                      margin: const EdgeInsets.all(7),
                      child: ElevatedButton.icon(
                          style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                      const EdgeInsets.all(18.0)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              iconColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor),
                              alignment: Alignment.centerLeft),
                          onPressed: () {},
                          icon: item.icon,
                          label: Text(
                            item.name,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          )),
                    ))
                .toList()),
      ),
    );
  }
}
