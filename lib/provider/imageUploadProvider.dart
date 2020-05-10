import 'package:flutter/cupertino.dart';
import 'package:my_app_2_2/enum/viewState.dart';

class ImageUploadProvider with ChangeNotifier {
  ViewState viewState = ViewState.IDLE;
  ViewState get getViewState => viewState;

  void setToLoading() {
    viewState = ViewState.LOADING;
    notifyListeners();
  }

  void setToIdle() {
    viewState = ViewState.IDLE;
    notifyListeners();
  }
}
