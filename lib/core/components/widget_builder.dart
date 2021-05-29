import 'package:albazaar_app/all_export.dart';

class ListWidgetBuilder{

  static Widget imageRowBuilder({BuildContext context, dynamic image, Function onPressed, int selected, int index}){
    print("Index $image");
    return GestureDetector(
      onTap: (){
        print(index);
        onPressed();
      },
      child: MyCard(
        hexaColor: "#FFFFFF",
        mRight: 10,
        boxBorder: Border.all(width: 2, color: selected == index ? AppServices.hexaCodeToColor(AppColors.secondary) : Colors.transparent),
        width: selected == index ? 55 : 45, height: selected == index ? 55 : 45,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(image)
        ),
      ),
    );
  }
}