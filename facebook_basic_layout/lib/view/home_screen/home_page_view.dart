import 'package:facebook_basic_layout/controller/user_service.dart';
import 'package:facebook_basic_layout/view/home_screen/page_body_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../chat_screen/chat_screen_view.dart';
import 'navigation_list_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    UserService userService = context.watch<UserService>();
    if (userService.currentUser.name == '') {
      userService.getData();
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 10,
          title: MediaQuery.of(context).size.width < 390
              ? null
              : Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.facebook),
                      onPressed: () {},
                      iconSize: 35,
                    ),
                    MediaQuery.of(context).size.width < 480
                        ? const Text('')
                        : const Text('Fhở Bò')
                  ],
                ),
          leading: MediaQuery.of(context).size.width < 550
              ? Builder(
                  builder: (appbarContext) => IconButton(
                      icon: const Icon(Icons.menu),
                      tooltip: 'Menu',
                      onPressed: () {
                        Scaffold.of(appbarContext).openDrawer();
                      }))
              : null,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.home),
              tooltip: 'Home',
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.group),
              tooltip: 'Group',
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications),
              tooltip: 'Notifications',
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.message),
              tooltip: 'Message',
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.info_rounded),
              tooltip: 'Infomation',
            ),
            IconButton(
              onPressed: () {
                userService.logOut();
              },
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
            )
          ],
        ),
        drawer: MediaQuery.of(context).size.width < 550
            ? Drawer(
                backgroundColor: Theme.of(context).primaryColor,
                width: MediaQuery.of(context).size.width * 0.7,
                elevation: 30,
                child: const NaviagtionList(),
              )
            : null,
        body: const PageBody(),
      ),
    );
  }
}
