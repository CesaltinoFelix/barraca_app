import 'package:barraca_app/pages/edit_profile.dart';
import 'package:barraca_app/pages/login.dart';
import 'package:barraca_app/pages/message.dart';
import 'package:barraca_app/pages/chat.dart';
import 'package:barraca_app/pages/my_wallets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:barraca_app/utils/constants.dart';
import 'package:barraca_app/components/profile_list_item.dart';
import 'package:barraca_app/controllers/user_controller.dart';
import '../components/defaultBackButton.dart';
import '../components/default_app_bar.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
    );
    // ScreenUtil.init(context, height: 896, width: 414, allowFontScaling: true);

    var profileInfo = Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: kSpacingUnit.w * 10,
            width: kSpacingUnit.w * 10,
            margin: EdgeInsets.only(top: kSpacingUnit.w * 3),
            child: Stack(
              children: <Widget>[
                userController.email.value == 'cesaltinofelix2000@gmail.com'
                    ? CircleAvatar(
                        radius: kSpacingUnit.w * 5,
                        backgroundImage:
                            AssetImage('assets/images/avatar.jpeg'),
                      )
                    : CircleAvatar(
                        radius: kSpacingUnit.w * 5,
                        backgroundImage:
                            AssetImage('assets/images/profile-1.png'),
                      ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: kSpacingUnit.w * 2.5,
                    width: kSpacingUnit.w * 2.5,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      heightFactor: kSpacingUnit.w * 1.5,
                      widthFactor: kSpacingUnit.w * 1.5,
                      child: Icon(
                        LineAwesomeIcons.pen,
                        color: kDarkPrimaryColor,
                        size: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: kSpacingUnit.w * 2),
          Text(
            '${userController.username.value}',
            style: kTitleTextStyle,
          ),
          SizedBox(height: kSpacingUnit.w * 0.5),
          Text(
            '${userController.email.value}',
            style: kCaptionTextStyle,
          ),
          SizedBox(height: kSpacingUnit.w * 2),
          GestureDetector(
            onTap: () => Get.to(const EditProfilePage()),
            child: Container(
              height: kSpacingUnit.w * 4,
              width: kSpacingUnit.w * 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kSpacingUnit.w * 3),
                color: Colors.orange.shade300,
              ),
              child: Center(
                child: Text(
                  'Editar Perfil',
                  style: kButtonTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    var header = Row(
      children: <Widget>[
        profileInfo,
      ],
    );

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: const DefaultAppBar(
        title: 'Perfil',
        child: DefaultBackButton(),
      ),
      body: Column(
        children: <Widget>[
          header,
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                GestureDetector(
                  onTap: () => Get.to(MyWallets()),
                  child: const ProfileListItem(
                    icon: LineAwesomeIcons.wallet,
                    text: 'Gerenciar Wallets',
                  ),
                ),
                const ProfileListItem(
                  icon: LineAwesomeIcons.history,
                  text: 'Historico de Vendas',
                ),
                ProfileListItem(
                  icon: LineAwesomeIcons.question_circle,
                  text: 'Ajuda & Suporte',
                ),
                ProfileListItem(
                  icon: LineAwesomeIcons.cog,
                  text: 'Definições',
                ),
                GestureDetector(
                  onTap: () => Get.to(Message()),
                  child: ProfileListItem(
                    icon: LineAwesomeIcons.facebook_messenger,
                    text: 'Notificatições',
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.to(Chat()),
                  child: ProfileListItem(
                    icon: LineAwesomeIcons.comment,
                    text: 'Chat',
                  ),
                ),
                ProfileListItem(
                  icon: LineAwesomeIcons.alternate_sign_out,
                  text: 'Terminar sessão',
                  hasNavigation: false,
                  onPress: () {
                    userController.logout();
                    Get.off(LoginPage());
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
