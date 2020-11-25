import 'package:flutter_svg/svg.dart';
import 'package:selendra_marketplace_app/all_export.dart';
import 'package:selendra_marketplace_app/ui/component.dart';
import 'package:selendra_marketplace_app/ui/screens/seller_confirmation/seller_confrmation.dart';

class SellerConfirmBody extends StatelessWidget {

  final OrderProduct productOrder;

  String address = """Smiles Devis\n123 Somewhere St\nSomewhere, USA 65060
  """;

  SellerConfirmBody({
    this.productOrder
  });

  @override
  Widget build(BuildContext context) {
    var _lang = AppLocalizeService.of(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Container(
            margin: EdgeInsets.only(top: 20),
            child: SvgPicture.asset("images/packaging.svg", width: 150, height: 150),
          ),

          Card(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [

                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      reuseText("SUMMARY:\n", fontSize: 15),
                      Row(
                        children: [
                          Expanded(
                            child: reuseText("Order #:"),
                          ),
                          Expanded(
                            child: reuseText("650065500"),
                          )
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: reuseText("Order Date: "),
                          ),
                          Expanded(
                            child: reuseText("Apr 3, 2017"),
                          )
                        ],
                      ),
                      
                      Row(
                        children: [
                          Expanded(
                            child: reuseText("Order Total: "),
                          ),
                          Expanded(
                            child: reuseText("\$data"),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Divider(),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      reuseText("SHIPPING ADDRESS:\n", fontSize: 15),
                      reuseText(address)
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(kDefaultRadius),
            ),
            child: ListTile(
              title: Text('{productOrder.total}៛'),
              subtitle: Text(
                "productOrder.shippingAddress",
                maxLines: 1,
              ),
              trailing: Text('{productOrder.qauantity}'),
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage("https://i.pinimg.com/originals/81/c4/fc/81c4fc9a4c06cf57abf23606689f7426.jpg"),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SellerConfirm(productOrder: productOrder))
                );
              },
            ),
          ),

          Container(
            margin: const EdgeInsets.all(20),
            child: ReuseButton.getItem(_lang.translate('confirm_payment'), () async {
              await Components.dialog(
                context, 
                Text("Did you already check customer's payment?"), 
                Text("Massage"), 
                action: FlatButton(
                  onPressed: (){
                    print("Yes");
                  }, 
                  child: Text("Yes")
                )
              );
              // validateAndSubmit();
            }, context),
          ),

          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: ReuseButton.getItem(_lang.translate('confirm_shipping'), () async {
              await Components.dialog(
                context, 
                Text("Did you already check customer's shipping?"), 
                Text("Massage"), 
                action: FlatButton(
                  onPressed: (){
                    print("Yes");
                  }, 
                  child: Text("Yes")
                )
              );
            }, context),
          ),

        ],
      ),
    );
  }

  Widget reuseText(String text, {double fontSize: 13}){
    return Text(text, style: TextStyle(fontSize: fontSize));
  }
}