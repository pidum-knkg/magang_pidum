import 'package:flutter/material.dart';
import 'package:magang_pidum/services/api_service.dart';

String transformTahapToString(Tahap? tahap) {
  if (tahap == null) return "-- s.d --";
  return "${tahap.start.year}-${tahap.start.month}-${tahap.start.day} s.d ${tahap.end.year}-${tahap.end.month}-${tahap.end.day}";
}

class PerkaraView extends StatefulWidget {
  const PerkaraView({
    super.key,
    required this.belumLimpah,
  });

  final BelumLimpah belumLimpah;

  @override
  State<PerkaraView> createState() => _PerkaraViewState();
}

class _PerkaraViewState extends State<PerkaraView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Perkara"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Table(
          border: const TableBorder(
            horizontalInside: BorderSide(
              width: .5,
              color: Colors.black45,
            ),
          ),
          columnWidths: const {
            0: IntrinsicColumnWidth(),
            1: IntrinsicColumnWidth(),
            2: FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.top,
          children: [
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Terdakwa",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    " : ",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.bottom,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(widget.belumLimpah.terdakwa),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "JPU",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    " : ",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.bottom,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                        widget.belumLimpah.jpu.map((e) => e.nama).join(' / ')),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "PDM",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    " : ",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.bottom,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(widget.belumLimpah.pdm),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "T7",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    " : ",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.bottom,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(transformTahapToString(widget.belumLimpah.t7)),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "T6",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    " : ",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.bottom,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(transformTahapToString(widget.belumLimpah.t6)),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "DITAHAN",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    " : ",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.bottom,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(widget.belumLimpah.ditahan),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "ASAL PERKARA",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    " : ",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.bottom,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(widget.belumLimpah.asalPerkara),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "PASAL",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    " : ",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.bottom,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(widget.belumLimpah.pasal),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "STATUS BB",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    " : ",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.bottom,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child:
                        Text(widget.belumLimpah.statusBarangBukti.toString()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
