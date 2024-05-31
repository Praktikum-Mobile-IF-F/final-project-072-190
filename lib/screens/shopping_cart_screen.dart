import 'dart:convert';
import 'package:final_project/models/user.dart';
import 'package:final_project/screens/history_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_project/models/cart.dart';
import 'package:final_project/models/order.dart';
import 'package:final_project/models/product.dart';
import 'package:final_project/screens/detail_product_screen.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({Key? key}) : super(key: key);

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  late String _email = '';
  late List<CartProduct> cartProducts = [];
  late List<bool> _selected = [];
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCartProducts();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    if (user != null) {
      setState(() {
        _email = json.decode(user)['email'];
      });
    }
    _loadCartProducts();
  }

  Future<void> _loadCartProducts() async {
    final cartBox = await Hive.openBox<Cart>('cartBox');
    Cart? cart = cartBox.get(_email);
    setState(() {
      cartProducts = cart?.products.toList().reversed.toList() ?? [];
      _selected = List<bool>.filled(cartProducts.length, false);
      _selectAll = false;
    });
  }

  Future<void> removeItem(int index) async {
    final cartBox = await Hive.openBox<Cart>('cartBox');
    Cart? cart = cartBox.get(_email);
    if (cart != null) {
      int originalIndex = cart.products.length - 1 - index;
      cart.products.removeAt(originalIndex);
      await cartBox.put(_email, cart);
      setState(() {
        cartProducts = cart.products.toList().reversed.toList();
        _selected = List<bool>.filled(cartProducts.length, false);
        _selectAll = false;
      });
    }
  }

  Product convertCartProduct(CartProduct cartProduct) {
    return Product(
      id: cartProduct.productId,
      name: cartProduct.name ?? '',
      imageUrl: cartProduct.imageUrl ?? '',
      url: cartProduct.productUrl ?? '',
      price: Price(
        current: PriceDetails(
          value: cartProduct.priceValue ?? 0.0,
        ),
        currency: cartProduct.priceCurrency ?? '',
      ),
    );
  }

  String _calculateTotal() {
    double total = 0.0;
    for (int i = 0; i < cartProducts.length; i++) {
      if (_selected[i]) {
        total += cartProducts[i].priceValue ?? 0.0;
      }
    }
    return total.toStringAsFixed(2);
  }

  Future<void> _promptAddress() async {
    TextEditingController _addressController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Address'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please enter your address to proceed with checkout.'),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(hintText: 'Enter address'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                final userBox = await Hive.openBox<User>('userBox');
                User? currentUser = userBox.values.firstWhere((user) => user.email == _email);
                if (currentUser != null) {
                  currentUser.address = _addressController.text;
                  await currentUser.save();
                  Navigator.of(context).pop();
                  _createOrder();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _createOrder() async {
    final userBox = await Hive.openBox<User>('userBox');
    User? currentUser = userBox.values.firstWhere((user) => user.email == _email);
    if (currentUser != null && (currentUser.address == null || currentUser.address!.isEmpty)) {
      _promptAddress();
      return;
    }

    final cartBox = await Hive.openBox<Cart>('cartBox');
    Cart? cart = cartBox.get(_email);
    if (cart != null) {
      List<CartProduct> selectedProducts = [];
      for (int i = 0; i < cartProducts.length; i++) {
        if (_selected[i]) {
          selectedProducts.add(cartProducts[i]);
        }
      }

      if (selectedProducts.isNotEmpty) {
        double totalPrice = 0.0;
        selectedProducts.forEach((product) {
          totalPrice += product.priceValue ?? 0.0;
        });
        OrderedProduct orderedProduct = OrderedProduct(
          orderId: DateTime.now().millisecondsSinceEpoch,
          totalPrice: totalPrice.toStringAsFixed(2),
          products: selectedProducts,
        );

        final orderBox = await Hive.openBox<Order>('orderBox');
        Order? order = orderBox.get(_email);

        if (order == null) {
          order = Order(email: _email, products: []);
        }

        order.products.add(orderedProduct);
        await orderBox.put(_email, order);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order Successful'),
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HistoryOrderScreen(),
          ),
        );
      }
    }
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      _selected = List<bool>.filled(cartProducts.length, _selectAll);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: Column(
        children: [
          CheckboxListTile(
            title: const Text('Select All'),
            value: _selectAll,
            onChanged: _toggleSelectAll,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          Expanded(
            child: cartProducts.isEmpty
                ? const Center(
              child: Text(
                'No cart products available',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
            )
                : ListView.builder(
              itemCount: cartProducts.length,
              itemBuilder: (context, index) {
                final cartProduct = cartProducts[index];
                final product = convertCartProduct(cartProduct);
                return ListTile(
                  leading: Checkbox(
                    value: _selected[index],
                    onChanged: (bool? value) {
                      setState(() {
                        _selected[index] = value!;
                        _selectAll = _selected.every((element) => element);
                      });
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(product: product),
                      ),
                    );
                  },
                  title: Container(
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black.withOpacity(0.05),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(0, -1),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: SizedBox(
                                    height: 100,
                                    width: 80,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        cartProduct.imageUrl ?? 'No Image Url',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 100,
                              width: 170,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    cartProduct.name ?? 'No Name',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    cartProduct.productSize ?? 'No Product Size',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${cartProduct.priceCurrency} ${cartProduct.priceValue}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            icon: Icon(Icons.restore_from_trash_outlined, color: Colors.red),
                            onPressed: () {
                              removeItem(index);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: USD ${_calculateTotal()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: _selected.contains(true) ? _createOrder : null,
                  child: const Text('Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
