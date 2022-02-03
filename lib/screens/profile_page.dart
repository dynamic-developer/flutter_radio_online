import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:radio_online/api_calling/api_service.dart';
import 'package:radio_online/api_calling/api_state.dart';
import 'package:radio_online/api_calling/controllers/editProfileController.dart';
import 'package:radio_online/api_calling/models/user.dart';
import 'package:radio_online/helper/shared_pref.dart';
import 'package:intl/intl.dart';
import 'package:radio_online/screens/home-page.dart';
import 'package:radio_online/screens/pages.dart';

import '../main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _controller = Get.put(EditProfileController());
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final userNameNode = FocusNode();
  final emailNode = FocusNode();
  final mobileNode = FocusNode();

  DateTime selectedDate = DateTime.now();
  TextEditingController initialDate = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  SharedPref sharedPref = SharedPref();
  Object? val = "Male";
  late String countryCode;
  String initialCountryCode = "";

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1500, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) selectedDate = picked;
    initialDate.value =
        TextEditingValue(text: DateFormat('yyyy-MM-dd').format(picked!));
  }

  @override
  void initState() {
    Get.lazyPut(
      () => EditProfileController(),
    );

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _controller.resetEditProfile();
    });
    initialDate.text =
        (userLoad.data!.birthDate == null ? '' : userLoad.data!.birthDate)!;
    val = userLoad.data!.gender;
    name.text =
        userLoad.data!.name == null ? '' : userLoad.data!.name!.toString();
    email.text =
        userLoad.data!.email == null ? '' : userLoad.data!.email!.toString();
    mobile.text =
        userLoad.data!.mobile == null ? '' : userLoad.data!.mobile.toString();
    if (userLoad.data!.birthDate != null) {
      selectedDate = DateTime.parse(userLoad.data!.birthDate.toString());
    }
    initialCountryCode = userLoad.data!.countryCode == null
        ? ''
        : userLoad.data!.countryCode.toString();
    super.initState();
  }

  @override
  void dispose() {
    userNameNode.dispose();
    emailNode.dispose();
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
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFEFF0F6),
        appBar: appBar(),
        body: Obx(() {
          if (_controller.state is EditProfileFailed) {
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
          if (_controller.state is EditProfileError) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              _scaffoldKey.currentState!.showSnackBar(SnackBar(
                content: Text(
                  (_controller.state as EditProfileError).message.toString(),
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ));
            });
          }
          if (_controller.state is EditProfileLoaded) {
            WidgetsBinding.instance!.addPostFrameCallback((_) async {
              //ScaffoldMessenger.of(context).clearSnackBars();
              UserAuth userSave = (_controller.state as EditProfileLoaded).user;
              await sharedPref.save("user", userSave);
              userLoad = UserAuth.fromJson(await sharedPref.read("user"));
              _scaffoldKey.currentState!.showSnackBar(SnackBar(
                content: Text(
                  (_controller.state as EditProfileLoaded)
                      .user
                      .message
                      .toString(),
                ),
                duration: Duration(seconds: 2),
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
          if (userLoad.data!.name == null ||
              userLoad.data!.countryCode == null ||
              userLoad.data!.mobile == null ||
              userLoad.data!.birthDate == null ||
              userLoad.data!.gender == null) {
            _scaffoldKey.currentState!.showSnackBar(SnackBar(
              content: Text("Please fill the detail."),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ));
          } else {
            Navigator.pop(context);
          }
        },
        child: Icon(
          Icons.arrow_back,
          size: 30,
          color: Color(0xFF6270A1),
        ),
      ),
      centerTitle: true,
      title: Text('Profile',
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
          customTextField(false, name.text, userNameNode, TextInputType.name,
              (value) {
            name.text = value;
          }, TextInputAction.next, 'Name', Icons.person),
          SizedBox(
            height: 20,
          ),
          customTextField(
              false, email.text, emailNode, TextInputType.emailAddress,
              (value) {
            email.text = value;
          }, TextInputAction.next, 'Email Address', Icons.email),
          SizedBox(
            height: 20,
          ),
          mobileNo(),
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
                      hintText: 'Date of birth',
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
                      if (mounted) {
                        setState(() {
                          val = _value;
                        });
                      }
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
                      if (mounted) {
                        setState(() {
                          val = value;
                        });
                      }
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
                      if (mounted) {
                        setState(() {
                          val = value;
                        });
                      }
                    },
                    activeColor: Color(0xFFFF2562),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          saveButton(context),
          SizedBox(
            height: 20,
          ),
          if (_controller.state is EditProfileLoading)
            CircularProgressIndicator(
              color: Color(0xFFFF2562),
            )
        ],
      ),
    );
  }

  Widget customTextField(
      bool obscureText,
      String initialValue,
      FocusNode focusNode,
      TextInputType keyboardType,
      ValueChanged<String> onChanged,
      TextInputAction textInputAction,
      String hintText,
      IconData icon) {
    return Container(
      child: TextFormField(
        obscureText: obscureText,
        initialValue: initialValue,
        focusNode: focusNode,
        keyboardType: keyboardType,
        onChanged: onChanged,
        cursorColor: Color(0xFFFF2562),
        textInputAction: textInputAction,
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

  Widget mobileNo() {
    return Container(
      child: TextFormField(
        obscureText: false,
        initialValue: mobile.text,
        keyboardType: TextInputType.phone,
        focusNode: mobileNode,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 12),
          prefixIcon: SizedBox(
            width: 20,
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
          mobile.text = value;
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

  Widget saveButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          if (!(_controller.state is EditProfileLoading)) {
            _controller.editProfile(
                name.text,
                email.text,
                countryCode.toString(),
                mobile.text,
                DateFormat('yyyy-MM-dd').format(selectedDate),
                val.toString(),
                userLoad.data!.apiToken.toString());
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => Pages(
                          page: HomePage(),
                          index: 0,
                        )));
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
