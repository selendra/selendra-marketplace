import 'package:http/http.dart' as http;
import 'package:albazaar_app/all_export.dart';
import 'package:albazaar_app/ui/component.dart';

class ProductsProvider with ChangeNotifier {
  
  PrefService _prefService = PrefService();
  PostRequest _postRequest = PostRequest();
  Backend _backend = Backend();

  //List of all product items
  List<Product> _items = [];

  //List of all owner product items
  List<OwnerProduct> _oItems = [];

  //List of all order product items
  List<OrderProduct> _orItems = [];

  List<OrderProduct> _allOrderItems = [];

  //List of all order product item that is available
  List<Product> _isAvailable = [];

  //List of all order product item that is sold
  List<Product> _isSold = [];

  //All product image
  List<ProductImage> _imageList = [];

  //Each product image url
  List<String> _url = [];

  List<OrderProduct> _completeProduct = [];

  List<Map<String, dynamic>> _categoryList = [];
  List<Map<String, dynamic>> _paymentOptList = [];
  List<Map<String, dynamic>> _shippingList = [];
  List<Map<String, dynamic>> _weightList = [];
  
  //initial product orderqty

  List<Product> get items => [..._items];
  List<OwnerProduct> get oItems => [..._oItems];
  List<Product> get isAvailable => [..._isAvailable];
  List<Product> get isSold => [..._isSold];
  List<OrderProduct> get orItems => [..._orItems];
  List<OrderProduct> get allOrderItems => [..._allOrderItems];
  List<ProductImage> get imageList => [..._imageList];
  List<String> get url => [..._url];
  List<OrderProduct> get completeProduct => [..._completeProduct];

  AddProductProvider get addProductProvider => _addProductProvider;
  AddProductProvider _addProductProvider;

  Future<dynamic> fetchListingProduct({bool refetch = false}) async {
    List<Map<String, dynamic>> responseJson = [];
    try {
      _backend.token = await _prefService.read('token');   
        
      if (_backend.token != null) {

        /* --------Check For Data has been Saved-------- */

        // First Login
        await _prefService.read(DbKey.products).then((value) async {
          // If we also want to refetch
          if (value == null || value.length == 0 || refetch == true){

            _backend.response = await http.get(ApiUrl.LISTING, headers: <String, String>{
              "accept": "application/json",
              "authorization": "Bearer " + _backend.token,
            });

            // If Have Something Wrong Evern If Response 200
            // Can't check with = responseJson.contains('error') directly
            // _GrowableList<dynamic> Response When Run Release
            if (json.decode(_backend.response.body).runtimeType.toString() != "List<dynamic>" && json.decode(_backend.response.body).runtimeType.toString() != "_GrowableList<dynamic>"){
              responseJson.add(
                {'error': json.decode(_backend.response.body)['error']}
              );
              throw(responseJson);

            } else {

              // Save Product Data Into Database
              _prefService.saveString(DbKey.products, _backend.response.body);

              // Parse String To Object
              _backend.data = await json.decode(_backend.response.body);

            }
          // Already Save Data
          } else {
            _backend.data = await json.decode(value);
          }
          _backend.data.forEach((value){
            responseJson.add(value);
          });
          
          clearProperty();
          for (var mItem in responseJson) {
            // print("My fetcing data ${mItem['is_sold']}");
            _items.add(
              Product.fromMap(mItem),
            );

          }
          
          // _categoriesModel.sortDataByCategory(_categoriesModel.listProduct, 'user');
          // Sort Products By Category 
          await fetchOrFromBuyer(_backend.token);

          // fetchOListingProduct(token);
          _addProductProvider = AddProductProvider();
        });
      }

    } catch (e) {
      return e;
    }
    return responseJson;
  }

  Future<dynamic> productListingGuestAcc() async {
    List<Map<String, dynamic>> responseJson = [];
    try {
      
      http.Response response = await http.get(ApiUrl.GUEST_ACC, headers: <String, String>{
        "accept": "application/json",
      });

      // If Have Something Wrong Evern If Response 200
      // Can't check with = responseJson.contains('error') directly
      // _GrowableList<dynamic> Response When Run Release
      if (json.decode(response.body).runtimeType.toString() != "List<dynamic>" && json.decode(response.body).runtimeType.toString() != "_GrowableList<dynamic>"){
        responseJson.add(
          {'error': json.decode(response.body)['error']}
        );
        throw(responseJson);
      } else {
        json.decode(response.body).forEach((value){
          responseJson.add(value);
        });
        clearProperty();
        for (var mItem in responseJson) {
          // print("My fetcing data ${mItem['is_sold']}");
          _items.add(
            Product.fromMap(mItem),
          );

        }
        
        // _categoriesModel.sortDataByCategory(_categoriesModel.listProduct, 'user');
        // Sort Products By Category
      }
    } catch (e) {
      return e;
    }
    return responseJson;
  }

  Future<void> addOrder(String productId, String qty, String address) async {
    try {
      await _prefService.read('token').then(
        (token) async {
          http.Response response = await http.post(
            ApiUrl.MAKE_ORDER,
            headers: <String, String>{
              "accept": "application/json",
              "authorization": "Bearer " + token,
              "Content-Type": "application/json",
            },
            body: jsonEncode(
              <String, String>{
                "product-id": productId,
                "qty": qty,
                "shipping-address": address
              },
            ),
          );
        },
      );
    } catch (e) {
      // print(e.toString());
    }
  }

  void addItem(BuildContext context, AddProduct newProduct) async {
    Components.dialogLoading(context: context, contents: "Adding");
    try {
      await _postRequest.addListing(newProduct).then((token) async {
        // Close Loading
        Navigator.pop(context);
        await Components.dialog(
            context,
            Text("${json.decode(token.body)['message']}",
                textAlign: TextAlign.center),
            Text("Message"));
        // Close Seller Screen
        if (json.decode(token.body)['message'].length > 1) {
          newProduct.productId = json.decode(token.body)['id'];
          Navigator.pop(context, {"add": true});
        }
        fetchListingProduct();
      });
      // Close Loading
    } on SocketException catch (e) {
      // print("Error $e");
    } catch (e) {
      // print("Error $e");
    }
  }

  // Fetch All Image Url
  Future<void> getAllProductImg(String token) async {
    for (int i = 0; i < _items.length; i++) {
      final listImagesResponse = await fetchImage(token, _items[i].id);
      for (var item in listImagesResponse) {
        // _imageList.add(ProductImage.fromJson(item));
        _items[i].subImageUrl.add(item['url']);
      }
    }

    // print("SubImageUrl length ${_items.sublist.length}");
  }

  /*Fetch all product image by looping all product id in list 
  and add it into all image list*/
  Future<List<Map<String, dynamic>>> fetchImage(String token, String productId) async {
    _imageList.clear();
    try {
      _backend.response = await http.post(
        ApiUrl.GET_PRODUCT_IMAGE,
        headers: <String, String>{
          "accept": "application/json",
          "authorization": "Bearer " + token,
          "Content-Type": "application/json",
        },
        body: jsonEncode(<String, String>{
          "url": "string",
          "product-id": productId,
        })
      );
      _backend.data = await json.decode(_backend.response.body);
    } catch (e) {
      // print(e.toString());
    }
    return List<Map<String, dynamic>>.from(_backend.data);
  }

  // List Order You Bought
  Future<void> fetchOrFromBuyer(token) async {
    dynamic responseJson;
    try {
      await StorageServices.fetchData(DbKey.productsOrder).then((value) async {
        
        // Fetch Data From Api
        if (value == null){
          http.Response response = await http.get(ApiUrl.LIST_FOR_BUYER, headers: <String, String>{
            "accept": "application/json",
            "authorization": "Bearer " + token,
          });
          responseJson = json.decode(response.body);
          _allOrderItems.clear();

          await StorageServices.setData(responseJson, DbKey.productsOrder);
        }
        // Fetch Data From Db 
        else {
          responseJson = value;
        }
      });

      for (var item in responseJson) {
        _allOrderItems.add(OrderProduct.fromJson(item));
        var itemData = OrderProduct.fromJson(item);
        if (itemData.orderStatus == 'Order Complete') {
          _completeProduct.add(itemData);
        } else {
          _orItems.add(itemData);
        }
      }

      notifyListeners();
    } catch (e) {
      // print(e.toString());
    }
  }

  Future<void> markOrderComplete(String orderId, BuildContext context, OrderProduct product) async {
    String message;
    try {
      await _prefService.read('token').then(
        (token) async {
          http.Response response = await http.post(
            ApiUrl.MARK_COMPLETE,
            headers: <String, String>{
              "accept": "application/json",
              "authorization": "Bearer " + token,
              "Content-Type": "application/json",
            },
            body: jsonEncode(
              <String, String>{
                "order-id": orderId,
              },
            ),
          );

          var responseJson = json.decode(response.body);
          message = responseJson['message'];
          if (message == null) {
            message = responseJson['message']['error'];
            await ReuseAlertDialog().successDialog(context, message);
          } else {
            Navigator.pop(context);
            Provider.of<ProductsProvider>(context, listen: false)
                .fetchListingProduct();
            await ReuseAlertDialog().customDialog(context, message, () {
              Navigator.pop(navigationKey.currentState.overlay.context);
              removeOrderProduct(orderId);
              notifyListeners();
            });
          }
        },
      );
    } catch (e) {
      // print(e.toString());
    }
  }

  void findIsSold(List<Product> allListing) {
    _isSold = [];
    _isAvailable = [];

    for (int i = 0; i < allListing.length; i++) {
      if (allListing[i].isSold && !_isSold.contains(allListing[i])) {
        _isSold.add(allListing[i]);
      } else {
        if (!_isAvailable.contains(allListing[i])) {
          _isAvailable.add(allListing[i]);
        }
      }
    }

    notifyListeners();
  }

  //find image of each product in image list using product Id
  void findImgById(String productId) async {
    _url = [];

    final product = findById(productId);
    addThumbnail(product.thumbnail);

    for (int i = 0; i < _imageList.length; i++) {
      if (_imageList[i].productId == productId) {
        _url.add(_imageList[i].url);
      }
    }
  }

  //Add Image thumbnail to show first index of all images
  void addThumbnail(String thumbnail) {
    _url.add(thumbnail);
  }

  List<Product> filterProductByCategories(String categoryName) {
    List<Product> filterList = [];

    for (int i = 0; i < _items.length; i++) {
      if (_items[i].categoryName == categoryName) {
        filterList.add(_items[i]);
      }
    }

    return filterList;
  }

  // Future<void> readLocalProduct() async {
  //   await _prefService.read('products').then((token) {
  //     if (token != null) {
  //       dynamic repsonseJson = json.decode(token);
  //       for (var item in repsonseJson) {
  //         _items.add(Product.fromMap(item));
  //       }
  //     }
  //   });
  //   await _prefService.read('oproducts').then((token) {
  //     if (token != null) {
  //       dynamic responseJson = json.decode(token);
  //       _oItems.add(Product.fromMap(responseJson));
  //     }
  //   });
  // }

  //Find product by product ID
  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void removeOrderProduct(String id) {
    _orItems.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  //Increase order quantity of product
  void addOrderQty(Product product) {
    product.orderQty++;
    notifyListeners();
  }

  //Decrease order quantity of product
  void minusOrderQty(Product product) {
    if (product.orderQty > 1) {
      product.orderQty--;
      notifyListeners();
    }
  }

  void clearProperty() {
    _imageList.clear();
    _orItems.clear();
    _oItems.clear();
    _items.clear();
    _completeProduct.clear();
    notifyListeners();
  }
}
