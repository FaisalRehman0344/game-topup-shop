import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:topup_shop/components/appbar.dart';
import 'package:topup_shop/models/login_state.dart';
import 'package:topup_shop/models/offer.dart';
import 'package:topup_shop/models/order.dart' as my;
import 'package:topup_shop/routes/my_routes.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

enum FilterVal { pending, approved, canceled }

class _AdminScreenState extends State<AdminScreen> {
  FilterVal filter = FilterVal.pending;
  Map<String, dynamic> newOffer = {};
  final _key = GlobalKey<FormState>();
  bool isLogin = false;
  List<String> inputFields = [
    "Name",
    "Price",
    "Quantity",
    "Description",
  ];

  FirebaseFirestore db = FirebaseFirestore.instance;

  void updateStatus(my.Order order) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              titlePadding: const EdgeInsets.only(left: 15, top: 25),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              actionsPadding: const EdgeInsets.only(right: 15, bottom: 25),
              title: const Text('Change Order Status'),
              content: SizedBox(
                height: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Select a status"),
                    SizedBox(
                      child: DropdownButton<FilterVal>(
                          underline: const Divider(color: Colors.black),
                          isExpanded: true,
                          value: order.status,
                          items: FilterVal.values
                              .map((e) => DropdownMenuItem<FilterVal>(
                                  child: Text(e.name.toUpperCase()), value: e))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              order.updateStatus(val!);
                            });
                          }),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel",
                      style: TextStyle(color: Colors.white)),
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.red.shade200),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      db
                          .collection("Orders")
                          .doc(order.documentId)
                          .set(order.toJson);
                    });
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
        });
  }

  void onChange(title, val) {
    if (title == "Name") {
      newOffer["name"] = val;
    } else if (title == "Quantity") {
      newOffer["quantity"] = int.parse(val);
    } else if (title == "Price") {
      newOffer["price"] = val + " PKR";
    } else if (title == "Description") {
      newOffer["description"] = val;
    }
  }

  Future<void> createOffer() async {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Add New Offer"),
            content: Form(
              key: _key,
              child: SizedBox(
                height: 400,
                width: 200,
                child: Column(
                  children: [
                    ListView.builder(
                        itemCount: inputFields.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: customField(inputFields[index],
                                  (val) => onChange(inputFields[index], val)));
                        }),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15)),
                      child: DropdownButton<OfferType>(
                          focusColor: Colors.transparent,
                          underline: Container(),
                          hint: const Text("Select Offer Type"),
                          isExpanded: true,
                          value: newOffer["offerType"] != null
                              ? OfferType.values.byName(newOffer["offerType"])
                              : null,
                          items: OfferType.values
                              .map((e) => DropdownMenuItem<OfferType>(
                                  child: Text(e.name.toUpperCase()), value: e))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              newOffer["offerType"] = val!.name;
                            });
                          }),
                    ),
                    const SizedBox(height: 20),
                    MaterialButton(
                      color: Colors.orange,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      onPressed: () async {
                        Navigator.pop(context);
                        await db.collection("Offers").doc().set(newOffer);
                      },
                      child: const Text("Create Offer"),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  @override
  void didChangeDependencies() async {
    isLogin = await LoginState.checkLogin;
    setState(() {
      isLogin = isLogin;
    });
    if (!isLogin) {
      context.go(Routes.home);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: customAppBar(size, context, isAdminLogin: isLogin),
      body: StreamBuilder(
          stream: db
              .collection("Orders")
              .where("status", isEqualTo: filter.name)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                width: size.width,
                height: size.height,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return SizedBox(
                width: size.width,
                height: size.height,
                child: Center(
                  child: Text(snapshot.error!.toString()),
                ),
              );
            }
            List<my.Order> orders = snapshot.data!.docs.map((e) {
              my.Order temp = my.Order.fromJson(e.data());
              temp.documentId = e.id;
              return temp;
            }).toList();
            return SingleChildScrollView(
              child: Container(
                width: size.width,
                alignment: Alignment.topCenter,
                child: Container(
                  width: size.width > 850 ? size.width * .9 : size.width,
                  margin: EdgeInsets.symmetric(
                      horizontal: size.width > 850 ? 0 : 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MaterialButton(
                            color: Colors.orange,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            onPressed: createOffer,
                            child: const Text("Create Offer"),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 30),
                          ),
                          SizedBox(
                            width: 150,
                            child: DropdownButton<FilterVal>(
                                underline: const Divider(color: Colors.black),
                                isExpanded: true,
                                value: filter,
                                items: FilterVal.values
                                    .map((e) => DropdownMenuItem<FilterVal>(
                                        child: Text(e.name.toUpperCase()),
                                        value: e))
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    filter = val!;
                                  });
                                }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width:
                              size.width > 850 ? size.width * .9 : size.width,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text("Name")),
                              DataColumn(label: Text("Game ID")),
                              DataColumn(label: Text("Quantity")),
                              DataColumn(label: Text("DateTime")),
                              DataColumn(label: Text("Contact")),
                              DataColumn(label: Text("Transaction ID")),
                              DataColumn(label: Text("Offer Type")),
                              DataColumn(label: Text("Status")),
                              DataColumn(label: Text("Action")),
                            ],
                            rows: orders
                                .where((element) => element.status == filter)
                                .map((e) => DataRow(cells: [
                                      DataCell(Text(e.name)),
                                      DataCell(Text(e.gameId)),
                                      DataCell(Text(e.quantity.toString())),
                                      DataCell(Text(
                                          e.dateTime.toLocal().toString())),
                                      DataCell(Text(e.contact)),
                                      DataCell(Text(e.transactionId)),
                                      DataCell(
                                          Text(e.offerType.name.toUpperCase())),
                                      DataCell(
                                          Text(e.status.name.toUpperCase())),
                                      DataCell(
                                        const Icon(Icons.settings),
                                        onTap: () => updateStatus(e),
                                      ),
                                    ]))
                                .toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  TextFormField customField(String title, var onChange) {
    return TextFormField(
      maxLines: title == "Description" ? 3 : null,
      keyboardType: TextInputType.number,
      inputFormatters: title == "Quantity" || title == "Price"
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.circular(15)),
        labelText: title,
      ),
      onChanged: onChange,
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (title == "Transaction ID") {
            return "Please enter transaction ID";
          } else {
            return "Please enter contact number";
          }
        }
        return null;
      },
    );
  }
}
