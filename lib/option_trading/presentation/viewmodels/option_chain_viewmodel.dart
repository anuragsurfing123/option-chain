import 'dart:math';

import 'package:flutter/material.dart';
import '../../domain/entities/option_entity.dart';
import '../../domain/usecases/get_option_chain_usecase.dart';

class OptionChainViewModel extends ChangeNotifier {
  final GetOptionChainUseCase _getOptionChainUseCase;

  OptionChainViewModel(this._getOptionChainUseCase) {
    _attachScrollListeners();
    fetchOptionChainData('NIFTY');
  }

  List<OptionEntity> _optionData = [];

  List<OptionEntity> get optionData => _optionData;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

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

  Future<void> fetchOptionChainData(String symbol) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    final result = await _getOptionChainUseCase.call(symbol);
    result.when(
      (data) {
        _optionData = data;
        _errorMessage = null;
      },
      (error) {
        _optionData = [];
        _errorMessage = error.message;
      },
    );
    _isLoading = false;
    notifyListeners();
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
      final target = max(0.0,min(targetLeftPixels, leftMaxExtent));



      if (rightDataHorizontalScrollController.position.pixels !=
          target) {
        rightDataHorizontalScrollController.jumpTo(target);
      }
      if (rightHeaderHorizontalScrollController.position.pixels !=
          target) {
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
      final target = max(0.0,min(targetRightPixels, rightMaxExtent));


      if (leftDataHorizontalScrollController.position.pixels !=
          target) {
        leftDataHorizontalScrollController.jumpTo(target);
      }
      if (leftHeaderHorizontalScrollController.position.pixels !=
          target) {
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
    leftHeaderHorizontalScrollController.dispose();
    leftDataHorizontalScrollController.dispose();
    rightHeaderHorizontalScrollController.dispose();
    rightDataHorizontalScrollController.dispose();
    leftDataVerticalScrollController.dispose();
    rightDataVerticalScrollController.dispose();
    fixedDataVerticalScrollController.dispose();
    super.dispose();
  }
}
