
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../repositories/user_repository.dart';
import '../auth/auth_page.dart';
import '../map/map_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.grey[200],
        child: ValueListenableBuilder<User?>(
          valueListenable: UserRepository.instance.userNotifier,
          builder: (context, value, child) {
            if (value != null) {
              return Builder(
                builder: (context) {
                  if (value.isVerified) {
                    return MapViewWidget();
                  } else {
                    return AuthPageWidget(page: 2, uid: value.uid);
                  }
                },
              );
            } else {
              return AuthPageWidget(page: 0);
            }
          },
        ),
      ),
    );
  }
}
