import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:topup_shop/components/appbar.dart';
import 'package:topup_shop/components/custom_field.dart';
import 'package:topup_shop/components/my_carosel.dart';
import 'package:topup_shop/models/offer.dart';
import 'package:topup_shop/models/order.dart' as repo;
import 'package:topup_shop/routes/my_routes.dart';
import 'package:topup_shop/screens/admin_screen.dart';

class OfferScreen extends StatefulWidget {
  const OfferScreen({Key? key, this.name, this.gameId}) : super(key: key);
  final String? name;
  final String? gameId;

  @override
  State<OfferScreen> createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  final _pcKey = GlobalKey<FormState>();
  final _mobKey = GlobalKey<FormState>();
  FirebaseFirestore db = FirebaseFirestore.instance;
  String? transactionId, contact;
  List<Offer> offers = [];
  bool _isLoading = false;

  Offer? selected;

  Future<void> getOffers() async {
    setState(() {
      _isLoading = true;
    });
    db
        .collection("Offers")
        .where("offerType", isEqualTo: widget.name)
        .get()
        .then((value) => {
              // ignore: avoid_function_literals_in_foreach_calls
              value.docs.forEach((element) {
                setState(() {
                  offers.add(Offer.fromJson(element.data()));
                });
              }),
              setState(() {
                _isLoading = false;
              })
            });
  }

  Future<void> submitOrder(GlobalKey<FormState> _key) async {
    if (_key.currentState!.validate()) {
      repo.Order order = repo.Order(
        name: selected!.name,
        quantity: selected!.quantity,
        dateTime: DateTime.now(),
        status: FilterVal.pending,
        transactionId: transactionId!,
        contact: contact!,
        offerType: selected!.offerType,
        gameId: widget.gameId!,
      );
      setState(() {
        _isLoading = true;
      });
      await db.collection("Orders").doc().set(order.toJson);
      setState(() {
        _isLoading = false;
      });
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              titlePadding: const EdgeInsets.only(left: 15, top: 25),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              actionsPadding: const EdgeInsets.only(right: 15, bottom: 25),
              title: const Text('Order Successful'),
              content: SizedBox(
                width: 30,
                height: 180,
                child: Column(
                  children: [
                    const Text(
                        "Your order has beed placed successfully. You will get your ordered product within 12 to 24 working hours."),
                    const SizedBox(height: 8),
                    const Text(
                        "In case of any query, feel free to contact us on the given numbers"),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Text(
                          "WhatsApp:",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 16),
                        SelectableText(
                          "03048550649",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: const [
                        Text(
                          "Phone",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 41),
                        SelectableText(
                          "03048550649",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Ok",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ],
            );
          });
    }
  }

  @override
  void didChangeDependencies() {
    if (widget.name == null || widget.name!.isEmpty) {
      context.go(Routes.home);
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    getOffers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: customAppBar(size, context),
      body: SingleChildScrollView(
        child: Visibility(
          visible: !_isLoading,
          replacement: SizedBox(
              width: size.width,
              height: size.height,
              child: const Center(child: CircularProgressIndicator())),
          child: Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                customCarosel(size),
                const SizedBox(height: 20),
                SizedBox(
                  width: size.width > 850 ? size.width * .7 : size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width > 850
                            ? selected != null
                                ? size.width * .3
                                : size.width * .6
                            : size.width * .9,
                        child: ListView.builder(
                            itemCount: offers.length,
                            shrinkWrap: true,
                            itemBuilder: ((context, index) {
                              Offer offer = offers[index];
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selected = offer;
                                  });
                                  if (size.width <= 850) {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: ((context) {
                                          return SingleChildScrollView(
                                              child: detailsCard(size,
                                                  size.width <= 850, _mobKey));
                                        }));
                                  }
                                },
                                child: Card(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  elevation: 8,
                                  child: ListTile(
                                    leading: Radio<Offer>(
                                      groupValue: selected,
                                      value: offer,
                                      onChanged: (value) {
                                        setState(() {
                                          selected = value;
                                        });
                                      },
                                    ),
                                    title: Text(offer.name),
                                    subtitle: Text(offer.price),
                                  ),
                                ),
                              );
                            })),
                      ),
                      selected != null && size.width > 850
                          ? detailsCard(size, size.width <= 850, _pcKey)
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card detailsCard(Size size, bool isMobile, GlobalKey<FormState> _key) {
    return Card(
      margin: const EdgeInsets.only(left: 20),
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: isMobile ? size.width : size.width * .3,
        height: 900,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selected!.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              selected!.description,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  "Quantity:",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 50),
                Text(
                  "${selected!.quantity.toString()} ${selected!.offerType == OfferType.pubg ? 'UC' : 'Diamonds'}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Text(
                  "Price:",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 67),
                Text(
                  selected!.price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Text(
                  "JazzCash:",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 43),
                SelectableText(
                  "03048550649",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: const [
                Text(
                  "Easypaisa:",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 41),
                SelectableText(
                  "03048550649",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Bank Details:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: const [
                Text(
                  "Bank Name:",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 36),
                SelectableText(
                  "Bank-Al-Habib",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: const [
                Text(
                  "Account Number:",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 7),
                SelectableText(
                  "11410048009862016",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: const [
                Text(
                  "Account Title:",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 28),
                SelectableText(
                  "Wajahat Hussain",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Form(
              key: _key,
              child: Column(
                children: [
                  customField("Transaction ID", (val) => transactionId = val),
                  const SizedBox(height: 10),
                  customField("Contact Number", (val) => contact = val),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: MaterialButton(
                color: Colors.orange,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                onPressed: () => submitOrder(_key),
                child: const Text("Confirm Order"),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "NOTE:",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            Text(
              "Transfer the price amount into one of the given accounts and click confirm button below. You will not get any UC or Diamond if you click the confirm button without sending the price amount. If you put the wrong transaction ID and click the confirm button, don't worry, you can create another order with the right transaction ID.",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.width > 1026
                      ? 16
                      : isMobile
                          ? 16
                          : 12,
                  color: Colors.red),
            ),
            const SizedBox(height: 10),
            Text(
              "قیمت کی رقم کو دیئے گئے اکاؤنٹس میں سے کسی ایک میں منتقل کریں اور نیچے کنفرم بٹن پر کلک کریں۔ اگر آپ قیمت کی رقم بھیجے بغیر کنفرم بٹن پر کلک کرتے ہیں تو آپ کو کوئی UC یا ڈائمنڈ نہیں ملے گا۔ اگر آپ غلط ٹرانزیکشن آئی ڈی ڈالتے ہیں اور کنفرم بٹن پر کلک کرتے ہیں تو پریشان نہ ہوں، آپ صحیح ٹرانزیکشن آئی ڈی کے ساتھ دوبارہ آرڈر کر سکتے ہیں۔",
              textDirection: TextDirection.rtl,
              locale: const Locale("ur"),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.width > 1026
                      ? 16
                      : isMobile
                          ? 16
                          : 12,
                  color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
