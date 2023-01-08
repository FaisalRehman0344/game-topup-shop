import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:topup_shop/models/login_state.dart';
import 'package:topup_shop/routes/my_routes.dart';
import 'package:topup_shop/screens/login_screen.dart';

PreferredSize customAppBar(Size size, BuildContext context, {bool? isLogin}) {
  return PreferredSize(
      preferredSize: Size(size.width, 55),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 7,
        child: Column(
          children: [
            Container(
              margin:
                  EdgeInsets.symmetric(horizontal: size.width > 850 ? 0 : 20),
              alignment: Alignment.topCenter,
              width: size.width > 850 ? size.width * .6 : size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: InkWell(
                      onTap: () => context.go(Routes.home),
                      child: Image.asset(
                        "assets/images/main.jpg",
                        width: 55,
                      ),
                    ),
                  ),
                  MaterialButton(
                    color: Colors.orange,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    onPressed: () {
                      if (LoginState.isLogin) {
                        LoginState.isLogin = false;
                        context.go(Routes.home);
                      } else {
                        context.go(Routes.getLogin);
                      }
                      
                    },
                    child:
                        Text(isLogin != null && isLogin ? 'Logout' : 'Login'),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
}

// 