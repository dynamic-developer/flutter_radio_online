import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radio_online/api_calling/api_state.dart';
import 'package:radio_online/api_calling/controllers/change_password_controller.dart';
import 'package:radio_online/helper/custom_text_form_field.dart';
import 'package:radio_online/helper/shared_pref.dart';
import 'package:radio_online/main.dart';
import 'package:radio_online/screens/pages.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = Get.put(ChangePasswordController());
  final oldPasswordNode = FocusNode();
  final newPasswordNode = FocusNode();
  final confirmPasswordNode = FocusNode();
  String oldPassword = '', newPassword = '', confirmNewPassword = '';
  SharedPref sharedPref = SharedPref();

  @override
  void initState() {
    _controller.resetChangePassword();
    super.initState();
  }

  @override
  void dispose() {
    oldPasswordNode.dispose();
    newPasswordNode.dispose();
    confirmPasswordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xFFEFF0F6),
        resizeToAvoidBottomInset: false,
        appBar: appBar(),
        body: Obx(() {
          if (_controller.state is ChangePasswordFailed) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              _scaffoldKey.currentState!.showSnackBar(SnackBar(
                content: Text(
                  'Check Your Internet Connection',
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ));
            });
          }
          if (_controller.state is ChangePasswordError) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              _scaffoldKey.currentState!.showSnackBar(SnackBar(
                content: Text(
                  (_controller.state as ChangePasswordError).message.toString(),
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ));
            });
          }
          if (_controller.state is ChangePasswordLoaded) {
            WidgetsBinding.instance!.addPostFrameCallback((_) async {
              //ScaffoldMessenger.of(context).clearSnackBars();
              _scaffoldKey.currentState!.showSnackBar(SnackBar(
                content: Text(
                  (_controller.state as ChangePasswordLoaded)
                      .user
                      .message
                      .toString(),
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 4),
                behavior: SnackBarBehavior.floating,
              ));
            });
          }
          return body(context);
        }),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Color(0xFFEFF0F6),
      toolbarHeight: 80,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back,
          size: 30,
          color: Color(0xFF6270A1),
        ),
      ),
      centerTitle: true,
      title: Text('Change Password',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF6270A1))),
    );
  }

  Widget body(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 45),
        child: form(context),
      ),
    );
  }

  Form form(BuildContext context) {
    return Form(
      key: formKey,
      //autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          userLoad.data!.isPasswordSet == 1?
          CustomTextFormField(
            obscureText: true,
            textEditingController: TextEditingController(),
            hintText: 'Old Password',
            icon: Icons.lock,
            onFieldSubmitted: (String value) {},
            cursorColor: Color(0xFFFF2562),
            onChanged: (String value) {
              oldPassword = value;
            },
            keyboardType: TextInputType.text,
            focusNode: oldPasswordNode,
            nextNode: newPasswordNode,
            textInputAction: TextInputAction.next,
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Please Enter your Password.';
              }
            },
          ) : Container(),
          SizedBox(
            height: 20,
          ),
          CustomTextFormField(
            obscureText: true,
            textEditingController: TextEditingController(),
            hintText: 'New Password',
            icon: Icons.lock,
            onFieldSubmitted: (String value) {},
            cursorColor: Color(0xFFFF2562),
            onChanged: (String value) {
              newPassword = value;
            },
            keyboardType: TextInputType.text,
            focusNode: newPasswordNode,
            nextNode: confirmPasswordNode,
            textInputAction: TextInputAction.next,
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Please Enter your Password.';
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          CustomTextFormField(
            obscureText: true,
            textEditingController: TextEditingController(),
            hintText: 'Confirm New Password',
            icon: Icons.lock,
            onFieldSubmitted: (String value) {},
            cursorColor: Color(0xFFFF2562),
            onChanged: (String value) {
              confirmNewPassword = value;
            },
            keyboardType: TextInputType.text,
            focusNode: confirmPasswordNode,
            nextNode: confirmPasswordNode,
            textInputAction: TextInputAction.done,
            validator: (String? value) {
              if (value!.isEmpty) {
                return 'Please Enter your Password.';
              } else if (newPassword != confirmNewPassword) {
                return 'Password must be same.';
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          saveButton(context),
          SizedBox(
            height: 20,
          ),
          if (_controller.state is ChangePasswordLoading)
            CircularProgressIndicator(
              color: Color(0xFFFF2562),
            )
        ],
      ),
    );
  }

  Widget saveButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          if (!(_controller.state is ChangePasswordLoading)) {
            _controller.changePassword(
                oldPassword, newPassword, token);
          }
        }
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Color(0xFFFF2562),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Center(
          child: Text(
            'Update',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
