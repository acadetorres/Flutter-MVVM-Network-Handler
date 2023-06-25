import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

import 'app_exception.dart';

/// This class is an excerpt from https://medium.com/@ermarajhussain/flutter-mvvm-architecture-best-practice-using-provide-http-4939bdaae171
/// It is now modified for our use cases.
class ApiService {
  ApiService(this._baseUrl);

  final String _baseUrl;
  final logger = Logger(level: Level.debug, filter: null, printer: PrettyPrinter());

  ///Calls the Endpoint returns the responseJson
  Future<dynamic> get(String path) async {
    logger.e(_baseUrl + path);
    dynamic responseJson;
    final response = await http.get((Uri.parse(_baseUrl + path)));
    responseJson = _returnResponse(response);
    return responseJson;
  }

  ///JSONBODY ARE THE FIELDS, encoded depending on the Content-Type
  Future post(String path, Map<String, String> JsonBody) async {
    logger.v(_baseUrl + path);
    logger.v(JsonBody);
    dynamic responseJson;

    final response = await http.post(
      Uri.parse(_baseUrl + path),
      body: JsonBody,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
    );

    responseJson = _returnResponse(response);

    return responseJson;
  }

  ///JSONBODY ARE THE FIELDS, filePath is is the image PATH, MEDIATYPE IF NOT IMAGE!!
  Future multiPartPost(String path, Map<String, String> JsonBody, String filePath, String fileField, [Uint8List? file, String? fileName]) async {
    logger.v(_baseUrl + path);
    logger.v(JsonBody);
    dynamic responseJson;

    final request = http.MultipartRequest("POST", Uri.parse(_baseUrl + path));

    request.fields.addAll(JsonBody);

    request.headers["Content-Type"] = "multipart/form-data";

    // final file =  File.fromUri(Uri.parse(filePath));


    // final httpFile = http.MultipartFile.fromBytes(fileField, await file.readAsBytes(), filename: file.path);

    // if (image != null) {
    //   final httpFile = http.MultipartFile.fromBytes(fileField, await image.readAsBytes());
    //   request.files.add(httpFile);
    // } else {
    //


    if (file != null) {
      final httpFile = http.MultipartFile.fromBytes(fileField, file, contentType: MediaType ('image', '*'), filename: fileName.toString());
      request.files.add(httpFile);
    } else {
      request.files.add(await http.MultipartFile.fromPath(fileField, filePath));
    }


    // }


    // request.files.add(http.MultipartFile.fromBytes(fileField,await file.readAsBytes() , filename: file.path, contentType: MediaType('image', '/*')));

    logger.e(fileField);

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    responseJson = _returnResponse(response);

    return responseJson;
  }

  ///This checks for response.statusCode and would return the json if it's 200/201
  ///And Throw an exception that is handled by the NetworkStreamHandler(This reduces the try catch blocks)
  ///HttpNotFoundException HttpException both inherited from AppException
  ///Message on the parameters of AppException is used when .toString() is called on the AppException
  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        // logger.v(responseJson);
        return responseJson;
      case 201:
        var responseJson = json.decode(response.body.toString());
        // logger.v(responseJson);
        return responseJson;
      // case 400:
      //   throw BadRequestException(response.body.toString());
      // case 403:
      //   throw UnauthorisedException(response.body.toString());
      // case 500:
      case 404:
        throw HttpNotFoundException(response.body);
      /// ON ERROR try to parse the response to MetaResponse using .fromJson function
      /// MetaResponse is generated with a JSON to DART plugin
      default:
        print(response.body.toString());
        // var meta = MetaResponse.fromJson(json.decode(response.body.toString()));
        logger.e(response.body.toString());
        throw HttpException(response.body.toString());
    }
  }
}
