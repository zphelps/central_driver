import 'package:central_driver/types/service.dart';
import 'package:flutter/material.dart';

class ServiceDetailsCard extends StatelessWidget {
  final Service service;
  const ServiceDetailsCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                    'CLIENT',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service.client.name,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ON-SITE CONTACT',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${service.on_site_contact.first_name} ${service.on_site_contact.last_name}',
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LOCATION',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 60,
                      child: Text(
                        service.location.street_address,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TRUCK',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service.truck.name,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SUMMARY',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service.summary,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
