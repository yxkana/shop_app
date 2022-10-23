import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'package:overlay_builder/overlay_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/widgets/product_item.dart';
import '../providers/cart.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatefulWidget {
  //final String titleScreen;
  //ProductDetailScreen(this.titleScreen);

  static const routeName = "/product-detail";

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  //Controllers
  late AnimationController _controller;
  late AnimationController _controllerIcon;
  late AnimationController _controllerTextButton;

  late AnimationController _buttonControllerUp;

  //Animation
  late Animation<double> _fadeAnimation;
  late Animation<double> _fadeTextAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<Offset> _slideAnimation;

  late Animation<double> _opacityAnimation;
  late Animation<Offset> _buttonTextSlideUp;

  var _expanded = false;

  var _itemAdded = true;
  var _firstClick = true;

  bool pressed = true;

  String text = "Add to cart";

  final layerLink = LayerLink();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //Offset

    //Controller
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _controllerIcon =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    //_controllerTextButton = AnimationController(vsync: this,Durati)

    _buttonControllerUp = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));

    //Animation
    _fadeAnimation = Tween(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _fadeTextAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controllerIcon, curve: Curves.linear));
    _rotateAnimation = Tween(begin: 0.0, end: pi).animate(
        CurvedAnimation(parent: _controllerIcon, curve: Curves.linear));
    _slideAnimation = Tween<Offset>(begin: Offset(0, -1.6), end: Offset(0, 0))
        .animate(
            CurvedAnimation(parent: _controllerIcon, curve: Curves.linear));

    //Fade Animation
    _opacityAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.2, end: 1.0), weight: 5),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.0, end: 1.0), weight: 38),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.0, end: 0.2), weight: 5),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 0.0), weight: 1),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.2, end: 1.0), weight: 5)
    ]).animate(
        CurvedAnimation(parent: _buttonControllerUp, curve: Curves.linear));

    //Slide Animation
    _buttonTextSlideUp = TweenSequence(<TweenSequenceItem<Offset>>[
      TweenSequenceItem<Offset>(
          tween: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)),
          weight: 5),
      TweenSequenceItem<Offset>(
          tween: Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 0)),
          weight: 38),
      TweenSequenceItem<Offset>(
          tween: Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -1)),
          weight: 5),
      TweenSequenceItem<Offset>(
          tween: Tween<Offset>(begin: Offset(0, -10), end: Offset(0, -10)),
          weight: 1),
      TweenSequenceItem<Offset>(
          tween: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)),
          weight: 5)
    ]).animate(
        CurvedAnimation(parent: _buttonControllerUp, curve: Curves.linear));

    _slideAnimation.addListener(() {
      setState(() {});
    });

    _buttonTextSlideUp.addListener(() {
      setState(() {});
    });
  }

  void addItem() {
    setState(() {
      _itemAdded = !_itemAdded;
      ChangeText();
    });
  }

  void ChangeText() {
    setState(() {
      if (_itemAdded) {
        text = "Add to cart";
      } else {
        text = "Item added to cart";
      }
    });
  }

  void firstClick() {
    setState(() {
      _firstClick = false;
    });
  }

  void OnPressed() {
    setState(() {
      pressed = !pressed;
    });
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
    _controllerIcon.dispose();
    _buttonControllerUp.dispose();

    //entry?.remove();
    //entry = null;
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final selectItem =
        Provider.of<Products>(context, listen: false).findID(productId);
    final cart = Provider.of<Cart>(context, listen: false);

    return Scaffold(
      //appBar: AppBar(title: Text(selectItem.title)),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              pinned: true,
              expandedHeight: 200,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  Color trans = Colors.white;
                  double percent = (constraints.maxHeight);

                  if (percent > 100) {
                    //trans = Colors.transparent;

                    _controller.forward();
                  }
                  if (percent < 100) {
                    //trans = Colors.white;
                    _controller.reverse();
                  }

                  return FlexibleSpaceBar(
                      expandedTitleScale: 2,
                      title: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          selectItem.title,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      background: GridTile(
                        child: Hero(
                          tag: selectItem.id,
                          child: Image.network(
                            selectItem.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ));
                },
              )),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  selectItem.title,
                  textAlign: TextAlign.left,
                  softWrap: true,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 25),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                width: double.infinity,
                child: Text(
                  selectItem.price.toStringAsFixed(0) + ",-",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.w900),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                  child: const Text(
                "Informace o produktu",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              )),
            ),
            Card(
              child: Column(children: [
                Material(
                  color: Colors.white.withOpacity(0.0),
                  child: ListTile(
                      onTap: () {
                        setState(() {
                          _expanded = !_expanded;
                        });
                        if (_expanded) {
                          _controllerIcon.forward();
                        } else if (_expanded == false) {
                          _controllerIcon.reverse();
                        }
                      },
                      title: Text("Podrobnosti o výrobku"),
                      trailing: AnimatedBuilder(
                        animation: _rotateAnimation,
                        builder: (context, child) => Transform.rotate(
                            angle: _rotateAnimation.value,
                            child: Icon(Icons.expand_more)),
                      )),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: _expanded ? 100 : 0,
                  child: ListView(
                    children: [
                      FadeTransition(
                        opacity: _fadeTextAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(selectItem.description)),
                        ),
                      )
                    ],
                  ),
                )
              ]),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
            ),
          ]))
        ],
      ),
      floatingActionButton: Container(
          height: MediaQuery.of(context).size.height * 0.07,
          width: MediaQuery.of(context).size.width * 0.8,
          child: FloatingActionButton(
            onPressed: () async {
              Future<void> pressedButt() async {
                setState(
                  () {
                    if (pressed == false) {
                      setState(() {
                        if (pressed == false) {
                          try {
                            _buttonControllerUp.reset();
                            print("inter.");
                          } finally {
                            cart.addItem(productId, selectItem.price,
                                selectItem.title, selectItem.imageUrl);

                            var timer = Timer(
                                Duration(milliseconds: 1788),
                                (() => setState(() {
                                      text = "Add to cart";
                                    })));

                            if (_itemAdded == false) {
                              _buttonControllerUp
                                  .forward()
                                  .whenCompleteOrCancel(() {
                                if (_buttonControllerUp.isCompleted) {
                                  addItem();
                                  OnPressed();
                                  _buttonControllerUp.reset();
                                } else {
                                  timer.cancel();
                                  print("reset");
                                }
                              });
                            }
                          }
                        }
                      });
                    }
                  },
                );
              }

              if (_itemAdded == false) {
                //_firstClick = true;
                //up = true;
                //OnPressed();
                _buttonControllerUp.reset();
                print("reset reset");

                setState(() {
                  _firstClick = true;
                  _itemAdded = true;
                  pressed = true;
                });
                addItem();
                OnPressed();
                pressedButt();
              } else {
                setState(() {
                  addItem();
                  OnPressed();
                  pressedButt();
                });
              }
            },
            child: _itemAdded
                ? Text(
                    text,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                : FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                        position: _buttonTextSlideUp,
                        child: Text(
                          text,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
