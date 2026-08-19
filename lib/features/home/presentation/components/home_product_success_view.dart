import 'package:flutter/material.dart';

import '../../../../app/presentation/ui_kit/app_box.dart';
import '../../../../app/utils/app_colors.dart';
import '../../../../app/utils/app_utils.dart';
import '../../domain/entity/product_entity.dart';

class HomeProductSuccessView extends StatelessWidget {
  const HomeProductSuccessView({required this.product, super.key});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final formatedCreatedAt = AppUtils.formateDate(product.createdAt);
    final formatedUpdatedAt = AppUtils.formateDate(product.updatedAt);

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 140),
      children: [
        _ProductMainCard(product: product),

        if (product.description.isNotEmpty) ...[
          const HBox(20),
          _ProductDescriptionCard(description: product.description),
        ],

        const HBox(28),
        _ProductDates(
          createdAt: formatedCreatedAt,
          updatedAt: formatedUpdatedAt,
        ),
      ],
    );
  }
}

class _ProductMainCard extends StatelessWidget {
  const _ProductMainCard({required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.shopping_basket_outlined,
                  size: 30,
                  color: AppColors.primary,
                ),
              ),
              const WBox(16),
              Expanded(
                child: Text(
                  product.productName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const HBox(20),
          _ProductStatus(isToBuy: product.isToBuy),
          if (product.quantity.isNotEmpty) ...[
            const HBox(14),
            _ProductInfoRow(
              icon: Icons.numbers_rounded,
              title: 'Количество',
              value: product.quantity,
            ),
          ],

          if (product.productManufacturer.isNotEmpty) ...[
            const HBox(14),
            _ProductInfoRow(
              icon: Icons.factory_outlined,
              title: 'Производитель',
              value: product.productManufacturer,
            ),
          ],
        ],
      ),
    );
  }
}

class _ProductStatus extends StatelessWidget {
  const _ProductStatus({required this.isToBuy});

  final bool isToBuy;

  @override
  Widget build(BuildContext context) {
    final color = isToBuy ? Colors.orange : Colors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isToBuy ? Icons.shopping_cart_outlined : Icons.check_circle_outline,
            size: 18,
            color: color,
          ),
          const WBox(8),
          Text(
            isToBuy ? 'Нужно купить' : 'Покупать не нужно',
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _ProductInfoRow extends StatelessWidget {
  const _ProductInfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const WBox(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
              ),
              const HBox(2),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductDescriptionCard extends StatelessWidget {
  const _ProductDescriptionCard({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notes_rounded, size: 20, color: Colors.grey.shade600),
              const WBox(8),
              Text(
                'Описание',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const HBox(10),
          Text(description, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _ProductDates extends StatelessWidget {
  const _ProductDates({required this.createdAt, required this.updatedAt});

  final String? createdAt;
  final String? updatedAt;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (createdAt != null)
          _ProductDateRow(title: 'Создан', value: createdAt!),
        if (updatedAt != null) ...[
          const SizedBox(height: 8),
          _ProductDateRow(title: 'Изменён', value: updatedAt!),
        ],
      ],
    );
  }
}

class _ProductDateRow extends StatelessWidget {
  const _ProductDateRow({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
