// TODO: LOGIC EDIT PROFILE

import 'package:flutter/material.dart';
import 'package:smile_cell/helpers/navigation.dart';
import 'package:smile_cell/pages/edit_phone_number_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _fullNameController = TextEditingController();
  final _cityController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.0,
        title: Text(
          "Edit Profil",
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0),
            child: Column(
              children: [
                // === PHONENUMBER ====
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8.0,
                  children: [
                    Text(
                      "Nomor Handphone",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        color: Color(0xCC000000),
                      )
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(16.0, 6.0, 6.0, 6.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Color(0xFFDDDDDD), width: 1.0)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "+62 845 3434 4343",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withValues(alpha: 0.6)
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => {
                                pushSlide(context, EditPhoneNumberScreen())
                              },
                              borderRadius: BorderRadius.circular(4.0),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                child: Text(
                                  "Edit",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Theme.of(context).colorScheme.primary
                                  ),
                                )
                              ),
                            ),
                          )
                        ],
                      )
                    )
                  ],
                ),

                SizedBox(height: 16.0),
                // === FULLNAME ====
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8.0,
                  children: [
                    Text(
                      "Nama Lengkap",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        color: Color(0xCC000000),
                      )
                    ),
                    TextFormField(
                      controller: _fullNameController,
                      textInputAction: TextInputAction.done,
                      validator: (value) => null,
                      style: TextStyle(fontSize: 16.0),
                      decoration: InputDecoration(
                        hintText: "Masukkan nama lengkap",
                        hintStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black.withValues(alpha: 0.6),
                        ),
                        errorStyle: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.error,
                          height: 1.2
                        ),
                        errorMaxLines: 2,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 14.0
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: _border(Color(0xFFDDDDDD)),
                        focusedBorder: _border(Theme.of(context).colorScheme.primary),
                        errorBorder: _border(Theme.of(context).colorScheme.error),
                        focusedErrorBorder: _border(Theme.of(context).colorScheme.error),
                        border: _border(Color(0xFFDDDDDD))
                      ),
                    )
                  ],
                ),

                SizedBox(height: 16.0),
                
                // ==== CITY ====
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8.0,
                  children: [
                    Text(
                      "Kota",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        color: Color(0xCC000000),
                      )
                    ),
                    TextFormField(
                      controller: _cityController,
                      textInputAction: TextInputAction.done,
                      validator: (value) => null,
                      style: TextStyle(fontSize: 16.0),
                      decoration: InputDecoration(
                        hintText: "Contoh: Surakarta",
                        hintStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black.withValues(alpha: 0.6),
                        ),
                        errorStyle: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.error,
                          height: 1.2
                        ),
                        errorMaxLines: 2,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 14.0
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: _border(Color(0xFFDDDDDD)),
                        focusedBorder: _border(Theme.of(context).colorScheme.primary),
                        errorBorder: _border(Theme.of(context).colorScheme.error),
                        focusedErrorBorder: _border(Theme.of(context).colorScheme.error),
                        border: _border(Color(0xFFDDDDDD))
                      ),
                    )
                  ],
                ),
                
                const Spacer(),
            
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54.0,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C93CB),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 0.0,
                        ),
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        "Simpan",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),
      )
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(color: color, width: 1.0)
  );
}