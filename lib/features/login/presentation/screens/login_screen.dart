import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maids_task/core/constant.dart';
import 'package:maids_task/features/login/presentation/widgets/login_form.dart';

import 'package:maids_task/widgets/image_loader.dart';
import 'package:maids_task/widgets/custom_appbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Account Login'),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppContentPadding.horizontalPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Center(
                child: ImageLoader(
                  imagePath: AppImages.loginImage,
                  size: Size(225, 225),
                ),
              ),
              SizedBox(height: 30.h),
              LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
