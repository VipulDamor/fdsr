import 'package:fdsr/component/edit_text.dart';
import 'package:fdsr/component/rounded_button.dart';
import 'package:fdsr/modules/editProfile/edit_profile_controller.dart';
import 'package:fdsr/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class EditProfile extends StatelessWidget {
  final editprofileController = Get.put(EditProfileController());
  final sharedPrefarance = GetStorage();

  @override
  Widget build(BuildContext context) {
    var userID = sharedPrefarance.read(Constant.KEY_USERID);
    editprofileController.setText(userID);
    Size size = Get.size;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Info',
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: size.height *
                (size.height > 770
                    ? 0.7
                    : size.height > 670
                        ? 0.8
                        : 0.9),
            width: 500,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(0),
                  ),
                  padding: EdgeInsets.all(6),
                  child: Text(
                    'ⓘ Personal info.',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      EditText(
                        'Awesome Name',
                        false,
                        Icons.person,
                        (value) {},
                        editprofileController.userNameController,
                        textInputType: TextInputType.name,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      EditText(
                        'About',
                        false,
                        Icons.info_outline,
                        (value) {},
                        editprofileController.aboutController,
                        textInputType: TextInputType.text,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      EditText(
                        'Mobile',
                        false,
                        Icons.phone_android,
                        (value) {},
                        editprofileController.mobileController,
                        textInputType: TextInputType.phone,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      EditText(
                        'Address',
                        false,
                        Icons.location_on_outlined,
                        (value) {},
                        editprofileController.addressController,
                        textInputType: TextInputType.streetAddress,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      RoundedButton('Update', () {
                        editprofileController.updateFirebaseProfile(userID);
                      }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
