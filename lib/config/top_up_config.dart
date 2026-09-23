import "package:flutter/material.dart";
import "package:smile_cell/data/models/payment_model.dart";
import "package:smile_cell/helpers/navigation.dart";
import "package:smile_cell/pages/top_up_screen.dart";

const minTopUpAmount = 10000;
const maxTopUpAmount = 10000000;
const transferTimeLimit = Duration(hours: 24);

const supportedBanks = <PaymentMethod>[
  PaymentMethod(
    id: "bri",
    name: "BRI",
    accountNumber: "19284028102940",
    logoAsset: "BRI.png",
  ),
  PaymentMethod(
    id: "bca",
    name: "BCA",
    accountNumber: "8720193746",
    logoAsset: "BCA.png",
  ),
  PaymentMethod(
    id: "cimb-niaga",
    name: "CIMB NIAGA",
    accountNumber: "706812349980",
    logoAsset: "CIMB.png",
  ),
];

Future<void> openTopUpScreen(BuildContext context) {
  return pushSlide(context, const TopUpScreen());
}