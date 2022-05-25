import 'package:auction/cubit/cubit.dart';
import 'package:auction/cubit/states.dart';
import 'package:auction/old/screens/profiles/shopping_cart_screen.dart';
import 'package:auction/old/screens/login_screen.dart';
import 'package:auction/old/screens/profiles/all_my_auctions.dart';
import 'package:auction/old/screens/profiles/favorite_screen.dart';
import 'package:auction/old/screens/profiles/my_reports_screen.dart';
import 'package:auction/old/screens/profiles/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuctionCubit, AuctionStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = AuctionCubit.get(context).model;
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.teal,
            title: const Text(
              'Auction',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/222.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Align(
                        child: Container(
                          height: 70.0,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                4.0,
                              ),
                              topRight: Radius.circular(
                                4.0,
                              ),
                            ),
                          ),
                        ),
                        alignment: AlignmentDirectional.topCenter,
                      ),
                      CircleAvatar(
                        radius: 64.0,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius: 60.0,
                          backgroundImage: NetworkImage(
                            '${userModel.image}',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '${userModel.name}',
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${userModel.email}',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Flexible(
                    child: Container(),
                    flex: 3,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const MyReportsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Reports',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(Icons.edit_sharp),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const FavoriteScreen(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Favorite',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(Icons.favorite),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AllMyAuctionsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'All My Auctions',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(Icons.edit_sharp),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ShoppingCartScreen(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'My Shopping Cart',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(Icons.shopping_cart_outlined),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(),
                    flex: 1,
                  ),
                  TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut().then((value) =>
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                              (route) => false));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.52,
                      decoration: const BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Log out',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(Icons.logout),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(),
                    flex: 3,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}