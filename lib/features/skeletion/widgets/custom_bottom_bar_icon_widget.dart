import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onepluspay/core/constants/theme.dart';

class CustomBottomBarIconWidget extends StatelessWidget {
  const CustomBottomBarIconWidget({
    Key? key,
    required this.callback,
    required this.iconDataSelected,
    required this.iconDataUnselected,
    required this.isSelected, required this.IconName, required this.Name,
  }) : super(key: key);

  final VoidCallback callback;
  final bool isSelected;
  final IconData iconDataSelected;
  final IconData iconDataUnselected;
  final String IconName;
  final String Name;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Column(
        children: [
          SvgPicture.asset(IconName,
            color: isSelected ? globalvariable.primarycolor : Colors.black87,
        ),
          Text(Name,style: TextStyle(
            color: isSelected ? globalvariable.primarycolor : Colors.black87
          ),)
          // IconButton(
          //   onPressed: callback,
          //   iconSize: isSelected ? 35 : 25,
          //   icon: Icon(
          //     isSelected ? iconDataSelected : iconDataUnselected,
          //     color: isSelected ? Colors.orangeAccent : Colors.black87,
          //   ),
          // ),
        ],
      ),
    );
  }
}