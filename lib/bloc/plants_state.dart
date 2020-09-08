import 'package:cloud_firestore/cloud_firestore.dart';

abstract class PlantsState {}

class PlantsStateInit extends PlantsState {}

class PlantsStateLoading extends PlantsState {}

class PlantsStateLoaded extends PlantsState {}