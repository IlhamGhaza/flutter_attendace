import 'package:flutter/material.dart';
import '../../../core/core.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 250.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Assets.images.bgHome.provider(),
                      alignment: Alignment.topCenter,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, left: 16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
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
                  ),
                ),
                Positioned(
                  top: 120.0,
                  left: MediaQuery.of(context).size.width / 2 - 50.0,
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: const NetworkImage(
                      'https://i.pinimg.com/originals/1b/14/53/1b14536a5f7e70664550df4ccaa5b231.jpg',
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 15.0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                            size: 15.0,
                          ),
                          onPressed: () {
                            // Aksi edit foto profil
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 220.0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Column(
                      children: const [
                        Text(
                          'hera@geoface.id | +6285806391116',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Account',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  ListTile(
                    title: const Text('Edit Profile'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Aksi untuk edit profil
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Jabatan'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Aksi untuk jabatan
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Perangkat Terdaftar'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Aksi untuk perangkat terdaftar
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
