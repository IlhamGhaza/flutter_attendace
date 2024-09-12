import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../../../data/datasources/auth_local_datasource.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 20.0),
            _buildAccountSection(context),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 290.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Assets.images.bgHome.provider(),
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 40.0,
          left: 16.0,
          child: _buildAppBar(context),
        ),
        Positioned(
          top: 120.0,
          left: 0,
          right: 0,
          child: _buildProfileImage(),
        ),
         Positioned(
          bottom: 10.0,
          left: 0,
          right: 0,
          child: _buildProfileInfo(),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 16.0),
        const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          const CircleAvatar(
            radius: 50.0,
            backgroundImage: NetworkImage(
              'https://i.pinimg.com/originals/1b/14/53/1b14536a5f7e70664550df4ccaa5b231.jpg',
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 15.0,
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue, size: 15.0),
                onPressed: () {
                  // Action to edit profile photo
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return  Center(
      child: FutureBuilder(
        future: AuthLocalDatasource().getAuthData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          } else {
            final user = snapshot.data?.user;
            return Column(
              children: [
                Text(
                'Hello, ${user?.name ?? 'Hello, Ilham Sensei'}',
                style: const TextStyle(
                  fontSize: 18.0,
                  color: AppColors.white,
                ),
                maxLines: 2,
                ),
                const SizedBox(height: 20.0),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          _buildAccountTile('Edit Profile', () {}),
          _buildAccountTile('Jabatan', () {}),
          _buildAccountTile('Perangkat Terdaftar', () {}),
        ],
      ),
    );
  }

  Widget _buildAccountTile(String title, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: onTap,
        ),
        const Divider(),
      ],
    );
  }

  
}