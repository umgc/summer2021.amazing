//**************************************************************
// Match for Aho-Corasick algorithm
// Author: Christian Ahmed
//**************************************************************

class Match {
  Match({required this.startIndex, required this.word});

  final int startIndex;
  final String word;

  Match copyWith({int? startIndex, String? word}) => Match(
    //startIndex: startIndex ?? this.startIndex,
    startIndex: startIndex ?? this.startIndex,
    word: word ?? this.word,
  );
}
