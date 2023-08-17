import 'package:flutter/material.dart';

import '../../api/bins/bins.dart';
import '../../api/services/services.dart';
import '../../types/bin.dart';
import '../../types/service_report.dart';

class SelectFillPercentage extends StatefulWidget {
  final bool finalFill;
  final Bin bin;
  const SelectFillPercentage({required this.finalFill, required this.bin, super.key});

  @override
  State<SelectFillPercentage> createState() => _SelectFillPercentageState();
}

class _SelectFillPercentageState extends State<SelectFillPercentage> {
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
              widget.finalFill ? 'Final Fill Level' : 'Initial Fill Level',
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
                        if ((widget.finalFill && widget.bin.initial_fill_level != null) && (index * 5) > widget.bin.initial_fill_level!) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Final fill level cannot be greater than initial fill level.', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                          ));
                          setState(() {
                            _indexUpdating = null;
                          });
                          return;
                        } else if ((!widget.finalFill && widget.bin.final_fill_level != null) && (index * 5) < widget.bin.final_fill_level!) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Initial fill level cannot be less than final fill level.', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                          ));
                          setState(() {
                            _indexUpdating = null;
                          });
                          return;
                        }
                        final finalFill = widget.finalFill ? index * 5 : widget.bin.final_fill_level;
                        await BinsApi().updateBin(widget.bin.id, {
                          widget.finalFill ? 'final_fill_level' : 'initial_fill_level': index * 5,
                          'ready_for_haul': (finalFill ?? 0) < 95 ? false : true,
                        });
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
