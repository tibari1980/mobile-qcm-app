import '../../core/constants/app_colors.dart';
import 'eligibility_model.dart';

class EligibilityService {
  static EligibilityResult calculateResult(Map<String, String> answers) {
    List<String> reasons = [];
    bool isExempt = false;

    // 1. Nationality Check
    final nationality = answers['nationality'];
    if (nationality == 'fr') {
      isExempt = true;
      reasons.add('Vous possédez déjà la nationalité française.');
    } else if (nationality == 'eu') {
      isExempt = true;
      reasons.add('Les ressortissants de l\'UE/EEE sont dispensés du contrat d\'intégration républicaine (CIR).');
    } else if (nationality == 'dz') {
      isExempt = true;
      reasons.add('Les ressortissants algériens sont régis par les accords de 1968 (dispense OFII).');
    }

    // 2. Age Check
    if (answers['age'] == 'over_65') {
      isExempt = true;
      reasons.add('Les personnes âgées de 65 ans ou plus sont dispensées de l\'examen.');
    }

    // 3. Health Check
    if (answers['health'] == 'certified') {
      isExempt = true;
      reasons.add('Un certificat médical constatant un handicap ou un état de santé chronique dispense de l\'examen.');
    }

    // 4. Protection Check
    if (answers['protection'] == 'yes') {
      isExempt = true;
      reasons.add('Les réfugiés, apatrides et protégés subsidiaires sont dispensés des épreuves de langue et de civisme.');
    }

    // 5. Special Situations
    if (answers['situation'] == 'diploma_fr') {
      reasons.add('Votre diplôme français (BAC+) vous dispense de l\'examen de langue, mais PAS de l\'examen civique.');
    }

    // Logic for Title/Status
    final requestType = answers['request_type'];
    final bool isMainRequest = ['nat', 'resident_10', 'csp'].contains(requestType);

    if (isExempt) {
      return EligibilityResult(
        status: EligibilityStatus.exempt,
        title: 'VOUS ÊTES DISPENSÉ',
        message: 'Selon votre profil, vous ne semblez pas avoir l\'obligation de passer l\'examen civique.',
        reasons: reasons.isEmpty ? ['Votre situation particulière vous accorde une dispense.'] : reasons,
        glowColor: AppColors.successGreenNeon,
      );
    } else if (isMainRequest) {
      return EligibilityResult(
        status: EligibilityStatus.mandatory,
        title: 'EXAMEN OBLIGATOIRE',
        message: 'Dans le cadre de votre demande, vous devez valider votre parcours citoyen.',
        reasons: [
          'La validation de l\'examen civique est obligatoire pour les titres de séjour longue durée et la naturalisation.',
          'Conservez votre attestation : une note de 80% (16/20) est requise.',
          if (answers['situation'] == 'diploma_fr') 'Note : Vous restez dispensé de l\'examen de LANGUE.'
        ],
        glowColor: AppColors.primaryNeon,
      );
    } else {
      return EligibilityResult(
        status: EligibilityStatus.exempt,
        title: 'PAS D\'OBLIGATION',
        message: 'Pour ce type de demande (renouvellement, visiteur...), l\'examen n\'est pas requis.',
        reasons: ['L\'examen civique concerne principalement les premières délivrances de cartes de résident ou la naturalisation.'],
        glowColor: AppColors.accentPurpleNeon,
      );
    }
  }
}
