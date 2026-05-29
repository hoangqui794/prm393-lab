import 'package:flutter/material.dart';

/// Exercise 2: Input Widgets Demo
/// This screen demonstrates interactive widgets that capture user input.
/// It uses a [StatefulWidget] to manage the state of the inputs:
/// - [Slider] for numeric range input.
/// - [Switch] for boolean toggle input.
/// - [RadioListTile] for selecting a single item from a group.
/// - [showDatePicker] triggered by an OutlinedButton.
class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  // State variables to store user-selected values
  double _sliderValue = 50.0;
  bool _isMovieActive = false;
  String? _selectedGenre; // Can be 'Action', 'Comedy', or null (None)
  DateTime? _selectedDate;

  // Function to show DatePicker and update state with the selected date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Format date helper: returns "dd/MM/yyyy" or "Not chosen"
  String _formatDate(DateTime? date) {
    if (date == null) return 'None';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 2 – Input Contr...'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Slider section
            Text(
              'Rating (Slider)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Slider(
              value: _sliderValue,
              min: 0.0,
              max: 100.0,
              divisions: 100,
              label: _sliderValue.round().toString(),
              activeColor: theme.colorScheme.primary,
              inactiveColor: theme.colorScheme.onSurface.withOpacity(0.12),
              onChanged: (double value) {
                // setState triggers build() to update the slider and text on screen
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
            Text(
              'Current value: ${_sliderValue.toInt()}',
              style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withOpacity(0.7)),
            ),
            const SizedBox(height: 24),

            // 2. Switch section
            Text(
              'Active (Switch)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: isDark ? theme.colorScheme.surfaceVariant : const Color(0xFFF4F2F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: Text(
                  'Is movie active?',
                  style: TextStyle(fontSize: 15, color: theme.colorScheme.onSurface),
                ),
                value: _isMovieActive,
                activeColor: theme.colorScheme.primary,
                onChanged: (bool value) {
                  setState(() {
                    _isMovieActive = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),

            // 3. RadioListTile section
            Text(
              'Genre (RadioListTile)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            RadioListTile<String>(
              title: const Text('Action'),
              value: 'Action',
              groupValue: _selectedGenre,
              activeColor: theme.colorScheme.primary,
              contentPadding: EdgeInsets.zero,
              onChanged: (String? value) {
                setState(() {
                  _selectedGenre = value;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Comedy'),
              value: 'Comedy',
              groupValue: _selectedGenre,
              activeColor: theme.colorScheme.primary,
              contentPadding: EdgeInsets.zero,
              onChanged: (String? value) {
                setState(() {
                  _selectedGenre = value;
                });
              },
            ),
            Text(
              'Selected genre: ${_selectedGenre ?? "None"}',
              style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withOpacity(0.7)),
            ),
            const SizedBox(height: 8),
            Text(
              'Selected date: ${_formatDate(_selectedDate)}',
              style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withOpacity(0.7)),
            ),
            const SizedBox(height: 24),

            // 4. Date Picker section
            // Displays a wide button that triggers showDatePicker
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () => _selectDate(context),
                style: OutlinedButton.styleFrom(
                  backgroundColor: isDark ? theme.colorScheme.surfaceVariant : const Color(0xFFF4F2F7),
                  side: BorderSide(color: isDark ? Colors.transparent : const Color(0xFFE2E0E6)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  'Open Date Picker',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
