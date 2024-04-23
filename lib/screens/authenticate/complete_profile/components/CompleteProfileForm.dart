import 'package:brain_train_app/routes/app_route.dart';
import 'package:brain_train_app/services/AuthService.dart';
import 'package:brain_train_app/services/ResultEnum.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../services/services.dart';
import '../../shared/DefaultButton.dart';
import '../../shared/InputFieldDecoration.dart';
import '../../shared/constants.dart';
import '../../shared/size_config.dart';

class CompleteProfileForm extends StatefulWidget {
  const CompleteProfileForm({super.key});

  @override
  State<CompleteProfileForm> createState() => _SignupFormState();
}

List<String> genderOptions = ['MALE', 'FEMALE'];

class _SignupFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();

  String fullname = "";
  late DateTime dob;
  // to display date in format "dd/MM/yyyy" in the text form field
  TextEditingController dobController = TextEditingController();

  String gender = "";

  @override
  void initState() {
    super.initState();
    dob = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildFullnameInputField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildDobInputField(),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildGenderCheckbox(),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Tiếp tục",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? phone = await prefs.getString("phone") ?? "";
                String date = "${dob.year}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}";
                var res =
                    await Services.instance.setContext(context).addInfoUser(phone, fullname, date, gender);
                if (res != false) {
                  Navigator.pushNamed(context, RouteGenerator.login);
                } 
              }
            },
          ),
        ],
      ),
    );
  }

  Padding buildGenderCheckbox() {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(21)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Giới tính",
            style: TextStyle(fontSize: getProportionateScreenWidth(16)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: RadioListTile(
              value: genderOptions[0],
              groupValue: gender,
              title: const Text("Nam"),
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
              tileColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              activeColor: kPrimaryColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 5),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: RadioListTile(
              value: genderOptions[1],
              groupValue: gender,
              title: const Text("Nữ"),
              onChanged: (value) {
                setState(() {
                  gender = value!;
                });
              },
              tileColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              activeColor: kPrimaryColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 5),
            ),
          ),
        ],
      ),
    );
  }

  TextFormField buildFullnameInputField() {
    return TextFormField(
      onSaved: (newValue) => fullname = newValue!,
      validator: (value) {
        if (value!.isEmpty) {
          return kNameNullError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: buildInputFieldDecoration(
        "Họ và tên",
        "Nhập họ và tên",
        Icons.person_outline,
      ),
    );
  }

  TextFormField buildDobInputField() {
    return TextFormField(
      readOnly: true,
      controller: dobController,
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        ).then((value) {
          setState(() {
            dob = value!;
            dobController.text = DateFormat('dd/MM/yyyy').format(value);
          });
        });
      },
      validator: (value) {
        if (value!.isEmpty) {
          return kDobNullError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: buildInputFieldDecoration(
        "Ngày sinh",
        "Nhập ngày sinh",
        Icons.calendar_month_outlined,
      ),
    );
  }

  showFailAlert({required context}) {
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: "Đã Xảy Ra Lỗi",
      widget: Text(
        "Xin hãy điền lại thông tin...",
        style: TextStyle(
          fontSize: getProportionateScreenWidth(16),
        ),
      ),
      confirmBtnText: "OK",
      confirmBtnColor: Colors.blue.shade700,
    );
  }
}
