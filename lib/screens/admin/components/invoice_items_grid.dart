import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penon/models/invoice_items_model.dart';

class InvoiceItemGrid extends StatefulWidget {
  final InvoiceItemsModel invoiceItem;
  final int index;
  const InvoiceItemGrid(
      {Key? key, required this.invoiceItem, required this.index})
      : super(key: key);

  @override
  _InvoiceItemGridState createState() => _InvoiceItemGridState();
}

class _InvoiceItemGridState extends State<InvoiceItemGrid> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
              color: Colors.blue[100],
              border: Border.all(
                color: Colors.grey[300]!,
              ),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 6),
                child: Row(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white70, shape: BoxShape.circle),
                        padding: EdgeInsets.all(8),
                        child: Text("${widget.index}")),
                    Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(widget.invoiceItem.itemName!,
                            style: GoogleFonts.poppins(
                                color: Colors.black, fontSize: 20))),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
              // Divider(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Rs.',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '${widget.invoiceItem.unitPrice}',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: ' X ',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                              TextSpan(
                                  text: '${widget.invoiceItem.quantity}',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: ' ${widget.invoiceItem.uom}',
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                        widget.invoiceItem.cgst! +
                                    widget.invoiceItem.sgst! +
                                    widget.invoiceItem.igst! ==
                                0
                            ? Container()
                            : widget.invoiceItem.igst == 0
                                ? Row(
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: 'CGST(Rs.) ',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                    '${widget.invoiceItem.cgst!}',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: '  SGST(Rs.) ',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                    '${widget.invoiceItem.cgst!}',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : RichText(
                                    text: TextSpan(
                                      text: 'IGST ',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                'Rs.${widget.invoiceItem.igst!}',
                                            style: TextStyle(
                                                color: Colors.grey[900],
                                                fontSize: 16)),
                                      ],
                                    ),
                                  ),
                      ],
                    ),

                    // Text(
                    //     " X ${widget.invoiceItem.quantity} ${widget.invoiceItem.uom}"),
                    SizedBox(
                        height: 30,
                        child: VerticalDivider(
                          thickness: 2,
                          color: Colors.grey,
                        )),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Rs. ',
                            style: TextStyle(
                                color: Colors.blue[800], fontSize: 12),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '${widget.invoiceItem.total}',
                                  style: TextStyle(
                                      color: Colors.blue[800],
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Text("Total: Rs.${widget.invoiceItem.total}")
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
