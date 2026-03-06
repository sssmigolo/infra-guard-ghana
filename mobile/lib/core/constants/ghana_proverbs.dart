// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
// InfraGuard AI - Ghanaian Proverbs for Loading Tips

class GhanaProverbs {
  GhanaProverbs._();

  static const List<String> proverbs = [
    '"Sankofa" – It is not wrong to go back for what you forgot. 🇬🇭',
    '"Obra nye ahoofe" – Life is not about beauty alone, but purpose.',
    '"Tete wo bi ka, tete wo bi kyere" – The past has something to say, to teach.',
    '"Nea onnim no sua a, ohu" – One who does not know can know from learning.',
    '"Obi nkyere abofra Nyame" – No one teaches a child about God.',
    '"Wope aboa bi ho a, na wode no si wo yam" – If you love an animal, keep it close.',
    '"Anomaa antu a, obua da" – A bird that does not fly will always remain hungry.',
    '"Dua koro gye mframa a, ebu" – One tree cannot withstand the storm.',
    '"Aboa a onni dua, Onyame na opra ne ho" – God takes care of the tailless animal.',
    '"Ti nkron mu nni fam" – Two heads are better than one.',
    '"Ohia ye yade a, anka obiara regye" – If poverty were a disease, no one would cure it.',
    '"Nkrabea mu nni kwatibea" – There is no shortcut to destiny.',
    '"Se wo were fi na wosan kofa a, yennkyiri" – There is nothing wrong in learning from the past.',
    '"Asetena mu nni babi a yetwa to mu" – Life has no shortcut.',
    '"Adwen pa ye nsa" – A good thought is like a drink.',
  ];

  static String get random => proverbs[DateTime.now().millisecond % proverbs.length];
}
