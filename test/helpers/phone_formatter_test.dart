import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:smile_cell/helpers/phone_formatter.dart";

TextEditingValue typed(String text, {int? cursor}) {
  return TextEditingValue(
    text: text,
    selection: TextSelection.collapsed(offset: cursor ?? text.length),
  );
}

void main() {
  group("formatPhoneForDisplay", () {
    test("menghapus awalan 0", () {
      expect(formatPhoneForDisplay("081234567890"), "81234567890");
    });

    test("menghapus awalan 62", () {
      expect(formatPhoneForDisplay("6281234567890"), "81234567890");
    });

    test("menghapus awalan +62 beserta spasi dan tanda hubung", () {
      expect(formatPhoneForDisplay("+62 812-3456-7890"), "81234567890");
    });

    test("mengabaikan tanda kurung", () {
      expect(formatPhoneForDisplay("(+62) 812 3456 7890"), "81234567890");
    });

    test("nomor yang sudah diawali 8 tidak berubah", () {
      expect(formatPhoneForDisplay("81234567890"), "81234567890");
    });

    test("input kosong tetap kosong", () {
      expect(formatPhoneForDisplay(""), "");
    });

    test("input parsial 6 dan 62 tidak dihapus", () {
      expect(formatPhoneForDisplay("6"), "6");
      expect(formatPhoneForDisplay("62"), "62");
      expect(formatPhoneForDisplay("+62"), "62");
    });

    test("input parsial 0 tidak dihapus", () {
      expect(formatPhoneForDisplay("0"), "0");
    });

    test("awalan dihapus begitu pola 628 atau 08 terbentuk", () {
      expect(formatPhoneForDisplay("628"), "8");
      expect(formatPhoneForDisplay("08"), "8");
    });
  });

  group("formatPhoneForDatabase", () {
    test("menambahkan awalan 0 pada nilai tampilan", () {
      expect(formatPhoneForDatabase("81234567890"), "081234567890");
    });

    test("menormalkan input dengan awalan 0, 62, dan +62", () {
      expect(formatPhoneForDatabase("081234567890"), "081234567890");
      expect(formatPhoneForDatabase("6281234567890"), "081234567890");
      expect(formatPhoneForDatabase("+62 812-3456-7890"), "081234567890");
    });

    test("input kosong mengembalikan string kosong", () {
      expect(formatPhoneForDatabase(""), "");
      expect(formatPhoneForDatabase(" - "), "");
    });
  });

  group("PhoneInputFormatter", () {
    const formatter = PhoneInputFormatter();

    test("menghapus awalan 0 saat mengetik 8", () {
      final result = formatter.formatEditUpdate(typed("0"), typed("08"));
      expect(result.text, "8");
      expect(result.selection.baseOffset, 1);
    });

    test("menunggu pola 628 sebelum menghapus awalan", () {
      expect(formatter.formatEditUpdate(typed(""), typed("6")).text, "6");
      expect(formatter.formatEditUpdate(typed("6"), typed("62")).text, "62");

      final result = formatter.formatEditUpdate(typed("62"), typed("628"));
      expect(result.text, "8");
      expect(result.selection.baseOffset, 1);
    });

    test("membersihkan teks yang ditempel", () {
      final result = formatter.formatEditUpdate(
        typed(""),
        typed("+62 812-3456-7890"),
      );
      expect(result.text, "81234567890");
      expect(result.selection.baseOffset, 11);
    });

    test("posisi kursor tetap benar saat mengetik di tengah", () {
      final result = formatter.formatEditUpdate(
        typed("81234", cursor: 2),
        typed("81-9234", cursor: 4),
      );
      expect(result.text, "819234");
      expect(result.selection.baseOffset, 3);
    });

    test("menghapus semua karakter menghasilkan teks kosong", () {
      final result = formatter.formatEditUpdate(typed("8"), typed(""));
      expect(result.text, "");
      expect(result.selection.baseOffset, 0);
    });
  });
}
