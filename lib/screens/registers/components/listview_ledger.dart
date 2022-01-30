import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:penon/custom_widgets/widgets.dart';
import 'package:penon/models/ledger_model.dart';
import 'package:penon/models/purchase_model.dart';
import 'package:penon/screens/registers/components/invoice_itemlist_bottomsheet.dart';

class LedgerList extends StatefulWidget {
  final LedgerModel invoice;
  final int index;
  const LedgerList({Key? key, required this.invoice, required this.index})
      : super(key: key);

  @override
  _LedgerListState createState() => _LedgerListState();
}

class _LedgerListState extends State<LedgerList> {
  @override
  Widget build(BuildContext context) {
    print(widget.index);
    Size size = MediaQuery.of(context).size;
    String invDate = widget.invoice.invoiceDate == null
        ? "No Date"
        : Jiffy(widget.invoice.invoiceDate.toString()).yMMMd;
    // var a = Jiffy(widget.invoice.invoiceDate == null
    //                         ? "No Date"
    //                         : widget.invoice.invoiceDate.toString()).yMMMMd;
    return Container(
        margin: const EdgeInsets.only(bottom: 1),
        padding: const EdgeInsets.only(left: 4, right: 4, top: 4, bottom: 4),
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
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
            Container(
              width: size.width * 0.5,
              color: Colors.yellow,
              child: Column(
                children: [
                  Text(widget.invoice.partyId.partyName!),
                  Text(invDate)
                ],
              ),
            ),
            Container(
                width: size.width * 0.20,
                child: Text(
                  widget.invoice.creditAmount.toString(),
                  textAlign: TextAlign.right,
                )),
            Container(
                width: size.width * 0.20,
                child: Text(
                  widget.invoice.debitAmount.toString(),
                  textAlign: TextAlign.right,
                ))
          ],
        ));
  }
}
