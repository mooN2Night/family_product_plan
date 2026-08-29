import 'package:barcode_widget/barcode_widget.dart';
import 'package:family_product_plan/app/presentation/ui_kit/app_bar.dart';
import 'package:family_product_plan/app/presentation/ui_kit/app_box.dart';
import 'package:family_product_plan/features/card/domain/entity/card_entity.dart';
import 'package:family_product_plan/features/card/domain/state/card_fetch/card_fetch_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_context_ext.dart';

class CardDetailScreen extends StatelessWidget {
  const CardDetailScreen({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    final cardRepository = context.di.repositories.cardRepository;

    return BlocProvider(
      create: (context) =>
          CardFetchBloc(cardRepository: cardRepository)
            ..add(CardFetchRequestedEvent(id: id)),
      child: const _CardDetailView(),
    );
  }
}

class _CardDetailView extends StatelessWidget {
  const _CardDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.secondary(title: 'Карта'),
      body: BlocBuilder<CardFetchBloc, CardFetchState>(
        builder: (context, state) {
          switch (state) {
            case CardFetchLoadingState():
              return Container(width: 50, height: 50, color: Colors.yellow);
            case CardFetchSuccessState():
              return _CardDetailSuccessView(card: state.card);
            case CardFetchErrorState():
              return Container(width: 50, height: 50, color: Colors.red);
            case _:
              return Container(width: 50, height: 50, color: Colors.blue);
          }
        },
      ),
    );
  }
}

class _CardDetailSuccessView extends StatelessWidget {
  const _CardDetailSuccessView({required this.card});

  final CardEntity card;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          Text('Магазин: ${card.name}'),
          if (card.number.isNotEmpty) ...[
            HBox(10),
            Text('Номер карты: ${card.number}'),
          ],
          HBox(20),
          BarcodeWidget(
            barcode: switch (card.barcodeFormat) {
              'BarcodeFormat.qrCode' => Barcode.qrCode(),
              'BarcodeFormat.code128' => Barcode.code128(),
              'BarcodeFormat.code39' => Barcode.code39(),
              'BarcodeFormat.codabar' => Barcode.codabar(),
              'BarcodeFormat.ean13' => Barcode.ean13(),
              'BarcodeFormat.upcA' => Barcode.upcA(),
              'BarcodeFormat.itf14' => Barcode.itf14(),
              _ => Barcode.qrCode(),
            },
            data: card.code,
            width: 200,
            height: 200,
          ),
        ],
      ),
    );
  }
}
