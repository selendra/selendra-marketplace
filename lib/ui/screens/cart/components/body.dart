import 'package:flutter/material.dart';
import 'package:albazaar_app/all_export.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    final _cartData = Provider.of<CartProvider>(context);
    final _items = _cartData.items;
    return Container(
      child: _items.isNotEmpty
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 1.4,
                    child: ListView.builder(
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          return CartItems(
                            _items.values.toList()[index].image,
                            _items.values.toList()[index].title,
                            _items.values.toList()[index].price,
                            _items.values.toList()[index].qty,
                            _items.keys.toList()[index],
                          );
                        }),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20.0),
                    child: ReuseButton.getItem(
                        AppLocalizeService.of(context).translate('check_out'),
                        () {
                      Navigator.pushReplacementNamed(context, CheckoutView);
                    }, context),
                  ),
                ],
              ),
            )
          : Center(
              child: SvgPicture.asset(
                'images/undraw_empty_cart.svg',
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.3,
              ),
            ),
    );
  }
}
