import 'package:flutter/material.dart';
import 'package:keuangan/bloc/keuangan_bloc.dart';
import 'package:keuangan/widget/warning_dialog.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/ui/keuangan_form.dart';
import 'package:keuangan/ui/keuangan_page.dart';

// ignore: must_be_immutable
class KeuanganDetail extends StatefulWidget {
  Keuangan? keuangan;

  KeuanganDetail({super.key, this.keuangan});

  @override
  _KeuanganDetailState createState() => _KeuanganDetailState();
}

class _KeuanganDetailState extends State<KeuanganDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Keuangan'),
        backgroundColor: _rainbowColor(0),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Item : ${widget.keuangan!.itemKeuangan}",
              style: const TextStyle(
                fontSize: 20.0,
                fontFamily: 'Verdana',
                color: Colors.black,
              ),
            ),
            Text(
              "Allocated : ${widget.keuangan!.allocatedKeuangan}",
              style: const TextStyle(
                fontSize: 18.0,
                fontFamily: 'Verdana',
                color: Colors.black,
              ),
            ),
            Text(
              "Spent : Rp. ${widget.keuangan!.spentKeuangan}",
              style: const TextStyle(
                fontSize: 18.0,
                fontFamily: 'Verdana',
                color: Colors.black,
              ),
            ),
            _tombolHapusEdit()
          ],
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceEvenly,
      children: [
        // Tombol Edit
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: _rainbowColor(1),
          ),
          child: const Text(
            "EDIT",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Verdana',
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KeuanganForm(
                  keuangan: widget.keuangan!,
                ),
              ),
            );
          },
        ),
        // Tombol Hapus
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: _rainbowColor(2),
          ),
          child: const Text(
            "DELETE",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Verdana',
            ),
          ),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text(
        "Yakin ingin menghapus data ini?",
        style: TextStyle(fontFamily: 'Verdana'),
      ),
      actions: [
        //tombol hapus
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () {
            KeuanganBloc.deleteKeuangan(id: widget.keuangan!.id!).then(
                (value) => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const KeuanganPage()))
                    }, onError: (error) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => const WarningDialog(
                        description: "Hapus gagal, silahkan coba lagi",
                      ));
            });
          },
        ),
        //tombol batal
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );

    showDialog(builder: (context) => alertDialog, context:context);
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
