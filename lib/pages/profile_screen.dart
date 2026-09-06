import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.0,
        title: Text(
          "Profil",
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _HeaderProfile(),
            SizedBox(height: 24.0),
            _DetailProfile(),
            SizedBox(height: 24.0),
            _ListMenu()
          ]
        ),
      )
    );
  }
}

class _HeaderProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.0),
        Text(
          "+62 8523 2343 8439",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          "Kode Agent: 54540",
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.black.withValues(alpha: 0.6),
          ),
        )
      ],
    );
  }
}

class _DetailProfile extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    final profile = [
      {'key': "Nama", 'value': "John Doe"},
      {'key': "Kota", 'value': "Surakarta"},
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0,2), 
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16.0
          )]
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFDDDDDD),
                  width: 1.0,
                )
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Informasi Pengguna",
                  style: TextStyle(
                    fontSize: 16.0,
                  )
                ),
                Row(
                  children: [
                    Icon(Icons.edit,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Text(
                      "Edit",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          ...profile.map((item) {
            return Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFDDDDDD),
                    width: 1.0,
                  )
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['key'] ?? "",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withValues(alpha: 0.8)
                    ),
                  ),
                  Text(
                    item['value'] ?? "",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black
                    ),
                  )
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}

class _ListMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final menus = [
      {'imageIcon': 'contact_support.svg', 'title': 'Contact Support', 'onTap': () => {}},
      {'imageIcon': 'logout.svg', 'title': 'Keluar', 'onTap': () => {}},
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: menus.map((item) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFDDDDDD), width: 1))),
            child: Row(
              spacing: 16.0,
              children: [
                SvgPicture.asset(item['imageIcon'].toString(),
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
                Text(
                  item['title'].toString(),
                  style: TextStyle(
                    fontSize: 16.0
                  ),
                )
              ],
            ),
          );
        }).toList(),
      )
    );
  }
}