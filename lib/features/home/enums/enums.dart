enum CharStatus { alive, dead, unknown }

extension CharStatusExtension on CharStatus {
  String get name {
    switch (this) {
      case CharStatus.alive:
        return 'Vivo';
      case CharStatus.dead:
        return 'Morto';
      case CharStatus.unknown:
        return 'Desconhecido';
    }
  }
}

enum CharGender { male, female, genderless, unknown }

extension CharGenderExtension on CharGender {
  String get name {
    switch (this) {
      case CharGender.male:
        return 'Masculino';
      case CharGender.female:
        return 'Feminino';
      case CharGender.genderless:
        return 'Sem gênero';
      case CharGender.unknown:
        return 'Desconhecido';
    }
  }
}

enum CharSpecies { human, alien, robot, unknown }

extension CharSpeciesExtension on CharSpecies {
  String get name {
    switch (this) {
      case CharSpecies.human:
        return 'Humano';
      case CharSpecies.alien:
        return 'Alienígena';
      case CharSpecies.robot:
        return 'Robô';
      case CharSpecies.unknown:
        return 'Desconhecido';
    }
  }
}
