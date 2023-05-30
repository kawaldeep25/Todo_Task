// base_model.dart
import 'package:flutter/material.dart';

class BaseBloc extends ChangeNotifier {
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    try {
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}

// viewstate.dart
/// Represents the state of the view
enum ViewState { Idle, Busy }
