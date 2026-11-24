import 'package:core/api/api.dart';
import 'package:flutter/material.dart';

import '../di/pos_composition.dart';
import 'user_create_screen.dart';
import 'user_edit_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key, required this.composition});

  final PosComposition composition;

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<UserProfileResponse>? _users;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await widget.composition.authService.listUsers(
      widget.composition.requireStoreId,
    );
    if (!mounted) return;
    switch (result) {
      case ApiSuccess<List<UserProfileResponse>>(data: final data):
        setState(() {
          _users = data;
          _loading = false;
        });
      case ApiFailure<List<UserProfileResponse>>(error: final e):
        setState(() {
          _error = e.message;
          _loading = false;
        });
    }
  }

  Future<void> _openCreate() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => UserCreateScreen(composition: widget.composition),
      ),
    );
    if (created == true) {
      await _load();
    }
  }

  Future<void> _openEdit(UserProfileResponse user) async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => UserEditScreen(
          composition: widget.composition,
          user: user,
        ),
      ),
    );
    if (updated == true) {
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios')),
      floatingActionButton: FloatingActionButton(
        key: const Key('users_list_add_fab'),
        onPressed: _openCreate,
        child: const Icon(Icons.person_add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView.builder(
                  itemCount: _users!.length,
                  itemBuilder: (context, index) {
                    final user = _users![index];
                    return ListTile(
                      key: Key('users_list_tile_${user.id}'),
                      title: Text(user.displayName),
                      subtitle: Text('${user.username} · ${user.role}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _openEdit(user),
                    );
                  },
                ),
    );
  }
}