Future<String> compararPorcentagens(ai, deep) async {
  if (ai > 75) {
    if (deep > 75) {
      return "A imagem provavelmente é um deepfake ou é gerada por IA.";
    } else if (deep > 40) {
      return "A imagem provavelmente é gerada por IA mas pode ser um deepfake também.";
    } else {
      return "A imagem provavelmente é gerada por IA.";
    }
  } else if (ai > 40) {
    if (deep > 75) {
      return "A imagem provavelmente é um deepfake mas pode ser gerada por IA também.";
    } else if (deep > 40) {
      return "A imagem pode ter sido gerada por IA ou pode ser um deepfake";
    } else {
      return "A imagem pode ter sido gerada por IA.";
    }
  } else {
    if (deep > 75) {
      return "A imagem provavelmente é um deepfake.";
    } else if (deep > 40) {
      return "A imagem pode ser um deepfake.";
    } else {
      return "É provavel que a imagem não seja um deepfake nem tenha sido gerada por IA.";
    }
  }
}
