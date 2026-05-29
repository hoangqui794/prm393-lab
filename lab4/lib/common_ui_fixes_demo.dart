import 'package:flutter/material.dart';

/// Exercise 5: Debug & Fix Common UI Errors
/// This screen demonstrates and explains the solutions to four common Flutter UI issues:
/// 1. ListView inside Column using Expanded
/// 2. Overflow on small screens using SingleChildScrollView
/// 3. State update issue using setState()
/// 4. DatePicker context errors
class CommonUiFixesDemo extends StatefulWidget {
  const CommonUiFixesDemo({super.key});

  @override
  State<CommonUiFixesDemo> createState() => _CommonUiFixesDemoState();
}

class _CommonUiFixesDemoState extends State<CommonUiFixesDemo> {
  // State variables for demonstrating Fix #3 (State updates)
  bool _switchVal = false;
  int _counter = 0;

  // State variables for demonstrating Fix #4 (DatePicker context)
  DateTime? _selectedDate;

  // Method to safely invoke showDatePicker using valid build context
  Future<void> _pickDateSafely(BuildContext context) async {
    // Calling DatePicker inside a button callback with a valid widget context
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<String> debugMovies = ['Movie A', 'Movie B', 'Movie C', 'Movie D'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 5 – Common U...'),
      ),
      // Fix #2: SingleChildScrollView wraps the layout to prevent overflow on small screens
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- FIX #1 DEMO (Directly matches the screenshot) ---
              Text(
                'Correct ListView inside Column using Expanded',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              
              // We constrain the ListView using a fixed-height Container or Expanded.
              // Since the body is inside a SingleChildScrollView, we can also use shrinkWrap: true
              // and NeverScrollableScrollPhysics to render it cleanly alongside other sections,
              // or use an Expanded inside a nested Column with defined height.
              // To strictly demonstrate "ListView inside Column using Expanded" in action:
              Container(
                height: 220, // Constrain container height to keep ListView layout bounded
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    // Expanded ensures ListView doesn't throw "Vertical viewport was given unbounded height"
                    Expanded(
                      child: ListView.builder(
                        itemCount: debugMovies.length,
                        physics: const NeverScrollableScrollPhysics(), // Disable scrolling inside scroll view
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.movie_creation,
                                  color: theme.colorScheme.primary,
                                  size: 26,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  debugMovies[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: theme.colorScheme.onSurface,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 32, thickness: 1),

              // --- INTERACTIVE FIX DEMONSTRATIONS & EXPLANATIONS ---
              Text(
                'Explanation of Fixes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),

              // Fix Card 1
              _buildFixCard(
                title: '1. ListView inside Column',
                problem: 'ListView tries to expand infinitely, whereas Column does not bound height, resulting in: "Vertical viewport was given unbounded height" exception.',
                solution: 'Wrap the ListView in an "Expanded" or "Flexible" widget, or set "shrinkWrap: true" with "NeverScrollableScrollPhysics()" if placed inside a scrollable screen.',
              ),
              
              // Fix Card 2
              _buildFixCard(
                title: '2. Small Screen Overflow',
                problem: 'When UI content height exceeds the screen boundary, Flutter displays a yellow-and-black striped warning: "A RenderFlex overflowed by X pixels".',
                solution: 'Wrap the parent container or Column inside a "SingleChildScrollView" to make the layout scrollable and adaptive to small screens.',
              ),

              // Fix Card 3
              _buildFixCard(
                title: '3. State Update Issue (setState)',
                problem: 'Updating state variables in memory does not cause the UI to redraw if you omit calling setState().',
                solution: 'Wrap state changes inside setState() to request a rebuild of the widget tree.',
                interactiveWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Value: $_counter | Switch: ${_switchVal ? "ON" : "OFF"}'),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                          onPressed: () {
                            // Fixed state update by adding setState()
                            setState(() {
                              _counter++;
                            });
                          },
                        ),
                        Switch(
                          value: _switchVal,
                          onChanged: (val) {
                            // Fixed state update by adding setState()
                            setState(() {
                              _switchVal = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Fix Card 4
              _buildFixCard(
                title: '4. DatePicker Context Errors',
                problem: 'Showing a dialog with an invalid context (e.g. during a build method before the context is fully ready or using a context from an unmounted widget) leads to layout crashes.',
                solution: 'Trigger showDatePicker inside user-triggered async callbacks (like button onPressed) using a valid, fully-mounted BuildContext.',
                interactiveWidget: OutlinedButton.icon(
                  onPressed: () => _pickDateSafely(context),
                  icon: const Icon(Icons.calendar_month, size: 18),
                  label: Text(_selectedDate == null 
                    ? 'Safe Date Picker' 
                    : 'Selected: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to display explanation cards for the fixes
  Widget _buildFixCard({
    required String title,
    required String problem,
    required String solution,
    Widget? interactiveWidget,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      color: isDark ? theme.colorScheme.surfaceVariant : const Color(0xFFF8F7FA),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: isDark ? Colors.transparent : const Color(0xFFEFECEF)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 16, 
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '❌ Problem: $problem',
              style: const TextStyle(color: Colors.redAccent, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Text(
              '✅ Solution: $solution',
              style: TextStyle(
                color: isDark ? Colors.greenAccent : Colors.green[700], 
                fontSize: 13, 
                fontWeight: FontWeight.w500,
              ),
            ),
            if (interactiveWidget != null) ...[
              const SizedBox(height: 12),
              interactiveWidget,
            ]
          ],
        ),
      ),
    );
  }
}
