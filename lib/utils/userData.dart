import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';

//APIs
class UserData {
  // get me
  static Future getMe(String token) async {
    final responseMe = await http.get(
      'http://bestfood.codes2.com/user/me',
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
  static Future getUserProfile(var token, var uid) async {
    final response = await http.get(
      'http://bestfood.codes2.com/user/detail?id=$uid',
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
      'http://bestfood.codes2.com/relation/add_follow?id=$uid',
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
      'http://bestfood.codes2.com/relation/get_follower?page=$pagination',
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
      'http://bestfood.codes2.com/relation/get_follower',
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
      'http://bestfood.codes2.com/relation/get_following?page=$pagination',
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
      'http://bestfood.codes2.com/relation/get_following',
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
      'http://bestfood.codes2.com/relation/get_follower?id=$uid',
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
      'http://bestfood.codes2.com/relation/get_follower?page=$pagination&id=$uid',
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
      'http://bestfood.codes2.com/relation/get_following?id=$uid',
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
      'http://bestfood.codes2.com/relation/get_following?page=$pagination&id=$uid',
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
      'http://bestfood.codes2.com/user/search?value=$value',
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
      'http://bestfood.codes2.com/user/search?value=$value&page=$paginationCount',
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
      'http://bestfood.codes2.com/relation/follow_request_count',
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
      'http://bestfood.codes2.com/relation/follow_request_list',
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
      'http://bestfood.codes2.com/relation/follow_request_list?page=$paginationCount',
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
      'http://bestfood.codes2.com/relation/remove_follow?id=$uid',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Takipçi çıkarılamadı');
    }
  }

  // get remove_following
  static Future getRemoveFollowing(var token, var uid) async {
    final response = await http.get(
      'http://bestfood.codes2.com/relation/remove_following?id=$uid',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Takipten çıkılamadı');
    }
  }

  // get accept_follow
  static Future getAcceptFollow(var token, var uid) async {
    final response = await http.get(
      'http://bestfood.codes2.com/relation/accept_follow?id=$uid',
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

  // user => upload_image
  static Future uploadProfileImage(var token, var file) async {
    Map<String, String> headers = {"Authorization": "Bearer " + token};
    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();
    var uri = Uri.parse("http://bestfood.codes2.com/user/upload_image");
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(file.path));
    request.files.add(multipartFile);
    request.headers.addAll(headers);
    var response = await request.send();
    if (response.statusCode == 200) {
      return response;
    }
  }

  //POST
// post => post/insert
  static Future insertPost(
      String description, String location, var token, String picture) async {
    final http.Response response = await http.post(
      'http://bestfood.codes2.com/post/insert',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        'description': description,
        'location': location,
        'picture': picture
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Post eklenirken bir sorun oluştu!');
    }
  }

  // post => post/detail
  static Future postDetail(var token, var postID) async {
    final response = await http.get(
      'http://bestfood.codes2.com/post/detail?id=$postID',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Post detail getirilemedi!');
    }
  }

  // post => post/get_me
  static Future postGetMe(var token) async {
    final response = await http.get(
      'http://bestfood.codes2.com/post/get_me',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Postlarım getirilemedi.');
    }
  }

// post => post/get_me with page
  static Future postGetMeWithPage(var token, int paginationCount) async {
    final response = await http.get(
      'http://bestfood.codes2.com/post/get_me?page=$paginationCount',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Benim postlarım sayfalarla birlikte getirilemedi.');
    }
  }

  // post => post/get_main_page?page={page}
  static Future postGetMainWithPage(var token, int paginationCount) async {
    final response = await http.get(
      'http://bestfood.codes2.com/post/get_main_page?page=$paginationCount',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Anasayfadaki postlar ek sayfa getirilemedi.');
    }
  }

  // post => post/get_main
  static Future postGetMain(var token) async {
    final response = await http.get(
      'http://bestfood.codes2.com/post/get_main_page',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Anasayfadaki postlar getirilemedi.');
    }
  }

  //post => post/insert
  static Future postUploadImage(var token, var file) async {
    Map<String, String> headers = {"Authorization": "Bearer " + token};
    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();
    var uri = Uri.parse("http://bestfood.codes2.com/post/upload_image");
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(file.path));
    request.files.add(multipartFile);
    request.headers.addAll(headers);
    var response = await request.send();
    if (response.statusCode == 200) {
      final response1 = await response.stream.bytesToString();
      return json.decode(response1);
    }
  }

  //TAGS
  //post tag/insert
  static Future<void> insertTag(String tag, String postID) async {
    final http.Response response = await http.post(
      'http://bestfood.codes2.com/user/tag/insert',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'id': postID, 'tag1': tag}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Tag eklenirken bir hata olustu.');
    }
  }

  //get => tag/search?tag={tag}
  static Future postTagSearch(var token, String tag) async {
    final response = await http.get(
      'http://bestfood.codes2.com/tag/search?tag=$tag',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Tag araması yaparken hata meydana geldi.');
    }
  }

  // get => tag/get_posts?tag={tag}
  static Future postGetPostWithTag(var token, String tag) async {
    final response = await http.get(
      'http://bestfood.codes2.com/tag/get_posts?tag=$tag',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(response.statusCode);
      throw Exception(
          'İçinde o tag geçen postlar getirilirken bir hata meydana geldi!');
    }
  }
}
