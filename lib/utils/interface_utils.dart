String emojiForCategorie(String categorie) {
  switch (categorie.toLowerCase()) {
    case 'amphibien':
      return '🐸';
    case 'reptile':
      return '🦎';
    case 'oiseau':
      return '🐦';
    case 'mammifère':
      return '🦔';
    case 'insecte':
      return '🐞';
    case 'tortue':
      return '🐢';
    default:
      return '🐾';
  }
}
