import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main.dart';
import '../types/organizational-user.dart';

final organizationUsersServiceProvider = Provider<OrganizationalUsersService>((ref) {
  return OrganizationalUsersService();
});

final organizationalUsersStreamProvider = StreamProvider.autoDispose<List<dynamic>>((ref) {
  return ref.watch(organizationUsersServiceProvider).usersStream();
});

final organizationalUserStreamProvider = StreamProvider.autoDispose.family<dynamic, String>((ref, uid) {
  return ref.watch(organizationUsersServiceProvider).userStream(uid);
});

class OrganizationalUsersService {

  Stream<OrganizationalUser> userStream(String uid) {
    return supabase
        .from('organizational_users')
        .stream(primaryKey: ['id']).eq('id', uid).map((event) => event.map<OrganizationalUser>((e) => OrganizationalUser.fromMap(e)).first);
  }

  Stream<List<OrganizationalUser>> usersStream() {
    return supabase
        .from('organizational_users')
        .select(
          'id, email, first_name, last_name, phone_number, role:role_id(id, name)',
        )
        .asStream()
        .map((event) => event.map<OrganizationalUser>((e) => OrganizationalUser.fromMap(e)).toList());
  }
}