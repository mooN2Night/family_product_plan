import 'package:flutter/material.dart';

import '../../../../../app/presentation/dialog/card_code_dialog.dart';
import '../../../../../app/presentation/dialog/card_delete_dialog.dart';
import '../../../../../app/presentation/ui_kit/app_box.dart';
import '../../../domain/entity/card_entity.dart';
import '../../../utils/card_palette.dart';
import '../widgets/card_code_image.dart';

class CardSuccessView extends StatefulWidget {
  const CardSuccessView({
    required this.cards,
    required this.cardHeight,
    required this.peekHeight,
    super.key,
  });

  final List<CardEntity> cards;
  final double cardHeight;
  final double peekHeight;

  @override
  State<CardSuccessView> createState() => _CardSuccessViewState();
}

class _CardSuccessViewState extends State<CardSuccessView> {
  /// Сколько места освобождается под раскрытой картой — ровно та часть,
  /// что в свёрнутом виде была перекрыта следующей картой.
  late final double _expandGap;
  static const _openCardSpacing = 16.0;

  static const _animationDuration = Duration(milliseconds: 280);
  static const _animationCurve = Curves.easeInOutCubic;

  /// Индекс раскрытой не-лицевой карты. `null` — все свёрнуты.
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _expandGap = widget.cardHeight - widget.peekHeight + _openCardSpacing;
  }

  @override
  Widget build(BuildContext context) {
    final cards = widget.cards;
    final cardHeight = widget.cardHeight;
    final peekHeight = widget.peekHeight;

    final frontIndex = cards.length - 1;
    final expandedIndex = _expandedIndex;
    final hasExpandedBackCard =
        expandedIndex != null && expandedIndex < frontIndex;

    final stackHeight =
        cardHeight +
        (cards.length - 1) * peekHeight +
        (hasExpandedBackCard ? _expandGap : 0);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 140),
      child: AnimatedContainer(
        duration: _animationDuration,
        curve: _animationCurve,
        height: stackHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Рисуем с конца списка: самая дальняя карта первая (низкий
            // z-order), первая карта из списка — последней (поверх всех).
            for (var i = 0; i < cards.length; i++)
              AnimatedPositioned(
                duration: _animationDuration,
                curve: _animationCurve,
                top:
                    i * peekHeight +
                    (hasExpandedBackCard && i > expandedIndex ? _expandGap : 0),
                left: 0,
                right: 0,
                child: _WalletCardTile(
                  card: cards[i],
                  gradient: CardPalette.gradientForIndex(i),
                  height: cardHeight,
                  isOpen: i == frontIndex || i == expandedIndex,
                  // У лицевой карты нечего сворачивать — она открыта всегда.
                  onTap: i == frontIndex
                      ? null
                      : () => setState(() {
                          _expandedIndex = expandedIndex == i ? null : i;
                        }),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WalletCardTile extends StatelessWidget {
  const _WalletCardTile({
    required this.card,
    required this.gradient,
    required this.height,
    required this.isOpen,
    required this.onTap,
  });

  final CardEntity card;
  final List<Color> gradient;
  final double height;

  /// `true` — показываем полную карту (имя, номер, QR/штрихкод):
  /// либо это лицевая карта, либо она раскрыта тапом.
  final bool isOpen;

  /// `null` у лицевой карты — сворачивать её тапом не нужно, она открыта
  /// всегда.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () =>
          showDeleteCardDialog(context, name: card.name, id: card.id),
      child: Container(
        height: height,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: gradient.last.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: isOpen
              ? _OpenCardContent(key: const ValueKey('open'), card: card)
              : _CollapsedCardContent(
                  key: const ValueKey('collapsed'),
                  card: card,
                ),
        ),
      ),
    );
  }
}

/// Свёрнутый вид: видна только верхняя полоска карты, поэтому название и
/// номер закреплены сверху.
class _CollapsedCardContent extends StatelessWidget {
  const _CollapsedCardContent({required this.card, super.key});

  final CardEntity card;

  @override
  Widget build(BuildContext context) {
    final hasNumber = card.number.trim().isNotEmpty;

    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            card.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          if (hasNumber) ...[
            const HBox(4),
            Text(
              card.number,
              style: TextStyle(
                fontSize: 13,
                letterSpacing: 1.1,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Полностью открытый вид: слева имя/номер, справа превью кода — тап по
/// нему открывает код на весь экран с автояркостью ([showCardCodeDialog]).
class _OpenCardContent extends StatelessWidget {
  const _OpenCardContent({required this.card, super.key});

  final CardEntity card;

  @override
  Widget build(BuildContext context) {
    final hasNumber = card.number.trim().isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.credit_card_rounded,
                size: 26,
                color: Colors.white.withValues(alpha: 0.5),
              ),
              const Spacer(),
              Text(
                card.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (hasNumber) ...[
                const HBox(4),
                Text(
                  card.number,
                  style: TextStyle(
                    fontSize: 13,
                    letterSpacing: 1.1,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ],
          ),
        ),
        const WBox(16),
        GestureDetector(
          onTap: () => showCardCodeDialog(context, card),
          child: Container(
            width: 92,
            height: 92,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: CardCodeImage(card: card),
          ),
        ),
      ],
    );
  }
}
