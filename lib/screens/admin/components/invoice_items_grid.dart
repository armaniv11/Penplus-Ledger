import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:penon/controllers/invoiceItemsController.dart';
import 'package:penon/custom_widgets/widgets.dart';
import 'package:penon/models/invoice_items_model.dart';

class InvoiceItemGrid extends StatefulWidget {
  final InvoiceItemsModel invoiceItem;
  final int index;
  final bool isEditable;
  final ValueChanged<int>? callback;
  final ValueChanged<int>? callbackItemIndex;

  const InvoiceItemGrid(
      {Key? key,
      required this.invoiceItem,
      required this.index,
      this.isEditable = false,
      this.callback,
      this.callbackItemIndex})
      : super(key: key);

  @override
  _InvoiceItemGridState createState() => _InvoiceItemGridState();
}

class _InvoiceItemGridState extends State<InvoiceItemGrid> {
  final InvoiceItemsController invoiceItemsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
              color: Colors.blue[100],
              border: Border.all(
                color: Colors.white,
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
                        child: Text(widget.invoiceItem.item.itemName,
                            style: GoogleFonts.poppins(
                                color: Colors.black, fontSize: 20))),
                    Spacer(),
                    !widget.isEditable
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  widget.callbackItemIndex!(widget.index - 1);
                                });
                              },
                              child: Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                    !widget.isEditable
                        ? Container()
                        : InkWell(
                            onTap: () {
                              setState(() {
                                widget.callback!(widget.index - 1);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color: Colors.red[200],
                                  shape: BoxShape.circle),
                              child: Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                                size: 18,
                              ),
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
                        Row(
                          children: [
                            iconWithText(
                              FontAwesomeIcons.rupeeSign,
                              10,
                              "${widget.invoiceItem.unitPrice}",
                              color: Colors.grey,
                              fontsize: 16,
                            ),
                            Text(' X ',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 10)),
                            Text('${widget.invoiceItem.quantity}',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            Text(' ${widget.invoiceItem.uom}',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                        widget.invoiceItem.cgst! +
                                    widget.invoiceItem.sgst! +
                                    widget.invoiceItem.igst! ==
                                0
                            ? Container()
                            : widget.invoiceItem.igst == 0
                                ? Row(
                                    children: [
                                      Text('cgst: ',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12)),
                                      iconWithText(
                                        FontAwesomeIcons.rupeeSign,
                                        8,
                                        "${widget.invoiceItem.cgst!}",
                                        color: Colors.grey,
                                        fontsize: 12,
                                      ),
                                      SizedBox(
                                          height: 10,
                                          child: const VerticalDivider(
                                            thickness: 2,
                                          )),
                                      Text('sgst: ',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12)),
                                      iconWithText(
                                        FontAwesomeIcons.rupeeSign,
                                        8,
                                        "${widget.invoiceItem.sgst!}",
                                        color: Colors.grey,
                                        fontsize: 12,
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Text('igst: ',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12)),
                                      iconWithText(
                                        FontAwesomeIcons.rupeeSign,
                                        8,
                                        "${widget.invoiceItem.igst!}",
                                        color: Colors.grey,
                                        fontsize: 12,
                                      ),
                                    ],
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
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
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
