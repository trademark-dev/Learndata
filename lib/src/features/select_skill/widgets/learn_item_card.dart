import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:d99_learn_data_enginnering/src/features/select_skill/widgets/learn_item_widget.dart';

class LearnItemCard extends StatelessWidget {
  final List<Map<String, dynamic>> items = const [
    {
      'text': 'Aliasing (AS) for readability in columns/tables.',
      'keywords': ['(AS)'],
    },
    {
      'text': 'Multiple WHERE conditions with parentheses.',
      'keywords': ['WHERE'],
    },
    {
      'text': 'ORDER BY on single/multiple columns.',
      'keywords': ['ORDER BY'],
    },
    {
      'text': 'DISTINCT for unique results.',
      'keywords': ['DISTINCT'],
    },
    {
      'text': 'Combining DISTINCT + ORDER BY',
      'keywords': ['DISTINCT', 'ORDER BY'],
    },
    {
      'text': 'Using JOIN to combine tables.',
      'keywords': ['JOIN'],
    },
    {
      'text': 'GROUP BY for aggregating data.',
      'keywords': ['GROUP BY'],
    },
    {
      'text': 'HAVING clause for filtered groups.',
      'keywords': ['HAVING'],
    },
    {
      'text': 'Subqueries in SELECT statements.',
      'keywords': ['SELECT'],
    },
    {
      'text': 'UNION to combine query results.',
      'keywords': ['UNION'],
    },
    {
      'text': 'Using LIMIT to restrict rows.',
      'keywords': ['LIMIT'],
    },
    {
      'text': 'COUNT function for row counting.',
      'keywords': ['COUNT'],
    },
    {
      'text': 'SUM and AVG for calculations.',
      'keywords': ['SUM', 'AVG'],
    },
  ];
  
  const LearnItemCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Scrollable list of items
        ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 0.h),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == items.length - 1 ? 0 : 4.h,
              ),
              child: LearnItemWidget(
                text: items[index]['text'] as String,
                highlightedKeywords: (items[index]['keywords'] as List<String>),
              ),
            );
          },
        ),
        // Top fade gradient
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 100.h,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF07101D).withOpacity(0),
                    const Color(0xFF0A1E33).withOpacity(0),
                    const Color(0xFF060C1A).withOpacity(0),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.2, 0.5, 1.0],
                ),
              ),
            ),
          ),
        ),
        // Bottom fade gradient
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 100.h,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    const Color(0xFF07101D).withOpacity(0.6),
                    const Color(0xFF0A1E33).withOpacity(0.4),
                    const Color(0xFF060C1A).withOpacity(0.1),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.2, 0.5, 1.0],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

