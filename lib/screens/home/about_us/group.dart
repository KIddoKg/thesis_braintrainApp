import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({Key? key}) : super(key: key);

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:const  Color(0xE6C50126),
        title: const Text('Nhóm nghiên cứu'),
      ),
      body: Container(
        color: Colors.black,
        child: Container(

          padding: const EdgeInsets.all(26.0),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Đây là một dự án nghiên cứu của phòng thí nghiệm Sức khỏe Não bộ (Brain Health Lab) của Khoa Kỹ thuật Y Sinh, Trường Đại học Quốc Tế – Đại Học Quốc Gia TP. HCM hợp tác cùng Bệnh viện Quân Y 175. Phần mềm được phát triển bởi Nhóm Sinh viên Khoa Công nghệ Thông tin, Trường Đại học Quốc tế - ĐHQG HCM.',
                style: TextStyle(
                    color: Colors.white54, fontSize: 16.0, height: 1.5),
              ),
              SizedBox(height: 16.0),
              Text(
                'Dự án được thử nghiệm tại Khoa Nội thần kinh, Bệnh viện Quân Y 175.',
                style: TextStyle(
                    color: Colors.white54, fontSize: 16.0, height: 1.5),
              ),
              SizedBox(height: 16.0),
              Text(
                'Dự án được tài trợ bởi Công ty Cổ phần IVS và Công ty Cổ phần ITR VN.',
                style: TextStyle(
                    color: Colors.white54, fontSize: 16.0, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

}