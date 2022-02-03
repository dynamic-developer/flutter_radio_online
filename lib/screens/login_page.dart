import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_codes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:radio_online/api_calling/api_service.dart';
import 'package:radio_online/api_calling/api_state.dart';
import 'package:radio_online/api_calling/controllers/auth_controller.dart';
import 'package:radio_online/api_calling/controllers/forgot_password_controller.dart';
import 'package:radio_online/api_calling/models/user.dart';
import 'package:radio_online/helper/shared_pref.dart';
import 'package:radio_online/main.dart';
import 'package:radio_online/screens/forgot_password_page.dart';
import 'package:radio_online/screens/home-page.dart';
import 'package:radio_online/screens/pages.dart';
import 'package:radio_online/screens/register_page.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

bool isPage = true;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = Get.put(AuthController());
  final formKey = GlobalKey<FormState>();
  final mobileNode = FocusNode();
  final passwordNode = FocusNode();
  String mobile = "", password = "";
  bool _isHidden = true;
  late String countryCode;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  SharedPref sharedPref = SharedPref();

  @override
  void dispose() {
    mobileNode.dispose();
    passwordNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    isPage = true;
    super.initState();
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
          body: Obx(() {
            if (_controller.state is UserFailed) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                _scaffoldKey.currentState!.showSnackBar(SnackBar(
                  content: Text(
                    'Check Your Internet Connection',
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                ));
              });
            }
            if (_controller.state is UserError) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                _scaffoldKey.currentState!.showSnackBar(SnackBar(
                  content: Text(
                    (_controller.state as UserError).message.toString(),
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ));
                Future.delayed(const Duration(seconds: 3), () {
                  _controller.resetState();
                });
              });
            }

            if (_controller.state is UserLoaded) {
              WidgetsBinding.instance!.addPostFrameCallback((_) async {
                //ScaffoldMessenger.of(context).clearSnackBars();
                UserAuth userSave = (_controller.state as UserLoaded).user;
                await sharedPref.save("user", userSave);
                userLoad = UserAuth.fromJson(await sharedPref.read("user"));
                //isPage=true;
                _controller.resetState();
                //TODO: changes made by adarsh
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Pages(
                              page: HomePage(),
                              index: 0,
                            )),
                    (r) => false);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (_) => Pages(
                //               page: HomePage(),
                //               index: 0,
                //             )));
              });
            }

            /// Google SignIn
            if (_controller.state is GoogleSignInFailed) {
              return Text(
                (_controller.state as GoogleSignInFailed).message.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Get.theme.errorColor),
              );
            }
            if (_controller.state is GoogleSignInError) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                _scaffoldKey.currentState!.showSnackBar(SnackBar(
                  content: Text(
                    (_controller.state as GoogleSignInError).message.toString(),
                  ),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ));
                Future.delayed(const Duration(seconds: 3), () {
                  _controller.resetState();
                });
              });
            }
            if (_controller.state is GoogleSignInLoaded) {
              WidgetsBinding.instance!.addPostFrameCallback((_) async {
                UserAuth userSave =
                    (_controller.state as GoogleSignInLoaded).googleSignIn;
                await sharedPref.save("user", userSave);
                userLoad = UserAuth.fromJson(await sharedPref.read("user"));
                isPage = true;
                _controller.resetState();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Pages(
                              page: HomePage(),
                              index: 0,
                            )),
                    (r) => false);
              });
            }

            /// Facebook SignIn
            if (_controller.state is FacebookSignInFailed) {
              return Text(
                (_controller.state as FacebookSignInFailed).message.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Get.theme.errorColor),
              );
            }
            if (_controller.state is FacebookSignInError) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                _scaffoldKey.currentState!.showSnackBar(SnackBar(
                  content: Text(
                    (_controller.state as FacebookSignInError)
                        .message
                        .toString(),
                  ),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ));
                Future.delayed(const Duration(seconds: 3), () {
                  _controller.resetState();
                });
              });
            }
            if (_controller.state is FacebookSignInLoaded) {
              WidgetsBinding.instance!.addPostFrameCallback((_) async {
                UserAuth userSave =
                    (_controller.state as FacebookSignInLoaded).facebookSignIn;
                await sharedPref.save("user", userSave);
                userLoad = UserAuth.fromJson(await sharedPref.read("user"));
                isPage = true;
                _controller.resetState();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Pages(
                              page: HomePage(),
                              index: 0,
                            )),
                    (r) => false);
                //TODO: changes made by adarsh
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (_) => Pages(
                //               page: HomePage(),
                //               index: 0,
                //             )));
              });
            }

            /// Apple SignIn
            if (_controller.state is AppleSignInFailed) {
              return Text(
                (_controller.state as AppleSignInFailed).message.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Get.theme.errorColor),
              );
            }
            if (_controller.state is AppleSignInError) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                _scaffoldKey.currentState!.showSnackBar(SnackBar(
                  content: Text(
                    (_controller.state as AppleSignInError).message.toString(),
                  ),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ));
                Future.delayed(const Duration(seconds: 3), () {
                  _controller.resetState();
                });
              });
            }
            if (_controller.state is AppleSignInLoaded) {
              print("-----------------------------------------------");
              WidgetsBinding.instance!.addPostFrameCallback((_) async {
                UserAuth userSave =
                    (_controller.state as AppleSignInLoaded).appleSignIn;
                await sharedPref.save("user", userSave);
                userLoad = UserAuth.fromJson(await sharedPref.read("user"));
                isPage = true;
                _controller.resetState();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Pages(
                              page: HomePage(),
                              index: 0,
                            )),
                    (r) => false);
                //TODO: changes made by adarsh
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (_) => Pages(
                //               page: HomePage(),
                //               index: 0,
                //             )));
              });
            }

            return body(context);
          }),
        ));
  }

  Widget body(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            children: [
              const SizedBox(height: 40.0),
              logo(),
              const SizedBox(height: 80.0),
              Text(
                "Sign In",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20.0),
              form(context),
              SizedBox(
                height: 20,
              ),
              Text(
                'Or login with',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              socialAuth(),
              const SizedBox(
                height: 70.0,
              ),
              signUpButton(context),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row logo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 40.0),
        Container(
            height: 100.0,
            child: Image.asset(
              'assets/image/radio_logo.png',
            )),
      ],
    );
  }

  Form form(BuildContext context) {
    return Form(
      key: formKey,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          // CustomTextFormField(
          //   obscureText: false,
          //   textEditingController: TextEditingController(text: email),
          //   hintText: 'Email',
          //   icon: Icons.person,
          //   onFieldSubmitted: (String value) {},
          //   cursorColor: Color(0xFFFF2562),
          //   onChanged: (String value) {
          //     email = value;
          //   },
          //   keyboardType: TextInputType.emailAddress,
          //   focusNode: userNameNode,
          //   nextNode: passwordNode,
          //   textInputAction: TextInputAction.next,
          //   validator: (String? value) {
          //     if (value!.isEmpty) {
          //       return 'Please Enter your username';
          //     }
          //   },
          // ),
          mobileNo(),
          SizedBox(
            height: 20,
          ),
          Container(
            child: TextFormField(
              obscureText: _isHidden,
              focusNode: passwordNode,
              keyboardType: TextInputType.text,
              //controller: TextEditingController(text: password),
              onChanged: (String value) {
                password = value;
              },
              cursorColor: Color(0xFFFF2562),
              onFieldSubmitted: (String value) {},
              textInputAction: TextInputAction.done,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Please Enter your Password.';
                }
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Password',
                  hintStyle: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF414041),
                      fontWeight: FontWeight.w500),
                  prefixIcon: Icon(
                    Icons.lock,
                    size: 18,
                    color: Color(0xFF6270A1),
                  ),
                  suffixIcon: InkWell(
                      onTap: _togglePasswordView,
                      //child: Icon(Icons.remove_red_eye_outlined,color: Colors.white54,size: 25,)),
                      child: Icon(
                          _isHidden
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Color(0xFF6270A1),
                          size: 18)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide.none,
                  )),
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF6270A1).withOpacity(0.5),
                  blurRadius: 5,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          forgotPasswordButton(context),
          SizedBox(
            height: 20,
          ),
          signInButton(context),
          SizedBox(
            height: 20,
          ),
          if (_controller.state is UserLoading)
            CircularProgressIndicator(
              color: Color(0xFFFF2562),
            ),
          if (_controller.state is GoogleSignInLoading)
            CircularProgressIndicator(
              color: Color(0xFFFF2562),
            ),
          if (_controller.state is FacebookSignInLoading)
            CircularProgressIndicator(
              color: Color(0xFFFF2562),
            )
        ],
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
    _controller.resetState();
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
              padding: const EdgeInsets.only(left: 2),
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

  Widget forgotPasswordButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            _controller.resetState();
            final controller = Get.put(ForgotPasswordController());
            controller.resetForgotPassword();
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => ForgotPasswordPage()));
          },
          child: Text(
            'Forgot Password?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget signInButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();

        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          if (!(_controller.state is UserLoading)) {
            _controller.login(mobile, countryCode.toString(), password,
                deviceId, Platform.operatingSystem);
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
            'SIGN IN',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ),
    );
  }

  Row socialAuth() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Platform.isAndroid
            ? Container(
                child: GestureDetector(
                  onTap: () {
                    signUpWithFacebook();
                  },
                  child: const Icon(
                    FontAwesomeIcons.facebookF,
                    color: Colors.white,
                    size: 24.0,
                  ),
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Color(0xFF406FFF),
                ),
              )
            : Container(),
        SizedBox(
          width: 20,
        ),
        Container(
          child: GestureDetector(
            onTap: () async {
              //Navigator.push(context, MaterialPageRoute(builder: (_) => Pages()));

              await _googleSignInPress();
            },
            child: const Icon(
              FontAwesomeIcons.google,
              color: Colors.white,
              size: 24.0,
            ),
          ),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Color(0xFFCA4335),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Platform.isIOS
            ? GestureDetector(
                onTap: () {
                  signUpWithApple();
                },
                child: Container(
                  child: const Icon(
                    FontAwesomeIcons.apple,
                    color: Colors.white,
                    size: 24.0,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Color(0xFF000000),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  RichText signUpButton(BuildContext context) {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
            text: 'New to Om Sakthi Music?',
            style: TextStyle(
                fontSize: 16,
                color: Color(0xFF414041),
                fontWeight: FontWeight.bold),
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _controller.resetState();
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => RegisterPage()));
              },
            text: ' Sign Up',
            style: TextStyle(
                color: Color(0xFFFF2562),
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ]));
  }

  ///GOOGLE SIGN IN
  Future<void> _googleSignInPress() async {
    print("00000");

    try {
      debugPrint("1111111111");
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print("22222222222");
      final FirebaseAuth _auth = FirebaseAuth.instance;
      print("333333333333");
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      print("4444444444444");
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      printInfo(info: _auth.currentUser!.uid);

      ///Api Calling
      _controller.googleSignIn(
          googleUser.displayName.toString(),
          googleUser.email.toString(),
          "",
          " ",
          " ",
          googleUser.id.toString(),
          deviceId,
          Platform.operatingSystem,
          countryCode);
      (await _auth.signInWithCredential(credential)).user;
      // AuthCredential credentialGoogle =
      //     GoogleAuthProvider.credential(accessToken: googleAuth.accessToken);
      // (await FirebaseAuth.instance.signInWithCredential(credentialGoogle)).user;
    } catch (e) {
      e.printError();
    }
  }

  ///Apple SignIn
  Future<void> signUpWithApple() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      var credential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);

      OAuthCredential oAuthCredential = OAuthProvider("apple.com")
          .credential(idToken: credential.identityToken);
      User? user = (await _auth.signInWithCredential(oAuthCredential)).user;
      print("APPLE CREDENTIAL :: ${credential}");
      print("APPLE CREDENTIAL family name :: ${credential.identityToken}");
      print("APPLE CREDENTIAL given Name :: ${credential.givenName}");
      print("APPLE idToken :: ${oAuthCredential.idToken}");
      print("APPLE USER ID: ${user}");
      print("APPLE USER NAME:: ${user?.displayName}");
      //TODO: server integration remain
      _controller.appleSignIn(
          credential.givenName ?? " ",
          credential.email ?? " ",
          mobile,
          " ",
          " ",
          credential.userIdentifier!,
          deviceId,
          Platform.operatingSystem,
          countryCode);
    } catch (e) {
      print(e);
    }
  }

  ///FACEBOOK SIGN IN
  Future<void> signUpWithFacebook() async {
    final fb = FacebookLogin();
    final FirebaseAuth _auth = FirebaseAuth.instance;

// Log in
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
      FacebookPermission.userFriends
    ]);
    final FacebookAccessToken? accessToken = res.accessToken;
    final AuthCredential credential =
        FacebookAuthProvider.credential(accessToken!.token);
    User? user = (await _auth.signInWithCredential(credential)).user;

    ///Api Calling
    _controller.facebookSignIn(
        user!.displayName.toString(),
        user.email.toString(),
        " ",
        " ",
        " ",
        accessToken.userId.toString(),
        deviceId,
        Platform.operatingSystem,
        countryCode);
  }
}
