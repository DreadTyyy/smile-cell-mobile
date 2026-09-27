import "package:flutter/material.dart";
import "package:smile_cell/data/models/send_balance_model.dart";
import "package:smile_cell/helpers/navigation.dart";
import "package:smile_cell/pages/send_balance_screen.dart";

const minSendAmount = 10000;
const maxSendAmount = 5000000;
const sendBalanceFee = 0;

const dummyRecipients = <Recipient>[
  Recipient(
    id: "1",
    name: "John Smile",
    phoneNumber: "081234567890",
  ),
  Recipient(
    id: "2",
    name: "Adib Haidar",
    phoneNumber: "085712345678",
  ),
  Recipient(
    id: "3",
    name: "Vitto Rendi",
    phoneNumber: "087812349900",
  ),
  Recipient(
    id: "3",
    name: "Naufal Helmy",
    phoneNumber: "081387564344",
  ),
];

Recipient? findRecipient(String phoneNumber) {
  for (final recipient in dummyRecipients) {
    if (recipient.phoneNumber == phoneNumber) {
      return recipient;
    }
  }
  return null;
}

Future<void> openSendBalanceScreen(BuildContext context) {
  return pushSlide(context, const SendBalanceScreen());
}