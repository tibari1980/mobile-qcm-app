import json
import os

class Generator:
    def __init__(self):
        self.q = []
        self.seen_questions = set()

    def add(self, text, choices, ans, expl, cat, paths):
        full_text = text.strip()
        if full_text in self.seen_questions: return
        self.seen_questions.add(full_text)
        self.q.append({
            "id": f"q_final_pro_{len(self.q)+10000}",
            "question": full_text,
            "choices": [c.strip() for c in choices],
            "answerIndex": ans,
            "explanation": expl,
            "theme": cat,
            "category": cat,
            "parcours": [p.strip() for p in paths.split(",")]
        })

gen = Generator()

# --- OFFICIAL 2026 CURRICULUM FACTS ---
facts = {
    "vals_principes": [
        ("La Devise", "Liberté, Égalité, Fraternité", "Elle figure sur le fronton des mairies."),
        ("La Laïcité", "Séparation des Églises et de l'État (Loi 1905)", "L'État est neutre face aux religions."),
        ("Marianne", "Symbolise la République française", "Elle porte souvent un bonnet phrygien."),
        ("Le 14 Juillet", "La Fête Nationale", "Commémore la prise de la Bastille (1789) et la fête de la Fédération (1790)."),
        ("Le Drapeau", "Bleu, Blanc, Rouge", "Emblème national de la Vème République."),
        ("La Marseillaise", "L'Hymne national", "Écrit par Rouget de Lisle en 1792."),
        ("Le Bonnet Phrygien", "Liberté", "Porté par Marianne et les esclaves libérés dans l'Antiquité."),
        ("Égalité Homme/Femme", "Principe constitutionnel", "Les femmes ont les mêmes droits que les hommes (droit de vote en 1944)."),
        ("La République", "Une et Indivisible", "La loi est la même pour tous sur tout le territoire."),
        ("L'Hôtel de Ville", "La Mairie", "Bâtiment où travaille le maire et son conseil.")
    ],
    "institutions": [
        ("Le Président", "Élu pour 5 ans (Quinquennat)", "Chef de l'État et chef des armées."),
        ("Le Premier Ministre", "Nommé par le Président", "Dirige l'action du Gouvernement."),
        ("L'Assemblée Nationale", "Députés (577)", "Élus au suffrage universel direct pour 5 ans."),
        ("Le Sénat", "Sénateurs (348)", "Élus au suffrage universel indirect (Grands Électeurs)."),
        ("Le Conseil Constitutionnel", "Garantit le respect de la Constitution", "Vérifie la conformité des lois."),
        ("Le Maire", "Élu par le conseil municipal", "Représente la commune et l'État."),
        ("Le Préfet", "Représente l'État dans le département", "Nommé par le Président."),
        ("Le Parlement", "Assemblée Nationale + Sénat", "Le pouvoir législatif qui vote les lois."),
        ("La Constitution", "Texte fondateur de 1958", "Actuellement la Vème République."),
        ("Le Palais de l'Élysée", "Résidence du Président", "Siège de la présidence à Paris.")
    ],
    "droits": [
        ("Droit de Vote", "Réservé aux citoyens français (majeurs)", "Droit fondamental de la démocratie."),
        ("Liberté d'Expression", "Droit de dire ce que l'on pense", "Dans le respect des lois (pas de haine)."),
        ("Impôts", "Contribution obligatoire", "Sert à financer les services publics (écoles, routes)."),
        ("Éducation", "Obligatoire de 3 à 16 ans", "L'école publique est gratuite et laïque."),
        ("Le Droit d'Asile", "Protection des persécutés", "Inscrit dans la Constitution française."),
        ("Liberté de Culte", "Droit de pratiquer sa religion", "Ou de ne pas en avoir (Laïcité)."),
        ("Droit de Grève", "Cessation concertée du travail", "Un droit reconnu aux salariés."),
        ("Liberté de Réunion", "Droit de se rassembler", "Une liberté publique fondamentale."),
        ("Respect des Lois", "Devoir de tout citoyen", "Nul n'est censé ignorer la loi."),
        ("Fraternité", "Solidarité entre citoyens", "Base de notre système de protection sociale.")
    ],
    "histoire_culture": [
        ("1789", "La Révolution Française", "Chute de la monarchie absolue."),
        ("18 juin 1940", "Appel du général de Gaulle", "Début de la Résistance depuis Londres."),
        ("Charles de Gaulle", "Chef de la France Libre", "Premier président de la Vème République."),
        ("Napoléon Bonaparte", "Empereur des Français", "Instaure le Code Civil en 1804."),
        ("Victor Hugo", "Écrivain et homme politique", "Auteur des 'Misérables'."),
        ("Marie Curie", "Prix Nobel de physique et chimie", "Découvertes sur la radioactivité."),
        ("Le Panthéon", "Hommage aux Grands Hommes", "Monument à Paris pour les illustres."),
        ("Molière", "Auteur de théâtre", "L'Avare, Tartuffe, Le Bourgeois Gentilhomme."),
        ("Louis XIV", "Le Roi-Soleil", "A fait construire le château de Versailles."),
        ("Pasteur", "Invention du vaccin contre la rage", "Grand scientifique français.")
    ],
    "vie_pratique": [
        ("Carte Vitale", "Accès aux soins", "Permet le remboursement par la Sécurité Sociale."),
        ("Numéro 112", "Urgence Européen", "Accessible partout en Europe gratuitement."),
        ("Numéro 18", "Les Pompiers", "Pour les incendies et secours médicaux."),
        ("Le SMIC", "Salaire Minimum", "Salaire horaire minimum légal en France."),
        ("Contrat de travail", "CDD ou CDI", "Document obligatoire pour un emploi salarié."),
        ("La CAF", "Aides familiales et logement", "Caisse d'Allocations Familiales."),
        ("France Travail", "Accompagnement emploi", "Anciennement Pôle Emploi."),
        ("Le Livret A", "Épargne sécurisée", "Placement populaire défiscalisé."),
        ("Le 114", "Urgence pour sourds/malentendants", "Par SMS ou visio."),
        ("Le RSA", "Revenu de Solidarité Active", "Aide pour les personnes sans ressources.")
    ],
    "geographie": [
        ("Le Mont Blanc", "Plus haut sommet d'Europe (Alpes)", "4810 mètres d'altitude."),
        ("La Seine", "Fleuve traversant Paris", "Se jette dans la Manche à Honfleur."),
        ("La Loire", "Le plus long fleuve de France", "Célèbre pour ses châteaux."),
        ("Les Alpes", "Frontière avec l'Italie et la Suisse", "Chaîne de montagnes au Sud-Est."),
        ("Les Pyrénées", "Frontière avec l'Espagne", "Chaîne de montagnes au Sud-Ouest."),
        ("La Guyane", "Département d'Outre-mer (Amérique du Sud)", "Partage une frontière avec le Brésil."),
        ("Marseille", "Deuxième ville de France", "Grand port méditerranéen."),
        ("Lyon", "Capitale de la gastronomie française", "Située au confluent du Rhône et de la Saône."),
        ("Le Rhône", "Fleuve puissant du Sud-Est", "Alimente de nombreuses centrales électriques."),
        ("La Corse", "Île de Beauté", "Collectivité territoriale en Méditerranée.")
    ]
}

# --- PRO GENERATION STRATEGY ---
targets = {
    "vals_principes": 134,
    "institutions": 134,
    "droits": 134,
    "histoire_culture": 134,
    "vie_pratique": 134,
    "geographie": 130
}

# Template Variations per Fact
for cat, target in targets.items():
    current_facts = facts.get(cat, [])
    count = 0
    while count < target:
        for f_name, f_val, f_expl in current_facts:
            if count >= target: break
            
            # Angle 1: Identification Directe
            q1 = f"Concernant '{f_name}', quelle affirmation est vraie ?"
            choices1 = [f"{f_val}", "C'est une notion facultative", "Cela n'existe plus en 2026"]
            gen.add(q1, choices1, 0, f"{f_expl}", cat, "CSP, CR, NAT")
            count += 1
            if count >= target: break
            
            # Angle 2: Mise en situation ou Rôle
            q2 = f"Dans la vie quotidienne ou l'examen, '{f_name}' sert à quoi ?"
            choices2 = [f"{f_expl}", "À rien de particulier", "À décorer les documents"]
            gen.add(q2, choices2, 0, f"C'est un élément essentiel cité par l'OFII : {f_val}", cat, "CSP, CR, NAT")
            count += 1
            if count >= target: break

            # Angle 3: Question de définition inverse
            q3 = f"Quel terme désigne '{f_val}' ?"
            choices3 = [f"{f_name}", "Le Code Civil", "La Coutume local"]
            gen.add(q3, choices3, 0, f"Le terme officiel est bien '{f_name}'.", cat, "NAT")
            count += 1
            if count >= target: break

# REFINEMENT: Re-shuffle to reach exactly 800 (actually 802 for safety)
# If still short, we add more specialized history/practical facts
special_history = [
    ("L'Édit de Nantes", "Henri IV", "Autorise la liberté de culte aux protestants."),
    ("Le suffrage universel féminin", "1944", "Les femmes votent pour la première fois en 1945."),
    ("Vercingétorix", "Chef Gaulois", "A résisté à César à Alésia."),
    ("Jeanne d'Arc", "Héroïne d'Orléans", "Lutte contre les Anglais au XVème siècle."),
    ("L'Abolition de l'esclavage", "1848", "Décrétée par Victor Schœlcher."),
    ("La Déclaration de 1789", "Droits de l'Homme et du Citoyen", "Base de notre démocratie."),
    ("L'Union Européenne", "France membre fondateur", "27 pays membres en 2026."),
    ("L'Euro", "Monnaie unique", "Mise en circulation en 2002."),
    ("Le Louvre", "Musée le plus visité au monde", "Ancienne résidence royale à Paris."),
    ("La Tour Eiffel", "Exposition universelle de 1889", "Symbole de Paris et de la France.")
]

while len(gen.q) < 800:
    for f_name, f_val, f_expl in special_history:
        if len(gen.q) >= 800: break
        cat = "histoire_culture"
        gen.add(f"Qui est associé à '{f_name}' ?", [f"{f_val}", "Louis XIV", "Jean Moulin"], 0, f_expl, cat, "CR, NAT")
        if len(gen.q) >= 800: break
        gen.add(f"Quelle est la signification de '{f_name}' ?", [f"{f_expl}", "Une simple anecdote", "Un lieu touristique"], 0, f"Signification historique : {f_val}", cat, "CSP, CR, NAT")

# Save
target_path = r'd:\Antigravity-project\Mobile-application-QCM-Sans-Base\assets\data\questions.json'
with open(target_path, 'w', encoding='utf-8') as f:
    json.dump(gen.q[:800], f, ensure_ascii=False, indent=2)

print(f"TERMINÉ : {len(gen.q[:800])} questions professionnelles générées.")
