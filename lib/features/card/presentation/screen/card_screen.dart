import 'package:family_product_plan/app/app_context_ext.dart';
import 'package:family_product_plan/app/presentation/ui_kit/app_bar.dart';
import 'package:family_product_plan/features/card/domain/state/cards/cards_bloc.dart';
import 'package:family_product_plan/features/card/presentation/card_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/presentation/ui_kit/app_box.dart';
import '../../../../app/presentation/ui_kit/app_skeleton.dart';
import '../../../../app/utils/app_colors.dart';
import '../../domain/state/card_action/card_action_bloc.dart';
import '../components/views/card_success_view.dart';

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
      ],
      child: const _CardView(),
    );
  }
}

class _CardView extends StatelessWidget {
  const _CardView();

  static const _cardHeight = 190.0;
  static const _peekHeight = 78.0;

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
              onPressed: () => context.goNamed(CardRoutes.cardAddScreenName),
              icon: Icon(Icons.add_outlined),
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
                  return const _CardsLoadingView(
                    cardHeight: _cardHeight,
                    peekHeight: _peekHeight,
                  );
                case CardsSuccessState():
                  final cards = state.cards;
                  if (cards.isEmpty) return const _CardsEmptyView();

                  return CardSuccessView(
                    cards: cards,
                    cardHeight: _cardHeight,
                    peekHeight: _peekHeight,
                  );
                case CardsErrorState():
                  return const _CardsErrorView();
                case _:
                  return const HWBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}

class _CardsLoadingView extends StatelessWidget {
  const _CardsLoadingView({required this.cardHeight, required this.peekHeight});

  final double cardHeight;
  final double peekHeight;
  static const count = 3;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: SizedBox(
        height: cardHeight + (count - 1) * peekHeight,
        child: Stack(
          children: [
            for (var i = count - 1; i >= 0; i--)
              Positioned(
                top: i * peekHeight,
                left: 0,
                right: 0,
                child: AppSkeleton(height: cardHeight, borderRadius: 24),
              ),
          ],
        ),
      ),
    );
  }
}

class _CardsEmptyView extends StatelessWidget {
  const _CardsEmptyView();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: AppColors.primarySoft,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.wallet_giftcard_outlined,
                        size: 32,
                        color: AppColors.primary,
                      ),
                    ),
                    const HBox(16),
                    const Text(
                      'У вас пока нет карт',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const HBox(6),
                    const Text(
                      'Добавьте скидочную карту, и она будет всегда под рукой',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const HBox(20),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () =>
                            context.goNamed(CardRoutes.cardAddScreenName),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Добавить карту',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CardsErrorView extends StatelessWidget {
  const _CardsErrorView();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: AppColors.primarySoft,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.error_outline_rounded,
                        size: 32,
                        color: AppColors.error,
                      ),
                    ),
                    const HBox(16),
                    const Text(
                      'Не удалось загрузить карты',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const HBox(6),
                    const Text(
                      'Проверьте соединение и попробуйте ещё раз',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const HBox(20),
                    OutlinedButton(
                      onPressed: () =>
                          context.read<CardsBloc>().add(CardsFetchEvent()),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(
                          color: AppColors.primary,
                          width: 1.4,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Повторить',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
