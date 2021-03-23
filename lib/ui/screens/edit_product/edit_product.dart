import 'package:albazaar_app/all_export.dart';
import 'package:albazaar_app/ui/screens/edit_product/edit_product_body.dart';

class EditProduct extends StatefulWidget {
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {

  ProductModel _product = ProductModel();

  void onChanged(String value){
    _product.formKey.currentState.validate();
  }

  void onSubmit(){

  }

  String validateField(String value, {String label}){
    if (_product.productNameNode.hasFocus){
      print("Product $label");
    } else if (_product.priceNode.hasFocus){
      print("Price $label");
    } else if (_product.locationNode.hasFocus){
      print("Location $label");
    } else if (_product.descriptionNode.hasFocus){
      print("Description $label");
    }
    return "Error";
  }

  @override
  Widget build(BuildContext context) {
    var _lang = AppLocalizeService.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        brightness: Brightness.light,
        titleSpacing: 20,
        // leadingWidth: 25,
        title: MyText(
          text: "Add Product",
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: 25,
        ),
        // bottom: ReuseTabBar.getItem(appBarItemOne, appBarItemTwo, appBarItemThree, controller, context),
        //  backgroundColor: Colors.white,
        leading: IconButton(
          padding: EdgeInsets.only(left: 25),
          icon: Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: AppServices.hexaCodeToColor(AppColors.primary),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: EditProductBody(
          product: _product,
          onChanged: onChanged,
          validate: validateField,
          onSubmit: onSubmit,
        )
      ),
    );
  }
}