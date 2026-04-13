import 'package:flutter/material.dart';

enum EligibilityStatus {
  exempt,
  mandatory,
  unknown,
}

class EligibilityResult {
  final EligibilityStatus status;
  final String title;
  final String message;
  final List<String> reasons;
  final Color glowColor;

  EligibilityResult({
    required this.status,
    required this.title,
    required this.message,
    required this.reasons,
    required this.glowColor,
  });
}

class EligibilityOption {
  final String id;
  final String label;
  final String? description;

  const EligibilityOption({
    required this.id,
    required this.label,
    this.description,
  });
}

class EligibilityQuestion {
  final String id;
  final String title;
  final String description;
  final List<EligibilityOption> options;

  const EligibilityQuestion({
    required this.id,
    required this.title,
    required this.description,
    required this.options,
  });
}

final List<EligibilityQuestion> eligibilityQuestions = [
  const EligibilityQuestion(
    id: 'nationality',
    title: 'Votre Nationalité',
    description: 'Votre pays d\'origine influe sur les accords bilatéraux.',
    options: [
      EligibilityOption(id: 'fr', label: 'Française', description: 'Citoyen de la République'),
      EligibilityOption(id: 'eu', label: 'Union Européenne', description: 'Espace Économique Européen / Suisse'),
      EligibilityOption(id: 'dz', label: 'Algérienne', description: 'Accords spécifiques 1968'),
      EligibilityOption(id: 'other', label: 'Autre pays', description: 'Hors UE et EEE'),
    ],
  ),
  const EligibilityQuestion(
    id: 'age',
    title: 'Votre Âge',
    description: 'L\'âge peut dispenser de certaines épreuves.',
    options: [
      EligibilityOption(id: 'under_65', label: 'Moins de 65 ans'),
      EligibilityOption(id: 'over_65', label: '65 ans ou plus'),
    ],
  ),
  const EligibilityQuestion(
    id: 'health',
    title: 'État de Santé',
    description: 'Avez-vous un handicap ou un problème de santé chronique ?',
    options: [
      EligibilityOption(id: 'standard', label: 'Standard', description: 'Pas de handicap majeur'),
      EligibilityOption(id: 'certified', label: 'Justifié par certificat', description: 'Empêchement médicalement constaté'),
    ],
  ),
  const EligibilityQuestion(
    id: 'protection',
    title: 'Protection Internationale',
    description: 'Êtes-vous sous la protection de l\'OFPRA ?',
    options: [
      EligibilityOption(id: 'no', label: 'Non', description: 'Situation standard'),
      EligibilityOption(id: 'yes', label: 'Oui', description: 'Réfugié, Apatride ou Protection Subsidiaire'),
    ],
  ),
  const EligibilityQuestion(
    id: 'residence',
    title: 'Durée de Résidence',
    description: 'Combien de temps avez-vous résidé en France ?',
    options: [
      EligibilityOption(id: 'over_5', label: 'Plus de 5 ans'),
      EligibilityOption(id: 'under_5', label: 'Moins de 5 ans'),
      EligibilityOption(id: 'none', label: 'Ne réside pas en France'),
    ],
  ),
  const EligibilityQuestion(
    id: 'request_type',
    title: 'Type de Demande',
    description: 'Quel titre sollicitez-vous ?',
    options: [
      EligibilityOption(id: 'nat', label: 'Naturalisation', description: 'Acquisition de la nationalité'),
      EligibilityOption(id: 'resident_10', label: 'Carte de Résident (10 ans)', description: 'Titre de séjour longue durée'),
      EligibilityOption(id: 'csp', label: 'Carte de séjour pluriannuelle', description: 'Parcours d\'intégration républicaine'),
      EligibilityOption(id: 'renewal', label: 'Renouvellement', description: 'Titre déjà détenu'),
      EligibilityOption(id: 'other', label: 'Autre', description: 'Visiteur, étudiant, etc.'),
    ],
  ),
  const EligibilityQuestion(
    id: 'situation',
    title: 'Situation Particulière',
    description: 'Possédez-vous un diplôme ou un statut spécifique ?',
    options: [
      EligibilityOption(id: 'none', label: 'Aucune / Autre'),
      EligibilityOption(id: 'diploma_fr', label: 'Diplôme français (BAC+)', description: 'Niveau égal ou supérieur au BAC'),
      EligibilityOption(id: 'student', label: 'Étudiant étranger', description: 'En cours d\'études supérieures'),
    ],
  ),
];
