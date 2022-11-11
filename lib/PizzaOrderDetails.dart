import 'package:flutter/material.dart';
import 'package:pizza_order/Ingredient.dart';

const _pizzaCartSize = 48.0;

class PizzaOrderDetails extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        Expanded(flex: 5, child: _PizzaDetails()),
                        Expanded(flex: 2, child: _PizzaIngredients()),
                        SizedBox(height: 20),
                      ],
                    ))),
            Positioned(
              bottom: 25,
              height: _pizzaCartSize,
              width: _pizzaCartSize,
              left: MediaQuery.of(context).size.width / 2 - _pizzaCartSize / 2,
              child: _PizzaCartButton(
                onTap: (){
                  print('cart');
                },
              ),
            )
          ],
        ));
  }
}

class _PizzaDetails extends StatefulWidget {
  @override
  _PizzaDetailsState createState() => _PizzaDetailsState();
}

class _PizzaDetailsState extends State<_PizzaDetails>
    with SingleTickerProviderStateMixin {
  final _listIngredients = <Ingredient>[];
  late AnimationController _animationController;
  double _total = 15.0;
  final _notifierFocused = ValueNotifier(false);
  List<Animation> _animationList = <Animation>[];
  BoxConstraints? _pizzaConstraints;

  Widget _buildIngredientsWidget() {
    List<Widget> elements = [];
    if(_animationList.isNotEmpty) {
      for (int i = 0; i < _listIngredients.length; i++ ) {
        Ingredient ingredient = _listIngredients[i];
        final ingredientWidget = Image.asset(ingredient.imageUnit, height: 40);
        for (int j = 0; j < ingredient.position.length; j++) {
          final animation = _animationList[j];
          final position = ingredient.position[j];
          final positionX = position.dx;
          final positionY = position.dy;
          double fromX = 0.0, fromY = 0.0;

          if (i == _listIngredients.length - 1) {
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
              elements.add(
                Opacity(
                  opacity: opacity,
                  child: Transform(
                      transform: Matrix4.identity()
                        ..translate(
                          fromX + (_pizzaConstraints?.maxWidth)! * positionX,
                          fromY + (_pizzaConstraints?.maxHeight)! * positionY,
                        ), child: ingredientWidget
                  )
                )
              );
            }
          } else {
            elements.add(
                Transform(
                  transform: Matrix4.identity()
                    ..translate(
                      (_pizzaConstraints?.maxWidth)! * positionX,
                      (_pizzaConstraints?.maxHeight)! * positionY,
                    ), child: ingredientWidget
                )
            );
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
        vsync: this, duration: const Duration(milliseconds: 400));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
        children: [
          Expanded(
            child: DragTarget<Ingredient>(
                onAccept: (ingredient) {
                  print('onAccept');
                  _notifierFocused.value = false;
                  setState(() {
                    _total++;
                    _listIngredients.add(ingredient);
                  });
                  _buildIngredientsAnimation();
                  _animationController.forward(
                    from: 0.0
                  );
                },
                onWillAccept: (ingredient) {
                  print('onWillAccept');
                  _notifierFocused.value = true;
                  for (Ingredient i in _listIngredients) {
                    if (i.compare(ingredient!)) {
                      return false;
                    }
                  }
                  return true;
                },
                onLeave: (ingredient) {
                  print('onLeave');
                  _notifierFocused.value = false;
                }, builder: (context, list, rejects) {
                return LayoutBuilder(
                builder: (context, constraints) {
                  _pizzaConstraints = constraints;
                  return Stack(
                    children: [
                      Center(
                        child: ValueListenableBuilder<bool>(
                          valueListenable: _notifierFocused,
                          builder: (context, focused, _) {
                            return AnimatedContainer(
                              //TODO CHECK
                              duration: const Duration(microseconds: 400),
                              height: focused
                                  ? constraints.maxHeight
                                  : constraints.maxHeight - 10,
                              child: Stack(
                                children: [
                                  Image.asset('assets/images/dish.png'),
                                  Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Image.asset('assets/images/pizza-1.png'))
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
                          }
                       )
                    ],
                  );
                },
              );
            }),
          ),
          const SizedBox(height: 5),
          AnimatedSwitcher(
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
              '\$$_total',
              key: UniqueKey(),
              style: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.bold, color: Colors.brown),
            ),
          )
        ],
      ),
    ]
    );
  }
}

class _PizzaCartButton extends StatefulWidget {

  const _PizzaCartButton({Key? key, required this.onTap}) : super(key: key);

  final VoidCallback onTap;

  @override
  _PizzaCartButtonState createState() => _PizzaCartButtonState();
}

class _PizzaCartButtonState extends State<_PizzaCartButton> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;


  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      upperBound: 1.0,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 500)
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _animateButton() async {
    await _animationController.forward(from: 0.0);
    await _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        widget.onTap();
        _animateButton();
      },
      child: AnimatedBuilder(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.orange.withOpacity(0.5),
                    Colors.orange
                  ]
              ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 15.0,
                offset: Offset(0.0, 4.0),
                spreadRadius: 4.0
              )
            ]
          ),
          child: Icon(
            Icons.shopping_cart_outlined,
            color: Colors.white,
            size: 35,
          ),
        ),
        animation: _animationController,
        builder: (context, child){
          return Transform.scale(
            scale: 2 - _animationController.value,
            child: child
          );
        },
      ),
    );
  }
}

class _PizzaIngredients extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ingredients.length,
        itemBuilder: (context, index) {
          final ingredient = ingredients[index];
          return _PizzaIngredientItem(ingredient: ingredient);
        });
  }
}

class _PizzaIngredientItem extends StatelessWidget {
  const _PizzaIngredientItem({Key? key, required this.ingredient})
      : super(key: key);
  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    final child = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7.0),
        child: Container(
          height: 45,
          width: 45,
          decoration:
              BoxDecoration(color: Color(0xFFF5EED3), shape: BoxShape.circle),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.asset(ingredient.image, fit: BoxFit.contain),
          ),
        ));

    return Center(
        child: Draggable(
            feedback: DecoratedBox(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10.0,
                      color: Colors.black26,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 5.0)
                  ],
              ),
              child: child,
            ),
            data: ingredient,
            child: child));
  }
}
