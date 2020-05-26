import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final userInfo;

  EditProfilePage({this.userInfo});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController descriptionController;
  TextEditingController userNameController;

  @override
  void initState() {
    super.initState();
    print(widget.userInfo);
    descriptionController = TextEditingController();
    userNameController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    descriptionController.text = widget.userInfo['user']['description'];
    firstNameController.text = widget.userInfo['user']['firstname'];
    lastNameController.text = widget.userInfo['user']['lastname'];
    userNameController.text = widget.userInfo['user']['username'];
  }

  @override
  void dispose() {
    descriptionController.dispose();
    userNameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Düzenle',
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                try {
                  print("Profil bilgileri güncellendi!");
                  Navigator.pop(context);
                } catch (e) {
                  print(e.toString());
                }
              }
            },
            icon: Icon(
              Icons.check,
              color: Color(0xFF639a67),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PEditWidget(
                  maxLines: 3,
                  maxSize: 200,
                  textInputType: TextInputType.multiline,
                  userNameController: descriptionController,
                  widgetText: "Bio",
                ),
                PEditWidget(
                  maxSize: 50,
                  userNameController: firstNameController,
                  widgetText: "İsim",
                ),
                PEditWidget(
                  maxSize: 50,
                  userNameController: lastNameController,
                  widgetText: "Soyisim",
                ),
                PEditWidget(
                  userNameController: userNameController,
                  widgetText: "Kullanıcı Adı",
                  maxSize: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PEditWidget extends StatelessWidget {
  final TextEditingController userNameController;
  final String widgetText;
  final int maxSize;
  final int maxLines;
  final TextInputType textInputType;
  PEditWidget(
      {this.userNameController,
      this.widgetText,
      this.maxSize,
      this.maxLines,
      this.textInputType});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(widgetText,
            style: TextStyle(
              color: Color(0xFF595B5F),
              fontWeight: FontWeight.w700,
            )),
        TextFormField(
          controller: userNameController,
          maxLines: maxLines,
          maxLength: maxSize,
          keyboardType: textInputType,
          validator: (value) {
            if (value.isEmpty) {
              return "Lütfen bu alanı boş bırakmayınız!";
            } else {
              return null;
            }
          },
        ),
      ],
    );
  }
}
