import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCheckBox extends StatefulWidget {
  final String? text;
  final bool? option;
  final ValueChanged<bool> callBack;
  const CustomCheckBox(
      {Key? key,
      required this.text,
      required this.option,
      required this.callBack})
      : super(key: key);

  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    bool? opt1 = widget.option;
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.text!,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                    fontSize: 12,
                    letterSpacing: 3),
              ),
              Checkbox(
                  value: opt1,
                  onChanged: (val) {
                    print(widget.text);
                    print(val);
                    widget.callBack(val!);
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDateField extends StatefulWidget {
  final double width;
  final double height;
  final String heading;
  final initialDate;
  final Color bgColor;
  final Color headingColor;
  final ValueChanged<String>? callBack;

  const CustomDateField(
      {Key? key,
      this.width = double.maxFinite,
      this.height = 20.0,
      required this.heading,
      this.bgColor = Colors.white,
      this.headingColor = Colors.grey,
      required this.callBack,
      required this.initialDate})
      : super(key: key);

  @override
  _CustomDateFieldState createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    print("initial Date");
    print(widget.initialDate);
    String heading = widget.heading;
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: widget.bgColor),
        width: widget.width,
        // height: widget.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(heading),
            SizedBox(
                height: 20,
                child: VerticalDivider(
                  color: Colors.blue,
                  thickness: 2,
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.initialDate ??
                    DateFormat('yyyy-MM-dd').format(DateTime.now()),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
                height: 20,
                child: VerticalDivider(
                  color: Colors.blue,
                  thickness: 2,
                )),
            InkWell(
              onTap: () async {
                final choice = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2021),
                    lastDate: DateTime(2023),
                    initialDate: DateTime.parse(widget.initialDate));
                print(choice);
                if (choice != null)
                  setState(() {
                    // dateSelected = DateFormat('yyyy-MM-dd').format(choice);
                    widget.callBack!(DateFormat('yyyy-MM-dd').format(choice));
                  });
              },
              child: Icon(
                Icons.edit,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomDropDown extends StatefulWidget {
  final String? heading;
  final List? items;
  final String? selected;
  final ValueChanged<String> callBack;
  final bool showHeading;
  final Color color;

  const CustomDropDown(
      {Key? key,
      required this.heading,
      required this.items,
      required this.callBack,
      required this.selected,
      this.showHeading = true,
      this.color = Colors.black})
      : super(key: key);

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    String? _selected = widget.selected;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Material(
        type: MaterialType.canvas,
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            children: [
              !widget.showHeading
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(left: 6, right: 6),
                      child: Text(
                        widget.heading!,
                        style: TextStyle(fontSize: 14, color: widget.color),
                        overflow: TextOverflow.ellipsis,
                      ),
                      // ignore: prefer_const_constructors
                    ),
              !widget.showHeading
                  ? Container()
                  : SizedBox(
                      height: 20,
                      child: VerticalDivider(
                        color: Colors.blue,
                        thickness: 2,
                      )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: DropdownButton(
                    hint: Text("Please select an option!!"),
                    underline: SizedBox(),
                    onChanged: (dynamic val) {
                      setState(() {
                        _selected = val;
                        print(val);
                        widget.callBack(_selected!);
                        // _selectedCare = val.toString();
                      });
                    },
                    isExpanded: true,
                    iconEnabledColor: Colors.blue[800],
                    dropdownColor: Colors.grey[100],
                    style: TextStyle(
                        letterSpacing: 3,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800]),
                    value: _selected,
                    items: widget.items!.map((location) {
                      return DropdownMenuItem(
                        child: new Text(location),
                        value: location,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class CustomTextClass extends StatefulWidget {
//   final TextEditingController controller;

//   const CustomTextClass({Key? key}) : super(key: key);

//   @override
//   _CustomTextClassState createState() => _CustomTextClassState();
// }

// class _CustomTextClassState extends State<CustomTextClass> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

// Widget customTextFormField(controller, hinttext, icon,
//     {width: double.maxFinite,
//     inputtype: TextInputType.name,
//     maxlines: 1,
//     maxlength: 15,
//     Color headingColor: Colors.yellow,
//     bool isDense: true,
//     double headingsize: 14,
//     bool validationEnabled = false,
//     bool enabled: true,
//     String suffixText: ""}) {
//   return Container(
//     width: width,
//     child: Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Padding(
//               //   padding:
//               //       const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 4),
//               //   child: Text(
//               //     hinttext,
//               //     style: TextStyle(
//               //         fontSize: headingsize,
//               //         fontWeight: FontWeight.bold,
//               //         color: headingColor),
//               //     overflow: TextOverflow.ellipsis,
//               //   ),
//               // ),
//               Container(
//                 // padding: EdgeInsets.only(bottom: 4, top: 4),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.white,
//                 ),
//                 child: TextFormField(
//                     validator: (value) {
//                       if (validationEnabled)
//                         return value!.isEmpty
//                             ? "$hinttext cannot be empty!!"
//                             : null;
//                     },
//                     textCapitalization: TextCapitalization.sentences,
//                     enabled: enabled,
//                     maxLines: maxlines == 1 ? null : maxlines,
//                     maxLength: maxlength == 15 ? null : maxlength,
//                     keyboardType: inputtype,
//                     controller: controller,
//                     style:
//                         TextStyle(color: !enabled ? Colors.grey : Colors.black),
//                     decoration: InputDecoration(
//                         label: Text(hinttext),
//                         suffixText: suffixText,
//                         labelStyle: TextStyle(color: Colors.black),
//                         errorStyle: TextStyle(
//                             color: Colors.red, fontWeight: FontWeight.bold),
//                         prefixIcon: icon,
//                         filled: true,
//                         isDense: true,
//                         border: InputBorder.none),
//                     onChanged: (val) {}),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
