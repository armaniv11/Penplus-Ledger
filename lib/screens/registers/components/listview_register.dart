import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:penon/custom_widgets/widgets.dart';
import 'package:penon/models/invoice_model.dart';
import 'package:penon/screens/admin/add_purchase.dart';
import 'package:penon/screens/admin/add_sale.dart';
import 'package:penon/screens/registers/components/invoice_itemlist_bottomsheet.dart';

class RegisterList extends StatefulWidget {
  final InvoiceModel invoice;
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
        margin: const EdgeInsets.only(bottom: 4),
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
                      decoration: const BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          widget.index.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      )),
                ),
                SizedBox(
                  width: size.width * 0.7,
                  child: Text(
                    widget.invoice.party.partyName!,
                    style: const TextStyle(),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: () {
                      if (widget.invoice.invoiceType == 'Sale') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddSale(
                                      updateInvoice: widget.invoice,
                                    )));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddPurchase(
                                      updateInvoice: widget.invoice,
                                    )));
                      }
                    },
                    child: const Icon(
                      Icons.edit,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                ),
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
                    color: Colors.blue[800]!,
                    size: 28,
                  ),
                )
              ],
            ),
            const Divider(
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
                      const Text(
                        "invoice Date",
                        style: TextStyle(fontSize: 10),
                      ),
                      Text(
                        a,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
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
