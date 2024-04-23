// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:developer';

import 'package:brain_train_app/shared/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../models/user_model.dart';
import '../../../helper/appsetting.dart';
import '../../../services/services.dart';
import '../../../shared/light_colors.dart';
import '../../../shared/share_widgets.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  bool passTwo = false;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    //print(UserModel.instance.passwordTwo);
    if(UserModel.instance.passwordTwo.isEmpty){
      passTwo = false;
      UserModel.instance.passwordTwo = "";
      setState(() {

      });
    }else{
      passTwo = true;
    }
  }

  Future<void> savePassTwo(String code) async {
    var res = await Services.instance.updateUser(code);
    if(res != false){
      passTwo = true;
      UserModel.instance.passwordTwo = code;
      setState(() {
      });
      //print("object");
    }
  }

  String  getFormattedDOBFromJson(dynamic dobJson) {
    String dobString ="";
    if(dobJson is String){
      dobString = dobJson;
    }else{
      //print(dobJson);
      DateTime dob = DateTime(dobJson[0], dobJson[1], dobJson[2]);

      // Format the DateTime object as a string
      dobString =
          "${dob.year}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}";
      //print(dobString);
    }
    return dobString;
  }
  Widget accountAppBar(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: height * .2),
      child: Container(
        color: AppColors.primaryColor,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AvatarLoad(
                UserModel.instance.profileUrl != ""
                    ? "assets/avatar.png"
                    : UserModel.instance.profileUrl,
                editAvatar: true,
                // size: 45,
                onPickerImage: (pathImage) {
                  UserModel.instance.profileUrl = pathImage;
                  UserModel.instance.save();
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 8,
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      UserModel.instance!.name!,
                      style: const TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const VerticalDivider(
                      width: 15,
                      color: Colors.white,
                      thickness: 1,
                    ),
                    Text(
                      UserModel.instance.phone,
                      style: const TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:  AppColors.primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColorBlack,
        centerTitle: true,
        title: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 200,
                height: 50,
                child: Marquee(
                    text: "Cài đặt",
                    scrollAxis: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    blankSpace: 50.0,
                    velocity: 25.0,
                    style: const TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        letterSpacing: 0.53)),
              ),
            ],
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(50),
          ),
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100.0),
            child: Column(
              children: [

                Text(
                  "${UserModel.instance.name}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                const SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      SizedBox(
                        width: MediaQuery.of(context).size.width/3-30,
                        child: Column(
                          children: [
                            const Center(
                              child: Text(
                                "SĐT", style: TextStyle(
                                  fontSize: 16, color: Colors.white),),
                            ), Center(
                              child:SizedBox(
                                width: MediaQuery.of(context).size.width/3-50,
                                height: 30,
                                child: Marquee(
                                    text: UserModel.instance.phone,
                                    scrollAxis: Axis.horizontal,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    blankSpace: 50.0,
                                    velocity: 25.0,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        letterSpacing: 0.53)),
                              ),                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width/3-30,
                        child: const Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 21,
                                backgroundColor: Color(0xff37EBBC),
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundImage: AssetImage(
                                    "assets/avatar.png",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width/3-30,
                        child: Column(
                          children: [
                            const  Center(
                              child: Text(
                                "Tuổi", style: TextStyle(
                                  fontSize: 16, color: Colors.white),),
                            ), Center(
                              child: SizedBox(
                                height: 30,
                                child: Text("${UserModel.instance.age}", style:const  TextStyle(
                                    fontSize: 16, color: Colors.white),),
                              ),
                            )
                          ],
                        ),
                      )
                    ],),
                ),

              ],
            )),
      ),
      body: CustomScrollView(
        slivers: [
          // SliverToBoxAdapter(
          //   child: accountAppBar(context),
          // ),
          SliverToBoxAdapter(
            child: Container(height: 8),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 58.0, right: 8, left: 8),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 16, bottom: 16, left: 16, right: 16.0),
                      child: Column(
                        children: [
                          ExpansionTile(
                            leading: const Icon(
                              Icons.person_pin,
                              // color: GlobalStyles.primaryColor,
                            ),
                            tilePadding:
                                const EdgeInsets.symmetric(vertical: -0),
                            title: Container(
                                alignment: const Alignment(-1.25, 1),
                                child: const Text('Thông tin cá nhân')),
                            children: [
                              UserRowText(
                                'Tên người dùng',
                                UserModel.instance.name!,
                                styleValue: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              UserRowText(
                                'Giới tính',
                                UserModel.instance.gender == "MALE" ? "NAM" : UserModel.instance.gender == "FEMALE" ? "NỮ" :"",
                                styleValue: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              UserRowText(
                                'Ngày sinh',
                                getFormattedDOBFromJson(UserModel.instance.dob),
                                styleValue: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          ExpansionTile(

                            // textColor: AppColors.primaryColor,
                            tilePadding: EdgeInsets.zero,
                            leading: const Icon(Icons.notifications),
                            title: Container(
                                alignment: const Alignment(-1.25, 1),
                                child: const Text('Cài đặt thông báo')),
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  UserRow(
                                    height: 28,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    title: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Cho phép hiển thị thông báo',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    child: Switch(
                                      value: true,
                                      onChanged: (value) async {},
                                    ),
                                  ),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Việc cho phép hiển thị thông báo, app sẽ giúp nhắc nhở bạn luyện tập hàng ngày',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  )
                                ],
                              ),
                            ],
                          ),
                          ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            // childrenPadding: const EdgeInsets.all(8),
                            leading: const Icon(Icons.security),
                            title: Container(
                                alignment: const Alignment(-1.15, 1),
                                child: const Text('Cài đặt bảo mật')),
                            children: [
                              SwitchListTile(
                                  contentPadding: const EdgeInsets.only(
                                      left: 0, right: 0, top: 0, bottom: 8),
                                  title:
                                      const Text('Sử dụng mã đăng khoá 2 lớp'),
                                  subtitle: const Text(
                                      'Việc cài đặt mã khoá này sẽ giúp đảm bảo số luyện không bị sai lệch nếu như có trẻ em vô tình mở app.'),
                                  value: passTwo,
                                  onChanged: (value) {

                                    if(passTwo == false){
                                      screenLockCreate(
                                        context: context,
                                        title: const Text('Nhập mật khẩu cấp hai'),
                                        confirmTitle: const Text('Nhập lại mật khẩu cấp hai'),
                                        onConfirmed: (value){
                                          savePassTwo(value);
                                           Navigator.of(context).pop();
                                      },

                                        cancelButton: const Icon(Icons.close),
                                        deleteButton: const Icon(Icons.delete),
                                      );
                                    }else{
                                      savePassTwo("");
                                      passTwo = false;
                                    }
                                    setState(() {

                                    });
                                  }),



                            ],
                          ),
                          ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            leading: const Icon(Icons.privacy_tip),
                            title: Container(
                                alignment: const Alignment(-1.15, 1),
                                child: const Text('Về chúng tôi')),
                            children: [
                              Visibility(
                                visible: true,
                                child: ListTile(
                                  title: const Text('Giới thiệu về BrainTrain'),
                                  onTap: () {
                                    showPopupInfoOne(context);
                                  },
                                ),
                              ),
                              Visibility(
                                visible: true,
                                child: ListTile(
                                  title: const Text('Chức năng nhận thức'),
                                  onTap: () {showPopupInfoTwo(context);},
                                ),
                              ),
                              Visibility(
                                visible: true,
                                child: ListTile(
                                  title: const Text('Nhóm nghiên cứu'),
                                  onTap: () {showPopupInfoThree(context);},
                                ),
                              )
                            ],
                          ),
                          ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            leading: const Icon(Icons.security_update_good),
                            title: Container(
                                alignment: const Alignment(-1.25, 1),
                                child: const Text('Phiên bản ứng dụng')),
                            // subtitle: Text(AppSetting.instance.version),
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "1.0.0.1",
                                        style:
                                            TextStyle(color: Colors.grey),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () {
                                showAlert(
                                    context, 'Thông báo', 'Bạn có muốn xoá tài khoản ? Tài khoản của bạn sẽ được xoá sau 24h nếu được quản trị viên chấp nhận. Nếu có sai sót hãy liên hệ với chúng tôi.',
                                    actions: [
                                      CupertinoButton(
                                          child: const Text('Đồng ý'),
                                          onPressed: () async {
                                            await Services.instance.lockUser();
                                          }),
                                      CupertinoButton(
                                          child: const Text('Hủy'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),
                                    ],
                                    actionAndroids: [
                                      ElevatedButton(
                                          onPressed: () async {
                                             var res = await Services.instance.lockUser();
                                             if(res == true){
                                               logOut();
                                             }
                                          },
                                          child: const Text('Đồng ý')),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Hủy'))
                                    ]
                                );
                              },
                              child: Text("Xoá tài khoản"),
                            ),
                          ),
                          const SizedBox(
                            height: 38,
                          ),

                          ButtonSubmit('Đăng xuất',
                              fontColor: Colors.white,
                              backgroundColor: Colors.redAccent, onTap: () {
                            showAlert(
                                context, 'Thông báo', 'Bạn có muốn đăng xuất ?',
                                actions: [
                                  CupertinoButton(
                                      child: const Text('Đồng ý'),
                                      onPressed: () async {
                                        logOut();
                                      }),
                                  CupertinoButton(
                                      child: const Text('Hủy'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                ],
                                actionAndroids: [
                                  ElevatedButton(
                                      onPressed: () {
                                        logOut();
                                      },
                                      child: const Text('Đồng ý')),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Hủy'))
                                ]
                            );
                          }),
                          const SizedBox(
                            height: 48,
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<BuildContext?> showPopupInfoOne(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        // isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.2,
              maxChildSize: 0.75,
              expand: false,
              builder: (_, controller) => Container(
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 60, // Độ rộng của hình chữ nhật
                        height: 10, // Chiều cao của hình chữ nhật
                        decoration: BoxDecoration(
                          color: Colors.grey, // Màu nền của hình chữ nhật
                          borderRadius:
                              BorderRadius.circular(20), // Bán kính bo tròn
                        ),
                      ),
                    ),
                    const Wrap(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Center(
                            child: Text(
                              "Giới thiệu về BrainTrain",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15.0),
                        ),
                      ],
                    ),

                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          // physics: NeverScrollableScrollPhysics(),
                          // shrinkWrap: true,
                          controller: controller,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '   Bạn có thể xem BrainTrain một phòng tập thể dục cho bộ não của mình. Chúng tôi đã phát triển một bộ trò chơi rèn luyện nhận thức dựa trên cơ sở thần kinh học cùng với phương pháp chơi đơn giản, thú vị để nhắm đến đối tượng bệnh nhân Suy giảm nhận thức nhẹ (Mild Cognitive Impairment – MCI). Ở giai đoạn MCI, số lượng tế bào thần kinh chưa bị tổn thương đáng kể, các kết nối tế bào thần kinh vẫn được bảo toàn, nhiều vùng não vẫn chưa bị teo lại. Do triệu chứng suy giảm nhận thức của nhóm bệnh nhân này chưa ảnh hưởng đáng kể đến sinh hoạt hằng ngày, nên đa số người bệnh thường chủ quan hoặc không nhận ra được đây chính là bệnh. Vì thế quá trình từ MCI tiến đến sa sút trí tuệ của họ diễn ra rất nhanh, và sa sút trí tuệ chính là giai đoạn không thể chữa trị được nữa. Mời bạn tham gia cùng chúng tôi rèn luyện các chức năng nhận thức và ngăn chặn diễn tiến của MCI. BrainTrain mong muốn cung cấp cho bệnh nhân MCI một môi trường tập luyện mang tính khoa học cho cơ quan quan trọng nhất cơ thể.',
                                  style: TextStyle(color: Colors.black,fontSize: 16.0, height: 1.5),
                                ),
                                const SizedBox(height: 16.0),
                                const Text(
                                  'Truy cập trang web: ',
                                  style: TextStyle(color: Colors.black,fontSize: 16.0, height: 1.5),
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
                                  style: TextStyle(color: Colors.black,fontSize: 16.0, height: 1.5),
                                ),
                                const SizedBox(height: 16.0),
                                const Text(
                                  'Thích nghi',
                                  style: TextStyle(color: Colors.black,
                                      fontSize:20, fontWeight: FontWeight.bold, height: 1.5),
                                ),
                                const Text(
                                  '   Bạn càng rèn luyện nhiều, bạn càng tiến bộ. Rèn luyện mỗi ngày và liên tục sẽ đảm bảo bạn cải thiện các chức năng nhận thức của mình thông qua điểm số của các trò chơi qua từng ngày. Bạn có thể theo dõi biểu đồ về điểm để thấy rõ tiến trình rèn luyện của mình.',
                                  style: TextStyle(color: Colors.black,fontSize: 16.0, height: 1.5),
                                ),
                                const SizedBox(height: 16.0),
                                const Text(
                                  'Động lực',
                                  style: TextStyle(color: Colors.black,
                                      fontSize:20, fontWeight: FontWeight.bold, height: 1.5),
                                ),
                                const Text(
                                  'Duy trì động lực là một yếu tố quan trọng trong quá trình cải thiện nhận thức. Vì thế, BrainTrain sẽ thúc đẩy bạn qua các mục tiêu dài hạn để bạn cố gắng đạt được.',
                                  style: TextStyle(color: Colors.black,fontSize: 16.0, height: 1.5),
                                ),
                                const SizedBox(height: 16.0),
                                const Text(
                                  'Thử thách',
                                  style: TextStyle(color: Colors.black,
                                      fontSize:20, fontWeight: FontWeight.bold, height: 1.5),
                                ),
                                const Text(
                                  'Độ khó của trò chơi sẽ thích ứng với cấp độ khả năng từng cá nhân, kế hoạch tập luyện và độ khó linh hoạt sẽ thúc đẩy và đảm bảo bạn luôn được thử thách ở mức độ tối đa.',
                                  style: TextStyle(color: Colors.black,fontSize: 16.0, height: 1.5),
                                ),
                                const SizedBox(height: 16.0),
                                const Text(
                                  'Thời gian',
                                  style: TextStyle(color: Colors.black,
                                      fontSize:20, fontWeight: FontWeight.bold, height: 1.5),
                                ),
                                const Text(
                                  'Một buổi tập ngắn 15 – 30 phút cũng có thể giúp kích thích rất nhiều cho bộ não của bạn. Đó là lý do tại sao chúng tôi đã thêm chế độ nhắc nhở, có thể giúp bạn biến việc rèn luyện nhận thức trở thành một phần thói quen hằng ngày hoặc hằng tuần của bạn.',
                                  style: TextStyle(color: Colors.black,fontSize: 16.0, height: 1.5),
                                ),
                                const SizedBox(height: 16.0),
                                const Text(
                                  'Tiện lợi',
                                  style: TextStyle(color: Colors.black,
                                      fontSize:20, fontWeight: FontWeight.bold, height: 1.5),
                                ),
                                const Text(
                                    'Ứng dụng hỗ trợ cải thiện nhận thức và chất lượng cuộc sống cho bệnh nhân MCI thuộc nhiều vùng miền khác nhau (bao gồm thành thị và nông thôn) thông qua việc rèn luyện nhận thức tại nhà và chia sẻ kết quả đến bác sĩ. Đây là một phương pháp chi phí thấp cho các khu vực có bối cảnh kinh tế xã hội đa dạng, giúp giảm chi phí và khó khăn cho người lớn tuổi mắc MCI trong việc di chuyển thăm khám ở các bệnh viện lớn ở thành phố.',
                                    style: TextStyle(color: Colors.black,fontSize: 16.0, height: 1.5)),

                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
  Future<BuildContext?> showPopupInfoTwo(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        // isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.2,
              maxChildSize: 0.75,
              expand: false,
              builder: (_, controller) => Container(
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:  BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 60, // Độ rộng của hình chữ nhật
                        height: 10, // Chiều cao của hình chữ nhật
                        decoration: BoxDecoration(
                          color: Colors.grey, // Màu nền của hình chữ nhật
                          borderRadius:
                              BorderRadius.circular(20), // Bán kính bo tròn
                        ),
                      ),
                    ),
                    const  Wrap(
                      children: [
                        Padding(
                          padding:  EdgeInsets.all(15.0),
                          child: Center(
                            child: Text(
                              "Chức năng nhận thức",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.all(15.0),
                        ),
                      ],
                    ),

                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          // physics: NeverScrollableScrollPhysics(),
                          // shrinkWrap: true,
                          controller: controller,
                          child: const Padding(
                            padding:  EdgeInsets.only(left: 25, right: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '  Các trò chơi trong ứng dụng BrainTrain sẽ rèn luyện các chức năng nhận thức sau:',
                                  style: TextStyle(color: Colors.black,fontSize: 16.0, height: 1.5),
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  'Trí nhớ',
                                  style: TextStyle(color: Colors.black,
                                      fontSize:20, fontWeight: FontWeight.bold, height: 1.5),
                                ),
                                Text(
                                  '  Trí nhớ là quá trình lưu trữ nhiều loại thông tin mà sau đó bạn có thể nhớ lại. Có nhiều loại hệ thống lưu trữ bộ nhớ khác nhau, ví dụ như: Trí nhớ dài hạn lưu trữ thông tin trong nhiều ngày, nhiều tuần, nhiều tháng, và thậm chí nhiều năm. Mặt khác, Trí nhớ ngắn hạn chỉ cho phép lưu trữ một lượng thông tin nhất định trong một khoảng thời gian ngắn. Loại trí nhớ ngắn hạn này liên quan trực tiếp đến trí nhớ dài hạn và chúng hoạt động như một cánh cửa dẫn chúng ta đến trí nhớ dài hạn, vì thế, bất kì tổn thương nào đối với trí nhớ ngắn hạn đều ảnh hưởng đến việc thu nhận những ký ức mới vào trí nhớ dài hạn.',
                                  style: TextStyle(color: Colors.black,fontSize: 16.0, height: 1.5),
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  '  BrainTrain đã thiết kế các trò chơi để giúp bạn rèn luyện và cải thiện trí nhớ ngắn hạn dựa trên khoa học về tính dẻo dai của thần kinh. Nếu bạn thường xuyên rèn luyện trí nhớ ngắn hạn, bộ não và các kết nối thần kinh của bạn sẽ trở nên mạnh mẽ và hiệu quả hơn (giống như cơ bắp của cơ thể',
                                  style: TextStyle(color: Colors.black,fontSize: 16.0, height: 1.5),
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  'Tập trung',
                                  style: TextStyle(color: Colors.black,
                                      fontSize:20, fontWeight: FontWeight.bold, height: 1.5),
                                ),
                                Text(
                                  '  Sự tập trung bao gồm khả năng dựa trên năng lực chú ý của bản thân. BrainTrain sẽ cung cấp các bài tập nhắm vào khả năng chú ý có chọn lọc và khả năng chú ý khi bị phân tâm. Rèn luyện các bài tập này thường xuyên sẽ giúp bạn hoàn thành các tác vụ, hoạt động hằng ngày một cách dễ dàng và nhanh chóng, ngay cả có những tình huống trong cuộc sống đòi hỏi bạn phải thực hiện đồng thời hai hoặc nhiều nhiệm vụ cùng lúc.',
                                  style: TextStyle(color: Colors.black,fontSize: 16.0, height: 1.5),
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  'Ngôn ngữ',
                                  style: TextStyle(color: Colors.black,
                                      fontSize:20, fontWeight: FontWeight.bold, height: 1.5),
                                ),
                                Text(
                                  '  Ngôn ngữ là một trong những chức năng cơ bản làm nền tảng cho khả năng giao tiếp. Bộ não người có một số vùng chuyên biệt giúp xử lý việc học và giao tiếp bằng lời nói. Tuy nhiên, các vùng não này có thể bị suy giảm ở bệnh nhân MCI, khiến họ gặp khó khăn trong việc nhớ lại các từ và tìm từ vựng chính xác để chia sẻ những gì họ muốn nói. Nếu không được can thiệp kịp thời, tình trạng này sẽ dẫn đến mất khả năng diễn đạt lưu loát bằng lời nói. Do đó, ứng dụng BrainTrain đã có các trò chơi ngôn ngữ giúp luyện tập việc nhớ lại đúng từ ngữ vào đúng thời điểm và vượt qua khó khăn trong giao tiếp để kết nối tốt hơn với bác sĩ và người chăm sóc trong các cuộc trò chuyện về bệnh tật của người bệnh. Cùng với việc làm giàu vốn từ vựng, trò chơi còn nâng cao năng lực nhận thức thông qua việc phát triển khả năng tập trung và óc sáng tạo.',
                                  style: TextStyle(color: Colors.black,fontSize: 16.0, height: 1.5),
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  'Toán học',
                                  style: TextStyle(color: Colors.black,
                                      fontSize:20, fontWeight: FontWeight.bold, height: 1.5),
                                ),
                                Text(
                                  '  Các trò chơi về toán được đánh giá như một phương pháp làm chậm tiến trình suy giảm nhận thức. Đồng thời, chúng cũng thúc đẩy cải thiện khả năng suy nghĩ để giải quyết vấn đề và đưa ra quyết định cho các nhiệm vụ cụ thể của người bệnh.',
                                  style: TextStyle(color: Colors.black,fontSize: 16.0, height: 1.5),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
  Future<BuildContext?> showPopupInfoThree(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        // isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.2,
              maxChildSize: 0.75,
              expand: false,
              builder: (_, controller) => Container(
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: const  BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft:  Radius.circular(25.0),
                    topRight:  Radius.circular(25.0),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 60, // Độ rộng của hình chữ nhật
                        height: 10, // Chiều cao của hình chữ nhật
                        decoration: BoxDecoration(
                          color: Colors.grey, // Màu nền của hình chữ nhật
                          borderRadius:
                              BorderRadius.circular(20), // Bán kính bo tròn
                        ),
                      ),
                    ),
                    const Wrap(
                      children: [
                        Padding(
                          padding:  EdgeInsets.all(15.0),
                          child: Center(
                            child: Text(
                              "Nhóm nghiên cứu",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15.0),
                        ),
                      ],
                    ),

                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          // physics: NeverScrollableScrollPhysics(),
                          // shrinkWrap: true,
                          controller: controller,
                          child:const  Padding(
                            padding: EdgeInsets.only(left: 25, right: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '  Đây là một dự án nghiên cứu của phòng thí nghiệm Sức khỏe Não bộ (Brain Health Lab) của Khoa Kỹ thuật Y Sinh, Trường Đại học Quốc Tế – Đại Học Quốc Gia TP. HCM hợp tác cùng Bệnh viện Quân Y 175. Phần mềm được phát triển bởi Nhóm Sinh viên Khoa Công nghệ Thông tin, Trường Đại học Quốc tế - ĐHQG HCM.',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0, height: 1.5),
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  '  Dự án được thử nghiệm tại Khoa Nội thần kinh, Bệnh viện Quân Y 175.',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0, height: 1.5),
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  '  Dự án được tài trợ bởi Công ty Cổ phần IVS và Công ty Cổ phần ITR VN.',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0, height: 1.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  // void logOut() async {
  //   Fluttertoast.showToast(msg: 'Đang đăng xuất');
  //
  //   Fluttertoast.cancel();
  //   Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  // }

  void logOut() async {
    var res = await Services.instance.setContext(context).logout();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (res.isSuccess) {
      await prefs.remove("lock");
      await prefs.remove("emoj");
      AppSetting.instance.reset();
      await AppSetting.pref.remove('@profile');
      await AppSetting.pref.remove('@appsetting');
      AppSetting.instance.accessToken = "";
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } else {
      Fluttertoast.showToast(
          msg: 'Có lỗi xảy ra khi đăng xuất. Bạn vẫn đăng xuất bình thường.');
     await prefs.remove("lock");
      await prefs.remove("emoj");
      AppSetting.instance.reset();
      await AppSetting.pref.remove('@profile');
      AppSetting.instance.accessToken = "";
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
    // Fluttertoast.showToast(msg: 'Đang đăng xuất');
    // AppSetting.instance.reset();
    // AppSetting.pref.remove('@profile');

    //   try {
    //     DMCLSocket.instance.socket!.disconnect();
    //   } catch (error) {
    //     Fluttertoast.showToast(
    //         msg: 'Có lỗi xảy ra khi đăng xuất. Bạn vẫn đăng xuất bình thường.');
    //   } finally {
    //     AppSetting.instance.reset();
    //     // UserModel.instance.passwordCache = '';
    //
    //     Fluttertoast.cancel();
    //     Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    //   }
  }
}
