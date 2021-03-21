import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:vistima_00/model/model.dart';
import 'package:vistima_00/pages/TimingPage/TimingNotifier.dart';
import 'package:vistima_00/viewmodel/taskViewModel.dart';
import 'package:zefyr/zefyr.dart';

class NoteEditorPage extends StatefulWidget {
  final Task task;
  final TasksNotifier tasksNotifier;
  final TimingNotifier timingNotifier;
  final bool isTiming;

  NoteEditorPage(
      {@required this.task,
      @required this.tasksNotifier,
      this.isTiming = false,
      this.timingNotifier});

  @override
  NoteEditorPageState createState() => NoteEditorPageState();
}

class NoteEditorPageState extends State<NoteEditorPage> {
  ZefyrController _controller;

  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _loadDocument().then((document) {
      setState(() {
        _controller = ZefyrController(document);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget body = (_controller == null)
        ? Center(child: CircularProgressIndicator())
        : ZefyrScaffold(
            child: ZefyrEditor(
              padding: EdgeInsets.all(16),
              controller: _controller,
              focusNode: _focusNode,
            ),
          );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // elevation: 0.5,
        title: Text("${widget.task.title} - Note"),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.save),
              onPressed: () => _saveDocument(context),
            ),
          )
        ],
      ),
      body: body,
    );
  }

  Future<NotusDocument> _loadDocument() async {
    if (widget.task.note != null) {
      return NotusDocument.fromJson(jsonDecode(widget.task.note));
    }
    return NotusDocument();
  }

  void _saveDocument(BuildContext context) {
    final contents = jsonEncode(_controller.document);
    widget.task.note = contents;
    LogUtil.e('>>>save:${widget.task.note}', tag: "NoteEditor");
    Navigator.pop(context);
  }
}
