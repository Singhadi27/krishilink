import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/auth_controller.dart';
import '../../terms_widget.dart';
import '../../utils/app_color.dart';
import '../../widgets/my_widgets.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  int selectedRadio = 0;
  TextEditingController forgetEmailController = TextEditingController();

  void setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  bool isSignUp = false;

  late AuthController authController;

  @override
  void initState() {
    super.initState();
    authController = Get.put(AuthController());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * 0.08,
                ),
                isSignUp
                    ? myText(
                  text: 'Sign Up',
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                  ),
                )
                    : myText(
                  text: 'Login',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                isSignUp
                    ? Container(
                  child: myText(
                    text:
                    'Welcome, Please Sign up',
                    style: GoogleFonts.roboto(
                      letterSpacing: 0,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
                    : Container(
                  child: myText(
                    text:
                    'Welcome back, Please Sign in',
                    style: GoogleFonts.roboto(
                      letterSpacing: 0,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                SizedBox(
                  width: Get.width * 0.55,
                  child: TabBar(
                    labelPadding: EdgeInsets.all(Get.height * 0.01),
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.black,
                    indicatorColor: Colors.black,
                    onTap: (v) {
                      setState(() {
                        isSignUp = !isSignUp;
                      });
                    },
                    tabs: [
                      myText(
                        text: 'Login',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black),
                      ),
                      myText(
                        text: 'Sign Up',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.04,
                ),
                SizedBox(
                  width: Get.width,
                  height: Get.height * 0.6,
                  child: Form(
                    key: formKey,
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        LoginWidget(),
                        SignUpWidget(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget LoginWidget(){
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              myTextField(
                  bool: false,
                  icon: 'assets/mail.png',
                  text: 'adityassingh6513@gmail.com',
                  validator: (String input){
                    if(input.isEmpty){
                      Get.snackbar('Warning', 'Email is required.',colorText: Colors.white,backgroundColor: Colors.green);
                      return '';
                    }

                    if(!input.contains('@')){
                      Get.snackbar('Warning', 'Email is invalid.',colorText: Colors.white,backgroundColor: Colors.green);
                      return '';
                    }
                  },
                  controller: emailController
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              myTextField(
                  bool: true,
                  icon: 'assets/lock.png',
                  text: 'password',
                  validator: (String input){
                    if(input.isEmpty){
                      Get.snackbar('Warning', 'Password is required.',colorText: Colors.white,backgroundColor: Colors.green);
                      return '';
                    }

                    if(input.length <6){
                      Get.snackbar('Warning', 'Password should be 6+ characters.',colorText: Colors.white,backgroundColor: Colors.green);
                      return '';
                    }
                  },
                  controller: passwordController
              ),
              InkWell(
                onTap: () {
                  Get.defaultDialog(
                      title: 'Forget Password?',
                      content: SizedBox(
                        width: Get.width,
                        child: Column(
                          children: [
                            myTextField(
                                bool: false,
                                icon: 'assets/lock.png',
                                text: 'enter your email...',
                                controller: forgetEmailController
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            MaterialButton(
                              color: Colors.green,
                              onPressed: (){
                                 authController.forgetPassword(forgetEmailController.text.trim());
                              },minWidth: double.infinity,child: const Text("Sent"),)

                          ],
                        ),
                      )
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: Get.height * 0.05,
                  ),
                  child: myText(
                      text: 'Forgot password?',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      )),
                ),
              ),
            ],
          ),

          Obx(() => authController.isLoading.value? const Center(child: CircularProgressIndicator(),)  :Container(
            height: 50,
            margin: EdgeInsets.symmetric(vertical: Get.height * 0.04),
            width: Get.width,
            child: ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                authController.login(email: emailController.text.trim(),password: passwordController.text.trim());
                // Perform login action here
                print('Login button pressed');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green), // Set button color to orange[900]
                elevation: MaterialStateProperty.all(10), // Add elevation for shadow effect
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), // Set border radius
              ),
              child: const Text('Login',
                style:TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                ),),

            ),
          )),

          SizedBox(
            height: Get.height *0.025,
          ),
          myText(
            text: 'Or Connect With',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            ),
          ),
          SizedBox(
            height: Get.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              socialAppsIcons(
                  text: 'assets/fb.png',
                  onPressed: (){

                    //Get.to(()=> ProfileScreen());

                  }
              ),

              socialAppsIcons(
                  text: 'assets/google.png',
                  onPressed: (){

                    authController.signInWithGoogle();

                  }

              ),
            ],
          )
        ],
      ),
    );
  }

  Widget SignUpWidget(){
    return SingleChildScrollView(
      child: Column(
        children: [
          myTextField(
            bool: false,
            icon: 'assets/mail.png',
            text: 'Email',
            validator: (String input) {
              if(input.isEmpty){
                Get.snackbar('Warning', 'Email is required.', colorText: Colors.white, backgroundColor: Colors.green);
                return '';
              }
              if(!input.contains('@')){
                Get.snackbar('Warning', 'Email is invalid.', colorText: Colors.white, backgroundColor: Colors.green);
                return '';
              }
            },
            controller: emailController,
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          myTextField(
            bool: true,
            icon: 'assets/lock.png',
            text: 'password',
            validator: (String input) {
              if(input.isEmpty){
                Get.snackbar('Warning', 'Password is required.', colorText: Colors.white, backgroundColor: Colors.green);
                return '';
              }
              if(input.length < 6){
                Get.snackbar('Warning', 'Password should be 6+ characters.', colorText: Colors.white, backgroundColor: Colors.green);
                return '';
              }
            },
            controller: passwordController,
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          myTextField(
            bool: false,
            icon: 'assets/lock.png',
            text: 'Re-enter password',
            validator: (input){
              if(input != passwordController.text.trim()){
                Get.snackbar('Warning', 'Confirm Password is not same as password.', colorText: Colors.white, backgroundColor: Colors.green);
                return '';
              }
            },
            controller: confirmPasswordController,
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          // Section to choose between Farmer and Trader
          Column(
            children: [
              myText(
                text: 'Sign up as:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    value: 0,
                    groupValue: selectedRadio,
                    onChanged: (val) {
                      setSelectedRadio(val as int);
                    },
                    activeColor: Colors.green,
                  ),
                  myText(
                    text: 'Farmer',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.black,
                    ),
                  ),
                  Radio(
                    value: 1,
                    groupValue: selectedRadio,
                    onChanged: (val) {
                      setSelectedRadio(val as int);
                    },
                    activeColor: Colors.green,
                  ),
                  myText(
                    text: 'Trader',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Obx(() => authController.isLoading.value ? const Center(child: CircularProgressIndicator(),) : Container(
            height: 50,
            margin: EdgeInsets.symmetric(vertical: Get.height * 0.04),
            width: Get.width,
            child: ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }

                authController.signUp(email: emailController.text.trim(), password: passwordController.text.trim());
                // Perform signup action here
                print('Sign Up button pressed');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green), // Set button color to green
                elevation: MaterialStateProperty.all(10), // Add elevation for shadow effect
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), // Set border radius
              ),
              child: const Text('Sign Up',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

}
