import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/presentation/widgets/data_cell_widget.dart';
import '../viewmodels/markets_viewmodel.dart';

class MarketsScreen extends StatelessWidget {
  const MarketsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketsViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.errorMessage != null) {
          return Center(child: Text('Error: ${viewModel.errorMessage!}'));
        }

        if (viewModel.optionData.isEmpty) {
          return const Center(child: Text('No real-time market data available.'));
        }
        return Column(
          children: [
            _mainHeader(),
            // header
            _buildTableHeader(viewModel),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLeftData(viewModel),
                  _buildMiddleData(viewModel),
                  _buildRightData(viewModel),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget _mainHeader() {
    return Container(
      color: Colors.grey[200],
      child: const Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'CALLS',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'PUTS',
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(MarketsViewModel viewModel) {
    const cellWidth = 80.0;
    const strikeFixedWidth = 100.0;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: viewModel.leftHeaderHorizontalScrollController,
              child: const Row(
                children: [
                  SizedBox(
                    width: cellWidth,
                    child: Text(
                      'Bid Qty',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    width: cellWidth,
                    child: Text(
                      'Bid Price',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    width: cellWidth,
                    child: Text(
                      'Ask Price',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    width: cellWidth,
                    child: Text(
                      'Ask Qty',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    width: cellWidth,
                    child: Text(
                      'LTP',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    width: cellWidth,
                    child: Text(
                      'Change',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    width: cellWidth,
                    child: Text(
                      'Volume',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    width: cellWidth,
                    child: Text(
                      'OI',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    width: cellWidth,
                    child: Text(
                      'IV',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: strikeFixedWidth,
            child: Text(
              'Strike Price',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: viewModel.rightHeaderHorizontalScrollController,
              child: const Row(
                children: [
                  SizedBox(
                    width: cellWidth,
                    child: Text(
                      'IV',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    width: cellWidth,
                    child: Text(
                      'OI',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    width: cellWidth,
                    child: Text(
                      'Volume',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    width: cellWidth,
                    child: Text(
                      'Change',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    width: cellWidth,
                    child: Text(
                      'LTP',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    width: cellWidth,
                    child: Text(
                      'Ask Qty',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    width: cellWidth,
                    child: Text(
                      'Ask Price',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    width: cellWidth,
                    child: Text(
                      'Bid Price',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    width: cellWidth,
                    child: Text(
                      'Bid Qty',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftData(MarketsViewModel viewModel) {
    const double cellWidth = 80.0;
    const double cellHeight = 40.0;
    const int numColumns = 9;

    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: viewModel.leftDataHorizontalScrollController,
        child: Container(
          color: Colors.white,
          width: cellWidth * numColumns,
          child: ListView.separated(
            controller: viewModel.leftDataVerticalScrollController,
            separatorBuilder: (BuildContext context, int index) =>
            const Divider(),
            itemCount: viewModel.optionData.length,
            itemBuilder: (context, index) {
              final data = viewModel.optionData[index];
              return Container(
                color: Colors.white,
                height: cellHeight,
                child: Row(
                  children: [
                    DataCellWidget(text: data.bidQtyCall, width: cellWidth),
                    DataCellWidget(text: data.bidPriceCall, width: cellWidth),
                    DataCellWidget(text: data.askPriceCall, width: cellWidth),
                    DataCellWidget(text: data.askQtyCall, width: cellWidth),
                    DataCellWidget(text: data.ltpCall, width: cellWidth),
                    DataCellWidget(
                        text: data.changeCall,
                        width: cellWidth,
                        isChange: true),
                    DataCellWidget(text: data.volumeCall, width: cellWidth),
                    DataCellWidget(text: data.oiCall, width: cellWidth),
                    DataCellWidget(text: data.ivCall, width: cellWidth),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMiddleData(MarketsViewModel viewModel) {
    const double strikeFixedWidth = 100.0;
    const double cellHeight = 40.0;

    return SizedBox(
      width: strikeFixedWidth,
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) =>
        const Divider(color: Colors.white,),
        controller: viewModel.fixedDataVerticalScrollController,
        itemCount: viewModel.optionData.length,
        itemBuilder: (context, index) {
          final data = viewModel.optionData[index];
          return Container(
            height: cellHeight,
            color: Colors.white,
            child: Center(
              child: Text(
                data.strikePrice,
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRightData(MarketsViewModel viewModel) {
    const double cellWidth = 80.0;
    const double cellHeight = 40.0;
    const int numColumns = 9;

    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: viewModel.rightDataHorizontalScrollController,
        child: SizedBox(
          width: cellWidth * numColumns,
          child: ListView.separated(
            controller: viewModel.rightDataVerticalScrollController,
            separatorBuilder: (BuildContext context, int index) =>
            const Divider(),
            itemCount: viewModel.optionData.length,
            itemBuilder: (context, index) {
              final data = viewModel.optionData[index];
              return Container(
                height: cellHeight,
                color: Colors.white,
                child: Row(
                  children: [
                    DataCellWidget(text: data.ivPut, width: cellWidth),
                    DataCellWidget(text: data.oiPut, width: cellWidth),
                    DataCellWidget(text: data.volumePut, width: cellWidth),
                    DataCellWidget(
                        text: data.changePut, width: cellWidth, isChange: true),
                    DataCellWidget(text: data.ltpPut, width: cellWidth),
                    DataCellWidget(text: data.askQtyPut, width: cellWidth),
                    DataCellWidget(text: data.askPricePut, width: cellWidth),
                    DataCellWidget(text: data.bidPricePut, width: cellWidth),
                    DataCellWidget(text: data.bidQtyPut, width: cellWidth),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}