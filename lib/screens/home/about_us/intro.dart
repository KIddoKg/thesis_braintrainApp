import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor: const Color(0xE6105601),
        title: const Text('Giới thiệu về BrainTrain'),
      ),
      body: Container(
        color: Colors.black,
        child: SingleChildScrollView(

          padding: const EdgeInsets.all(26.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bạn có thể xem BrainTrain một phòng tập thể dục cho bộ não của mình. Chúng tôi đã phát triển một bộ trò chơi rèn luyện nhận thức dựa trên cơ sở thần kinh học cùng với phương pháp chơi đơn giản, thú vị để nhắm đến đối tượng bệnh nhân Suy giảm nhận thức nhẹ (Mild Cognitive Impairment – MCI). Ở giai đoạn MCI, số lượng tế bào thần kinh chưa bị tổn thương đáng kể, các kết nối tế bào thần kinh vẫn được bảo toàn, nhiều vùng não vẫn chưa bị teo lại. Do triệu chứng suy giảm nhận thức của nhóm bệnh nhân này chưa ảnh hưởng đáng kể đến sinh hoạt hằng ngày, nên đa số người bệnh thường chủ quan hoặc không nhận ra được đây chính là bệnh. Vì thế quá trình từ MCI tiến đến sa sút trí tuệ của họ diễn ra rất nhanh, và sa sút trí tuệ chính là giai đoạn không thể chữa trị được nữa. Mời bạn tham gia cùng chúng tôi rèn luyện các chức năng nhận thức và ngăn chặn diễn tiến của MCI. BrainTrain mong muốn cung cấp cho bệnh nhân MCI một môi trường tập luyện mang tính khoa học cho cơ quan quan trọng nhất cơ thể.',
                style: TextStyle(color: Colors.white54,fontSize: 16.0, height: 1.5),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Truy cập trang web: ',
                style: TextStyle(color: Colors.white54,fontSize: 16.0, height: 1.5),
              ),
              Link(
                uri: Uri.parse(
                    'https://www.cognitivetrainingdat.org/studies-cognitive-training-benefits/'),
                target: LinkTarget.blank,
                builder: (BuildContext ctx, FollowLink? openLink) {
                  return TextButton(
                    onPressed: openLink,
                    child: const Text(
                      'https://www.cognitivetrainingdat.org/studies-cognitive-training-benefits/',
                      style: TextStyle(fontSize: 13.0, height: 1.5),
                    ),
                  );
                },
              ),
              const Text(
                'để khám phá thêm các công trình nghiên cứu khoa học đã chứng minh hiệu quả của việc rèn luyện nhận thức.',
                style: TextStyle(color: Colors.white54,fontSize: 16.0, height: 1.5),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Thích nghi',
                style: TextStyle(color: Colors.white,
                    fontSize:20, fontWeight: FontWeight.bold, height: 1.5),
              ),
              const Text(
                'Bạn càng rèn luyện nhiều, bạn càng tiến bộ. Rèn luyện mỗi ngày và liên tục sẽ đảm bảo bạn cải thiện các chức năng nhận thức của mình thông qua điểm số của các trò chơi qua từng ngày. Bạn có thể theo dõi biểu đồ về điểm để thấy rõ tiến trình rèn luyện của mình.',
                style: TextStyle(color: Colors.white54,fontSize: 16.0, height: 1.5),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Động lực',
                style: TextStyle(color: Colors.white,
                    fontSize:20, fontWeight: FontWeight.bold, height: 1.5),
              ),
              const Text(
                'Duy trì động lực là một yếu tố quan trọng trong quá trình cải thiện nhận thức. Vì thế, BrainTrain sẽ thúc đẩy bạn qua các mục tiêu dài hạn để bạn cố gắng đạt được.',
                style: TextStyle(color: Colors.white54,fontSize: 16.0, height: 1.5),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Thử thách',
                style: TextStyle(color: Colors.white,
                    fontSize:20, fontWeight: FontWeight.bold, height: 1.5),
              ),
              const Text(
                'Độ khó của trò chơi sẽ thích ứng với cấp độ khả năng từng cá nhân, kế hoạch tập luyện và độ khó linh hoạt sẽ thúc đẩy và đảm bảo bạn luôn được thử thách ở mức độ tối đa.',
                style: TextStyle(color: Colors.white54,fontSize: 16.0, height: 1.5),
              ),
              const  SizedBox(height: 16.0),
              const Text(
                'Thời gian',
                style: TextStyle(color: Colors.white,
                    fontSize:20, fontWeight: FontWeight.bold, height: 1.5),
              ),
              const Text(
                'Một buổi tập ngắn 15 – 30 phút cũng có thể giúp kích thích rất nhiều cho bộ não của bạn. Đó là lý do tại sao chúng tôi đã thêm chế độ nhắc nhở, có thể giúp bạn biến việc rèn luyện nhận thức trở thành một phần thói quen hằng ngày hoặc hằng tuần của bạn.',
                style: TextStyle(color: Colors.white54,fontSize: 16.0, height: 1.5),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Tiện lợi',
                style: TextStyle(color: Colors.white,
                    fontSize:20, fontWeight: FontWeight.bold, height: 1.5),
              ),
              const Text(
                  'Ứng dụng hỗ trợ cải thiện nhận thức và chất lượng cuộc sống cho bệnh nhân MCI thuộc nhiều vùng miền khác nhau (bao gồm thành thị và nông thôn) thông qua việc rèn luyện nhận thức tại nhà và chia sẻ kết quả đến bác sĩ. Đây là một phương pháp chi phí thấp cho các khu vực có bối cảnh kinh tế xã hội đa dạng, giúp giảm chi phí và khó khăn cho người lớn tuổi mắc MCI trong việc di chuyển thăm khám ở các bệnh viện lớn ở thành phố.',
                  style: TextStyle(color: Colors.white54,fontSize: 16.0, height: 1.5)),

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
