import 'package:central_driver/main.dart';
import 'package:central_driver/state/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../api/organizational_users.dart';
import '../../api/trucks.dart';
import '../../sections/services/calendar.dart';
import '../../sections/services/list.dart';
import '../../types/truck.dart';
import '../service-flow/service-flow.dart';
import '../services/details.dart';


class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  String? dropdownValue;
  String selectedDate = DateTime.now().toString();
  List<Truck> trucks = [];
  bool hasReNavigated = false;

  getTruck(mounted) async {
    final res = await TrucksApi().getTrucks();
    print(res);
    if (mounted) {
      setState(() {
        trucks = res;
        dropdownValue = trucks[0].id;
      });
      ref.read(servicesStateProvider.notifier).setTruckID(trucks[0].id);
    }
  }

  @override
  initState() {
    super.initState();
    getTruck(mounted);
  }

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(organizationalUserStreamProvider(supabase.auth.currentUser!.id));

    return userAsyncValue.when(
      data: (user) {
        if (user.current_service_id != null && !hasReNavigated) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).push(ServiceFlow.route(user.current_service_id));
          });
          hasReNavigated = true;
        }

        return Scaffold(
            appBar: AppBar(
                bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(135),
                  child: ServicesCalendar(),
                ),
                backgroundColor: Colors.white,
                elevation: 0,
                title: trucks.isNotEmpty ? DropdownButton<String>(
                  elevation: 2,
                  enableFeedback: true,
                  borderRadius: BorderRadius.circular(8),
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_drop_down_rounded, color: Colors.black),
                  underline: Container(
                    height: 0,
                    color: Colors.transparent,
                  ),
                  isDense: true,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                  onChanged: (String? value) async {
                    // This is called when the user selects an item.
                    if (mounted) {
                      setState(() {
                        dropdownValue = value!;
                      });
                      ref.read(servicesStateProvider.notifier).setTruckID(value!);
                    }
                  },
                  items: trucks.map((Truck truck) {
                    return DropdownMenuItem<String>(
                      alignment: Alignment.center,
                      value: truck.id,
                      child: Text(truck.name),
                    );
                  }).toList(),
                ) : const Text('Loading...'),
                leadingWidth: 75,
                leading: const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image(
                      image: AssetImage('assets/Central Logo-1.jpg'),
                      // height: 40,
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.black),
                    onPressed: () async {
                      showPlatformDialog(
                        context: context,
                        builder: (_) => PlatformAlertDialog(
                          title: const Text('Ready to logout?'),
                          actions: <Widget>[
                            PlatformDialogAction(child: PlatformText('Cancel'), onPressed: () => Navigator.pop(context)),
                            PlatformDialogAction(
                              child: PlatformText('Logout', style: const TextStyle(color: Colors.red)),
                              onPressed: () async {
                                Navigator.pop(context);
                                await supabase.auth.signOut();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ]
            ),
            body: dropdownValue == null ? const Center(child: CircularProgressIndicator()) : const ServicesList()
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) {
        return Center(child: Text('Error with realtime connection: ${err.toString()} ${stack.toString()}'));
      },
    );
  }
}
