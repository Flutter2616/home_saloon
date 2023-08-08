import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:get/get.dart';
import 'package:home_saloon/screen/homescreen/home_screen.dart';
import 'package:home_saloon/screen/payment_screen/payment_controller.dart';
import 'package:home_saloon/screen/payment_screen/payment_modal.dart';
import 'package:home_saloon/utils/firebase_data.dart';
import 'package:sizer/sizer.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({super.key});

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

//0xff6E4CFE
class _AddPaymentScreenState extends State<AddPaymentScreen> {
  TextEditingController txtname = TextEditingController();
  TextEditingController txtcardnumber = TextEditingController();
  TextEditingController txtdate = TextEditingController();
  TextEditingController txtcvv = TextEditingController();

  Paymentcontroller payment = Get.put(Paymentcontroller());

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back, color: Colors.black, size: 18.sp),
              ),
              const SizedBox(height: 10),
              Text('Add a Card',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp)),
              const SizedBox(height: 25),
              CreditCardForm(
                formKey: formKey,
                obscureCvv: true,
                obscureNumber: false,
                isHolderNameVisible: true,
                isCardNumberVisible: true,
                isExpiryDateVisible: true,
                cardHolderName: "${payment.cardname.value}",
                expiryDate: "${payment.carddate.value}",
                themeColor: Colors.black,
                textColor: Colors.black,
                enableCvv: true,
                onFormComplete: () {
                  print("card value==${payment.cardnumber}");
                  print("card value==${payment.cardcvv}");
                  print("card value==${payment.carddate}");
                  print("card value==${payment.cardname}");
                  Paymentmodal modal = Paymentmodal(
                      cardcvv: "${payment.cardcvv}",
                      carddate: "${payment.carddate}",
                      cardname: "${payment.cardname}",
                      cardnumber: "${payment.cardnumber}");
                  Firebasedata.data.add_Card(modal, "${user['uid']}");
                  payment.cardname.value='';
                  payment.cardnumber.value='';
                  payment.cardcvv.value='';
                  payment.carddate.value='';
                  Get.back();
                },
                cardNumberDecoration: InputDecoration(
                  labelText: 'Number',
                  hintText: 'XXXX XXXX XXXX XXXX',
                  hintStyle: const TextStyle(color: Colors.black),
                  labelStyle: const TextStyle(color: Colors.black),
                ),
                expiryDateDecoration: InputDecoration(
                  hintStyle: const TextStyle(color: Colors.black),
                  labelStyle: const TextStyle(color: Colors.black),
                  labelText: 'Expired Date',
                  hintText: 'XX/XX',
                ),
                cvvCodeDecoration: InputDecoration(
                  hintStyle: const TextStyle(color: Colors.black),
                  labelStyle: const TextStyle(color: Colors.black),
                  labelText: 'CVV',
                  hintText: 'XXX',
                ),
                cardHolderDecoration: InputDecoration(
                  hintStyle: const TextStyle(color: Colors.black),
                  labelStyle: const TextStyle(color: Colors.black),
                  labelText: 'Card Holder',
                ),
                onCreditCardModelChange: (CreditCardModel credit) {
                 payment.cardnumber.value=credit.cardNumber;
                 payment.carddate.value=credit.expiryDate;
                 payment.cardcvv.value=credit.cvvCode;
                 payment.cardname.value=credit.cardHolderName;
                },
                cardNumber: '${payment.cardnumber.value}',
                cvvCode: '${payment.cardcvv.value}',
              )
            ],
          ),
        ),
      ),
    );
  }

  TextFormField Carddetail(TextEditingController controller, String title) {
    return TextFormField(
      controller: controller,
      style: TextStyle(
          fontSize: 12.sp, color: Colors.black, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: "$title",
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12.sp),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff6E4CFE),
          ),
          borderRadius: BorderRadius.circular(8.sp),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8.sp),
        ),
      ),
    );
  }
}
