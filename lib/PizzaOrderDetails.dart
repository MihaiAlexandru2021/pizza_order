import 'package:flutter/material.dart';
import 'package:pizza_order/Ingredient.dart';
import 'package:pizza_order/PizzaOrderProvider.dart';

import 'PizzaCartButton.dart';
import 'PizzaIngredients.dart';
import 'PizzaOrderBlock.dart';
import 'PizzaSizeButton.dart';

const _pizzaCartSize = 48.0;

class PizzaOrderDetails extends StatefulWidget {

  @override
  _PizzaOrderDetailsState createState() => _PizzaOrderDetailsState();
}

class _PizzaOrderDetailsState extends State<PizzaOrderDetails> {

  final block = PizzaOrderBlock();

  Widget build(BuildContext context) {
    return PizzaOrderProvider(
      block: block,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'New Orleans Pizza',
              style: TextStyle(
                color: Colors.brown,
                fontSize: 28,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.add_shopping_cart_outlined,
                  color: Colors.brown,
                ),
                onPressed: () {},
              )
            ],
          ),
          body: Stack(
            children: [
              Positioned.fill(
                  bottom: 50,
                  left: 10,
                  right: 10,
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 10,
                      child: Column(
                        children: [
                          Expanded(flex: 4, child: _PizzaDetails()),
                          Expanded(flex: 2, child: PizzaIngredients()),
                          SizedBox(height: 20),
                        ],
                      ))),
              Positioned(
                bottom: 25,
                height: _pizzaCartSize,
                width: _pizzaCartSize,
                left: MediaQuery.of(context).size.width / 2 - _pizzaCartSize / 2,
                child: PizzaCartButton(
                  onTap: () {
                    print('cart');
                  },
                ),
              )
            ],
          )),
    );
  }
}

class _PizzaDetails extends StatefulWidget {
  @override
  _PizzaDetailsState createState() => _PizzaDetailsState();
}

class _PizzaDetailsState extends State<_PizzaDetails> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _animationRotationController;
  final _notifierFocused = ValueNotifier(false);
  List<Animation> _animationList = <Animation>[];
  BoxConstraints? _pizzaConstraints;
  final _notifierPizzaSize =
      ValueNotifier<_PizzaSizeState>(_PizzaSizeState(_PizzaSizeValue.M));

  Widget _buildIngredientsWidget() {
    List<Widget> elements = [];
    final listIngredients = PizzaOrderProvider.of(context)?.listIngredients;
    if (_animationList.isNotEmpty) {
      for (int i = 0; i < listIngredients!.length; i++) {
        Ingredient ingredient = listIngredients[i];
        final ingredientWidget = Image.asset(ingredient.imageUnit, height: 40);
        for (int j = 0; j < ingredient.position.length; j++) {
          final animation = _animationList[j];
          final position = ingredient.position[j];
          final positionX = position.dx;
          final positionY = position.dy;
          double fromX = 0.0, fromY = 0.0;

          if (i == listIngredients.length - 1) {
            if (j < 1) {
              fromX = -(_pizzaConstraints?.maxWidth)! * (1 - animation.value);
            } else if (j < 2) {
              fromX = (_pizzaConstraints?.maxWidth)! * (1 - animation.value);
            } else if (j < 4) {
              fromY = -(_pizzaConstraints?.maxHeight)! * (1 - animation.value);
            } else {
              fromY = (_pizzaConstraints?.maxHeight)! * (1 - animation.value);
            }

            final opacity = animation.value;

            if (animation.value > 0) {
              elements.add(Opacity(
                  opacity: opacity,
                  child: Transform(
                      transform: Matrix4.identity()
                        ..translate(
                          fromX + (_pizzaConstraints?.maxWidth)! * positionX,
                          fromY + (_pizzaConstraints?.maxHeight)! * positionY,
                        ),
                      child: ingredientWidget)));
            }
          } else {
            elements.add(Transform(
                transform: Matrix4.identity()
                  ..translate(
                    (_pizzaConstraints?.maxWidth)! * positionX,
                    (_pizzaConstraints?.maxHeight)! * positionY,
                  ),
                child: ingredientWidget));
          }
        }
      }
      return Stack(
        children: elements,
      );
    }
    return SizedBox.fromSize();
  }

  void _buildIngredientsAnimation() {
    _animationList.clear();
    _animationList.add(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.8, curve: Curves.decelerate),
    ));
    _animationList.add(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.2, 0.8, curve: Curves.decelerate),
    ));
    _animationList.add(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.4, 1.0, curve: Curves.decelerate),
    ));
    _animationList.add(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.1, 0.7, curve: Curves.decelerate),
    ));
    _animationList.add(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.3, 1.0, curve: Curves.decelerate),
    ));
  }

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _animationRotationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationRotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final block = PizzaOrderProvider.of(context);
    return Column(
      children: [
        Expanded(
          child: DragTarget<Ingredient>(onAccept: (ingredient) {
            _notifierFocused.value = false;
            block?.addIngredient(ingredient);
            _buildIngredientsAnimation();
            _animationController.forward(from: 0.0);
          }, onWillAccept: (ingredient) {
            _notifierFocused.value = true;
            return !block!.containsIngredient(ingredient!);
          }, onLeave: (ingredient) {
            _notifierFocused.value = false;
          }, builder: (context, list, rejects) {
            return LayoutBuilder(
              builder: (context, constraints) {
                _pizzaConstraints = constraints;
                return ValueListenableBuilder<_PizzaSizeState>(
                    valueListenable: _notifierPizzaSize,
                    builder: (context, pizzaSize, _) {
                      return RotationTransition(
                        turns: _animationRotationController,
                        child: Stack(
                          children: [
                            Center(
                              child: ValueListenableBuilder<bool>(
                                valueListenable: _notifierFocused,
                                builder: (context, focused, _) {
                                  return AnimatedContainer(
                                    duration: const Duration(microseconds: 400),
                                    height: focused
                                        ? constraints.maxHeight * pizzaSize.factor
                                        : constraints.maxHeight * pizzaSize.factor - 10,
                                    child: Stack(
                                      children: [
                                        DecoratedBox(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 15.0,
                                                    color: Colors.black26,
                                                    offset: Offset(0.0, 3.0),
                                                    spreadRadius: 5.0)
                                              ]),
                                          child: Image.asset(
                                              'assets/images/dish.png'),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Image.asset(
                                                'assets/images/pizza-1.png'))
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, _) {
                                  return _buildIngredientsWidget();
                                })
                          ],
                        ),
                      );
                    });
              },
            );
          }),
        ),
        const SizedBox(height: 5),
        ValueListenableBuilder<int>(
          valueListenable: block!.notifierTotal,
          builder: (context, totalValue, _) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: animation.drive(Tween<Offset>(
                        begin: Offset(0.0, 0.0),
                        end: Offset(0.0, animation.value))),
                    child: child,
                  ),
                );
              },
              child: Text(
                '\$$totalValue',
                key: UniqueKey(),
                style: TextStyle(
                    fontSize: 30, fontWeight: FontWeight.bold, color: Colors.brown),
              ),
            );
          }
        ),
        const SizedBox(height: 15),
        ValueListenableBuilder<_PizzaSizeState>(
          valueListenable: _notifierPizzaSize,
          builder: (context, pizzaSize, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PizzaSizeButton(
                    text: 'S',
                    onTap: () {
                      _updatePizza(_PizzaSizeValue.S);
                    },
                    selected: pizzaSize.value == _PizzaSizeValue.S),
                PizzaSizeButton(
                    text: 'M',
                    onTap: () {
                      _updatePizza(_PizzaSizeValue.M);
                    },
                    selected: pizzaSize.value == _PizzaSizeValue.M),
                PizzaSizeButton(
                    text: 'L',
                    onTap: () {
                      _updatePizza(_PizzaSizeValue.L);
                    },
                    selected: pizzaSize.value == _PizzaSizeValue.L)
              ],
            );
          }
        )
      ],
    );
  }

  void _updatePizza(_PizzaSizeValue value) {
    _notifierPizzaSize.value = _PizzaSizeState(value);
    _animationRotationController.forward(from: 0.0);
  }

}

enum _PizzaSizeValue { S, M, L }

class _PizzaSizeState {
  _PizzaSizeState(this.value) : factor = _getFactoryBySize(value);

  final _PizzaSizeValue value;
  final double factor;

  static double _getFactoryBySize(_PizzaSizeValue value) {
    switch (value) {
      case _PizzaSizeValue.S:
        return 0.75;
      case _PizzaSizeValue.M:
        return 0.85;
      case _PizzaSizeValue.L:
        return 1.0;
    }
    return 0.0;
  }
}

