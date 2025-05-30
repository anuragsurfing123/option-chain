import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import '../../../../option_trading/data/models/option_data_model.dart';
import '../../domain/repositories/i_market_repository.dart';

class MarketsViewModel extends ChangeNotifier with WidgetsBindingObserver {
  final MarketRepository _repository;
  StreamSubscription<List<OptionDataModel>>? _marketDataSubscription;

  bool _isLoading = false;
  String? _errorMessage;
  List<OptionDataModel> _optionData = [];
  bool _initialScrollSet = false;

// left scroll controller
  final ScrollController leftHeaderHorizontalScrollController =
      ScrollController();
  final ScrollController leftDataHorizontalScrollController =
      ScrollController();

  // right scroll controller
  final ScrollController rightHeaderHorizontalScrollController =
      ScrollController();
  final ScrollController rightDataHorizontalScrollController =
      ScrollController();

  // vertical scroll controller
  final ScrollController leftDataVerticalScrollController = ScrollController();
  final ScrollController rightDataVerticalScrollController = ScrollController();
  final ScrollController fixedDataVerticalScrollController = ScrollController();

  MarketsViewModel(this._repository) {
    WidgetsBinding.instance.addObserver(this);
    _attachScrollListeners();
    // _setInitialScrollPositions();
    _startListeningToMarketData();
  }

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  List<OptionDataModel> get optionData => _optionData;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setOptionData(List<OptionDataModel> data) {
    _optionData = data;
    notifyListeners();
  }

  void _startListeningToMarketData() {
    _setLoading(true);
    _setErrorMessage(null);

    _marketDataSubscription?.cancel();

    _marketDataSubscription = _repository.getMarketData().listen(
      (data) {
        _setOptionData(data);
        _setLoading(false);

        if (!_initialScrollSet) {
          _setInitialScrollPositions();
          _initialScrollSet = true;
        }
      },
      onError: (error) {
        _setErrorMessage('WebSocket Market Data Error: $error');
        _setLoading(false);
      },
      onDone: () {
        debugPrint('Market WebSocket connection closed by server or manually.');
        _setErrorMessage('Market data stream closed.');
        _setLoading(false);
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('AppLifecycleState changed to: $state');
    if (state == AppLifecycleState.resumed) {
      debugPrint('App resumed. Attempting to reconnect WebSocket.');
      _startListeningToMarketData(); // reconnect
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      debugPrint('App paused or detached. Disconnecting WebSocket.');
      _marketDataSubscription?.cancel(); // close connection
      _marketDataSubscription = null;
    }
  }

  void _attachScrollListeners() {
    // vertical listener
    leftDataVerticalScrollController.addListener(_syncVerticalScroll);
    rightDataVerticalScrollController.addListener(_syncVerticalScroll);
    fixedDataVerticalScrollController.addListener(_syncVerticalScroll);

    // horizontal listener
    leftHeaderHorizontalScrollController.addListener(() {
      if (leftHeaderHorizontalScrollController.hasClients &&
          leftHeaderHorizontalScrollController
              .position.isScrollingNotifier.value) {
        _syncHorizontalScroll(leftHeaderHorizontalScrollController, 'left');
      }
    });

    leftDataHorizontalScrollController.addListener(() {
      if (leftDataHorizontalScrollController.hasClients &&
          leftDataHorizontalScrollController
              .position.isScrollingNotifier.value) {
        _syncHorizontalScroll(leftDataHorizontalScrollController, 'left');
      }
    });

    rightHeaderHorizontalScrollController.addListener(() {
      if (rightHeaderHorizontalScrollController.hasClients &&
          rightHeaderHorizontalScrollController
              .position.isScrollingNotifier.value) {
        _syncHorizontalScroll(rightHeaderHorizontalScrollController, 'right');
      }
    });
    rightDataHorizontalScrollController.addListener(() {
      if (rightDataHorizontalScrollController.hasClients &&
          rightDataHorizontalScrollController
              .position.isScrollingNotifier.value) {
        _syncHorizontalScroll(rightDataHorizontalScrollController, 'right');
      }
    });
  }

  void _setInitialScrollPositions() {
    debugPrint(
        '_setInitialScrollPositions called ${leftHeaderHorizontalScrollController.hasClients} ${leftDataHorizontalScrollController.hasClients} ${rightHeaderHorizontalScrollController.hasClients} ${rightDataHorizontalScrollController.hasClients}  ');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (leftHeaderHorizontalScrollController.hasClients &&
          leftDataHorizontalScrollController.hasClients &&
          rightHeaderHorizontalScrollController.hasClients &&
          rightDataHorizontalScrollController.hasClients) {
        debugPrint('_setInitialScrollPositions called');
        final double leftMaxExtent =
            leftDataHorizontalScrollController.position.maxScrollExtent;

        if (leftHeaderHorizontalScrollController.position.pixels !=
            leftMaxExtent) {
          leftHeaderHorizontalScrollController.jumpTo(leftMaxExtent);
        }
        if (leftDataHorizontalScrollController.position.pixels !=
            leftMaxExtent) {
          leftDataHorizontalScrollController.jumpTo(leftMaxExtent);
        }

        if (rightHeaderHorizontalScrollController.position.pixels != 0.0) {
          rightHeaderHorizontalScrollController.jumpTo(0.0);
        }
        if (rightDataHorizontalScrollController.position.pixels != 0.0) {
          rightDataHorizontalScrollController.jumpTo(0.0);
        }
      }
    });
  }

  void _syncHorizontalScroll(
      ScrollController sourceController, String sourceSide) {
    debugPrint(
        'leftHeaderHorizontalScrollController.hasClients: ${leftHeaderHorizontalScrollController.hasClients}, rightHeaderHorizontalScrollController.hasClients: ${rightHeaderHorizontalScrollController.hasClients},leftDataHorizontalScrollController.hasClients: ${leftDataHorizontalScrollController.hasClients}, rightDataHorizontalScrollController.hasClients: ${rightDataHorizontalScrollController.hasClients}');
    if (!leftHeaderHorizontalScrollController.hasClients ||
        !rightHeaderHorizontalScrollController.hasClients ||
        !leftDataHorizontalScrollController.hasClients ||
        !rightDataHorizontalScrollController.hasClients) {
      return;
    }

    final double sourceCurrentPixels = sourceController.position.pixels;
    final double leftMaxExtent =
        leftDataHorizontalScrollController.position.maxScrollExtent;
    final double rightMaxExtent =
        rightDataHorizontalScrollController.position.maxScrollExtent;

    debugPrint(
        'sourceCurrentPixels: $sourceCurrentPixels, leftMaxExtent: $leftMaxExtent, rightMaxExtent: $rightMaxExtent');

    if (sourceSide == 'left') {
      if (sourceController == leftHeaderHorizontalScrollController &&
          leftDataHorizontalScrollController.position.pixels !=
              sourceCurrentPixels) {
        leftDataHorizontalScrollController.jumpTo(sourceCurrentPixels);
      } else if (sourceController == leftDataHorizontalScrollController &&
          leftHeaderHorizontalScrollController.position.pixels !=
              sourceCurrentPixels) {
        leftHeaderHorizontalScrollController.jumpTo(sourceCurrentPixels);
      }

      final double targetLeftPixels = leftMaxExtent - sourceCurrentPixels;
      final target = max(0.0, min(targetLeftPixels, leftMaxExtent));

      if (rightDataHorizontalScrollController.position.pixels != target) {
        rightDataHorizontalScrollController.jumpTo(target);
      }
      if (rightHeaderHorizontalScrollController.position.pixels != target) {
        rightHeaderHorizontalScrollController.jumpTo(target);
      }
    } else if (sourceSide == 'right') {
      if (sourceController == rightHeaderHorizontalScrollController &&
          rightDataHorizontalScrollController.position.pixels !=
              sourceCurrentPixels) {
        rightDataHorizontalScrollController.jumpTo(sourceCurrentPixels);
      } else if (sourceController == rightDataHorizontalScrollController &&
          rightHeaderHorizontalScrollController.position.pixels !=
              sourceCurrentPixels) {
        rightHeaderHorizontalScrollController.jumpTo(sourceCurrentPixels);
      }

      final double targetRightPixels = rightMaxExtent - sourceCurrentPixels;
      final target = max(0.0, min(targetRightPixels, rightMaxExtent));

      if (leftDataHorizontalScrollController.position.pixels != target) {
        leftDataHorizontalScrollController.jumpTo(target);
      }
      if (leftHeaderHorizontalScrollController.position.pixels != target) {
        leftHeaderHorizontalScrollController.jumpTo(target);
      }
    }
  }

  void _syncVerticalScroll() {
    final List<ScrollController> controllers = [
      fixedDataVerticalScrollController,
      leftDataVerticalScrollController,
      rightDataVerticalScrollController,
    ];

    ScrollController? initiator;
    for (var controller in controllers) {
      if (controller.hasClients &&
          controller.position.isScrollingNotifier.value) {
        initiator = controller;
        break;
      }
    }

    if (initiator != null) {
      final double offset = initiator.position.pixels;
      for (var controller in controllers) {
        if (controller != initiator &&
            controller.hasClients &&
            controller.position.pixels != offset) {
          controller.jumpTo(offset);
        }
      }
    }
  }

  @override
  void dispose() {
    _marketDataSubscription?.cancel();
    _repository.dispose();
    WidgetsBinding.instance.removeObserver(this); // Unregister the observer

    leftHeaderHorizontalScrollController.dispose();
    rightHeaderHorizontalScrollController.dispose();
    leftDataHorizontalScrollController.dispose();
    rightDataHorizontalScrollController.dispose();
    leftDataVerticalScrollController.dispose();
    fixedDataVerticalScrollController.dispose();
    rightDataVerticalScrollController.dispose();
    super.dispose();
  }
}
