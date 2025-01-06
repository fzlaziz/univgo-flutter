import 'package:flutter/material.dart';

class BuatUlasanPage extends StatefulWidget {
  final Function(String, int, String) tambahUlasan;
  final Map<String, dynamic>? initialData;

  const BuatUlasanPage({
    super.key,
    required this.tambahUlasan,
    this.initialData,
  });

  @override
  _BuatUlasanPageState createState() => _BuatUlasanPageState();
}

class _BuatUlasanPageState extends State<BuatUlasanPage> {
  late TextEditingController _ulasanController;
  late int _rating;

  @override
  void initState() {
    super.initState();
    _ulasanController =
        TextEditingController(text: widget.initialData?['ulasan'] ?? '');
    _rating = widget.initialData?['rating'] ?? 0;
  }

  void _kirimUlasan() {
    if (_ulasanController.text.isNotEmpty && _rating > 0) {
      widget.tambahUlasan('Nama Anda', _rating, _ulasanController.text);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap isi ulasan dan pilih rating!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.initialData != null ? 'Ubah Ulasan' : 'Buat Ulasan',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        backgroundColor: const Color(0xFF0059FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture dan Nama Pengguna
            const Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    'https://www.example.com/path/to/your/profile-image.jpg',
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'fufufafa', // Ganti dengan nama pengguna yang sesungguhnya
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Teks mengenai ulasan public
            const Text(
              'Ulasan Anda akan bersifat public beserta dengan nama akun Anda',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),

            // Rating Section
            const Text(
              'Rating Anda',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: Icon(
                    Icons.star,
                    color: _rating > index ? Colors.yellow : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // TextField untuk menulis ulasan
            const Text(
              'Tulis Ulasan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _ulasanController,
              maxLines: 5,
              maxLength: 250,
              decoration: const InputDecoration(
                hintText: 'Tulis ulasan Anda di sini...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Tombol Post
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _kirimUlasan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0059FF),
                ),
                child:
                    const Text('Post', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SemuaUlasanPage extends StatefulWidget {
  final List<Map<String, dynamic>> ulasan;
  final List<Map<String, dynamic>> ulasanSaya;
  final Function(String, int, String) tambahUlasan;

  const SemuaUlasanPage({
    super.key,
    required this.ulasan,
    required this.ulasanSaya,
    required this.tambahUlasan,
  });

  @override
  _SemuaUlasanPageState createState() => _SemuaUlasanPageState();
}

class _SemuaUlasanPageState extends State<SemuaUlasanPage> {
  @override
  Widget build(BuildContext context) {
    double avgRating = widget.ulasan
            .fold(0, (sum, item) => sum + item['rating'] as int)
            .toDouble() /
        widget.ulasan.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Ulasan'),
        backgroundColor: const Color(0xFF0059FF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.ulasanSaya.isNotEmpty) ...[
              const Text(
                'Ulasan Kamu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.ulasanSaya.length,
                itemBuilder: (context, index) {
                  final ulasanItem = widget.ulasanSaya[index];
                  return _buildUlasanItem(ulasanItem);
                },
              ),
              const SizedBox(height: 16),
            ],
            if (widget.ulasan.isNotEmpty) ...[
              const Text(
                'Ulasan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    avgRating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Icon(Icons.star, color: Colors.yellow, size: 14),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.ulasan.length} ulasan',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.ulasan.length,
                itemBuilder: (context, index) {
                  final ulasanItem = widget.ulasan[index];
                  return _buildUlasanItem(ulasanItem);
                },
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final isUlasanSayaNotEmpty = widget.ulasanSaya.isNotEmpty;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BuatUlasanPage(
                tambahUlasan: (nama, rating, ulasanBaru) {
                  if (isUlasanSayaNotEmpty) {
                    final lastIndexSaya = widget.ulasanSaya.length - 1;

                    if (lastIndexSaya >= 0) {
                      // Cari indeks ulasan di list `ulasan` berdasarkan konten
                      final lastUlasanSaya = widget.ulasanSaya[lastIndexSaya];
                      final indexInUlasan = widget.ulasan.indexWhere((item) =>
                          item['nama'] == lastUlasanSaya['nama'] &&
                          item['rating'] == lastUlasanSaya['rating'] &&
                          item['ulasan'] == lastUlasanSaya['ulasan']);

                      if (indexInUlasan != -1) {
                        setState(() {
                          widget.ulasanSaya[lastIndexSaya] = {
                            'nama': nama,
                            'rating': rating,
                            'ulasan': ulasanBaru,
                          };
                          widget.ulasan[indexInUlasan] =
                              widget.ulasanSaya[lastIndexSaya];
                        });
                      }
                    }
                  } else {
                    widget.tambahUlasan(nama, rating, ulasanBaru);
                  }
                },
                initialData:
                    isUlasanSayaNotEmpty ? widget.ulasanSaya.last : null,
              ),
            ),
          );
        },
        backgroundColor: const Color(0xFF0059FF),
        icon: const Icon(Icons.edit, color: Colors.white),
        label: Text(
          widget.ulasanSaya.isNotEmpty ? 'Ubah Ulasan' : 'Buat Ulasan',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildUlasanItem(Map<String, dynamic> ulasanItem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 25,
              child: Icon(Icons.person, size: 35),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ulasanItem['nama'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Row(
                    children: List.generate(
                      ulasanItem['rating'],
                      (index) => const Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          ulasanItem['ulasan'],
          style: const TextStyle(fontSize: 12, color: Colors.black),
        ),
        const SizedBox(height: 5),
        const Divider(thickness: 1, color: Colors.grey),
        const SizedBox(height: 16),
      ],
    );
  }
}
