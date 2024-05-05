// ignore: file_names
import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  final String name;
  final double? netPrice;
  final dynamic actionClass;
  final dynamic chemicalClass;
  final dynamic habitForming;
  final dynamic therapeuticClass;
  final int id;
  final List<String> sideEffects;
  final List<String> substitutes;
  final List<String> uses;

  const ProductPage({
    Key? key,
    required this.name,
    this.netPrice,
    required this.actionClass,
    required this.chemicalClass,
    required this.habitForming,
    required this.therapeuticClass,
    required this.id,
    required this.sideEffects,
    required this.substitutes,
    required this.uses,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $name',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Net Price: ${netPrice != null ? '\$${netPrice?.toStringAsFixed(2)}' : 'N/A'}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Requires Prescription'),
                    _buildInfoItem(habitForming),
                    const SizedBox(height: 16),
                    _buildSectionHeader('Action Class'),
                    _buildInfoItem(therapeuticClass),
                    const SizedBox(height: 16),
                    _buildSection('Uses', uses),
                    const SizedBox(height: 16),
                    _buildSection('Substitutes', substitutes),
                    const SizedBox(height: 16),
                    _buildSection('Side Effects', sideEffects),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          items.isNotEmpty ? items.join(', ') : 'N/A',
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoItem(String value) {
    return Text(
      value,
      style: const TextStyle(
        fontSize: 16,
      ),
    );
  }
}
