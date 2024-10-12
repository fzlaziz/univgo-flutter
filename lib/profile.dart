import 'package:flutter/material.dart';
import 'package:univ_go/app/change_password.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.grey[700],
                    ),
                  ),
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Nama Lengkap',
                hintText: 'Udin Becus Tamvan',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'UdinisiUdin',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 16),
            const TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'udinbecus@gmail.com',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Pilih Jenjang',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'SMP',
                  child: Text(
                    'SMP',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                DropdownMenuItem(
                  value: 'SMA/SMK',
                  child: Text(
                    'SMA/SMK',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                DropdownMenuItem(
                  value: 'Kuliah',
                  child: Text(
                    'Kuliah',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                DropdownMenuItem(
                  value: 'Umum',
                  child: Text(
                    'Umum',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
              onChanged: (value) {},
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Referensi Jurusan',
                hintText: 'Misal: Teknik Sipil',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Referensi Kampus',
                hintText: 'Misal: Universitas Indonesia',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen()),
                );
              },
              icon: const Icon(
                Icons.lock,
                color: Colors.yellow,
              ),
              label: const Text(
                'Ganti Password',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 20),
                minimumSize:
                    const Size.fromHeight(50), // Make button full width
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle save action
              },
              child: const Text(
                'Simpan',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 20),
                minimumSize:
                    const Size.fromHeight(50), // Make button full width
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
