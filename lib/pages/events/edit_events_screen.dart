// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:provider_pattern/helpers/constants.dart';
// import 'package:provider_pattern/providers/events.dart';
// import 'package:toast/toast.dart';

// class EditEventScreen extends StatefulWidget {
//   static const String routeName = "/edit-event";
//   @override
//   _EditEventScreenState createState() => _EditEventScreenState();
// }

// class _EditEventScreenState extends State<EditEventScreen> {
//   final FocusNode _priceFocusNode = FocusNode();
//   final FocusNode _descriptionFocusNode = FocusNode();
//   final _imageUrlController = TextEditingController();
//   final FocusNode _imageUrlFocusNode = FocusNode();

//   final _fromKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//   bool _isInit = true;
//   List<String> _hallOptions = ["Yes", "No", null];
//   String _selectedHallOption;
//   Event _initValue = new Event(
//     id: null,
//     description: '',
//     title: '',
//     imageUrl: '',
//     email: null,
//     makeHallAvailable: null,
//     noOFPersons: null,
//     phoneNumber: null,
//     totalPrice: null,
//     eventType: null,
//   );
//   var _editEvent = Event(
//     id: null,
//     title: '',
//     description: '',
//     imageUrl: '',
//     email: null,
//     makeHallAvailable: null,
//     noOFPersons: null,
//     phoneNumber: null,
//     totalPrice: null,
//     eventType: null,
//   );

//   @override
//   void initState() {
//     _imageUrlFocusNode.addListener(_updateImageUrl);
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     if (_isInit) {
//       _editEvent = ModalRoute.of(context).settings.arguments as Event;
//       if (_editEvent != null) {
//         _initValue = _editEvent;
//         _imageUrlController.text = _editEvent.imageUrl;
//       } else {
//         _editEvent = _initValue;
//       }
//     }
//     _isInit = false;
//     super.didChangeDependencies();
//   }

//   void _updateImageUrl() {
//     if (!_imageUrlFocusNode.hasFocus) {
//       if (_imageUrlController.text.isEmpty ||
//           !_imageUrlController.text.startsWith('http')) {
//         return;
//       }

//       setState(() {});
//     }
//   }

//   Future<void> _saveEvent() async {
//     bool isValid = _fromKey.currentState.validate();
//     if (!isValid) {
//       return;
//     }
//     _fromKey.currentState.save();

//     setState(() {
//       _isLoading = true;
//     });
//     if (_editEvent.id == null) {
//       try {
//         await Provider.of<EventProvider>(context, listen: false)
//             .addEvents(_editEvent);
//         Toast.show("Event Booked Sucessfully", context,
//             duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
//       } catch (error) {
//         await showDialog(
//             context: context,
//             builder: (ctx) {
//               return AlertDialog(
//                 title: Text("Something went wrong"),
//                 content: Text(error.toString()),
//                 actions: <Widget>[
//                   FlatButton(
//                     child: Text("OK"),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   )
//                 ],
//               );
//             });
//       } finally {
//         // setState(() {
//         //   _isLoading = false;
//         // });
//         // Navigator.of(context).pop();
//       }
//     } else {
//       await Provider.of<EventProvider>(context, listen: false)
//           .updateEvent(_editEvent.id, _editEvent);
//       // setState(() {
//       //   _isLoading = false;
//       // });
//     }
//     setState(() {
//       _isLoading = false;
//     });
//     Navigator.of(context).pop();
//   }

//   @override
//   void dispose() {
//     _imageUrlFocusNode.removeListener(_updateImageUrl);
//     _imageUrlFocusNode.dispose();
//     _priceFocusNode.dispose();
//     _descriptionFocusNode.dispose();
//     _imageUrlController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("BOOK EVENT"),
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.save),
//             onPressed: _saveEvent,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 autovalidate: true,
//                 key: _fromKey,
//                 child: ListView(
//                   children: <Widget>[
//                     TextFormField(
//                       initialValue: _initValue.title,
//                       decoration: InputDecoration(
//                         labelText: "Event Type",
//                       ),
//                       textInputAction: TextInputAction.next,
//                       onFieldSubmitted: (_) {
//                         FocusScope.of(context).requestFocus(_priceFocusNode);
//                       },
//                       onSaved: (value) {
//                         _editEvent = Event(
//                             id: _editEvent.id,
//                             title: value,
//                             description: _editEvent.description,
//                             imageUrl: _editEvent.imageUrl,
//                             email: _editEvent.email,
//                             makeHallAvailable: _editEvent.makeHallAvailable,
//                             phoneNumber: _editEvent.phoneNumber,
//                             eventType: _editEvent.eventType,
//                             noOFPersons: _editEvent.noOFPersons,
//                             totalPrice: _editEvent.totalPrice);
//                       },
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Event Type cannot be empty';
//                         }
//                         return null;
//                       },
//                     ),
//                     TextFormField(
//                       initialValue: _initValue.description,
//                       decoration: InputDecoration(
//                         labelText: "Description",
//                       ),
//                       maxLines: 3,
//                       keyboardType: TextInputType.multiline,
//                       focusNode: _descriptionFocusNode,
//                       onSaved: (value) {
//                         _editEvent = Event(
//                             id: _editEvent.id,
//                             title: _editEvent.title,
//                             description: value,
//                             imageUrl: _editEvent.imageUrl,
//                             email: _editEvent.email,
//                             makeHallAvailable: _editEvent.makeHallAvailable,
//                             phoneNumber: _editEvent.phoneNumber,
//                             noOFPersons: _editEvent.noOFPersons,
//                             eventType: _editEvent.eventType,
//                             totalPrice: _editEvent.totalPrice);
//                       },
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'event description cannot be empty';
//                         }
//                         if (value.length < 5) {
//                           return 'event description is too short';
//                         }
//                         return null;
//                       },
//                     ),
//                     TextFormField(
//                       initialValue: _initValue.noOFPersons != null
//                           ? _initValue.noOFPersons.toString()
//                           : "",
//                       decoration: InputDecoration(
//                         labelText: "No. of Persons",
//                       ),
//                       keyboardType: TextInputType.number,
//                       textInputAction: TextInputAction.next,
//                       onFieldSubmitted: (_) {
//                         FocusScope.of(context).requestFocus(_priceFocusNode);
//                       },
//                       onSaved: (value) {
//                         _editEvent = Event(
//                             id: _editEvent.id,
//                             title: _editEvent.title,
//                             description: _editEvent.description,
//                             imageUrl: _editEvent.imageUrl,
//                             email: _editEvent.email,
//                             makeHallAvailable: _editEvent.makeHallAvailable,
//                             phoneNumber: _editEvent.phoneNumber,
//                             eventType: _editEvent.eventType,
//                             noOFPersons: int.parse(value),
//                             totalPrice: _editEvent.totalPrice);
//                       },
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'No of persons cannot be empty';
//                         }
//                         return null;
//                       },
//                     ),
//                     TextFormField(
//                       initialValue: _initValue.totalPrice,
//                       decoration: InputDecoration(
//                         labelText: "Estimated Budget (Ksh) ",
//                       ),
//                       keyboardType: TextInputType.number,
//                       textInputAction: TextInputAction.next,
//                       onFieldSubmitted: (_) {
//                         FocusScope.of(context).requestFocus(_priceFocusNode);
//                       },
//                       onSaved: (value) {
//                         _editEvent = Event(
//                             id: _editEvent.id,
//                             title: _editEvent.title,
//                             description: _editEvent.description,
//                             imageUrl: _editEvent.imageUrl,
//                             email: _editEvent.email,
//                             makeHallAvailable: _editEvent.makeHallAvailable,
//                             eventType: _editEvent.eventType,
//                             phoneNumber: _editEvent.phoneNumber,
//                             noOFPersons: _editEvent.noOFPersons,
//                             bookingDate: _editEvent.bookingDate,
//                             totalPrice: value);
//                       },
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Estimated budget Cannot be empty';
//                         }
//                         return null;
//                       },
//                     ),
//                     DropdownButtonFormField<String>(
//                       icon: const Icon(
//                         Icons.arrow_drop_down,
//                         color: Colors.blue,
//                       ),
//                       hint: Text("Make Hall Available",
//                           style: TextStyle(fontSize: 12)),
//                       items: _hallOptions.map((String value) {
//                         return new DropdownMenuItem<String>(
//                           value: value != null ? value : "",
//                           child: new Text(value != null ? value : "",
//                               style: TextStyle(fontSize: 12)),
//                         );
//                       }).toList(),
//                       validator: (value) {
//                         if (value == "" || value == "") {
//                           return "hall avalability cannot be empty";
//                         }
//                         return null;
//                       },
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedHallOption = value;
//                         });
//                       },
//                       onSaved: (value) {
//                         _editEvent = Event(
//                             id: _editEvent.id,
//                             title: _editEvent.title,
//                             description: _editEvent.description,
//                             imageUrl: _editEvent.imageUrl,
//                             email: _editEvent.email,
//                             makeHallAvailable: value,
//                             phoneNumber: _editEvent.phoneNumber,
//                             noOFPersons: _editEvent.noOFPersons,
//                             eventType: _editEvent.eventType,
//                             totalPrice: _editEvent.totalPrice);
//                       },
//                       value: _editEvent.makeHallAvailable != null
//                           ? _editEvent.makeHallAvailable
//                           : _selectedHallOption,
//                     ),
//                     TextFormField(
//                       initialValue: _initValue.phoneNumber,
//                       decoration: InputDecoration(
//                         labelText: "Phone",
//                       ),
//                       textInputAction: TextInputAction.next,
//                       keyboardType: TextInputType.phone,
//                       onFieldSubmitted: (_) {
//                         FocusScope.of(context).requestFocus(_priceFocusNode);
//                       },
//                       onSaved: (value) {
//                         _editEvent = Event(
//                             id: _editEvent.id,
//                             title: _editEvent.title,
//                             description: _editEvent.description,
//                             imageUrl: _editEvent.imageUrl,
//                             email: _editEvent.email,
//                             makeHallAvailable: _editEvent.makeHallAvailable,
//                             phoneNumber: value,
//                             eventType: _editEvent.eventType,
//                             noOFPersons: _editEvent.noOFPersons,
//                             totalPrice: _editEvent.totalPrice);
//                       },
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Phone cannot be empty';
//                         }
//                         return null;
//                       },
//                     ),
//                     TextFormField(
//                       initialValue: _initValue.email,
//                       decoration: InputDecoration(
//                         labelText: "Email",
//                       ),
//                       textInputAction: TextInputAction.next,
//                       keyboardType: TextInputType.emailAddress,
//                       onFieldSubmitted: (_) {
//                         FocusScope.of(context).requestFocus(_priceFocusNode);
//                       },
//                       onSaved: (value) {
//                         _editEvent = Event(
//                             id: _editEvent.id,
//                             title: _editEvent.title,
//                             description: _editEvent.description,
//                             imageUrl: _editEvent.imageUrl,
//                             email: value,
//                             makeHallAvailable: _editEvent.makeHallAvailable,
//                             phoneNumber: _editEvent.phoneNumber,
//                             eventType: _editEvent.eventType,
//                             noOFPersons: _editEvent.noOFPersons,
//                             totalPrice: _editEvent.totalPrice);
//                       },
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Email cannot be empty';
//                         }
//                         return null;
//                       },
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: MaterialButton(
//                         height: 45,
//                         color: Constants.primaryColor,
//                         onPressed: () {
//                           _saveEvent();
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             Text(
//                               "BOOK EVENT",
//                               textAlign: TextAlign.center,
//                               style:
//                                   TextStyle(color: Colors.white, fontSize: 18),
//                             ),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             Icon(
//                               FontAwesomeIcons.book,
//                               color: Colors.white,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
