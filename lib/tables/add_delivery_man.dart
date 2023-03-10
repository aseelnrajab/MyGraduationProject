import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/screens/basic/helper.dart';
import '../../pref/shared_pref_controller.dart';
import '../controllers/fb-fir-stor-man-delivery.dart';
import '../models/register_men.dart';

//ملف اضافة موظف
class AddDeliveryMan extends StatefulWidget {
  const AddDeliveryMan({Key? key}) : super(key: key);

  @override
  State<AddDeliveryMan> createState() => _AddDeliveryManState();
}

class _AddDeliveryManState extends State<AddDeliveryMan> with Helper {
  //controller لحتى يتحكم بالمدخلات
  late TextEditingController _identificationNumberController;
  late TextEditingController _firstNameController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _passwordController;
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;
  String? _identificationNumberError;
  String? _passwordError;
  String? _firstError;
  String? _confirmPasswordError;
  bool? determineTheInternetConnection;
  List<String> ident = <String>[];

  //
  // getDeliveryMen() async {
  //   await FirebaseFirestore.instance.collection('Men').get().then((value) {
  //     for (int i = 0; i < value.docs.length; i++) {
  //       ident[i] = value.docs[i].get('identificationNumber');
  //     }
  //   });
  // }

  //كل controller بنعمله لازمه initState method
  @override
  void initState() {
    super.initState();
    _identificationNumberController = TextEditingController();
    _passwordController = TextEditingController();
    _firstNameController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

//وكل controller لازمه dispose لانهائه
  @override
  void dispose() {
    _identificationNumberController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
            color: Colors.black,
          ),

          title: const Text(
            'اضافة موظف جديد',
            style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          //عنوان الاب بار
          centerTitle: true,
          // سنترنا العنوان
          backgroundColor: const Color(0xffffcc33),

          // لون خلفيه الاب بار
          //shadowColor: Colors.black,
          // لحتى يتواجد ظل اسود تحت الاب بار
          elevation: 0, // درجة الظل
        ),
        body: Container(
          padding:
              const EdgeInsets.only(right: 40, left: 40, bottom: 40, top: 50),
          color: Colors.grey.shade100,
          alignment: Alignment.center,
          height: double.infinity,
          child: Column(children: [
            Expanded(
              child: ListView(shrinkWrap: true, children: [
                TextField(
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Tajawal'),
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    errorText: _firstError,
                    label: const Text(
                      'الاسم الأول ',
                      style:
                          TextStyle(color: Colors.black, fontFamily: 'Tajawal'),
                    ),
                    prefixIcon: const Icon(
                      Icons.text_format,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Tajawal'),
                  controller: _identificationNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    errorText: _identificationNumberError,
                    label: const Text(
                      'رقم هوية الموظف',
                      style:
                          TextStyle(color: Colors.black, fontFamily: 'Tajawal'),
                    ),
                    prefixIcon: const Icon(
                      Icons.text_format,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Tajawal'),
                    controller: _passwordController,
                    obscureText: _obscureTextPassword,
                    decoration: InputDecoration(
                      errorText: _passwordError,
                      icon: const Icon(
                        Icons.lock,
                      ),
                      label: const Text(
                        "ادخل كلمة المرور",
                        style: TextStyle(
                            color: Colors.black, fontFamily: 'Tajawal'),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureTextPassword = !_obscureTextPassword;
                          });
                        },
                        icon: Icon(
                            _obscureTextPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xffffcc33)),
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Tajawal'),
                    controller: _confirmPasswordController,
                    obscureText: _obscureTextConfirmPassword,
                    decoration: InputDecoration(
                      errorText: _confirmPasswordError,
                      icon: const Icon(
                        Icons.lock,
                      ),
                      label: const Text(
                        "تأكيد كلمة المرور",
                        style: TextStyle(
                            color: Colors.black, fontFamily: 'Tajawal'),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureTextConfirmPassword =
                                !_obscureTextConfirmPassword;
                          });
                        },
                        icon: Icon(
                            _obscureTextConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xffffcc33)),
                      ),
                    )),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  // color: Colors.yellow.shade500,
                  height: 60.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent, width: 1),
                    color: const Color(0xffffcc33),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(30),
                  ),

                  child: MaterialButton(
                    //زر لتاكيد إنششاء الحساب
                    onPressed: () async {
                      await initConnectivity(); //لفخص الاتصال بالانترنت
                      //لو ما في نت بظهر رساله
                      if (determineTheInternetConnection == false) {
                        showsnakbar(
                            Context: context,
                            massage: 'غير متصل بالانترنت حاليا',
                            error: true);
                      }
                      //لو في نت بنفذ انشاء موظف
                      else if (determineTheInternetConnection == true) {
                        await performRegistrationDeliveryMan();
                      }
                    },

                    child: const Text(
                      ' إنشاء حساب',
                      style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                  ),
                ),
              ]),
            ),
          ]),
        ));
  }
  //Function لحتى انفذ الانشاء
  //بكل مرة بدو يجيب ال identification number يلي في الcollection
  //وبقارنها وحده وحده مع الي ادخله المستخدم لحتى يتاكد ما ادخل اشي مكرر
  Future<void> performRegistrationDeliveryMan() async {
    bool check = true;
    //بنعمل get للكولكشن يلي بالفايرستور في الفايربيس لحتى نكتب عليها
    await FirebaseFirestore.instance.collection('Men').get().then(
      (value) {
        // docs
        //getأصله من نوع
        //بحيب كل الدوكيمنت بهاد الكولكشن
        //بوصله لحتى أضيف الداتا
        for (int i = 0; i < value.docs.length; i++) {
          //ident Array identified by this class .
          ident.add(value.docs[i].get('identificationNumber'));
          if (_identificationNumberController.text == ident[i]) {
            //لو مدخل من قبل بظهر رساله انه موجود مسبقا
            showsnakbar(
              Context: context,
              massage: 'رقم الهوية هذا موجود مسبقا',
              error: true,
            );

            check = false;
            break;
          }
        }
      },
    );
    //لو ما لقي شبيه بروح بتاكد من المعلومات المدخله
    if (checkData() && //first call this method
        checkIdentificationNumber() &&
        checkPassword() &&
        check) {
      await registerDeliveryMan();
    }
  }
//بفخص المدخل
  bool checkData() {
    //data مش فاضيه
    if (_identificationNumberController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _firstNameController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty) {
      controlError();
      return true;
    }
    else {
      controlError();
      showSnackBarMessage();
      return false;
    }
  }

  //لو كان فاضيه البيانات بعمل تعليمات انه يدخل البيانات

  void controlError() {
    setState(() {
      _firstError =
          _identificationNumberController.text.isEmpty ? 'ادخل الاسم' : null;
      _passwordError =
          _passwordController.text.isEmpty ? 'ادخل كلمة المرور' : null;
      _identificationNumberError =
          _firstNameController.text.isEmpty ? 'ادخل رقم الهوية' : null;
      _confirmPasswordError = _confirmPasswordController.text.isEmpty
          ? 'ادخل تأكيد كلمة المرور'
          : null;
    });
  }

  //بظهر رساله انه في خطأ
  void showSnackBarMessage() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('خطأ في المعلومات المُدخلة'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        onVisible: () => print('Visible'),
        //to know that the error showed
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 20, left: 30, right: 30),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
            label: 'تخطي', textColor: Colors.white, onPressed: () {})));
  }

  //يتحقق من الباسورد انه طوله اكبر من ٦
  bool checkPassword() {
    bool statusLengthen = _passwordController.text.length >= 6;
    bool statusEqual =
        _passwordController.text == _confirmPasswordController.text;
    bool checkPassword = statusLengthen && statusEqual;

    if (checkPassword) {
      return true;
    } else if (!statusLengthen) {
      showsnakbar(
        Context: context,
        massage: 'كلمة المرور يجب ان تكون اكبر من او تساوي ست حروف او ارقام'
            '',
        error: true,
      );
      return false;
    } else if (!statusEqual) {
      showsnakbar(
        Context: context,
        massage: 'كلمة المرور الجديدة لا تتطابق مع تأكيد كلمة مرور ',
        error: true,
      );
      return false;
    }
    return false;
  }

  // bool checkIf() {
  //   for (int i = 0; i < ident.length; i++) {
  //     if (_identificationNumberController.text == ident[i].toString()) {
  //       showsnakbar(
  //         Context: context,
  //         massage: 'رقم الهوية هذا موجود مسبقا',
  //         error: true,
  //       );
  //       return false;
  //     }
  //   }
  //   return true;
  // }


  //يتامد انه رقم الهويه ٩ ارقام
  bool checkIdentificationNumber() {
    bool statusLengthen = _identificationNumberController.text.length == 9;
    if (statusLengthen) {
      return true;
    } else if (!statusLengthen) {
      showsnakbar(
        Context: context,
        massage: 'رقم الهوية يجب ان يحتوي على تسع ارقام',
        error: true,
      );
      return false;
    }
    return false;
  }

  //بنفذ الانشاء
  Future<void> registerDeliveryMan() async {
    bool status = await FbFirestoreRegistrationMenController()
        .crateDeliveryMan(man: deliveryMan);
    if (status) {
      clear();// بعمل كلير للتيسكت فيلدز كامله
      showsnakbar(Context: context, massage: 'تم اضافة الموظف بنجاح');
    }
  }

  DeliveryMan get deliveryMan {
    //معلومات رجل التوصيل
    DeliveryMan men = DeliveryMan();
    //Orders order = widget.orders==null?Orders():widget.orders!;
    men.identificationNumber = _identificationNumberController.text;
    men.firstName = _firstNameController.text;
    men.password = _passwordController.text;
    men.companyName = SharedPrefController().companyName;
    return men;
  }

  Future<void> initConnectivity() async {
    //تحقق الانترنت
    late ConnectivityResult result;
    try {
      result = await Connectivity().checkConnectivity();
    } on PlatformException catch (e) {
      print("Error Occurred: ${e.toString()} ");
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    if (result == ConnectivityResult.none) {
      return updateConnectionState(result);
    } else if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      return updateConnectionState(result);
    }
  }

  Future<void> updateConnectionState(ConnectivityResult result) async {
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      showStatus(result, true);
    } else {
      showStatus(result, false);
    }
  }

  void showStatus(ConnectivityResult result, bool status) {
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      determineTheInternetConnection = status;
    } else {
      determineTheInternetConnection = status;
    }
  }


  void clear() {
    _identificationNumberController.text = '';
    _firstNameController.text = '';
    _passwordController.text = '';
    _confirmPasswordController.text = '';
  }
}
