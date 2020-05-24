import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final token;

  EditProfilePage({this.token});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController bioController;
  TextEditingController userNameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bioController = TextEditingController();
    userNameController = TextEditingController();
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
                Text('Kullanıcı adı',
                    style: TextStyle(
                      color: Color(0xFF595B5F),
                      fontWeight: FontWeight.w700,
                    )),
                TextFormField(
                  controller: userNameController,
                  maxLength: 25,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Lütfen bu alanı boş bırakmayınız!";
                    } else {
                      return null;
                    }
                  },
                ),
                Text('Bio',
                    style: TextStyle(
                      color: Color(0xFF595B5F),
                      fontWeight: FontWeight.w700,
                    )),
                TextFormField(
                  controller: bioController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  maxLength: 200,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Lütfen bu alanı boş bırakmayınız!";
                    } else {
                      return null;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
