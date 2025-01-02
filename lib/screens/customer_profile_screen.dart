import 'package:flutter/material.dart';

class CustomerProfile extends StatelessWidget {
  const CustomerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hồ sơ người dùng'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
              width: 300,
              child: Card(
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.yellow,
                        backgroundImage:
                            NetworkImage('https://picsum.photos/200/200'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text('Tên người dùng',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        const Icon(Icons.email),
                        const SizedBox(
                          height: 8,
                        ),
                        Text('Email: examples@gmail.com'),
                      ]),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        const Icon(Icons.phone),
                        const SizedBox(
                          height: 8,
                        ),
                        Text('Phone: 0123456789'),
                      ]),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
