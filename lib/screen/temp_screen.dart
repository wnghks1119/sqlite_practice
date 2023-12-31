import 'package:flutter/material.dart';

import '../data_component/db_helper.dart';

class TextInputLaterScreen extends StatefulWidget {
  final DateTime selectedDate;

  const TextInputLaterScreen({super.key, required this.selectedDate});

  @override
  State<TextInputLaterScreen> createState() => _TextInputLaterScreenState();
}

class _TextInputLaterScreenState extends State<TextInputLaterScreen> {

  List<Map<String, dynamic>> _allData = [];
  bool _isLoading = true;

  void _refreshData() async {
    final data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _addData(year, month, day) async {
    await SQLHelper.createData(year, month, day, _descController.text);
    _refreshData();
  }

  Future<void> _updateData(year, month, day) async {
    await SQLHelper.updateData(year, month, day, _descController.text);
    _refreshData();
  }

  final TextEditingController _descController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "텍스트 입력 화면",
          ),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: TextField(
                  controller: _descController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    //filled: true,
                    //fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.redAccent),
                    ),
                    border: OutlineInputBorder(),
                    labelText: "1. 감사한 일",
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  // 버튼 클릭 시 입력했던 데이터가 저장될 수 있도록 함수 추가 (createData -> _addData)
                  onPressed: () {
                    _updateData(widget.selectedDate.year, widget.selectedDate.month, widget.selectedDate.day);

                    // Navigator.pop(context);
                    print("전체 데이터");
                    print(_allData);
                    print("Add Data");
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "저장",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
