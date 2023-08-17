import 'package:central_driver/types/service.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';


class ServiceListTile extends StatelessWidget {
  final Service service;
  const ServiceListTile({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/service_details', arguments: {'service': service});
      },
      child: Card(
        child: Opacity(
          opacity: service.completed_on != null ? 0.3 : 1,
          child: Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
                ),
                width: 8,
                height: 75,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        formatDate(DateTime.parse(service.timestamp).toLocal(), [h, ':', nn, ' ', am]),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        )
                      ),
                      Text(' • ', style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
                      Text(
                        service.job.service_type,
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(service.client.name, style: TextStyle(fontSize: 17, decoration: service.completed_on != null ? TextDecoration.lineThrough : null)),
                ],
              ),
              const Spacer(),
              service.completed_on != null ? const Icon(
                Icons.check_circle,
                color: Colors.green,
              ) : const SizedBox(),
              const SizedBox(width: 10),
              const Icon(
                  Icons.chevron_right
              ),
              const SizedBox(width: 10),
            ],
          ),
        )
      ),
    );
  }
}
