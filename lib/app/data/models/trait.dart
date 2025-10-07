enum Trait { openness, conscientiousness, extraversion, agreeableness, neuroticism }

extension TraitExt on Trait {
  String get localizationKey {
    switch (this) {
      case Trait.openness:
        return 'trait_openness';
      case Trait.conscientiousness:
        return 'trait_conscientiousness';
      case Trait.extraversion:
        return 'trait_extraversion';
      case Trait.agreeableness:
        return 'trait_agreeableness';
      case Trait.neuroticism:
        return 'trait_neuroticism';
    }
  }

  String get key => name;
}
