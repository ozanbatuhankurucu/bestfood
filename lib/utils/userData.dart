import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';

//APIs
class UserData {
  // get me
  static Future getMe(String token) async {
    final responseMe = await http.get(
      'http://bestfood.codes2.com/me',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );
    if (responseMe.statusCode == 200) {
      return json.decode(responseMe.body);
    } else {
      throw Exception('Failed to load user info!');
    }
  }

  // get profile
  static Future getProfile(var token, var uid) async {
    final response = await http.get(
      'http://bestfood.codes2.com/profile?id=$uid',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Aranan kullanıcılar getirilemedi!');
    }
  }

  // get add_follow
  static Future getAddFollow(var token, var uid) async {
    final response = await http.get(
      'http://bestfood.codes2.com/add_follow?id=$uid',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Takip isteği gönderildi!');
    }
  }

  // me => get_followers with page
  static Future getFollowersMePage(var token, int pagination) async {
    final response = await http.get(
      'http://bestfood.codes2.com/get_follower?page=$pagination',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Takipçileri ek sayfa çekerken bir hata meydana geldi!');
    }
  }

  // me => get_followers
  static Future getFollowersMe(var token) async {
    final response = await http.get(
      'http://bestfood.codes2.com/get_follower',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Takipçileri çekerken bir hata meydana geldi!');
    }
  }

  // me => get_following with page
  static Future getFollowingMePage(var token, int pagination) async {
    final response = await http.get(
      'http://bestfood.codes2.com/get_following?page=$pagination',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Takip edilenleri ek sayfa çekerken bir hata meydana geldi!');
    }
  }

  // me => get_following
  static Future getFollowingMe(var token) async {
    final response = await http.get(
      'http://bestfood.codes2.com/get_following',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Takip edilenleri çekerken bir hata meydana geldi!');
    }
  }

  // user => get_follower
  static Future getFollower(var token, var uid) async {
    final response = await http.get(
      'http://bestfood.codes2.com/get_follower?id=$uid',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('User Takipçileri çekerken bir hata meydana geldi!');
    }
  }

  // user => get_follower with page
  static Future getFollowerPage(var token, var uid, int pagination) async {
    final response = await http.get(
      'http://bestfood.codes2.com/get_follower?page=$pagination&id=$uid',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'User Takipçileri ek sayfa çekerken bir hata meydana geldi!');
    }
  }

  // user => get_following
  static Future getFollowing(var token, var uid) async {
    final response = await http.get(
      'http://bestfood.codes2.com/get_following?id=$uid',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Takip edilenleri çekerken bir hata meydana geldi!');
    }
  }

  // user => get_following with page
  static Future getFollowingPage(var token, var uid, int pagination) async {
    final response = await http.get(
      'http://bestfood.codes2.com/get_following?page=$pagination&id=$uid',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Takip edilenleri ek sayfa çekerken bir hata meydana geldi!');
    }
  }

  //get search value
  static Future getSearchValue(String value, var token) async {
    final response = await http.get(
      'http://bestfood.codes2.com/search?value=$value',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Aranan kullanıcılar getirilemedi!');
    }
  }

  //get search value with page
  static Future getSearchValuePage(
      String value, var token, int paginationCount) async {
    final response = await http.get(
      'http://bestfood.codes2.com/search?value=$value&page=$paginationCount',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Aranan kullanıcılar getirilemedi!');
    }
  }
  // get follow_request_count
  static Future getFollowRequestCount(var token) async {
    final response = await http.get(
      'http://bestfood.codes2.com/follow_request_count',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Takip istek sayısı getirilemedi!');
    }
  }


  //get follow_request_list
  static Future getFollowRequestList(var token) async {
    final response = await http.get(
      'http://bestfood.codes2.com/follow_request_list',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Takip istekleri getirilemedi!');
    }
  }

  //get follow_request_list page
  static Future getFollowRequestListPage(var token, int paginationCount) async {
    final response = await http.get(
      'http://bestfood.codes2.com/follow_request_list?page=$paginationCount',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Takip istekleri ek sayfa getirilemedi!');
    }
  }

  // get remove_follow
  static Future getRemoveFollow(var token, var uid) async {
    final response = await http.get(
      'http://bestfood.codes2.com/remove_follow?id=$uid',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Takipten çıkılamadı veya takip isteği silinemedi!');
    }
  }

  // get accept_follow
  static Future getAcceptFollow(var token, var uid) async {
    final response = await http.get(
      'http://bestfood.codes2.com/accept_follow?id=$uid',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Takip isteği onaylanamadı!');
    }
  }

  // post upload_image
  static Future uploadProfileImage(var token, var file) async {
    Map<String, String> headers = {"Authorization": "Bearer " + token};
    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();
    var uri = Uri.parse("http://bestfood.codes2.com/upload_image");
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(file.path));
    request.files.add(multipartFile);
    request.headers.addAll(headers);
    var response = await request.send();
    print(response.statusCode);
  }
}
