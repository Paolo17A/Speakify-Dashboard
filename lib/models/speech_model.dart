class SpeechModel {
  String category;
  List<String> sentences;
  int index;

  SpeechModel(
      {required this.category, required this.sentences, required this.index});
}

List<SpeechModel> speechCategories = [
  SpeechModel(
      category: 'Diction',
      sentences: [
        "The cat sat on the mat.",
        "Big red ball bounces high.",
        "Happy kids laugh loud.",
        "Blue sky brings joy.",
        "Warm sun shines bright."
      ],
      index: 1),
  SpeechModel(
      category: 'Articulation',
      sentences: [
        "Slimy snails crawl slowly.",
        "Green grass grows tall.",
        "Soft breeze rustles leaves.",
        "Fuzzy teddy bear hugs tight.",
        "Pink flowers bloom beautifully."
      ],
      index: 2),
  SpeechModel(
      category: 'Pronounciation',
      sentences: [
        "Quick brown fox jumps.",
        "Sweet candy tastes delicious.",
        "Little squirrel climbs trees.",
        "Brown eyes see clearly.",
        "Fast cars zoom by."
      ],
      index: 3),
  SpeechModel(
      category: 'Communication',
      sentences: [
        "Silent whispers echo softly.",
        "Mystic mountains touch heavens.",
        "Vivid paintings ignite emotions.",
        "Captivating stories weave magic.",
        "Fragrant roses bloom gracefully."
      ],
      index: 4),
  SpeechModel(
      category: 'Linguistics',
      sentences: [
        "Sophisticated languages unveil cultures.",
        "Harmonious symphonies evoke emotions.",
        "Intricate tapestries depict history.",
        "Philosophical concepts challenge minds.",
        "Intriguing patterns form connections."
      ],
      index: 5),
  SpeechModel(
      category: 'Vocalization',
      sentences: [
        "Sibilant sounds serenade night.",
        "Harmonious hums resonate softly.",
        "Cacophonous crescendos captivate crowds.",
        "Euphonious melodies enthrall audiences.",
        "Dissonant chords evoke emotions."
      ],
      index: 6),
  SpeechModel(
      category: 'Oration',
      sentences: [
        "Eloquent speeches sway minds.",
        "Compelling tales spark revolutions.",
        "Passionate pleas ignite change.",
        "Rhetorical devices captivate hearts.",
        "Inspirational anecdotes resonate deeply."
      ],
      index: 7),
  SpeechModel(
      category: 'Expression',
      sentences: [
        "Profound prose reflects wisdom.",
        "Sublime metaphors paint landscapes.",
        "Vivid imagery sparks imagination.",
        "Emotional resonance touches hearts.",
        "Articulate monologues convey depth."
      ],
      index: 8),
  SpeechModel(
      category: 'Intonation',
      sentences: [
        "Inquisitive inflections uncover nuances.",
        "Emphatic tones underscore emphasis.",
        "Melodic cadence soothes souls.",
        "Ascending intonations signal queries.",
        "Descending tones evoke emotions."
      ],
      index: 9),
  SpeechModel(
      category: 'Consistency',
      sentences: [
        "How can a clam cram in a clean cream can?",
        "Six slippery snails slid slowly seaward.",
        "Black bug bleeds black blood. Black blood bleeds black bug.",
        "I saw Susie sitting in a shoeshine shop.",
        "Peter Piper picked a peck of pickled peppers. How many pickled peppers did Peter Piper pick?"
      ],
      index: 10),
];
