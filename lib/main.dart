import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        appBarTheme: AppbarStyle.getAppbarStyle(),
        elevatedButtonTheme: ElevatedButtonStyle.getElevatedButtonStyle(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int totalPrice;

  @override
  void initState() {
    totalPrice = calculateTotalPrice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return Container(
            margin: const EdgeInsets.all(15.00),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    Text(
                      "My Bag",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'WorkSans'),
                    ),
                  ],
                ),
                SizedBox(
                  height: (orientation == Orientation.portrait) ? 25 : 16,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: contents.length,
                    itemBuilder: (context, index) => ShoppingCard(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      orientation: orientation,
                      index: index,
                      increaseQuantity: () {
                        increaseQuantity(index, orientation);
                        setState(() {});
                      },
                      decreaseQuantity: () {
                        decreaseQuantity(index);
                        setState(() {});
                      },
                    ),
                  ),
                ),
                HomeScreenBottomLayout(
                  orientation: orientation,
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  totalPrice: totalPrice,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(showSnackBar());
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }

  int calculateTotalPrice() {
    totalPrice = 0;
    for (CardData data in contents) {
      totalPrice += data.dressPrice;
    }
    return totalPrice;
  }

  void increaseQuantity(int index, Orientation orientation) {
    if (contents[index].quantity < 5) {
      contents[index].quantity = contents[index].quantity + 1;
      totalPrice += contents[index].dressPrice;
    }
    if (contents[index].quantity == 5) {
      showAlertDialog(index, orientation);
    }
  }

  void showAlertDialog(int index, Orientation orientation) {
    showDialog(
      context: context,
      builder: (context) {
        return AppAlertDialog(
            title: "Congratulations!",
            content:
            "You have added 5 ${contents[index].dressName.toString()} in your bag!",
            orientation: orientation);
      },
    );
  }

  void decreaseQuantity(int index) {
    if (contents[index].quantity > 1) {
      contents[index].quantity = contents[index].quantity - 1;
      totalPrice -= contents[index].dressPrice;
    }
  }

  SnackBar showSnackBar() {
    return SnackBar(
      content: const Text(
        "Congratulations! Your purchase was a success!!",
        style: TextStyle(
          fontSize: 15,
          fontFamily: "WorkSans",
        ),
      ),
      padding: const EdgeInsets.all(20.00),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.green[600],
      elevation: 10,
    );
  }
}

class AppbarStyle{
  static AppBarTheme getAppbarStyle () => const AppBarTheme(
      backgroundColor: Color(0xFFF9F9F9),
      iconTheme: IconThemeData(
        size: 28,
      )
  );
}

class ElevatedButtonStyle{
  static ElevatedButtonThemeData getElevatedButtonStyle() => ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFDB3022),
        elevation: 5,
        shadowColor: Colors.red,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w400,fontFamily: "Worksans"),
      )
  );
}
class AppAlertDialog extends StatelessWidget {
  final String title, content;
  final Orientation orientation;

  const AppAlertDialog(
      {super.key,
        required this.title,
        required this.content,
        required this.orientation});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      title: Center(
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "WorkSans"),
        ),
      ),
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18, fontFamily: "WorkSans"),
      ),
      contentPadding: const EdgeInsets.all(40.00),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: (orientation == Orientation.portrait)
              ? MediaQuery.of(context).size.height * 0.06
              : MediaQuery.of(context).size.height * 0.12,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OKAY"),
          ),
        )
      ],
    );
  }
}
class HomeScreenBottomLayout extends StatelessWidget {
  final Orientation orientation;
  final double screenHeight, screenWidth;
  final Function onPressed;
  final int totalPrice;

  const HomeScreenBottomLayout({
    super.key,
    required this.orientation,
    required this.screenHeight,
    required this.screenWidth,
    required this.onPressed,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (orientation == Orientation.portrait)
          ? screenHeight * 0.14
          : screenHeight * 0.22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Wrap(
                children: [
                  Text(
                    "Total amount",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontFamily: "WorkSans",
                    ),
                  ),
                ],
              ),
              Wrap(
                children: [
                  Text(
                    "${totalPrice.toString()}\$",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: "WorkSans",
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: (orientation == Orientation.portrait) ? 20 : 10,
          ),
          Center(
            child: SizedBox(
              width: screenWidth * 0.9,
              height: (orientation == Orientation.portrait)
                  ? MediaQuery.of(context).size.height * 0.06
                  : MediaQuery.of(context).size.height * 0.12,
              child: ElevatedButton(
                onPressed: () => onPressed(),
                child: const Text("CHECK OUT"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class ShoppingCard extends StatelessWidget {
  final double screenHeight, screenWidth;
  final Orientation orientation;
  final int index;
  final Function increaseQuantity;
  final Function decreaseQuantity;

  const ShoppingCard({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.orientation,
    required this.index,
    required this.increaseQuantity,
    required this.decreaseQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      height: (orientation == Orientation.portrait)
          ? screenHeight * 0.15
          : screenHeight * 0.4,
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.00),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurStyle: BlurStyle.normal,
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.34,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.00),
                  bottomLeft: Radius.circular(10.00)),
              color: const Color(0xFFE3E3E3),
              image: DecorationImage(
                  image: AssetImage(contents[index].dressImage),
                  fit: BoxFit.cover),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(11.00),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        children: [
                          Text(
                            contents[index].dressName,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: "WorkSans"
                            ),
                          ),
                        ],
                      ),
                      const Wrap(
                        alignment: WrapAlignment.end,
                        children: [
                          Icon(
                            Icons.more_vert,
                            color: Colors.grey,
                          ),
                        ],
                      )
                    ],
                  ),
                  Expanded(
                    child: Wrap(
                      children: [
                        Wrap(
                          children: [
                            ShoppingCardLabels.getDressLabel(
                              text: "Color",
                              isLabel: true,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            ShoppingCardLabels.getDressLabel(
                              text: contents[index].dressColor,
                              isLabel: false,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            ShoppingCardLabels.getDressLabel(
                              text: "Size:",
                              isLabel: true,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            ShoppingCardLabels.getDressLabel(
                              text: contents[index].dressSize,
                              isLabel: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: (orientation == Orientation.portrait)
                        ? MediaQuery.of(context).size.height * 0.05
                        : MediaQuery.of(context).size.height * 0.16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ShoppingCardQuantityButton(
                          icon: Icons.remove,
                          onPressed: decreaseQuantity,
                        ),
                        Wrap(
                          children: [
                            Text(
                              contents[index].quantity.toString(),
                              style: const TextStyle(fontSize: 17,fontFamily: "WorkSans"),
                            ),
                          ],
                        ),
                        ShoppingCardQuantityButton(
                          icon: Icons.add,
                          onPressed: increaseQuantity,
                        ),
                        Row(
                          children: [
                            Wrap(
                              children: [
                                Text(
                                  "${contents[index].dressPrice * contents[index].quantity}\$",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "WorkSans",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShoppingCardLabels {
  static Text getDressLabel({required String text, required bool isLabel}) {
    if (isLabel) {
      return Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontFamily: "WorkSans",
        ),
      );
    }
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontFamily: "WorkSans",
      ),
    );
  }
}

class ShoppingCardQuantityButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;

  const ShoppingCardQuantityButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurStyle: BlurStyle.normal,
            blurRadius: 15,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          )
        ],
      ),
      alignment: Alignment.center,
      child: IconButton(
        onPressed: () => onPressed(),
        icon: Icon(
          icon,
          color: Colors.grey,
          size: 26,
        ),
      ),
    );
  }
}
class CardData {
  final String dressName, dressColor, dressSize, dressImage;
  int dressPrice, quantity;

  CardData({
    required this.dressName,
    required this.dressColor,
    required this.dressSize,
    required this.dressPrice,
    required this.dressImage,
    required this.quantity,
  });
}

List<CardData> contents = [
  CardData(
    dressName: "Pullover",
    dressColor: "Black",
    dressSize: "L",
    dressPrice: 51,
    dressImage: "assets/images/pullover.png",
    quantity: 1,
  ),
  CardData(
    dressName: "T-Shirt",
    dressColor: "Grey",
    dressSize: "L",
    dressPrice: 30,
    dressImage: "assets/images/tShirt.png",
    quantity: 1,
  ),
  CardData(
    dressName: "Sport Dress",
    dressColor: "Black",
    dressSize: "M",
    dressPrice: 43,
    dressImage: "assets/images/sport.png",
    quantity: 1,
  )
];