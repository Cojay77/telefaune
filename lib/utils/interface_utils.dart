String emojiForCategorie(String? categorie) {
  final value = (categorie ?? '').toLowerCase();
  switch (value) {
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
