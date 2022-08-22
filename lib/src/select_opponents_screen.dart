import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:p2p_call_sample/theme/colors.dart';

import 'managers/call_manager.dart';
import 'managers/push_notifications_manager.dart';
import 'utils/configs.dart' as utils;
import 'utils/platform_utils.dart';
import 'utils/pref_util.dart';

class SelectOpponentsScreen extends StatelessWidget {
  final CubeUser currentUser;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(),
      child: Scaffold(
        backgroundColor: kGrey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            '${CubeChatConnection.instance.currentUser!.fullName}',
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () => _logOut(context),
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: BodyLayout(currentUser),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return Future.value(false);
  }

  _logOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Apakah Anda yakin ingin keluar saat ini?"),
          actions: <Widget>[
            TextButton(
              child: Text("BATAL"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("OK"),
              onPressed: () async {
                CallManager.instance.destroy();
                CubeChatConnection.instance.destroy();
                await PushNotificationsManager.instance.unsubscribe();
                await SharedPrefs.deleteUserData();
                await signOut();

                Navigator.pop(context); // cancel current Dialog
                _navigateToLoginScreen(context);
              },
            ),
          ],
        );
      },
    );
  }

  _navigateToLoginScreen(BuildContext context) {
    Navigator.pop(context);
  }

  SelectOpponentsScreen(this.currentUser);
}

class BodyLayout extends StatefulWidget {
  final CubeUser currentUser;

  @override
  State<StatefulWidget> createState() {
    return _BodyLayoutState(currentUser);
  }

  BodyLayout(this.currentUser);
}

class _BodyLayoutState extends State<BodyLayout> {
  final CubeUser currentUser;
  late Set<int> _selectedUsers;

  _BodyLayoutState(this.currentUser);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
            Expanded(
              child: _getOpponentsList(context),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Visibility(
                  visible: kIsWeb || Platform.isIOS || Platform.isAndroid,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: FloatingActionButton(
                      heroTag: "ScreenSharing",
                      child: Icon(
                        Icons.screen_share,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.teal,
                      onPressed: () async {
                        startBackgroundExecution().then((_) {
                          CallManager.instance.startNewCall(
                              context, CallType.VIDEO_CALL, _selectedUsers,
                              startScreenSharing: true);
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: FloatingActionButton(
                    heroTag: "VideoCall",
                    child: Icon(
                      Icons.videocam,
                      color: Colors.white,
                    ),
                    backgroundColor: kCelticBlue,
                    onPressed: () => CallManager.instance.startNewCall(
                        context, CallType.VIDEO_CALL, _selectedUsers),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: FloatingActionButton(
                    heroTag: "AudioCall",
                    child: Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.green,
                    onPressed: () => CallManager.instance.startNewCall(
                        context, CallType.AUDIO_CALL, _selectedUsers),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _getOpponentsList(BuildContext context) {
    CubeUser? currentUser = CubeChatConnection.instance.currentUser;
    final users =
        utils.users.where((user) => user.id != currentUser!.id).toList();

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return Container(
          height: 90,
          color: kWhite,
          margin: EdgeInsets.only(bottom: 4),
          child: CheckboxListTile(
            title: Row(
              children: [
                Icon(Icons.account_circle_rounded, size: 48,),
                SizedBox(width: 4,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      users[index].fullName!,
                    ),
                    SizedBox(height: 4,),
                    Text("NIP: ${users[index].login!}", style: TextStyle(fontSize: 12, color: Colors.grey),)
                  ],
                ),
              ],
            ),
            value: _selectedUsers.contains(users[index].id),
            onChanged: ((checked) {
              setState(() {
                if (checked!) {
                  _selectedUsers.add(users[index].id!);
                } else {
                  _selectedUsers.remove(users[index].id);
                }
              });
            }),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    initForegroundService();

    _selectedUsers = {};

    checkSystemAlertWindowPermission(context);

    PushNotificationsManager.instance.init();
  }
}
