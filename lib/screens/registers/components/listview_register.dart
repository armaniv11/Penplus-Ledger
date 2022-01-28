import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:penon/custom_widgets/widgets.dart';
import 'package:penon/models/purchase_model.dart';
import 'package:penon/screens/registers/components/invoice_itemlist_bottomsheet.dart';

class RegisterList extends StatefulWidget {
  final PurchaseModel invoice;
  final int index;
  const RegisterList({Key? key, required this.invoice, required this.index})
      : super(key: key);

  @override
  _RegisterListState createState() => _RegisterListState();
}

class _RegisterListState extends State<RegisterList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String a = widget.invoice.invoiceDate == null
        ? "No Date"
        : Jiffy(widget.invoice.invoiceDate.toString()).yMMMMd;
    // var a = Jiffy(widget.invoice.invoiceDate == null
    //                         ? "No Date"
    //                         : widget.invoice.invoiceDate.toString()).yMMMMd;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        margin: EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
        width: size.width,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          widget.index.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ),
                Text(
                  widget.invoice.party.partyName!,
                  style: TextStyle(),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      // isDismissible: true,
                      context: context,
                      builder: (context) {
                        return InvoiceItemListBottomSheet(
                          invoice: widget.invoice,

                          // callback: changeCart,
                        );
                      },
                    );
                  },
                  child: Icon(
                    Icons.arrow_right_alt,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.grey,
              height: 6,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "invoice Date",
                        style: TextStyle(fontSize: 10),
                      ),
                      Text(
                        a,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(fontSize: 10),
                      ),
                      iconWithText(FontAwesomeIcons.rupeeSign, 10.0,
                          widget.invoice.grandTotal.toString(),
                          color: Colors.green)
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
