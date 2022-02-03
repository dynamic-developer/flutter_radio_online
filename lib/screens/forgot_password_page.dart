import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radio_online/api_calling/api_service.dart';
import 'package:radio_online/api_calling/api_state.dart';
import 'package:radio_online/api_calling/controllers/forgot_password_controller.dart';
import 'package:radio_online/helper/custom_text_form_field.dart';
import 'package:radio_online/screens/login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = Get.put(ForgotPasswordController());
  final formKey = GlobalKey<FormState>();
  final mobileNode = FocusNode();
  String mobile = '';
  late String countryCode;

  @override
  void initState() {
    Get.lazyPut(
      () => ForgotPasswordController(),
    );

    super.initState();
  }

  @override
  void dispose() {
    mobileNode.dispose();
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
        appBar: appBar(),
        body: Obx(() {
          if (_controller.state is ForgotPasswordFailed) {
            if (_controller.state is ForgotPasswordFailed) {
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
          }
          if (_controller.state is ForgotPasswordError) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              _scaffoldKey.currentState!.showSnackBar(SnackBar(
                content: Text(
                  (_controller.state as ForgotPasswordError).message.toString(),
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
              ));
            });
          }
          if (_controller.state is ForgotPasswordLoaded) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              //ScaffoldMessenger.of(context).clearSnackBars();
              _scaffoldKey.currentState!.showSnackBar(SnackBar(
                content: Text(
                  (_controller.state as ForgotPasswordLoaded)
                      .user
                      .message
                      .toString(),
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 5),
                behavior: SnackBarBehavior.floating,
              ));
              Future.delayed(const Duration(seconds: 3), () {
                _controller.resetForgotPassword();
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LoginPage()));
              });
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
      title: Text('Forgot Password',
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
          mobileNo(),
          SizedBox(
            height: 20,
          ),
          sendButton(context),
          SizedBox(
            height: 20,
          ),
          if (_controller.state is ForgotPasswordLoading)
            CircularProgressIndicator(
              color: Color(0xFFFF2562),
            )
        ],
      ),
    );
  }

  Widget mobileNo() {
    return Container(
      child: TextFormField(
        obscureText: false,
        keyboardType: TextInputType.phone,
        focusNode: mobileNode,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 12),
          prefixIcon: SizedBox(
            width: 60,
            child: CountryCodePicker(
              // padding: const EdgeInsets.only(left: 2),
              dialogSize: Size(MediaQuery.of(context).size.width / 1.2,
                  MediaQuery.of(context).size.height / 1.5),
              // countryList: countryCodes.length > 0 ? countryCodes : codes,
              onInit: (code) {
                countryCode = code!.dialCode!;
              },
              onChanged: (code) {
                countryCode = code.dialCode!;
              },
              showFlag: true,
              showFlagDialog: true,
              initialSelection: 'IN',
              hideMainText: false,
              showFlagMain: false,
              alignLeft: true,
              favorite: ['+91', 'IN', '+1'],
            ),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Mobile Number',
          border: InputBorder.none,
          hintStyle: TextStyle(
              fontSize: 14,
              color: Color(0xFF414041),
              fontWeight: FontWeight.w500),
        ),
        cursorColor: Color(0xFFFF2562),
        onChanged: (String value) {
          mobile = value;
        },
        validator: (String? value) {
          //Validator.isValidEmail(value!);
          if (value!.isEmpty) {
            return 'Please Enter your Mobile Number.';
          } else if (value.length != 10) {
            return 'Invalid Mobile Number';
          }
        },
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF6270A1).withOpacity(0.01)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6270A1).withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }

  Widget sendButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          if (!(_controller.state is ForgotPasswordLoading)) {
            _controller.forgotPassword(countryCode.toString(), mobile);
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
            'Reset Password',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
