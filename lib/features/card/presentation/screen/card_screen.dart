import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/app/presentation/ui_kit/app_bar.dart';
import 'package:family_product_plan/features/card/domain/entity/card_entity.dart';
import 'package:family_product_plan/features/card/domain/state/cards/cards_bloc.dart';
import 'package:family_product_plan/features/card/presentation/card_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/presentation/dialog/card_add_dialog.dart';
import '../../domain/state/card_action/card_action_bloc.dart';
import 'card_scan_screen.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cardRepository = context.di.repositories.cardRepository;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CardsBloc(cardRepository: cardRepository)..add(CardsFetchEvent()),
        ),
        BlocProvider(
          create: (context) => CardActionBloc(cardRepository: cardRepository),
        ),
      ],
      child: const _CardView(),
    );
  }
}

class _CardView extends StatelessWidget {
  const _CardView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CardActionBloc, CardActionState>(
      listener: (context, state) {
        if (state is CardActionSuccessState) {
          context.read<CardsBloc>().add(CardsFetchEvent());
        }
      },
      child: Scaffold(
        appBar: CustomAppBar.secondary(
          title: 'Скидочные карты',
          actions: [
            IconButton(
              onPressed: () => showAddCardDialog(context),
              icon: Icon(Icons.add_outlined),
            ),
            IconButton(
              onPressed: () async {
                final result = await context.pushNamed<ScannedCardResult>(
                  CardRoutes.cardScannerScreenName,
                );

                if (result != null) {
                  debugPrint('debugPrint ${result.rawValue}');
                  debugPrint('debugPrint ${result.format}');
                }
              },
              icon: Icon(Icons.qr_code_scanner_outlined),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async =>
              context.read<CardsBloc>().add(CardsFetchEvent()),
          child: BlocBuilder<CardsBloc, CardsState>(
            builder: (context, state) {
              switch (state) {
                case CardsLoadingState():
                  return Container(width: 50, height: 50, color: Colors.yellow);
                case CardsSuccessState():
                  final cards = state.cards;
                  if (cards.isEmpty) {
                    return Center(
                      child: Text('У вас пока нет зарегестрированных карт'),
                    );
                  }

                  return _CardSuccessView(cards: cards);
                case CardsErrorState():
                  return Container(width: 50, height: 50, color: Colors.red);
                case _:
                  return Container(width: 50, height: 50, color: Colors.blue);
              }
            },
          ),
        ),
      ),
    );
  }
}

class _CardSuccessView extends StatelessWidget {
  const _CardSuccessView({required this.cards});

  final List<CardEntity> cards;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];

        return ListTile(
          onTap: () => context.goNamed(
            CardRoutes.cardDetailScreenName,
            pathParameters: {'id': card.id},
          ),
          title: Text(card.name),
          subtitle: Text(card.number),
        );
      },
    );
  }
}
