import 'package:flutter/material.dart';

class UserAccount {
  String name, email;
  UserAccount({required this.name, required this.email});
}

class TicketModel {
  final String from, to, airline, time, gate, seat;
  final List<String> passengers;

  TicketModel({
    required this.from,
    required this.to,
    required this.airline,
    required this.time,
    required this.gate,
    required this.seat,
    required this.passengers,
  });
}