import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:artoku/bloc/blockapster.dart';
import 'package:artoku/fintness_app_theme.dart';
import 'package:artoku/main.dart';
import 'package:artoku/models/kapstermodel.dart';
import 'package:artoku/ui_view/masterdata/input_kapster.dart';
import 'package:artoku/ui_view/template/frxappbar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Kapster extends StatefulWidget {
  @override
  _KapsterState createState() => _KapsterState();
}

class _KapsterState extends State<Kapster> {
  List<kapster> listkps;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyApp(
                      tab_id: 1,
                    )));
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<Getkapster>(create: (context) => Getkapster(listkps)),
          BlocProvider<Deletekapster>(create: (context) => Deletekapster(0)),
        ],
        child: Scaffold(
          backgroundColor: FitnessAppTheme.tosca,
          appBar: FrxAppBar("Pegawai", backroute: "/masterdata"),
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              size: 30,
              color: FitnessAppTheme.darkText,
            ),
            backgroundColor: FitnessAppTheme.yellow,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => InputKapster()));
            },
          ),
          body:
              Padding(padding: const EdgeInsets.all(5.0), child: Kapsterlist()),
        ),
      ),
    );
  }
}

class Kapsterlist extends StatefulWidget {
  @override
  _KapsterlistState createState() => _KapsterlistState();
}

class _KapsterlistState extends State<Kapsterlist> {
  TextEditingController txtcari = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () {
      Getkapster bloc = BlocProvider.of<Getkapster>(context);
      bloc.add("");
    });
  }

  @override
  Widget build(BuildContext context) {
    Getkapster bloc = BlocProvider.of<Getkapster>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
            color: FitnessAppTheme.white,
            child: TextFormField(
              controller: txtcari,
              style: TextStyle(fontSize: 20.0, color: Colors.black),
              decoration: InputDecoration(
                  hintText: "Cari Pegawai ",
                  prefixIcon: Icon(
                    Icons.search,
                    color: FitnessAppTheme.tosca,
                  )),
              onChanged: (val) {
                Future.delayed(Duration(milliseconds: 500), () {
                  bloc.add(val);
                });
              },
            )),
        Expanded(
          child: BlocBuilder<Getkapster, List<kapster>>(
              builder: (context, datakps) => ListView.builder(
                  itemCount: (datakps != null) ? datakps.length : 0,
                  itemBuilder: (context, idx) {
                    return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        elevation: 0,
                        color: FitnessAppTheme.white,
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: ListTile(
                            title: Text(datakps[idx].kapster_nama,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 20)),
                            subtitle: Text(
                              (datakps[idx].kapster_alamat != null)
                                  ? datakps[idx].kapster_alamat
                                  : "",
                              style: TextStyle(
                                  fontSize: 14, color: FitnessAppTheme.grey),
                            ),
                            trailing: Text(datakps[idx].kapster_hp.toString(),
                                style: TextStyle(fontSize: 16)),
                          ),
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'Edit',
                              color: FitnessAppTheme.yellow,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => InputKapster(
                                              editPlg: datakps[idx],
                                            )));
                              },
                            ),
                            IconSlideAction(
                                caption: 'Share',
                                color: Colors.red[900],
                                icon: Icons.delete_outline_rounded,
                                onTap: () async {
                                  AlertDialog delKat = AlertDialog(
                                    title: Text(
                                        "Hapus Kategori ${datakps[idx].kapster_nama}"),
                                    content:
                                        DeleteConfrimationKapster(datakps[idx]),
                                  );
                                  final del = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return BlocProvider<
                                            Deletekapster>.value(
                                          value: Deletekapster(0),
                                          child: delKat,
                                        );
                                      });
                                  if (del) {
                                    Getkapster bloc =
                                        BlocProvider.of<Getkapster>(context);
                                    bloc.add("");
                                  }
                                }),
                          ],
                        ));
                  })),
        ),
      ],
    );
  }
}

class DeleteConfrimationKapster extends StatefulWidget {
  final kapster delPlg;
  DeleteConfrimationKapster(this.delPlg);
  @override
  _DeleteConfrimationKapsterState createState() =>
      _DeleteConfrimationKapsterState();
}

class _DeleteConfrimationKapsterState extends State<DeleteConfrimationKapster> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              "Anda yakin ingin menghapus Kapster : \n${widget.delPlg.kapster_nama} ?"),
          Padding(
            padding: EdgeInsets.all(10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  color: FitnessAppTheme.tosca,
                  child: Text(
                    "Tidak",
                    style:
                        TextStyle(fontSize: 18.0, color: FitnessAppTheme.white),
                  )),
              FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  color: FitnessAppTheme.redtext,
                  onPressed: () {
                    Deletekapster remover =
                        BlocProvider.of<Deletekapster>(context);
                    remover.add(widget.delPlg.kapster_id);
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    "Ya, Hapus",
                    style:
                        TextStyle(fontSize: 18.0, color: FitnessAppTheme.white),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
