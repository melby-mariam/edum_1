import 'package:edum_1/services/firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:edum_1/services/firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EventNewPost22 extends StatefulWidget {
  @override
  State<EventNewPost22> createState() => _EventNewPost22State();
}

class _EventNewPost22State extends State<EventNewPost22> {

  FirestoreService _firestoreService = FirestoreService();

  final _formKey = GlobalKey<FormState>();
  String _eventTitle = '';
  String _eventDate = '';
  String _eventVenue = '';
  String? _otherDetails;
  File? _imageFile;
  bool _submitted = false;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _eventTitleController = TextEditingController();
  TextEditingController _eventVenueController = TextEditingController();
  TextEditingController _otherDetailsController = TextEditingController();
   // Controller for event date
  // final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Event Post'),
        actions: [
          TextButton(
            onPressed: _submitForm,
            child: Text(
              'Post',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: SpinKitFadingCircle(
                color: Theme.of(context).primaryColor,
                size: 50.0,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField('Event Title', (value) => _eventTitle = value!,_eventTitleController),
                      SizedBox(height: 16.0),
                      _buildTextFieldWithCalendarIcon('Event Date', (value) => _eventDate = value!),
                      SizedBox(height: 16.0),
                      _buildTextField('Event Venue', (value) => _eventVenue = value!,_eventVenueController),
                      SizedBox(height: 16.0),
                      _buildTextField('Other Details', (value) => _otherDetails = value,_otherDetailsController),
                      SizedBox(height: 16.0),

                      Text(
                        'Photo',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      Center(
                        child: _buildImagePicker(),
                      ),
                      SizedBox(height: 16.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          child: Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> _submitForm() async {
    setState(() {
      _submitted = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      final imageURL = await _uploadImage();
      await _firestoreService.addEventPosts(
      EventTitle: _eventTitleController.text, 
      moderatorId: 'mod123', 
      moderatorName: 'modmemms', 
      Date: _dateController.text, 
      Venue: _eventVenueController.text, 
      otherDetails: _otherDetailsController.text,
      imageURL: imageURL,
      dpURL: 'https://png.pngtree.com/thumb_back/fh260/background/20230611/pngtree-two-cute-egg-cupids-sitting-in-sunlight-next-to-each-other-image_2914931.jpg',
      );
      // await _firestoreService.addEventPosts(
      //   type: 'Event',
      //   alumniId: 'eventId',
      //   alumniName: 'Moderator',
      //   alumniDesignation: 'ModeratorDescription',
      //   caption: _eventTitle,
      //   description: _otherDetails ?? '',
        
        // eventDate: _eventDate,
        // eventVenue: _eventVenue,
      

      setState(() {
        _isLoading = false;
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New post added'),
          duration: Duration(seconds: 2),
        ),
      );

      _resetForm();
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _eventTitle = '';
      _eventDate = '';
      _eventVenue = '';
      _otherDetails = '';
      _imageFile = null;
      _submitted = false;
      _dateController.clear();
    });
  }

  Future<String?> _uploadImage() async {
    if (_imageFile == null) return null;

    final storageRef = FirebaseStorage.instance.ref();
    final fileName = path.basename(_imageFile!.path);
    final imageRef = storageRef.child('event_posts/$fileName');

    try {
      await imageRef.putFile(_imageFile!);
      final downloadURL = await imageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Widget _buildTextField(String label, Function(String?) onSaved, TextEditingController t_controller) {
    bool showError = _submitted && (label == 'Event Title' ? _eventTitle.isEmpty : (label == 'Event Date' ? _eventDate.isEmpty : label == 'Event Venue' ? _eventVenue.isEmpty : false));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextFormField(
          controller: t_controller,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: OutlineInputBorder(),
            errorBorder: showError ? OutlineInputBorder(borderSide: BorderSide(color: Colors.red)) : OutlineInputBorder(),
            errorText: showError ? 'This field is required' : null,
          ),
          onSaved: onSaved,
          validator: (value) {
            if (_submitted && (value == null || value.isEmpty) && (label == 'Event Title' || label == 'Event Date' || label == 'Event Venue')) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextFieldWithCalendarIcon(String label, Function(String?) onSaved) {
    bool showError = _submitted && _eventDate.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextFormField(
          controller: _dateController,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: OutlineInputBorder(),
            errorBorder: showError ? OutlineInputBorder(borderSide: BorderSide(color: Colors.red)) : OutlineInputBorder(),
            errorText: showError ? 'This field is required' : null,
            suffixIcon: label == 'Event Date'
                ? IconButton(
                    onPressed: _pickDate,
                    icon: Icon(Icons.calendar_today),
                  )
                : null,
          ),
          onSaved: onSaved,
          validator: (value) {
            if (_submitted && value!.isEmpty && label == 'Event Date') {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  void _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _eventDate = DateFormat('dd/MM/yyyy').format(pickedDate);
        _dateController.text = _eventDate;
      });
    }
  }

  Widget _buildImagePicker() {
    return _imageFile == null
        ? ElevatedButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.upload),
            label: Text('Upload Photo'),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _pickImage,
                icon: Icon(Icons.upload),
              ),
              Image.file(
                _imageFile!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _imageFile = null;
                  });
                },
                icon: Icon(Icons.close),
              ),
            ],
          );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
}