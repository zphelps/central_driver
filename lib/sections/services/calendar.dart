import 'package:central_driver/state/services.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class ServicesCalendar extends ConsumerStatefulWidget {
  const ServicesCalendar({super.key});

  @override
  ConsumerState<ServicesCalendar> createState() => _WorkOrdersCalendarState();
}

class _WorkOrdersCalendarState extends ConsumerState<ServicesCalendar> {

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TableCalendar(
          availableCalendarFormats: const {CalendarFormat.week: 'week'},
          calendarFormat: CalendarFormat.week,
          headerVisible: false,
          calendarStyle: CalendarStyle(
            selectedTextStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
              todayTextStyle: const TextStyle(
              color:  Colors.black,
              fontWeight: FontWeight.w600
            )
          ),
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              if (mounted) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                ref.read(servicesStateProvider.notifier).setDate(_selectedDay.toString());
              }
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 16.0, top: 8, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                formatDate(_selectedDay!, [DD, ', ', MM, ' ', dd]),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
