import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:thebestfoodsql/components/tFFieldPost.dart';
import 'package:thebestfoodsql/utils/constants.dart';
import 'package:thebestfoodsql/utils/userData.dart';

const kGoogleApiKey = "AIzaSyDeJf-xQDxUZhLIW-ONmp2_iuUkKoDBcGk";

// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class CreatePostPage extends StatefulWidget {
  final token;
  CreatePostPage({this.token});
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _CreatePostPageState extends State<CreatePostPage> {
  Mode _mode = Mode.fullscreen;
  final _formKey = GlobalKey<FormState>();
  final snackBar = SnackBar(content: Text('Lütfen resim yükleyiniz!'));
  String currentVenueName;
  String postDescription;
  String location;
  File _image;

  Future takePhoto(context) async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 45);
    setState(() {
      _image = image;
      print('Image Path $_image');
    });
    uploadPhoto(context, image);
  }

  Future pickCamera(context) async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 45);
    setState(() {
      _image = image;
      print('Image Path $_image');
    });
    uploadPhoto(context, image);
  }

  Future uploadPhoto(BuildContext context, var image) async {
    if (image != null) {}
  }

  void addTag() {
    List<String> tags = [];
    String description = "Çok güzel bir mekan. #adanakebap #salgam";

    List<String> newList =
        description.split(' ').map((String text) => text).toList();

    for (String word in newList) {
      if (word.contains('#')) {
        tags.add(word);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        title: Text('Yeni Gönderi'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(FontAwesomeIcons.times)),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    if (_image != null) {
                      final responseImage =
                          await UserData.postUploadImage(widget.token, _image);
                      final responseInsertPost = await UserData.insertPost(
                          postDescription,
                          currentVenueName,
                          widget.token,
                          responseImage['file_path']);
                      final responseGetPost =
                          await UserData.postGetMe(widget.token);
                      print(responseImage);
                      print(responseInsertPost);
                      print(responseGetPost);
                    } else {
                      setState(() {
                        print("Lütfen resim yükleyiniz!");
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('Lütfen resim yükleyiniz!')));
                      });
                    }
                  }
                },
                icon: Icon(Icons.check)),
          ),
          SizedBox(width: 5.0),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _image != null
                ? Container(
                    child: Image.file(
                      _image,
                      fit: BoxFit.fill,
                    ),
                  )
                : Container(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    kSizedBoxTen,
                    kSizedBoxTen,
                    TFFieldPost(
                      title: 'Yemek Öneriniz',
                      maxLine: 3,
                      onChangedFunction: (value) {
                        postDescription = value;
                      },
                      function: (value) {
                        if (value.isEmpty) {
                          return 'Lütfen yemek önerisi yapınız!';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                            onPressed: () {
                              _settingModalBottomSheet(context);
                            },
                            icon: Icon(FontAwesomeIcons.image)),
                        IconButton(
                            onPressed: () {
                              _handlePressButton(context);
                            },
                            icon: Icon(Icons.location_on)),
                      ],
                    ),
                    Container(
                      child: currentVenueName == null
                          ? Container()
                          : Text(currentVenueName),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Fotoğraf çek'),
                    onTap: () {
                      pickCamera(context);
                    }),
                new ListTile(
                  leading: new Icon(Icons.image),
                  title: new Text('Galeriden seç'),
                  onTap: () {
                    takePhoto(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<void> _handlePressButton(context) async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: _mode,
      language: "tr",
      components: [Component(Component.country, "tr")],
    );

    displayPrediction(p, homeScaffoldKey.currentState);
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      setState(() {
        currentVenueName = p.description;
      });
      scaffold.showSnackBar(
        SnackBar(content: Text("${p.description} - $lat/$lng")),
      );
    }
  }
}
