
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

import 'api_response.dart';
import 'package:get/get.dart';


/// This the ViewModel that every ViewModel will inherit.
/// BaseViewModel is from Stacked package, it has dispose method
/// and that might be for the lifecycle handling of the class. Otherwise without extending it, it's OK
class ViewModel extends GetxController {

  final logger = Logger(
      filter: null,
      printer : PrettyPrinter(),
      output: null);


  ///isLoading State, this is 'observed' by the UI when notifyListeners() are called on the viewModel
  RxBool isLoading = false.obs;

  ///The MetaResponse.message State, this is 'observed' by the UI when notifyListeners() are called on the viewModel
  RxString errorMessage = "".obs;


  ///This function handles the isLoading and errorMessage coming from the ApiResponse.Status
  ///This function is called everytime a stream of ApiResponse that is listened by the ViewModel
  ///is Received.
  void handleApiResponse (ApiResponse event) {
    switch(event.status) {
      case Status.LOADING:
        setLoading(event.isLoading);
        // notifyListeners();
        break;
      case Status.COMPLETED:
        ///Could not handle this yet. So it's manually handled in the ViewModel.


        // logger.e("GOT HERE THE COMPLETED HANDLE RESPONSE ${event.data}");
        // notifyListeners();
        break;
      case Status.ERROR:
        showToast(event.message as String);
        break;
    }
  }

  ///Toast Message with Fluttertoast package
  showToast(message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 11.0,
    );
  }

  setLoading(bool isLoading) {
    this.isLoading.value = isLoading;
  }
}