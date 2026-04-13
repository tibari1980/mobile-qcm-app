import 'package:flutter/material.dart';



class IntroStep {

  final String badge;

  final String titleFirst;

  final String titleHighlight;

  final String description;

  final String imagePath;

  final List<IntroFeature> features;



  IntroStep({

    required this.badge,

    required this.titleFirst,

    required this.titleHighlight,

    required this.description,

    required this.imagePath,

    required this.features,

  });

}



class IntroFeature {

  final IconData icon;

  final String title;



  IntroFeature({required this.icon, required this.title});

}



// Data Source for Dynamism

final introData = [

  IntroStep(

    badge: 'ÉTAPE 01 — FONDATIONS',

    titleFirst: 'Maîtrisez la\n',

    titleHighlight: 'République',

    description: "Apprenez les lois et les valeurs de la France à travers des quiz immersifs. Une expérience d'apprentissage d'élite conçue pour votre réussite.",

    imagePath: 'assets/images/eiffel_tour_3d.png',

    features: [

      IntroFeature(icon: Icons.psychology_rounded, title: 'Révision Adaptative'),

      IntroFeature(icon: Icons.verified_rounded, title: 'Score Garanti'),

    ],

  ),

];

