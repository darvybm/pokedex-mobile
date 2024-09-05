import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:temp/utils/colors.dart';
import 'package:temp/utils/screen_sizes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 15);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return true to allow popping the route (i.e., going back)
        // Return false to prevent popping the route
        return ModalRoute.of(context)?.settings.name != '/';
      },
      child: AppBar(
        toolbarHeight: ScreenUtil.diagonal(context) * 0.2,
        iconTheme: IconThemeData(
          color: MyColors.greyDark,
          size: ScreenUtil.diagonal(context) * 0.04,
        ),
        backgroundColor: MyColors.greyLight,
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil.screenWidth(context) * 0.02
              ),
              child: SvgPicture.asset(
                'assets/images/icons/pokeballcon.svg',
                colorFilter: const ColorFilter.mode(MyColors.greyDark, BlendMode.srcIn),
                width: ScreenUtil.diagonal(context) * 0.04,
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              title,
              style: TextStyle(
                color: MyColors.greyDark,
                fontSize: ScreenUtil.diagonal(context) * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          if (ModalRoute.of(context)?.settings.name != '/') // Check if not on the home page
            IconButton(
              icon: Icon(Icons.home, color: MyColors.greyDark),
              onPressed: () {
                // Navigate to the home screen
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
            ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
    );
  }
}
