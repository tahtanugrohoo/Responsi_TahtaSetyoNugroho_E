import 'package:flutter/material.dart';
import 'package:keuangan/bloc/keuangan_bloc.dart';
import 'package:keuangan/widget/warning_dialog.dart';
import 'package:keuangan/model/keuangan.dart';
import 'package:keuangan/ui/keuangan_page.dart';

// ignore: must_be_immutable
class KeuanganForm extends StatefulWidget {
  Keuangan? keuangan;
  KeuanganForm({super.key, this.keuangan});

  @override
  _KeuanganFormState createState() => _KeuanganFormState();
}

class _KeuanganFormState extends State<KeuanganForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH KEUANGAN";
  String tombolSubmit = "SIMPAN";
  final _itemKeuanganTextboxController = TextEditingController();
  final _allocatedKeuanganTextboxController = TextEditingController();
  final _spentKeuanganTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  void isUpdate() {
    if (widget.keuangan != null) {
      setState(() {
        judul = "UBAH KEUANGAN";
        tombolSubmit = "UBAH";
        _itemKeuanganTextboxController.text =
            widget.keuangan!.itemKeuangan ?? '';
        _allocatedKeuanganTextboxController.text =
            widget.keuangan!.allocatedKeuangan?.toString() ?? '';
        _spentKeuanganTextboxController.text =
            widget.keuangan!.spentKeuangan?.toString() ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          judul,
          style: const TextStyle(fontFamily: 'Verdana'),
        ),
        backgroundColor: _rainbowColor(0),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),
                _itemKeuanganTextField(),
                const SizedBox(height: 20),
                _allocatedKeuanganTextField(),
                const SizedBox(height: 20),
                _spentKeuanganTextField(),
                const SizedBox(height: 30),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemKeuanganTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Item Keuangan",
        labelStyle: const TextStyle(fontFamily: 'Verdana'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _itemKeuanganTextboxController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Item Keuangan harus diisi";
        }
        return null;
      },
    );
  }

  Widget _allocatedKeuanganTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Allocated Keuangan",
        labelStyle: const TextStyle(fontFamily: 'Verdana'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      keyboardType: TextInputType.number,
      controller: _allocatedKeuanganTextboxController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Allocated Keuangan harus diisi";
        }
        if (int.tryParse(value) == null) {
          return "Allocated Keuangan harus berupa angka";
        }
        return null;
      },
    );
  }

  Widget _spentKeuanganTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Spent Keuangan",
        labelStyle: const TextStyle(fontFamily: 'Verdana'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      keyboardType: TextInputType.number,
      controller: _spentKeuanganTextboxController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Spent Keuangan harus diisi";
        }
        if (int.tryParse(value) == null) {
          return "Spent Keuangan harus berupa angka";
        }
        return null;
      },
    );
  }

  Widget _buttonSubmit() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        backgroundColor: _rainbowColor(3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(
              tombolSubmit,
              style: const TextStyle(fontFamily: 'Verdana', fontSize: 18),
            ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          if (!_isLoading) {
            if (widget.keuangan != null) {
              ubah();
            } else {
              simpan();
            }
          }
        }
      },
    );
  }

  void simpan() {
    setState(() {
      _isLoading = true;
    });

    Keuangan createKeuangan = Keuangan(id: null);
    createKeuangan.itemKeuangan = _itemKeuanganTextboxController.text;
    createKeuangan.allocatedKeuangan =
        int.tryParse(_allocatedKeuanganTextboxController.text);
    createKeuangan.spentKeuangan =
        int.tryParse(_spentKeuanganTextboxController.text);

    KeuanganBloc.addKeuangan(keuangan: createKeuangan).then((value) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const KeuanganPage()));
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
                description: "Simpan gagal, silahkan coba lagi",
              ));
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void ubah() {
    setState(() {
      _isLoading = true;
    });

    Keuangan updateKeuangan = Keuangan(id: widget.keuangan!.id!);
    updateKeuangan.itemKeuangan = _itemKeuanganTextboxController.text;
    updateKeuangan.allocatedKeuangan =
        int.tryParse(_allocatedKeuanganTextboxController.text);
    updateKeuangan.spentKeuangan =
        int.tryParse(_spentKeuanganTextboxController.text);

    KeuanganBloc.updateKeuangan(keuangan: updateKeuangan).then((value) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const KeuanganPage()));
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
                description: "Permintaan ubah data gagal, silahkan coba lagi",
              ));
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
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
