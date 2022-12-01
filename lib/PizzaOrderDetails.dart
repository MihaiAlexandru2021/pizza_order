import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pizza_order/Ingredient.dart';
import 'package:pizza_order/PizzaCartIcon.dart';
import 'package:pizza_order/PizzaOrderHome.dart';
import 'package:pizza_order/PizzaOrderProvider.dart';
import 'PizzaCartButton.dart';
import 'Pizza.dart';
import 'PizzaIngredients.dart';
import 'PizzaOrderBlock.dart';
import 'PizzaSizeButton.dart';

const _pizzaCartSize = 48.0;

class PizzaOrderDetails extends StatefulWidget {
  final Pizza pizza;

  const PizzaOrderDetails({required this.pizza});

  @override
  _PizzaOrderDetailsState createState() => _PizzaOrderDetailsState();
}

class _PizzaOrderDetailsState extends State<PizzaOrderDetails> {
  final block = PizzaOrderBlock();

  @override
  Widget build(BuildContext context) {
    return PizzaOrderProvider(
      block: block,
      child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.brown),
            title: Text(
              widget.pizza.name,
              style: const TextStyle(
                color: Colors.brown,
                fontSize: 28,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            actions: [
              PizzaCartIcon()
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
                          Expanded(
                              flex: 4,
                              child: _PizzaDetails(
                                pizza: widget.pizza,
                              )),
                          Expanded(flex: 2, child: PizzaIngredients()),
                          SizedBox(height: 20),
                        ],
                      ))),
              Positioned(
                bottom: 25,
                height: _pizzaCartSize,
                width: _pizzaCartSize,
                left:
                    MediaQuery.of(context).size.width / 2 - _pizzaCartSize / 2,
                child: PizzaCartButton(
                  onTap: () {
                    block.startPizzaBoxAnimation();
                  },
                ),
              )
            ],
          )),
    );
  }
}

class _PizzaDetails extends StatefulWidget {
  final Pizza pizza;

  const _PizzaDetails({required this.pizza});

  @override
  _PizzaDetailsState createState() => _PizzaDetailsState();
}

class _PizzaDetailsState extends State<_PizzaDetails>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _animationRotationController;
  List<Animation> _animationList = <Animation>[];
  BoxConstraints? _pizzaConstraints;
  final keyPizza = GlobalKey();

  Widget _buildIngredientsWidget(Ingredient? deletedIngredient) {
    List<Widget> elements = [];
    final listIngredients =
        List.from(PizzaOrderProvider.of(context)!.listIngredients);
    if (deletedIngredient != null) {
      listIngredients.add(deletedIngredient);
    }
    if (_animationList.isNotEmpty) {
      for (int i = 0; i < listIngredients.length; i++) {
        Ingredient ingredient = listIngredients[i];
        final ingredientWidget = Image.asset(ingredient.imageUnit, height: 40);
        for (int j = 0; j < ingredient.position.length; j++) {
          final animation = _animationList[j];
          final position = ingredient.position[j];
          final positionX = position.dx;
          final positionY = position.dy;
          double fromX = 0.0, fromY = 0.0;

          if (i == listIngredients.length - 1 &&
              _animationController.isAnimating) {
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
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final block = PizzaOrderProvider.of(context);
      block!.notifierPizzaBoxAnimation.addListener(() {
        if (block.notifierPizzaBoxAnimation.value) {
          addPizzaToCart();
        }
      });
    });
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
    block?.notifierTotal.value = widget.pizza.price.toInt();
    block?.notifierPizzaPrice.value = widget.pizza.price.toInt();
    return Column(
      children: [
        Expanded(
          child: DragTarget<Ingredient>(onAccept: (ingredient) {
            block!.notifierFocused.value = false;
            block.addIngredient(ingredient);//TODO: Check price++
            _buildIngredientsAnimation();
            _animationController.forward(from: 0.0);
          }, onWillAccept: (ingredient) {
            block!.notifierFocused.value = true;
            return !block.containsIngredient(ingredient!);
          }, onLeave: (ingredient) {
            block!.notifierFocused.value = false;
          }, builder: (context, list, rejects) {
            return LayoutBuilder(
              builder: (context, constraints) {
                _pizzaConstraints = constraints;
                return ValueListenableBuilder<PizzaMetadata?>(
                    valueListenable: block!.notifierPizzaImage,
                    builder: (context, data, child) {
                      if (data != null) {
                        Future?.microtask(() => _startPizzaBoxAnimation(data));
                      }

                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 60),
                        opacity: data != null ? 0.0 : 1,
                        child: ValueListenableBuilder<PizzaSizeState>(
                            valueListenable: block.notifierPizzaSize,
                            builder: (context, pizzaSize, _) {
                              return RepaintBoundary(
                                key: keyPizza,
                                child: RotationTransition(
                                  turns: CurvedAnimation(
                                      curve: Curves.elasticOut,
                                      parent: _animationRotationController),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: ValueListenableBuilder<bool>(
                                          valueListenable:
                                              block.notifierFocused,
                                          builder: (context, focused, _) {
                                            return AnimatedContainer(
                                              duration: const Duration(
                                                  microseconds: 400),
                                              height: focused
                                                  ? constraints.maxHeight *
                                                      pizzaSize.factor
                                                  : constraints.maxHeight *
                                                          pizzaSize.factor -
                                                      10,
                                              child: Stack(
                                                children: [
                                                  DecoratedBox(
                                                    decoration:
                                                        const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            boxShadow: [
                                                          BoxShadow(
                                                              blurRadius: 15.0,
                                                              color: Colors
                                                                  .black26,
                                                              offset: Offset(
                                                                  0.0, 3.0),
                                                              spreadRadius: 5.0)
                                                        ]),
                                                    child: Image.asset(
                                                        'assets/images/dish.png'),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Image.asset(
                                                          widget.pizza.image))
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      ValueListenableBuilder<Ingredient?>(
                                          valueListenable:
                                              block.notifierDeletedIngredient,
                                          builder:
                                              (context, deletedIngredient, _) {
                                            _animateRemovedIngredient(
                                                deletedIngredient);
                                            return AnimatedBuilder(
                                                animation: _animationController,
                                                builder: (context, _) {
                                                  return _buildIngredientsWidget(
                                                      deletedIngredient);
                                                });
                                          })
                                    ],
                                  ),
                                ),
                              );
                            }),
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
                  '$totalValue \$',
                  key: UniqueKey(),
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown),
                ),
              );
            }),
        const SizedBox(height: 15),
        ValueListenableBuilder<PizzaSizeState>(
            valueListenable: block.notifierPizzaSize,
            builder: (context, pizzaSize, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PizzaSizeButton(
                      text: 'S',
                      onTap: () {
                        _updatePizza(PizzaSizeValue.S);
                      },
                      selected: pizzaSize.value == PizzaSizeValue.S),
                  PizzaSizeButton(
                      text: 'M',
                      onTap: () {
                        _updatePizza(PizzaSizeValue.M);
                      },
                      selected: pizzaSize.value == PizzaSizeValue.M),
                  PizzaSizeButton(
                      text: 'L',
                      onTap: () {
                        _updatePizza(PizzaSizeValue.L);
                      },
                      selected: pizzaSize.value == PizzaSizeValue.L)
                ],
              );
            })
      ],
    );
  }

  Future<void> _animateRemovedIngredient(Ingredient? deletedIngredient) async {
    if (deletedIngredient != null) {
      await _animationController.reverse(from: 1.0);
      final block = PizzaOrderProvider.of(context);
      block!.refreshRemoveIngredient();
    }
  }

  void _updatePizza(PizzaSizeValue value) {
    final block = PizzaOrderProvider.of(context);
    block!.notifierPizzaSize.value = PizzaSizeState(value);
    _animationRotationController.forward(from: 0.0);
  }

  void addPizzaToCart() {
    final block = PizzaOrderProvider.of(context);
    RenderRepaintBoundary? boundary =
        keyPizza.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    block!.transformToImage(boundary!);
  }

  OverlayEntry? overlayEntry;

  void _startPizzaBoxAnimation(PizzaMetadata metadata) {
    final block = PizzaOrderProvider.of(context);
    if (overlayEntry == null) {
      overlayEntry = OverlayEntry(builder: (context) {
        return PizzaOrderAnimation(
          metadata: metadata,
          onComplete: () {
            overlayEntry!.remove();
            overlayEntry = null;
            block!.reset();
          },
        );
      });
      Overlay.of(context)!.insert(overlayEntry!);
    }
  }
}

class PizzaOrderAnimation extends StatefulWidget {
  const PizzaOrderAnimation(
      {Key? key, required this.metadata, required this.onComplete})
      : super(key: key);

  final PizzaMetadata metadata;
  final VoidCallback onComplete;

  @override
  State<PizzaOrderAnimation> createState() => _PizzaOrderAnimationState();
}

class _PizzaOrderAnimationState extends State<PizzaOrderAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pizzaScaleAnimation;
  late Animation<double> _pizzaOpacityAnimation;
  Animation<double>? _boxEnterScaleAnimation;
  late Animation<double> _boxExitScaleAnimation;
  Animation<double>? _boxExitToCartAnimation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    _pizzaScaleAnimation = Tween(begin: 1.0, end: 0.5).animate(
        CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.2)));
    _pizzaOpacityAnimation =
        CurvedAnimation(parent: _controller, curve: Interval(0.2, 0.4));
    _boxEnterScaleAnimation =
        CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.2));
    _boxExitScaleAnimation = Tween(begin: 1.0, end: 1.3).animate(
        CurvedAnimation(parent: _controller, curve: Interval(0.6, 0.75)));
    _boxExitToCartAnimation =
        CurvedAnimation(parent: _controller, curve: Interval(0.85, 1.0));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });
    _controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metadata = widget.metadata;
    return Positioned(
      top: metadata.position.dy,
      left: metadata.position.dx,
      width: metadata.size.width,
      height: metadata.size.height,
      child: GestureDetector(
        onTap: () {
          widget.onComplete();
        },
        child: AnimatedBuilder(
            animation: _controller,
            builder: (context, snapshot) {
              final moveToX = _boxExitToCartAnimation!.value > 0
                  ? metadata.position.dx +
                      metadata.size.width / 2 * _boxExitToCartAnimation!.value
                  : 0.0;

              final moveToY = _boxExitToCartAnimation!.value > 0
              ? -metadata.size.height / 1.5 * _boxExitToCartAnimation!.value
              : 0.0;

              return Opacity(
                opacity: 1 - _boxExitToCartAnimation!.value,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..translate(moveToX, moveToY)
                    ..rotateZ(_boxExitToCartAnimation!.value)
                    ..scale(_boxExitScaleAnimation.value),
                  child: Transform.scale(
                  alignment: Alignment.center,
                  scale: 1 - _boxExitToCartAnimation!.value,
                    child: Stack(
                      children: [
                        _buildBox(),
                        Opacity(
                          opacity: 1 - _pizzaOpacityAnimation.value,
                          child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..scale(_pizzaScaleAnimation.value)
                                ..translate(
                                    0.0, 20 * (1 - _pizzaOpacityAnimation.value)),
                              child: Image.memory(widget.metadata.imageBytes)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget _buildBox() {
    return LayoutBuilder(
      builder: (context, constrains) {
        final boxHeight = constrains.maxHeight / 2.0;
        final boxWidth = constrains.maxWidth / 2.0;
        final minAngle = -45.0;
        final maxAngle = -125;
        final boxClosingValue =
            lerpDouble(minAngle, maxAngle, 1 - _pizzaOpacityAnimation.value);

        return Opacity(
          opacity: _boxEnterScaleAnimation!.value,
          child: Transform.scale(
            scale: _boxEnterScaleAnimation!.value,
            child: Stack(
              children: [
                Center(
                  child: Transform(
                      alignment: Alignment.topCenter,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.003)
                        ..rotateX(
                          degressToRads(minAngle).toDouble(),
                        ),
                      child: Image.asset(
                        'assets/images/box_inside.png',
                        height: boxHeight,
                        width: boxWidth,
                      )),
                ),
                Center(
                  child: Transform(
                      alignment: Alignment.topCenter,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.003)
                        ..rotateX(
                          degressToRads(boxClosingValue!).toDouble(),
                        ),
                      child: Image.asset(
                        'assets/images/box_inside.png',
                        height: boxHeight,
                        width: boxWidth,
                      )),
                ),
                if (boxClosingValue >= -123)
                  Center(
                    child: Transform(
                        alignment: Alignment.topCenter,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.003)
                          ..rotateX(
                            degressToRads(boxClosingValue).toDouble(),
                          ),
                        child: Image.asset(
                          'assets/images/box_front.png',
                          height: boxHeight,
                          width: boxWidth,
                        )),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

num degressToRads(num deg) {
  return (deg * pi) / 180.0;
}
