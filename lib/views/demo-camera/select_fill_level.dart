import 'package:flutter/material.dart';

import '../../api/bins/bins.dart';
import '../../api/services/services.dart';
import '../../types/bin.dart';
import '../../types/service_report.dart';

class SelectFillLevel extends StatefulWidget {
  const SelectFillLevel({super.key});

  @override
  State<SelectFillLevel> createState() => _SelectFillLevelState();
}

class _SelectFillLevelState extends State<SelectFillLevel> {
  int? _indexUpdating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[50],
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bin Fill Level',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.black,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select the fill percentage of the container.',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                  itemCount: 24,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return ListTile(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      tileColor: Colors.grey[200],
                      onTap: () async {
                        setState(() {
                          _indexUpdating = index;
                        });
                        await Future.delayed(const Duration(milliseconds: 250));
                        setState(() {
                          _indexUpdating = null;
                        });
                        Navigator.of(context).pop(index * 5);
                      },
                      trailing: _indexUpdating == index
                          ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                          : null,
                      title: Text(
                        '${index * 5}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    );
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}
