import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart';

class FuncScreen extends StatefulWidget {
  const FuncScreen({Key? key}) : super(key: key);

  @override
  _FuncScreenState createState() => _FuncScreenState();
}

class _FuncScreenState extends State<FuncScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:const  Color(0xE62BD9D3),
        title: const Text(
          'Chức năng nhận thức',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: const SingleChildScrollView(
          padding: EdgeInsets.all(26.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Các trò chơi trong ứng dụng BrainTrain sẽ rèn luyện các chức năng nhận thức sau:',
                style: TextStyle(
                    color: Colors.white54, fontSize: 16.0, height: 1.5),
              ),
              SizedBox(height: 16.0),
              Text(
                'Trí nhớ',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.5),
              ),
              Text(
                'Trí nhớ là quá trình lưu trữ nhiều loại thông tin mà sau đó bạn có thể nhớ lại. Có nhiều loại hệ thống lưu trữ bộ nhớ khác nhau, ví dụ như: Trí nhớ dài hạn lưu trữ thông tin trong nhiều ngày, nhiều tuần, nhiều tháng, và thậm chí nhiều năm. Mặt khác, Trí nhớ ngắn hạn chỉ cho phép lưu trữ một lượng thông tin nhất định trong một khoảng thời gian ngắn. Loại trí nhớ ngắn hạn này liên quan trực tiếp đến trí nhớ dài hạn và chúng hoạt động như một cánh cửa dẫn chúng ta đến trí nhớ dài hạn, vì thế, bất kì tổn thương nào đối với trí nhớ ngắn hạn đều ảnh hưởng đến việc thu nhận những ký ức mới vào trí nhớ dài hạn.',
                style: TextStyle(
                    color: Colors.white54, fontSize: 16.0, height: 1.5),
              ),
              SizedBox(height: 16.0),
              Text(
                'BrainTrain đã thiết kế các trò chơi để giúp bạn rèn luyện và cải thiện trí nhớ ngắn hạn dựa trên khoa học về tính dẻo dai của thần kinh. Nếu bạn thường xuyên rèn luyện trí nhớ ngắn hạn, bộ não và các kết nối thần kinh của bạn sẽ trở nên mạnh mẽ và hiệu quả hơn (giống như cơ bắp của cơ thể',
                style: TextStyle(
                    color: Colors.white54, fontSize: 16.0, height: 1.5),
              ),
              SizedBox(height: 16.0),
              Text(
                'Tập trung',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.5),
              ),
              Text(
                'Sự tập trung bao gồm khả năng dựa trên năng lực chú ý của bản thân. BrainTrain sẽ cung cấp các bài tập nhắm vào khả năng chú ý có chọn lọc và khả năng chú ý khi bị phân tâm. Rèn luyện các bài tập này thường xuyên sẽ giúp bạn hoàn thành các tác vụ, hoạt động hằng ngày một cách dễ dàng và nhanh chóng, ngay cả có những tình huống trong cuộc sống đòi hỏi bạn phải thực hiện đồng thời hai hoặc nhiều nhiệm vụ cùng lúc.',
                style: TextStyle(
                    color: Colors.white54, fontSize: 16.0, height: 1.5),
              ),
              SizedBox(height: 16.0),
              Text(
                'Ngôn ngữ',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.5),
              ),
              Text(
                'Ngôn ngữ là một trong những chức năng cơ bản làm nền tảng cho khả năng giao tiếp. Bộ não người có một số vùng chuyên biệt giúp xử lý việc học và giao tiếp bằng lời nói. Tuy nhiên, các vùng não này có thể bị suy giảm ở bệnh nhân MCI, khiến họ gặp khó khăn trong việc nhớ lại các từ và tìm từ vựng chính xác để chia sẻ những gì họ muốn nói. Nếu không được can thiệp kịp thời, tình trạng này sẽ dẫn đến mất khả năng diễn đạt lưu loát bằng lời nói. Do đó, ứng dụng BrainTrain đã có các trò chơi ngôn ngữ giúp luyện tập việc nhớ lại đúng từ ngữ vào đúng thời điểm và vượt qua khó khăn trong giao tiếp để kết nối tốt hơn với bác sĩ và người chăm sóc trong các cuộc trò chuyện về bệnh tật của người bệnh. Cùng với việc làm giàu vốn từ vựng, trò chơi còn nâng cao năng lực nhận thức thông qua việc phát triển khả năng tập trung và óc sáng tạo.',
                style: TextStyle(
                    color: Colors.white54, fontSize: 16.0, height: 1.5),
              ),
              SizedBox(height: 16.0),
              Text(
                'Toán học',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.5),
              ),
              Text(
                'Các trò chơi về toán được đánh giá như một phương pháp làm chậm tiến trình suy giảm nhận thức. Đồng thời, chúng cũng thúc đẩy cải thiện khả năng suy nghĩ để giải quyết vấn đề và đưa ra quyết định cho các nhiệm vụ cụ thể của người bệnh.',
                style: TextStyle(
                    color: Colors.white54, fontSize: 16.0, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
