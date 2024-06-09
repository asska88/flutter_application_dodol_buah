import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/auth/auth_service.dart';

class UserProfileWidget extends StatefulWidget {
  const UserProfileWidget({super.key});

  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
final AuthService _authService = AuthService();
  User? _user;
@override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _authService.fetchUserData();

  }

  Future<void> fetchUserData() async {
    if (_user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();
      if (userDoc.exists) {
        setState(() {});
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _userProfile(),
    );
  }

  StreamBuilder<User?> _userProfile() {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            final user = snapshot.data;
            return user != null
                ? FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData && snapshot.data!.exists) {
                        final userData =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(_user?.photoURL ?? ''),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                  'Nama: ${userData['displayName'] ?? user.displayName ?? ''}'),
                              const SizedBox(height: 8),
                              Text('Email: ${user.email}'),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _signOut,
                                child: const Text('Sign Out'),
                              ),
                            ]));
                      } else {
                        return const Center(child: Text('Anda belum login.'));
                      }
                    },
                  )
                : const Center();
          } else {
            return const Text('Anda belum login.');
          }
        });
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted){setState(() {
      _user = null;
    });
      Navigator.pushReplacementNamed(context, '/');
    }
  }
  }
