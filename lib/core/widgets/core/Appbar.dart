import 'package:flutter/material.dart';
import 'package:onepluspay/core/constants/theme.dart';

class OnePlugAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onPressed;
  const OnePlugAppBar({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // title: Text(title),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        SizedBox(
            width:200,
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(title,style: globalvariable.bodyLarge.copyWith(fontSize: 16),overflow: TextOverflow.ellipsis,))),
            SizedBox(width: 30,)
      ],
      centerTitle: false,
      leading:  IconButton(onPressed:onPressed, icon: Icon(Icons.chevron_left,size: 40,),),

    )

    ;

  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
