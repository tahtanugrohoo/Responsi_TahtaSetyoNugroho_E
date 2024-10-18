import 'package:flutter/material.dart';
import 'package:keuangan/bloc/logout_bloc.dart';
import 'package:keuangan/bloc/keuangan_bloc.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/ui/keuangan_detail.dart';
import 'package:keuangan/ui/keuangan_form.dart';
import 'package:keuangan/ui/login_page.dart';

class KeuanganPage extends StatefulWidget {
  const KeuanganPage({super.key});

  @override
  _KeuanganPageState createState() => _KeuanganPageState();
}

class _KeuanganPageState extends State<KeuanganPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'List Keuangan',
          style: TextStyle(fontFamily: 'Verdana'),
        ),
        backgroundColor: _rainbowColor(0),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KeuanganForm()),
                );
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text(
                'Logout',
                style: TextStyle(fontFamily: 'Verdana'),
              ),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                await LogoutBloc.logout().then((value) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                });
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Keuangan>>(
        future: KeuanganBloc.getKeuangan(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(
              child: Text(
                "Error loading data",
                style: TextStyle(fontFamily: 'Verdana'),
              ),
            );
          }
          return snapshot.hasData
              ? ListKeuangan(list: snapshot.data!)
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Color _rainbowColor(int index) {
    List<Color> rainbowColors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
    ];
    return rainbowColors[index % rainbowColors.length];
  }
}

class ListKeuangan extends StatelessWidget {
  final List<Keuangan> list;

  const ListKeuangan({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ItemKeuangan(keuangan: list[index]);
      },
    );
  }
}

class ItemKeuangan extends StatelessWidget {
  final Keuangan keuangan;

  const ItemKeuangan({super.key, required this.keuangan});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KeuanganDetail(keuangan: keuangan),
          ),
        );
      },
      child: Card(
        color: _rainbowColor(keuangan.id! % 7),
        child: ListTile(
          title: Text(
            keuangan.itemKeuangan ?? 'Unknown',
            style: const TextStyle(
              fontFamily: 'Verdana',
              fontSize: 18.0,
            ),
          ),
          subtitle: Text(
            'Allocated: ${keuangan.allocatedKeuangan?.toString() ?? '0'}, Spent: ${keuangan.spentKeuangan?.toString() ?? '0'}',
            style: const TextStyle(fontFamily: 'Verdana', fontSize: 14.0), // Custom font
          ),
          trailing: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }

  Color _rainbowColor(int index) {
    List<Color> rainbowColors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
    ];
    return rainbowColors[index % rainbowColors.length];
  }
}
