// Question model

class Question {
  String? qid;
  String? question;
  List<String>? options;
  String? answser;
  String? department;
  String? module;
  String? course;
  String? image;

  Question({
    this.qid,
    this.question,
    this.options,
    this.department,
    this.module,
    this.course,
    this.image,
  });
}
