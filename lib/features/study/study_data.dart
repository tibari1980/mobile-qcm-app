import 'package:flutter/material.dart';



class StudyTheme {

  final String id;

  final String title;

  final String subtitle;

  final IconData icon;

  final String contentMarkdown;

  final Color primaryColor;



  const StudyTheme({

    required this.id,

    required this.title,

    required this.subtitle,

    required this.icon,

    required this.contentMarkdown,

    required this.primaryColor,

  });

}



class StudyData {

  static const List<StudyTheme> themes = [

    StudyTheme(

      id: 'vals',

      title: 'Principes et valeurs',

      subtitle: 'Les piliers de la République',

      icon: Icons.account_balance_rounded,

      primaryColor: Color(0xFF00E5FF),

      contentMarkdown: '''

### Les Symboles de la République

- **Le drapeau tricolore** : Emblème national apparu sous la Révolution (Bleu et Rouge : couleurs de Paris, Blanc : couleur de la Royauté).

- **L'hymne national** : *La Marseillaise*, écrite par Rouget de Lisle en 1792.

- **La devise** : *Liberté, Égalité, Fraternité*.

- **Marianne** : Incarne la République et ses valeurs. Souvent coiffée du bonnet phrygien (symbole de liberté).

- **La fête nationale** : Le 14 juillet (célébration de la prise de la Bastille en 1789 et de la fête de la Fédération en 1790).



### Les Principes Fondamentaux (4 piliers)

La France est une République :

- **Indivisible** : Aucune partie du peuple ne peut s'attribuer l'exercice de la souveraineté.

- **Laïque** : Séparation stricte des Églises et de l'État (loi de 1905). Liberté de conscience absolue.

- **Démocratique** : Gouvernement du peuple, par le peuple, pour le peuple (Suffrage universel).

- **Sociale** : Principe d'égalité et de solidarité (ex: Sécurité sociale, éducation gratuite).

      ''',

    ),

    StudyTheme(

      id: 'inst',

      title: 'Organisation politique',

      subtitle: 'Institutions et Pouvoirs',

      icon: Icons.gavel_rounded,

      primaryColor: Color(0xFFFF1744),

      contentMarkdown: '''

### Organisation des Institutions

La **Vème République** (Constitution de 1958) repose sur la séparation des pouvoirs :



1. **Le Pouvoir Exécutif** :

   - **Le Président de la République** : Chef de l'État, élu pour 5 ans. Il réside au Palais de l'Élysée. Il nomme le Premier Ministre.

   - **Le Gouvernement** : Dirigé par le Premier Ministre. Il conduit la politique de la Nation. (Résidence : Hôtel Matignon).



2. **Le Pouvoir Législatif (Le Parlement)** :

   Il vote les lois et contrôle le Gouvernement. Il est composé de :

   - **L'Assemblée Nationale** : 577 Députés élus au suffrage universel direct pour 5 ans (siège au Palais Bourbon).

   - **Le Sénat** : 348 Sénateurs élus au suffrage universel indirect pour 6 ans (siège au Palais du Luxembourg).



3. **Le Pouvoir Judiciaire** :

   Il veille au respect de la loi et sanctionne les infractions.

   - Les juges sont indépendants.

      ''',

    ),

    StudyTheme(

      id: 'droit',

      title: 'Droits et devoirs',

      subtitle: 'Les responsabilités citoyennes',

      icon: Icons.verified_user_rounded,

      primaryColor: Color(0xFF00C853),

      contentMarkdown: '''

### Les Droits du Citoyen Français

- **Droits civils** : Liberté d'expression, liberté de conscience, liberté d'aller et venir, liberté de la presse, droit à la vie privée.

- **Droits politiques** : Droit de voter et de se présenter aux élections.

- **Droits sociaux** : Droit à l'éducation, droit de grève, droit à la santé, droit au travail.



### Les Devoirs du Citoyen Français

- **Le respect de la loi** : Nul n'est censé ignorer la loi.

- **Le devoir de solidarité** : Paiement de l'impôt et des cotisations sociales.

- **Le devoir de sécurité et défense** : Participation à la Journée Défense et Citoyenneté (JDC).

- **Le devoir électoral** : Bien que le vote ne soit pas obligatoire en France (sauf pour les élections sénatoriales), il est considéré comme un grand devoir civique.

      ''',

    ),

    StudyTheme(

      id: 'hist',

      title: 'Histoire de France',

      subtitle: 'Grands événements de la Nation',

      icon: Icons.history_edu_rounded,

      primaryColor: Color(0xFFFF9100),

      contentMarkdown: '''

### Chronologie Rapide

- **Antiquité** : La France s'appelle la Gaule. Romanisation après la victoire de Jules César à Alésia (52 av. J.-C.).

- **Moyen-Âge** : Baptême de Clovis (vers 496). Charlemagne couronné Empereur d'Occident (800). Jeanne d'Arc pendant la Guerre de Cent Ans.

- **Époque Moderne** : Louis XIV (le Roi Soleil) et la construction de Versailles (Monarchie Absolue).

- **La Révolution Française (1789)** : Fin de la monarchie absolue. Déclaration des Droits de l'Homme et du Citoyen (26 août 1789).

- **Première République** (1792).

- **Le XIXe siècle** : Instabilité politique. Empires (Napoléon Ier et III), restaurations monarchiques, et Républiques.

- **La loi de séparation** des Églises et de l'État en 1905 (fondement de la laïcité).

- **Les 2 Guerres Mondiales** : 

  - WWI (1914-1918)

  - WWII (1939-1945), L'Appel du 18 juin 1940 par le Général de Gaulle.

- **Constitution de la Vème République** : 1958.

      ''',

    ),

    StudyTheme(

      id: 'soc',

      title: 'Société et Culture',

      subtitle: 'Le rayonnement de la France',

      icon: Icons.people_alt_rounded,

      primaryColor: Color(0xFFE040FB),

      contentMarkdown: '''

### La France dans le Monde

- La France est membre fondateur de l'**Union Européenne** (Traité de Rome, 1957).

- Elle siège de manière permanente au Conseil de Sécurité de l'ONU.

- Elle possède une Zone Économique Exclusive (ZEE) parmi les plus vastes au monde grâce à ses territoires d'Outre-mer (DROM-COM : Guadeloupe, Martinique, Guyane, La Réunion, Mayotte, Nouvelle-Calédonie, Polynésie, etc.).



### Contribution Culturelle

La France rayonne par ses personnalités :

- **Littérature** : Victor Hugo, Émile Zola, Molière, Voltaire, Rousseau.

- **Sciences** : Marie Curie (Prix Nobel), Louis Pasteur (Vaccin contre la rage).

- **Art et Musique** : Claude Monet (Impressionnisme), Auguste Rodin, Édith Piaf.

- **Architecture** : La Tour Eiffel, Le Mont-Saint-Michel, le Louvre.

      ''',

    ),

  ];

}

