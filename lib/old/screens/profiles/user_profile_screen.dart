import 'package:auction/cubit/cubit.dart';
import 'package:auction/cubit/states.dart';
import 'package:auction/old/resources/models/post_model.dart';
import 'package:auction/old/screens/online_screens/online_auction_event_screen.dart';
import 'package:auction/old/screens/online_screens/online_manage_screen.dart';
import 'package:auction/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../theme.dart';

class UserProfileScreen extends StatefulWidget {
  final String name;
  final String id;
  const UserProfileScreen({Key? key, required this.name, required this.id})
      : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState(
        name: name,
        id: id,
      );
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  CollectionReference db = FirebaseFirestore.instance.collection('posts');
  final TextEditingController _reportController = TextEditingController();

  final int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      AuctionCubit.get(context).onItemTapped(index);

      print(index);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const OnlineMangScreen()),
          (route) => false);
    });
  }

  _UserProfileScreenState({
    required this.name,
    required this.id,
  });
  String name;
  String id;
  @override
  void initState() {
    super.initState();
    AuctionCubit.get(context).getUserProfile(id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuctionCubit, AuctionStates>(
        listener: (context, state) {},
        builder: (context, state) {
          // var userModel = AuctionCubit.get(context).model;
          var userModel = AuctionCubit.get(context).usermodel;

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.teal,
              title: Text(
                name,
                style: const TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/222.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15.0,
                    ),
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
                      height: 15.0,
                    ),
                    Text(
                      '${userModel.name}',
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      '${userModel.email}',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    SizedBox(
                      height: 500,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: id)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (ctx, index) => Container(
                              child: PostCard3(
                                  context: context,
                                  snap: snapshot.data!.docs[index].data(),
                                  userid: userModel.uid.toString()),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  backgroundColor: primaryColor,
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  backgroundColor: primaryColor,
                  icon: Icon(Icons.hail_outlined),
                  label: 'My Auctions',
                ),
                BottomNavigationBarItem(
                  backgroundColor: primaryColor,
                  icon: Icon(Icons.add),
                  label: 'AddPost',
                ),
                BottomNavigationBarItem(
                  backgroundColor: primaryColor,
                  icon: Icon(Icons.account_circle),
                  label: 'profile',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.white,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              backgroundColor: primaryColor,
              unselectedItemColor: Colors.white,
            ),
          );
        });
  }

  int duration = 10;
  late int doo;
  late PostModel SelectedPost;
  late Map post1 = {
    'name': '',
    'titel': '',
    'postdate': '',
    'image': '',
    'postImage': '',
    'isStarted': '',
    'category': '',
    'token': ''
  };

  Widget PostCard3({required dynamic snap, context, required String userid}) {
    return GestureDetector(
      onTap: () {
        AuctionCubit.get(context).getPostUserTocken(
          snap['uid'].toString(),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OnlineEventScreen(
              snap['postId'].toString(),
              doo = (snap['startAuction'].toDate())!
                  .difference(DateTime.now())
                  .inSeconds,
              duration: doo,
              post1: {
                'name': snap['name'].toString(),
                'uid': snap['uid'].toString(),
                'titel': snap['titel'].toString(),
                'postdate': snap['postTime'].toDate(),
                'image': snap['image'].toString(),
                'postImage': snap['image'].toString(),
                'startAuction': snap['startAuction'].toDate(),
                'price': snap['price'].toString(),
                'description': snap['description'].toString(),
                'category': snap['category'].toString(),
              },
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 5,
          right: 5,
          top: 5,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.teal.withOpacity(0.2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.teal,
                              backgroundImage: NetworkImage(
                                snap['image'].toString(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snap['name'].toString(),
                              style: TextStyle(
                                color: Colors.teal[600],
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                                '${DateFormat.yMd().add_jm().format(snap['postTime'].toDate())} '),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snap['titel'].toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.teal[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                    ' ${DateFormat.yMd().add_jm().format(snap['startAuction'].toDate())}  '),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.40,
                                child: Text(
                                  snap['description'].toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.teal[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              snap['winner'].toString() != "null"
                                  ? Text(
                                      snap['winner'].toString(),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.teal,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  : const Text(
                                      'no One play in this item',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.teal,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                              Text(
                                snap['category'].toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.teal,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.52,
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                  snap['postImage'].toString(),
                                ),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
