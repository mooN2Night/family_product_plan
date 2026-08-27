import 'package:barcode_widget/barcode_widget.dart';
import 'package:family_product_plan/app/presentation/ui_kit/app_bar.dart';
import 'package:family_product_plan/app/presentation/ui_kit/app_box.dart';
import 'package:family_product_plan/features/card/domain/entity/card_entity.dart';
import 'package:family_product_plan/features/card/domain/state/card_fetch/card_fetch_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../app/app_context_ext.dart';
import '../../../../app/utils/app_colors.dart';
import '../../domain/state/card_action/card_action_bloc.dart';

class CardDetailScreen extends StatelessWidget {
  const CardDetailScreen({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    final cardRepository = context.di.repositories.cardRepository;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CardFetchBloc(cardRepository: cardRepository)
                ..add(CardFetchRequestedEvent(id: id)),
        ),
        BlocProvider(
          create: (context) => CardActionBloc(cardRepository: cardRepository),
        ),
      ],
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
          HBox(10),
          Text('Номер карты: ${card.number}'),
          HBox(10),
          TabBar(
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: AppColors.primary, width: 3),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              insets: EdgeInsets.symmetric(horizontal: 28),
            ),
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            splashBorderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            tabs: [
              Tab(child: Text('qr_flutter')),
              Tab(child: Text('barcode_widget qrCode')),
              Tab(child: Text('barcode_widget code128')),
            ],
          ),
          HBox(20),
          SizedBox(
            height: 260,
            child: TabBarView(
              children: [
                Center(child: QrImageView(data: card.number, size: 200)),
                Center(
                  child: BarcodeWidget(
                    barcode: Barcode.qrCode(),
                    data: card.number,
                    width: 200,
                    height: 200,
                  ),
                ),
                Center(
                  child: BarcodeWidget(
                    barcode: Barcode.code128(),
                    data: card.number,
                    width: 250,
                    height: 100,
                    drawText: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
