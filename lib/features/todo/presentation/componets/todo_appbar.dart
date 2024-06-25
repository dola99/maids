import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maids_task/Model/user_data.dart';
import 'package:maids_task/core/helpers/secure_sharedprefernce.dart';
import 'package:maids_task/features/login/cubit/login_cubit.dart';
import 'package:maids_task/features/login/presentation/screens/login_screen.dart';

class TodoListScreenAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const TodoListScreenAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Todos'),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        UserData.getInstance().userName,
                        style: const TextStyle(color: Colors.black),
                      ),
                      Text(
                        '${UserData.getInstance().firstName} ${UserData.getInstance().lastName}',
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(
                      UserData.getInstance().image,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                  onPressed: () async {
                    await SharedPreferencesHelper.clearToken();
                    LoginCubit.get(context).init();
                    Navigator.of(context).pushReplacement(CupertinoPageRoute(
                      builder: (context) => const LoginScreen(),
                    ));
                  },
                  icon: const Icon(Icons.logout, color: Colors.red)),
            ],
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
