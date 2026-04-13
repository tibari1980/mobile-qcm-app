import json
import os

def generate_questions():
    questions = []
    
    # --- THEME 1: PRINCIPES & VALEURS (vals_principes) ---
    theme1_data = [
        ("Quelle est la devise de la République française ?", ["Liberté, Égalité, Fraternité", "Paix, Progrès, Solidarité", "Travail, Famille, Patrie"], 0, "La devise est inscrite dans l'article 2 de la Constitution.", "CSP, CR, NAT"),
        ("Quelle est la signification de la Laïcité en France ?", ["L'interdiction de toutes les religions", "La neutralité de l'Etat et la liberté de conscience", "La promotion d'une religion officielle"], 1, "L'Etat est neutre et garantit le libre exercice des cultes.", "CSP, CR, NAT"),
        ("Qui est Marianne ?", ["Une ancienne reine de France", "Une figure allégorique de la République", "La première femme présidente"], 1, "Marianne incarne la République et ses valeurs.", "CSP, CR, NAT"),
        ("Le principe d'égalité entre femmes et hommes est-il inscrit dans la loi ?", ["Oui, c'est un principe fondamental", "Non, c'est optionnel", "Seulement dans le secteur privé"], 0, "L'égalité est garantie par la Constitution et la loi.", "CSP, CR, NAT"),
        ("Le drapeau français possède trois couleurs. Lesquelles ?", ["Bleu, Blanc, Rouge", "Vert, Blanc, Rouge", "Bleu, Jaune, Rouge"], 0, "Le drapeau tricolore est l'emblème national de la République.", "CSP, CR, NAT"),
        ("Que fête-t-on le 14 juillet ?", ["La fin de la Seconde Guerre mondiale", "La Fête nationale (Prise de la Bastille et Fédération)", "Le début de l'été"], 1, "Le 14 juillet commémore la prise de la Bastille (1789) et la Fête de la Fédération (1790).", "CSP, CR, NAT"),
        ("Peut-on être discriminé pour sa religion lors d'un entretien d'embauche ?", ["Oui, c'est le choix de l'employeur", "Non, c'est strictement interdit par la loi", "Seulement pour les postes publics"], 1, "La discrimination est un délit en France.", "CSP, CR, NAT"),
        ("Le buste de Marianne est présent dans :", ["Toutes les mairies de France", "Uniquement à l'Élysée", "Seulement dans les préfectures"], 0, "Le buste de Marianne est un symbole de la République présent dans les mairies.", "CSP, CR, NAT"),
        ("La liberté de conscience permet de :", ["Croire ou ne pas croire en une religion", "Ne pas respecter les lois", "Imposer sa religion aux autres"], 0, "La liberté de conscience est un droit individuel fondamental.", "CSP, CR, NAT"),
        ("La fraternité implique :", ["La solidarité entre tous les citoyens", "L'obligation de vivre ensemble", "Le rejet des étrangers"], 0, "La fraternité est le troisième pilier de la devise républicaine.", "CSP, CR, NAT"),
    ]

    # --- THEME 2: INSTITUTIONS & POLITIQUE (institutions) ---
    theme2_data = [
        ("Qui élit le Président de la République ?", ["Le Parlement", "Les citoyens français au suffrage universel", "Le Gouvernement"], 1, "Le Président est élu pour 5 ans au suffrage universel direct.", "CSP, CR, NAT"),
        ("Quel est le rôle du Parlement ?", ["Exécuter les lois", "Voter les lois et contrôler le Gouvernement", "Rendre la justice"], 1, "Le Parlement est composé de l'Assemblée nationale et du Sénat.", "CSP, CR, NAT"),
        ("Où siège le Premier ministre ?", ["Au Palais de l'Elysée", "À l'Hôtel de Matignon", "Au Palais Bourbon"], 1, "Matignon est la résidence officielle du Premier ministre.", "CR, NAT"),
        ("La France est divisée en collectivités territoriales. Lesquelles ?", ["Communes, Départements, Régions", "Cantons et Villages uniquement", "Préfectures et Mairies"], 0, "L'organisation de la France est décentralisée.", "CSP, CR, NAT"),
        ("Quel est l'âge minimum pour voter en France ?", ["16 ans", "18 ans", "21 ans"], 1, "Le droit de vote est ouvert à 18 ans.", "CSP, CR, NAT"),
        ("Comment s'appelle le texte fondamental de la 5ème République ?", ["Le Code Civil", "La Constitution de 1958", "La Déclaration des Droits de l'Homme"], 1, "La Constitution définit l'organisation des pouvoirs publics.", "CR, NAT"),
        ("Qui nomme le Premier ministre ?", ["Le Président de la République", "Les députés", "Les sénateurs"], 0, "Le Président nomme le Premier ministre selon la majorité au Parlement.", "CR, NAT"),
        ("Le Parlement siège dans deux lieux. Lesquels ?", ["Palais Bourbon et Palais du Luxembourg", "Palais de l'Élysée et Matignon", "Hôtel de Ville et Préfecture"], 0, "L'Assemblée (Bourbon) et le Sénat (Luxembourg).", "NAT"),
        ("Combien y a-t-il de départements en France (métropole et outre-mer) ?", ["95", "101", "110"], 1, "Il y a 101 départements français.", "NAT"),
        ("Quel est le rôle du Conseil constitutionnel ?", ["Rendre la justice", "Vérifier la conformité des lois à la Constitution", "Élire le Président"], 1, "Le Conseil s'assure du respect de la Loi fondamentale.", "NAT"),
    ]

    # --- THEME 3: DROITS & DEVOIRS (droits) ---
    theme3_data = [
        ("Le droit de grève est-il autorisé en France ?", ["Non, c'est interdit", "Oui, c'est un droit constitutionnel", "Seulement dans le privé"], 1, "Le droit de grève est garanti par le préambule de la Constitution.", "CSP, CR, NAT"),
        ("Payer ses impôts est :", ["Un choix personnel", "Un devoir du citoyen pour financer les services publics", "Une option pour les riches"], 1, "La contribution aux charges publiques est un devoir civique.", "CSP, CR, NAT"),
        ("Qu'est-ce que le SNU ?", ["Le Service National Universel", "Le Système National d'Urgence", "Le Syndicat National Unique"], 0, "Le SNU vise à favoriser l'engagement des jeunes.", "CR, NAT"),
        ("La liberté d'expression permet-elle de diffuser des propos haineux ?", ["Oui, tout est permis", "Non, la loi punit l'incitation à la haine", "Seulement sur internet"], 1, "La liberté d'expression comporte des limites légales.", "CSP, CR, NAT"),
        ("Les enfants ont-ils des droits spécifiques ?", ["Non, les mêmes que les adultes", "Oui, protégés par la Convention internationale des droits de l'enfant", "Seulement le droit de jouer"], 1, "La protection de l'enfance est une priorité nationale.", "CSP, CR, NAT"),
        ("La Journée Défense et Citoyenneté (JDC) est-elle obligatoire ?", ["Oui, pour tous les jeunes Français entre 16 et 18 ans", "Non, c'est facultatif", "Seulement pour ceux qui veulent faire l'armée"], 0, "La JDC est une étape obligatoire du parcours citoyen.", "CR, NAT"),
        ("Le respect des lois est :", ["Optionnel si on n'est pas d'accord", "Obligatoire pour tous sur le territoire français", "Réservé aux fonctionnaires"], 1, "Nul n'est censé ignorer la loi.", "CSP, CR, NAT"),
        ("Un agent public peut-il porter un signe religieux visible ?", ["Oui, c'est sa liberté", "Non, il doit respecter la neutralité du service public", "Seulement les petites croix"], 1, "La neutralité s'impose à tous les agents publics.", "CR, NAT"),
        ("Le droit d'asile est accordé aux personnes :", ["Qui veulent trouver du travail", "Persécutées dans leur pays pour leurs opinions ou origines", "Qui veulent faire du tourisme"], 1, "La France est une terre d'asile historique.", "NAT"),
    ]

    # --- THEME 4: HISTOIRE, CULTURE & GÉOGRAPHIE (histoire_culture / geographie) ---
    theme4_data = [
        ("Qui était Clovis ?", ["Le premier roi chrétien des Francs", "Le chef de la Révolution française", "Un empereur romain"], 0, "Clovis s'est fait baptiser à Reims vers 496.", "NAT"),
        ("En quelle année a eu lieu la Révolution française ?", ["1689", "1789", "1889"], 1, "1789 marque la fin de l'Ancien Régime.", "CSP, CR, NAT"),
        ("Quel est le plus long fleuve de France ?", ["La Seine", "La Loire", "Le Rhône"], 1, "La Loire mesure 1012 kilomètres.", "CSP, CR, NAT"),
        ("Qui a écrit 'Les Misérables' ?", ["Gustave Flaubert", "Victor Hugo", "Émile Zola"], 1, "Victor Hugo est l'un des plus grands écrivains français.", "CR, NAT"),
        ("Citez un grand monument parisien :", ["La Tour Eiffel", "Le Mont Saint-Michel", "Le Pont du Gard"], 0, "La Tour Eiffel a été construite pour l'Exposition universelle de 1889.", "CSP, CR, NAT"),
        ("La France a-t-elle participé à la création de l'Union européenne ?", ["Non, elle a rejoint plus tard", "Oui, c'est un pays fondateur", "Seulement depuis l'Euro"], 1, "La France est un membre fondateur de la CECA puis de la CEE.", "CR, NAT"),
        ("Quelle ville est célèbre pour son Palais des Papes ?", ["Marseille", "Avignon", "Lyon"], 1, "Avignon a été le siège de la papauté au 14ème siècle.", "NAT"),
        ("Qui était Charles de Gaulle ?", ["Un chanteur célèbre", "Le chef de la France Libre et président de la République", "Un explorateur"], 1, "De Gaulle a mené la Résistance depuis Londres en 1940.", "CSP, CR, NAT"),
        ("Quel événement a eu lieu le 6 juin 1944 ?", ["La fin de la guerre", "Le Débarquement allié en Normandie", "La Révolution"], 1, "Le 'D-Day' a permis la libération de la France.", "CR, NAT"),
        ("La ville de Lyon est située au confluent de quels fleuves ?", ["La Seine et la Marne", "Le Rhône et la Saône", "La Loire et l'Indre"], 1, "Lyon est une ville carrefour au coeur de l'Europe.", "NAT"),
        ("Qui a peint 'La Joconde' ?", ["Léonard de Vinci", "Pablo Picasso", "Claude Monet"], 0, "Le tableau est exposé au Musée du Louvre à Paris.", "CSP, CR, NAT"),
    ]

    # --- THEME 5: VIE PRATIQUE (vie_pratique) ---
    theme5_data = [
        ("L'école est-elle obligatoire en France ?", ["Non", "Oui, de 3 à 16 ans", "Oui, de 6 à 18 ans"], 1, "L'instruction est obligatoire dès 3 ans depuis 2019.", "CSP, CR, NAT"),
        ("À quoi sert la Carte Vitale ?", ["À payer ses impôts", "À justifier de ses droits à l'Assurance maladie", "À voyager gratuitement"], 1, "La Carte Vitale permet le remboursement des soins de santé.", "CSP, CR, NAT"),
        ("Qu'est-ce qu'un contrat de travail à durée indéterminée (CDI) ?", ["Un contrat de 1 an", "Un contrat sans date de fin prévue", "Un contrat de stage"], 1, "Le CDI est la forme normale et générale de la relation de travail.", "CSP, CR, NAT"),
        ("Qui aide au paiement du loyer pour les revenus modestes ?", ["La Mairie", "La CAF (via l'APL)", "La Banque de France"], 1, "L'Aide Personnalisée au Logement (APL) est versée par la CAF.", "CSP, CR, NAT"),
        ("Quel est l'âge légal de la majorité en France ?", ["16 ans", "18 ans", "21 ans"], 1, "La majorité civile est fixée à 18 ans.", "CSP, CR, NAT"),
        ("En cas d'urgence médicale grave, quel numéro appeler ?", ["Le 15 (SAMU)", "Le 12", "Le 114"], 0, "Le 15 est le numéro des urgences vitales.", "CSP, CR, NAT"),
        ("Un locataire doit-il assurer son logement ?", ["Oui, c'est une obligation légale", "Non, c'est au propriétaire de le faire", "Seulement s'il le souhaite"], 0, "L'assurance habitation est obligatoire pour les locataires.", "CR, NAT"),
        ("Quelle est la durée légale du travail par semaine (hors heures sup) ?", ["35 heures", "39 heures", "40 heures"], 0, "La semaine de 35 heures est la règle depuis 2000.", "CSP, CR, NAT"),
        ("Peut-on être soigné gratuitement en cas de faibles revenus ?", ["Non", "Oui, via la Complémentaire Santé Solidaire (C2S)", "Seulement aux urgences"], 1, "La solidarité nationale garantit l'accès aux soins pour tous.", "NAT"),
    ]

    # Process and build final list
    questions = []
    counter = 2000
    all_themes = [
        (theme1_data, "vals_principes"),
        (theme2_data, "institutions"),
        (theme3_data, "droits"),
        (theme4_data, "histoire_culture"),
        (theme5_data, "vie_pratique")
    ]
    
    for theme_list, cat_id in all_themes:
        for q_text, choices, ans, expl, path_str in theme_list:
            counter += 1
            questions.append({
                "id": f"q_{counter}",
                "question": q_text,
                "choices": choices,
                "answerIndex": ans,
                "explanation": expl,
                "theme": cat_id,
                "category": cat_id,
                "parcours": [p.strip() for p in path_str.split(",")]
            })

    # Add Geographie explicit questions (for the 6th slot)
    geo_data = [
        ("Quelle est la capitale de la France ?", ["Lyon", "Paris", "Marseille"], 1, "Paris est la capitale et le siège du gouvernement.", "CSP, CR, NAT"),
        ("Citez une chaîne de montagnes française :", ["Les Alpes", "L'Himalaya", "Les Andes"], 0, "Les Alpes abritent le Mont Blanc.", "CSP, CR, NAT"),
        ("Où se trouve la Guyane ?", ["En Europe", "En Afrique", "En Amérique du Sud"], 2, "La Guyane est un département d'outre-mer situé en Amazonie.", "NAT"),
    ]
    for q_text, choices, ans, expl, path_str in geo_data:
        counter += 1
        questions.append({
            "id": f"q_{counter}",
            "question": q_text,
            "choices": choices,
            "answerIndex": ans,
            "explanation": expl,
            "theme": "geographie",
            "category": "geographie",
            "parcours": [p.strip() for p in path_str.split(",")]
        })

    # Save to JSON
    target_path = r'd:\Antigravity-project\Mobile-application-QCM-Sans-Base\assets\data\questions.json'
    os.makedirs(os.path.dirname(target_path), exist_ok=True)
    with open(target_path, 'w', encoding='utf-8') as f:
        json.dump(questions, f, ensure_ascii=False, indent=2)

if __name__ == "__main__":
    generate_questions()
    print("Database sync complete.")
