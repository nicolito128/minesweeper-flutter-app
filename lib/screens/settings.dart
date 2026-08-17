import 'package:flutter/material.dart';
import 'package:minesweeper/settings.dart';
import 'package:minesweeper/utils/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final currentPalette = globalSettings.palette;

    return Scaffold(
      backgroundColor: currentPalette.background,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: currentPalette.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: currentPalette.background,
        iconTheme: IconThemeData(color: currentPalette.secondary),
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- THEMES ---
          _buildSectionTitle('Themes', currentPalette),
          const SizedBox(height: 12),
          _buildThemesList(currentPalette),

          const SizedBox(height: 32),

          // --- OTHERS ---
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Palette currentPalette) {
    return Text(
      title,
      style: TextStyle(
        color: currentPalette.text,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildThemesList(Palette currentPalette) {
    return Column(
      children: paletteList.map((paletteOption) {
        final isSelected = currentPalette == paletteOption;

        return GestureDetector(
          onTap: () {
            setState(() {
              globalSettings.palette = paletteOption;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: paletteOption.secondary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? paletteOption.primary : Colors.transparent,
                width: 3.0,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  paletteOption.name,
                  style: TextStyle(
                    color: paletteOption.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    _ColorCircle(color: paletteOption.primary),
                    const SizedBox(width: 8),
                    _ColorCircle(color: paletteOption.secondary),
                    const SizedBox(width: 8),
                    _ColorCircle(color: paletteOption.background),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSwitchOption(
    String title,
    IconData icon,
    bool value,
    Palette currentPalette,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: currentPalette.secondary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: currentPalette.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: currentPalette.secondary),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  color: currentPalette.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: (val) {
              // setState(...)
            },
            activeThumbColor: currentPalette.primary,
            activeTrackColor: currentPalette.secondary,
            inactiveThumbColor: currentPalette.secondary.withValues(alpha: 0.5),
            inactiveTrackColor: currentPalette.background,
          ),
        ],
      ),
    );
  }
}

class _ColorCircle extends StatelessWidget {
  final Color color;

  const _ColorCircle({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white70, width: 1.5),
      ),
    );
  }
}

