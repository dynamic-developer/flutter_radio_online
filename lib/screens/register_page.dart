import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_codes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:radio_online/api_calling/api_service.dart';
import 'package:radio_online/api_calling/api_state.dart';
import 'package:radio_online/api_calling/controllers/auth_controller.dart';
import 'package:radio_online/api_calling/models/user.dart';
import 'package:radio_online/helper/shared_pref.dart';
import 'package:radio_online/main.dart';
import 'package:radio_online/screens/login_page.dart';
import 'package:radio_online/screens/pages.dart';
import 'package:intl/intl.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'get_pages.dart';
import 'home-page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = Get.put(AuthController());
  final formKey = GlobalKey<FormState>();
  final firstNameNode = FocusNode();
  final lastNameNode = FocusNode();
  final emailNode = FocusNode();
  final mobileNode = FocusNode();
  final passwordNode = FocusNode();
  DateTime selectedDate = DateTime.now();
  SharedPref sharedPref = SharedPref();
  bool _isHidden = true;
  TextEditingController initialDate = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );
  late String countryCode;
  Object? val = "Male";

  String name = "", lastName = "", email = "", mobile = "", password = "";

  @override
  void initState() {
    isPage = false;
    super.initState();
  }

  @override
  void dispose() {
    firstNameNode.dispose();
    lastNameNode.dispose();
    emailNode.dispose();
    mobileNode.dispose();
    passwordNode.dispose();
    super.dispose();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1500, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      initialDate.value =
          TextEditingValue(text: DateFormat('yyyy-MM-dd').format(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
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
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ));
              });
            }
            if (_controller.state is UserError) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                _scaffoldKey.currentState!.showSnackBar(SnackBar(
                  content: Text(
                    (_controller.state as UserError).message.toString(),
                    textAlign: TextAlign.center,
                  ),
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
                UserAuth userSave = (_controller.state as UserLoaded).user;
                await sharedPref.save("user", userSave);
                userLoad = UserAuth.fromJson(await sharedPref.read("user"));
                //ScaffoldMessenger.of(context).clearSnackBars();
                _controller.resetState();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Pages(
                              page: HomePage(),
                              index: 0,
                            )),
                    (r) => false);
                //TODO: changes by adarsh
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40.0),
              logo(),
              const SizedBox(height: 70.0),
              Text(
                "Create Account",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20.0),
              form(context),
              SizedBox(
                height: 20,
              ),
              Text(
                'Or Register with',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              socialAuth(),
              const SizedBox(
                height: 50.0,
              ),
              signInButton(context),
              const SizedBox(
                height: 20.0,
              ),
              termsConditionsButton(),
              const SizedBox(
                height: 20.0,
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
      //autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          // CustomTextFormField(
          //   obscureText: false,
          //   textEditingController: TextEditingController(text: name),
          //   hintText: 'Name',
          //   icon: Icons.person,
          //   onFieldSubmitted: (String value) {},
          //   cursorColor: Color(0xFFFF2562),
          //   onChanged: (String value) {
          //     name = value;
          //   },
          //   keyboardType: TextInputType.text,
          //   focusNode: firstNameNode,
          //   nextNode: emailNode,
          //   textInputAction: TextInputAction.next,
          //   validator: (String? value) {
          //     if (value!.isEmpty) {
          //       return 'Please Enter your first name';
          //     }
          //   },
          // ),
          customTextField(
              false,
              firstNameNode,
              TextInputType.text,
              (value) {
                name = value;
              },
              TextInputAction.next,
              'Name',
              Icons.person,
              (value) {
                if (value!.isEmpty) {
                  return 'Please Enter your first name';
                }
              }),
          SizedBox(
            height: 20,
          ),
          // CustomTextFormField(
          //   obscureText: false,
          //   textEditingController: TextEditingController(text: email),
          //   hintText: 'Email Address',
          //   icon: Icons.email,
          //   onFieldSubmitted: (String value) {},
          //   cursorColor: Color(0xFFFF2562),
          //   onChanged: (String value) {
          //     email = value;
          //   },
          //   keyboardType: TextInputType.emailAddress,
          //   focusNode: emailNode,
          //   nextNode: mobileNode,
          //   textInputAction: TextInputAction.next,
          //   validator: (String? value) {
          //     //Validator.isValidEmail(value!);
          //     if (value!.isEmpty) {
          //       return 'Please Enter your Email.';
          //     } else if (!RegExp(
          //             r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          //         .hasMatch(value)) {
          //       return 'Enter Valid Email';
          //     }
          //   },
          // ),
          customTextField(
              false,
              emailNode,
              TextInputType.emailAddress,
              (value) {
                email = value;
              },
              TextInputAction.next,
              'Email Address',
              Icons.email,
              (value) {
                if (value!.isNotEmpty) {
                  if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return 'Enter Valid Email';
                  }
                }
              }),
          SizedBox(
            height: 20,
          ),
          mobileNo(),
          // Container(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Expanded(
          //         flex: 15,
          //         child: CountryCodePicker(
          //           padding: const EdgeInsets.only(left: 2),
          //           dialogSize: Size(MediaQuery.of(context).size.width / 1.2,
          //               MediaQuery.of(context).size.height / 1.5),
          //           countryList: countryCodes,
          //           onInit: (code) {
          //             countryCode = code!;
          //           },
          //           onChanged: (code) {
          //             countryCode = code;
          //           },
          //           showFlag: false,
          //           showFlagDialog: false,
          //           // initialSelection: 'IN',
          //           hideMainText: false,
          //           showFlagMain: false,
          //           alignLeft: true,
          //           //favorite: ['+91', 'IN'],
          //         ),
          //       ),
          //       Expanded(
          //         flex: 90,
          //         child: TextFormField(
          //           obscureText: false,
          //           keyboardType: TextInputType.phone,
          //           focusNode: mobileNode,
          //           textInputAction: TextInputAction.next,
          //           decoration: InputDecoration(
          //             contentPadding: EdgeInsets.all(0),
          //             fillColor: Colors.white,
          //             filled: true,
          //             hintText: 'Mobile Number',
          //             border: InputBorder.none,
          //             hintStyle: TextStyle(
          //                 fontSize: 14,
          //                 color: Color(0xFF414041),
          //                 fontWeight: FontWeight.w500),
          //           ),
          //           //controller: TextEditingController(text: mobile),
          //           // onFieldSubmitted: (String value) {},
          //           cursorColor: Color(0xFFFF2562),
          //           onChanged: (String value) {
          //             mobile = value;
          //           },
          //
          //           validator: (String? value) {
          //             //Validator.isValidEmail(value!);
          //             if (value!.isEmpty) {
          //               return 'Please Enter your Mobile Number.';
          //             } else if (value.length != 10) {
          //               return 'Invalid Mobile Number';
          //             }
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     border: Border.all(color: Color(0xFF6270A1).withOpacity(0.01)),
          //     boxShadow: [
          //       BoxShadow(
          //         color: Color(0xFF6270A1).withOpacity(0.5),
          //         blurRadius: 5,
          //         offset: const Offset(0, 1),
          //       ),
          //     ],
          //   ),
          // ),
          // CustomTextFormField(
          //   obscureText: false,
          //   hintText: 'Mobile Number',
          //   textEditingController: TextEditingController(text: mobile),
          //   icon: Icons.phone,
          //   onFieldSubmitted: (String value) {},
          //   cursorColor: Color(0xFFFF2562),
          //   onChanged: (String value) {
          //     mobile = value;
          //   },
          //   keyboardType: TextInputType.phone,
          //   focusNode: mobileNode,
          //   nextNode: passwordNode,
          //   textInputAction: TextInputAction.next,
          //   validator: (String? value) {
          //     //Validator.isValidEmail(value!);
          //     if (value!.isEmpty) {
          //       return 'Please Enter your Mobile Number.';
          //     } else if (value.length != 10) {
          //       return 'Invalid Mobile Number';
          //     }
          //   },
          // ),
          SizedBox(
            height: 20,
          ),
          // CustomTextFormField(
          //   obscureText: true,
          //   hintText: 'Password',
          //   textEditingController: TextEditingController(text: password),
          //   icon: Icons.lock,
          //   onFieldSubmitted: (String value) {},
          //   cursorColor: Color(0xFFFF2562),
          //   onChanged: (String value) {
          //     password = value;
          //   },
          //   keyboardType: TextInputType.text,
          //   focusNode: passwordNode,
          //   nextNode: passwordNode,
          //   textInputAction: TextInputAction.done,
          //   validator: (String? value) {
          //     if (value!.isEmpty) {
          //       return 'Please Enter your Password.';
          //     }
          //   },
          // ),
          passwordTextField(),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: AbsorbPointer(
              child: Container(
                child: TextFormField(
                  controller: initialDate,
                  keyboardType: TextInputType.datetime,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Please Select Date';
                    }
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(16),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Date Of Birth',
                      hintStyle: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF414041),
                          fontWeight: FontWeight.w500),
                      prefixIcon: Icon(
                        Icons.dialpad,
                        size: 18,
                        color: Color(0xFF6270A1),
                      ),
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
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Gender',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(0.0),
                  horizontalTitleGap: 0.0,
                  title: Text("Male",
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF414041),
                          fontWeight: FontWeight.w500)),
                  leading: Radio(
                    value: "Male",
                    groupValue: val,
                    onChanged: (_value) {
                      setState(() {
                        val = _value;
                      });
                    },
                    activeColor: Color(0xFFFF2562),
                  ),
                ),
              ),
              Flexible(
                child: ListTile(
                  horizontalTitleGap: 0.0,
                  contentPadding: const EdgeInsets.all(0.0),
                  title: Text("Female",
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF414041),
                          fontWeight: FontWeight.w500)),
                  leading: Radio(
                    value: "Female",
                    groupValue: val,
                    onChanged: (value) {
                      setState(() {
                        val = value;
                      });
                    },
                    activeColor: Color(0xFFFF2562),
                  ),
                ),
              ),
              Flexible(
                child: ListTile(
                  horizontalTitleGap: 0.0,
                  contentPadding: const EdgeInsets.all(0.0),
                  title: Text("Others",
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF414041),
                          fontWeight: FontWeight.w500)),
                  leading: Radio(
                    value: "Others",
                    groupValue: val,
                    onChanged: (value) {
                      setState(() {
                        val = value;
                      });
                    },
                    activeColor: Color(0xFFFF2562),
                  ),
                ),
              ),
            ],
          ),
          signUpButton(context),
          SizedBox(
            height: 20,
          ),
          if (_controller.state is UserLoading)
            CircularProgressIndicator(
              color: Color(0xFFFF2562),
            ),
        ],
      ),
    );
  }

  Widget passwordTextField() {
    return Container(
      child: TextFormField(
        obscureText: _isHidden,
        focusNode: passwordNode,
        keyboardType: TextInputType.text,
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
              favorite: ['+91', 'IN', "+1"],
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

  Widget signUpButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          if (!(_controller.state is UserLoading)) {
            _controller.register(
                name,
                email,
                countryCode.toString(),
                mobile,
                password,
                DateFormat('yyyy-MM-dd').format(selectedDate),
                //"${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
                val.toString(),
                deviceId,
                Platform.operatingSystem);
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
            'SIGN UP',
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
            ? GestureDetector(
                onTap: () {
                  signUpWithFacebook();
                },
                child: Container(
                  child: const Icon(
                    FontAwesomeIcons.facebookF,
                    color: Colors.white,
                    size: 24.0,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Color(0xFF406FFF),
                  ),
                ),
              )
            : Container(),
        SizedBox(
          width: 20,
        ),
        GestureDetector(
          onTap: () {
            _googleSignInPress();
          },
          child: Container(
            child: const Icon(
              FontAwesomeIcons.google,
              color: Colors.white,
              size: 24.0,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Color(0xFFCA4335),
            ),
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

  ///GOOGLE SIGN IN
  Future<void> _googleSignInPress() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final FirebaseAuth _auth = FirebaseAuth.instance;

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      (await _auth.signInWithCredential(credential)).user;

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
      //TODO: changes by adarsh
      // AuthCredential credentialGoogle =
      //     GoogleAuthProvider.credential(accessToken: googleAuth.accessToken);
      // (await FirebaseAuth.instance.signInWithCredential(credentialGoogle)).user;
    } catch (e) {
      print(e);
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

  RichText termsConditionsButton() {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
            text: 'I agreed to the ',
            style: TextStyle(
                fontSize: 14,
                color: Color(0xFF414041),
                fontWeight: FontWeight.bold),
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => GetPages(
                              pageId: '4',
                              pageTitle: 'Terms And Condition',
                            )));
              },
            text: 'Terms & Conditions ',
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: 'and ',
            style: TextStyle(
                fontSize: 14,
                color: Color(0xFF414041),
                fontWeight: FontWeight.bold),
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => GetPages(
                              pageId: '3',
                              pageTitle: 'Privacy Policy',
                            )));
              },
            text: 'Privacy Policy',
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.blue,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          )
        ]));
  }

  RichText signInButton(BuildContext context) {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
            text: 'Already have Account?',
            style: TextStyle(
                fontSize: 16,
                color: Color(0xFF414041),
                fontWeight: FontWeight.bold),
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pop(context);
                //TODO:: change by adarsh
                // Navigator.push(
                //     context, MaterialPageRoute(builder: (_) => LoginPage()));
              },
            text: ' Sign In',
            style: TextStyle(
                color: Color(0xFFFF2562),
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ]));
  }

  Widget customTextField(
      bool obscureText,
      FocusNode focusNode,
      TextInputType keyboardType,
      ValueChanged<String> onChanged,
      TextInputAction textInputAction,
      String hintText,
      IconData icon,
      FormFieldValidator<String> validator) {
    return Container(
      child: TextFormField(
        obscureText: obscureText,
        focusNode: focusNode,
        keyboardType: keyboardType,
        onChanged: onChanged,
        cursorColor: Color(0xFFFF2562),
        textInputAction: textInputAction,
        validator: validator,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(16),
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
                fontSize: 14,
                color: Color(0xFF414041),
                fontWeight: FontWeight.w500),
            prefixIcon: Icon(
              icon,
              size: 18,
              color: Color(0xFF6270A1),
            ),
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
    );
  }
}
