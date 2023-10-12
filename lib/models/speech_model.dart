class SpeechModel {
  String category;
  List<String> sentences;
  int index;
  String description;

  SpeechModel(
      {required this.category,
      required this.sentences,
      required this.index,
      this.description = ''});

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'sentences': sentences,
      'index': index,
      'description': description
    };
  }

  // Create SpeechModel from JSON
  factory SpeechModel.fromJson(Map<String, dynamic> json) {
    return SpeechModel(
        category: json['category'],
        sentences: List<String>.from(json['sentences']),
        index: json['index'],
        description: json['description']);
  }
}

List<SpeechModel> speechCategories = [
  SpeechModel(
      category: 'Diction',
      sentences: [
        "She sells seashells by the seashore.",
        "How can a clam cram in a clean cream can?",
        "Six slippery snails slid slowly seaward.",
        "Fuzzy Wuzzy was a bear. Fuzzy Wuzzy had no hair",
        "I saw Susie sitting in a shoeshine shop. Where she sits, she shines, and where she shines, she sits."
      ],
      index: 1,
      description:
          'Diction refers to the choice and use of words in speech or writing, particularly in terms of clarity and effectiveness.'),
  SpeechModel(
      category: 'Articulation',
      sentences: [
        "The big brown bear",
        "Quick, quiet quokkas quiver quickly.",
        "Peter Piper picked a peck of pickled peppers.",
        "Sally saw seven silly, sleepy sheep.",
        "The black cat crept cautiously."
      ],
      index: 2,
      description:
          "Articulation involves the clear and distinct pronunciation of words and sounds, ensuring they are spoken correctly and easily understood."),
  SpeechModel(
      category: 'Pronounciation',
      sentences: [
        "He's an heir to the throne.",
        "Sweet candy tastes delicious.",
        "She's a successful actress.",
        "A proper copper coffee pot.",
        "Brown eyes see clearly."
      ],
      index: 3,
      description:
          'Pronunciation relates to the correct way of saying words, including the accurate sounds and stress patterns used in a particular language.'),
  SpeechModel(
      category: 'Communication',
      sentences: [
        "I understand your perspective.",
        "I value your opinion on this matter",
        "We should engage in open dialogue.",
        "Can you elaborate on your proposal?",
        "Constructive feedback is essential."
      ],
      index: 4,
      description:
          'Communication encompasses the exchange of information, thoughts, and ideas between individuals or groups through various means, such as spoken or written language, gestures, or body language.'),
  SpeechModel(
      category: 'Linguistics',
      sentences: [
        "Phonetics studies speech sounds.",
        "Syntax deals with sentence structure.",
        "Morphology analyzes word forms.",
        "Pragmatics studies language in context.",
        "Phonology studies sound patterns."
      ],
      index: 5,
      description:
          'Linguistics is the scientific study of language, exploring its structure, evolution, and usage, as well as the principles underlying it.'),
  SpeechModel(
      category: 'Vocalization',
      sentences: [
        "Sibilant sounds serenade night.",
        "Harmonious hums resonate softly.",
        "Cacophonous crescendos captivate crowds.",
        "Euphonious melodies enthrall audiences.",
        "Dissonant chords evoke emotions."
      ],
      index: 6,
      description:
          'Vocalization pertains to the act of producing vocal sounds, whether in speech, singing, or other forms of vocal expression.'),
  SpeechModel(
      category: 'Oration',
      sentences: [
        "Ladies and gentlemen, today I'd like to discuss about Broadcasting",
        "In conclusion, let me summarize my main points.",
        "I want to inspire you with my words.",
        "This speech aims to inform and persuade.",
        "As a public speaker, I strive for impact.",
        "Greetings, esteemed colleagues.",
        "In summary, let's recap the main points.",
        "I aim to motivate and uplift.",
        "This address seeks to inform and sway.",
        "My speeches aspire to leave an impact."
      ],
      index: 7,
      description:
          'Oration refers to the art of delivering a formal and persuasive speech, often in a public setting, to convey ideas or persuade an audience.'),
  SpeechModel(
      category: 'Expression',
      sentences: [
        "I'm thrilled to be here today.",
        "I feel deeply honored and grateful.",
        "My passion for this topic is evident.",
        "I can't overemphasize the importance of this issue.",
        "Let me convey my enthusiasm for our project.",
        "I'm genuinely excited to be here.",
        "I'm profoundly appreciative of this opportunity.",
        "My fervor for this subject shines through.",
        "The significance of this matter can't be overstated.",
        "Allow me to convey my enthusiasm for our cause."
      ],
      index: 8,
      description:
          'Expression involves the conveyance of thoughts, emotions, or creativity through various means, such as language, art, or body language.'),
  SpeechModel(
      category: 'Intonation',
      sentences: [
        "Are you sure about that?",
        "I can't believe you did that!",
        "It's a beautiful day, isn't it?",
        "You're coming to the party, right?",
        "I have a question for you.",
        "You really think so?",
        "I can hardly believe it!",
        "It's a beautiful day, don't you think?",
        "You'll be at the gathering, won't you?",
        "I've got a question for you, okay?"
      ],
      index: 9,
      description:
          'Intonation relates to the rising and falling patterns of pitch and stress in speech, which can convey meaning and emotional nuances.'),
  SpeechModel(
      category: 'Consistency',
      sentences: [
        "Consistency is the key to success.",
        "We need to maintain a consistent approach.",
        "Our policies must remain consistent.",
        "Consistency builds trust with our customers.",
        "Inconsistency can lead to confusion.",
        "Steadiness is the pathway to achievement.",
        "We must stick to a uniform strategy.",
        "Our principles should remain unwavering.",
        "Reliability fosters trust among clients.",
        "Inconsistency leads to ambiguity."
      ],
      index: 10,
      description:
          'Consistency refers to the quality of being uniform, dependable, or reliable in behavior, speech, or action. In communication, it ensures that messages are clear and coherent over time.'),
  SpeechModel(
      category: 'Consistency',
      sentences: [
        "Clear communication is crucial for success.",
        "Articulate your thoughts with precision and clarity.",
        "Ensure every syllable is enunciated effectively.",
        "The enunciator announced the important news.",
        "Proper enunciation enhances understanding.",
        "Enunciate each word distinctly and confidently.",
        "The speaker's enunciation was impeccable.",
        "Enunciate your words for a powerful impact.",
        "Enunciation is the key to effective communication.",
        "Practicing enunciation improves speech clarity."
      ],
      index: 11,
      description:
          'Consistency refers to the quality of being uniform, dependable, or reliable in behavior, speech, or action. In communication, it ensures that messages are clear and coherent over time.'),
  SpeechModel(
      category: 'Consistency',
      sentences: [
        "She sells seashells by the seashore.",
        "Unique New York, New York's unique.",
        "Red leather, yellow leather.",
        "Six slippery snails slid slowly southward.",
        "How can a clam cram in a clean cream can?",
        "Fuzzy Wuzzy was a bear. Fuzzy Wuzzy had no hair. Fuzzy Wuzzy wasn't very fuzzy, was he?",
        "Sally sells seashells by the seashore. The shells she sells are surely seashells.",
        "Peter Piper picked a peck of pickled peppers.",
        "She sees cheese sitting on the bleachers.",
        "Betty Botter bought some butter. But she said, 'This butter's bitter. If I put it in my batter, it will make my batter bitter.'"
      ],
      index: 12,
      description:
          'Consistency refers to the quality of being uniform, dependable, or reliable in behavior, speech, or action. In communication, it ensures that messages are clear and coherent over time.'),
];
