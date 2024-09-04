import 'package:flutter/material.dart';
import 'package:flutter_attendace/presentation/setting/pages/edit_pages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_attendace/presentation/auth/bloc/logout/logout_bloc.dart';
import 'package:flutter_attendace/presentation/auth/pages/login_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 20),
          _buildSectionHeader('Account'),
          _buildListTile('Edit Profile', () {}),
          _buildListTile('Password', () {}),
          _buildListTile('Language', () {}),
          const SizedBox(height: 30),
          _buildSectionHeader('Preferences'),
          _buildListTile('Theme', () {}),
          _buildListTile('Notifications', () {}),
          _buildListTile('Attendance', () {}),
          const SizedBox(height: 30),
          _buildSectionHeader('Support'),
          _buildListTile('Terms of Service & Privacy', () {}),
          _buildListTile('Clear Cache', () {}),
          _buildListTile('About Me', () {}),
          const SizedBox(height: 30),
          // _buildSectionHeader(''),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildListTile(String title, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          onTap: onTap,
        ),
        const Divider(height: 1, color: Colors.grey),
      ],
    );
  }  Widget _buildLogoutButton(BuildContext context) {
    return BlocConsumer<LogoutBloc, LogoutState>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () {},
          success: (_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          error: (value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(value.error),
                backgroundColor: Colors.red,
              ),
            );
          },
        );
      },
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => ElevatedButton(
            onPressed: () {
              context.read<LogoutBloc>().add(const LogoutEvent.logout());
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Logout'),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}