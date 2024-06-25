import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maids_task/core/constant.dart';
import 'package:maids_task/features/login/cubit/login_cubit.dart';
import 'package:maids_task/features/todo/presentation/screens/todo_list_screen.dart';
import 'package:maids_task/widgets/custom_button.dart';
import 'package:maids_task/widgets/snack_bar.dart';

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const LoginButton({super.key, required this.formKey});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginFailed) {
              ShowSnackBar.show(
                  context: context,
                  message: state.errorMessages!,
                  textColor: AppColors.error_300,
                  color: AppColors.error_50,
                  isSuccess: false);
            } else if (state is LoginSuccesfully) {
              ShowSnackBar.show(
                  context: context,
                  message: 'Welcome ${state.userData?.firstName ?? ''}',
                  textColor: AppColors.bgGrey_900,
                  color: AppColors.primaryColor,
                  isSuccess: true);
              Navigator.of(context).pushReplacement(CupertinoPageRoute(
                builder: (context) => const TodoListScreen(),
              ));
            }
          },
          builder: (context, state) {
            return CustomButton(
              titleButton: 'Login',
              weight: double.infinity,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  LoginCubit.get(context).login();
                }
              },
              buttonState: state.buttonState,
            );
          },
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
