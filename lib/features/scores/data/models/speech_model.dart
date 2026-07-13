class SpeechModel {
  String category;
  List<String> sentences;
  int index;
  String description;
  List<String> resources;
  List<String> audioPath;

  SpeechModel(
      {required this.category,
      required this.sentences,
      required this.index,
      this.description = '',
      this.resources = const [],
      this.audioPath = const []});

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'sentences': sentences,
      'index': index,
      'description': description
    };
  }

  factory SpeechModel.fromJson(Map<String, dynamic> json) {
    return SpeechModel(
        category: json['category'],
        sentences: List<String>.from(json['sentences']),
        index: json['index'],
        description: json['description']);
  }
}

List<List<SpeechModel>> speechLevels = [
  [speechCategories[0], speechCategories[1]],
  [speechCategories[2], speechCategories[3]],
  [speechCategories[4], speechCategories[5]],
  [speechCategories[6], speechCategories[7]],
  [speechCategories[8], speechCategories[9]],
];

SpeechModel? getSpeeechByIndex(int index) {
  for (var model in speechCategories) {
    if (model.index == index) {
      return model;
    }
  }
  return null;
}

List<SpeechModel> speechCategories = [
  SpeechModel(
      category: 'Diction',
      sentences: [
        "She sells seashells by the seashore.",
        "How can a clam cram in a clean cream can?",
        "Six slippery snails slid slowly seaward.",
        "Fuzzy Wuzzy was a bear. Fuzzy Wuzzy had no hair",
        "I saw Susie sitting in a shoeshine shop.",
        "Betty bought some butter but the butter was bitter.",
        "How much wood could a would a woodchuck chuck.",
        "Red leather yellow leather.",
        "Toy boat toy boat toy boat.",
        "Unique New York"
      ],
      index: 1,
      audioPath: [
        'audio/DICTION/SHE_SELLS_SEASHELLS_BY_THE_SEASHORE_V11.mp3',
        'audio/DICTION/HOW_CAN_A_CLAM_CRAM_IN_A_CLEAN_CREAM_CAN__V14.mp3',
        'audio/DICTION/SIX_SLIPPERY_SNAILS_SLID_SLOWLY_SEAWARD_V15.mp3',
        'audio/DICTION/FUZZY_WUZZY_WAS_A_BEAR_FUZZY_WUZZY_HAD_NO_HAIR_V16.mp3',
        'audio/DICTION/I_SAW_SUSIE_SITTING_IN_A_SHOESHINE_SHOP_WHERE_SHE_SITS_SHE_SHINES_AND_WHERE_SHE_SHINES_SHE_SITS_V19.mp3',
        'audio/DICTION/BETTY_BOUGHT_SOME_BUTTER_BUT_THE_BUTTER_WAS_BITTER_SO_BETTY_BOUGHT_BETTER_BUTTER_TO_MAKE_THE_BITTER_BUTTER_BETTER_V18.mp3',
        'audio/DICTION/HOW_MUCH_WOOD_WOULD_A_WOODCHUCK_CHUCK_IF_A_WOODCHUCK_COULD_CHUCK_WOOD__V17.mp3',
        'audio/DICTION/RED_LEATHER_YELLOW_LEATHER_V13.mp3',
        'audio/DICTION/TOY_BOAT_TOY_BOAT_TOY_BOAT_V20.mp3',
        'audio/DICTION/UNIQUE_NEW_YORK_V12.mp3'
      ],
      resources: [
        'https://www.youtube.com/watch?v=8sQoYa8TptI',
        'https://www.youtube.com/shorts/WN1K3ry1y3s',
        'https://www.youtube.com/shorts/R8p51Y6R6pA',
        'https://www.youtube.com/shorts/h7GmFT9DT5c'
      ],
      description:
          'Diction refers to the choice and use of words in speech or writing, particularly in terms of clarity and effectiveness.'),
  SpeechModel(
      category: 'Articulation',
      sentences: [
        "The big brown bear",
        "Quick, quiet quokkas quiver quickly.",
        "Peter Piper picked a peck of pickled peppers.",
        "Sally saw seven silly sleepy sheep.",
        "The black cat crept cautiously.",
        "Quick brown fox jumps.",
        "Red lorry yellow lorry",
        "She sells sea shell by the seashore.",
        "Six slippery snails slid slowly seaward sliding silently.",
        "The sixth sick sheik sixth sheep's sick."
      ],
      index: 2,
      audioPath: [
        'audio/ARTICULATION/THE_BIG_BROWN_BEAR_V11.mp3',
        'audio/ARTICULATION/QUICK_QUIET_QUOKKAS_QUIVER_QUICKLY_V12.mp3',
        'audio/ARTICULATION/PETER_PIPER_PICKED_A_PECK_OF_PICKLED_PEPPERS_V13.mp3',
        'audio/ARTICULATION/SALLY_SAW_SEVEN_SILLY_SLEEPY_SHEEP_V14.mp3',
        'audio/ARTICULATION/THE_BLACK_CAT_CREPT_CAUTIOUSLY_V15.mp3',
        'audio/ARTICULATION/QUICK_BROWN_FOX_JUMPS_V20.mp3',
        'audio/ARTICULATION/RED_LORRY_YELLOW_LORRY_V19.mp3',
        'audio/ARTICULATION/SHE_SELLS_SEASHELL_BY_THE_SEASHORE_THE_SHELLS_SHE_SELLS_ARE_SURELY_SEASHELLS_V17.mp3',
        'audio/ARTICULATION/SIX_SLIPPERY_SNAILS_SLID_SLOWLY_SEAWARD_SLIDING_SILENTLY_V18.mp3',
        'audio/ARTICULATION/THE_SIXTH_SICK_SHEIK_S_SIXTH_SHEEP_S_SICK_V16.mp3'
      ],
      resources: [
        'https://www.youtube.com/watch?v=8sQoYa8TptI',
        'https://www.youtube.com/shorts/WN1K3ry1y3s',
        'https://www.youtube.com/shorts/R8p51Y6R6pA',
        'https://www.youtube.com/shorts/h7GmFT9DT5c'
      ],
      description:
          "Articulation involves the clear and distinct pronunciation of words and sounds, ensuring they are spoken correctly and easily understood."),
  SpeechModel(
      category: 'Pronounciation',
      sentences: [
        "He's an heir to the throne.",
        "Freshly fried flying fish.",
        "She's a successful actress.",
        "A proper copper coffee pot.",
        "Schedule your Schedule Carefully",
        "Rural juror",
        "THe water is boiling.",
        "She saw Susie in the shoeshine shop.",
        "The sixth sick sheik's sixth sheep's sick.",
        "The wind is blowing."
      ],
      index: 3,
      audioPath: [
        'audio/PRONUNCIATION/HE_S_AN_HEIR_TO_THE_THRONE_V72.mp3',
        'audio/PRONUNCIATION/FRESHLY_FRIED_FLYING_FISH_V81.mp3',
        'audio/PRONUNCIATION/SHE_S_A_SUCCESSFUL_ACTRESS_V75.mp3',
        'audio/PRONUNCIATION/A_PROPER_COPPER_COFFEE_POT_V78.mp3',
        'audio/PRONUNCIATION/SCHEDULE_YOUR_SCHEDULE_CAREFULLY_V71.mp3',
        'audio/PRONUNCIATION/RURAL_JUROR_V76.mp3',
        'audio/PRONUNCIATION/THE_WATER_IS_BOILING_V73.mp3',
        'audio/PRONUNCIATION/SHE_SAW_SUSIE_IN_THE_SHOESHINE_SHOP_V77.mp3',
        'audio/PRONUNCIATION/THE_SIXTH_SICK_SHEIK_S_SIXTH_SHEEP_S_SICK_V79.mp3',
        'audio/PRONUNCIATION/THE_WIND_IS_BLOWING_V74.mp3'
      ],
      description:
          'Pronunciation relates to the correct way of saying words, including the accurate sounds and stress patterns used in a particular language.'),
  SpeechModel(
      category: 'Communication',
      sentences: [
        "I understand your perspective.",
        "I value your opinion on this matter",
        "We should engage in open dialogue.",
        "Can you elaborate on your proposal?",
        "Constructive feedback is essential.",
        "Could you clarify your point?",
        "Effective Communication is Key",
        "I appreciate your input",
        "Let's collaborate on this project.",
        "Let's discuss this further."
      ],
      index: 4,
      audioPath: [
        'audio/COMMUNICATION/I_UNDERSTAND_YOUR_PERSPECTIVE_V5.mp3',
        'audio/COMMUNICATION/I_VALUE_YOUR_OPINION_ON_THIS_MATTER_V8.mp3',
        'audio/COMMUNICATION/WE_SHOULD_ENGAGE_IN_OPEN_DIALOUGE_V9.mp3',
        'audio/COMMUNICATION/CAN_YOU__ELABORATE_ON_YOUR_PROPOSAL___V10.mp3',
        'audio/COMMUNICATION/CONSTRUCTIVE_FEEDBACK_IS_ESSENTIAL_V11.mp3',
        'audio/COMMUNICATION/COULD_YOU_CLARIFY_YOUR_POINT__V4.mp3',
        'audio/COMMUNICATION/EFFECTIVE_COMMUNICATION_IS_KEY_V12.mp3',
        'audio/COMMUNICATION/I_APPRECIATE_YOUR_INPUT_V1.mp3',
        'audio/COMMUNICATION/LETS_COLLABORATE_IN_THIS_PROJECT_V7.mp3',
        'audio/COMMUNICATION/LETS_DISCUSS_THIS_FURTHER_V3.mp3'
      ],
      resources: [
        'https://www.youtube.com/watch?v=HAnw168huqA',
        'https://www.youtube.com/shorts/h8ZJSAyJ_bQ',
        'https://www.youtube.com/shorts/jW0wlFcU-Zg'
      ],
      description:
          'Communication encompasses the exchange of information, thoughts, and ideas between individuals or groups through various means, such as spoken or written language, gestures, or body language.'),
  SpeechModel(
      category: 'Linguistics',
      sentences: [
        "Phonetics studies speech sounds.",
        "Syntax deals with sentence structure.",
        "Morphology analyzes word forms.",
        "Pragmatics studies language in context.",
        "Phonology studies sound patterns.",
        "Morphemes are the units of morphology.",
        "Pragmatics considers language use.",
        "Semantics explores word meanings.",
        "Syntax examines sentence structure.",
        'Semantics delves into meanings.'
      ],
      index: 5,
      audioPath: [
        'audio/LINGUISTICS/PHONETICS_STUDIES_SPEECH_SOUNDS_V51.mp3',
        'audio/LINGUISTICS/SYNTAX_DEALS_WITH_SENTENCE_STRUCTURE_V52.mp3',
        'audio/LINGUISTICS/MORPHOLOGY_ANALYZES_WORD_FORMS_V54.mp3',
        'audio/LINGUISTICS/PRAGMATIC_STUDIES_LANGUAGE_IN_CONTEXT_V55.mp3',
        'audio/LINGUISTICS/PHONOLOGY_STUDIES_SOUNDS_IN_PATTERNS_V56.mp3',
        'audio/LINGUISTICS/MORPHEMES_ARE_THE_UNITS_OF_MORPHOLOGY_V59.mp3',
        'audio/LINGUISTICS/PRAGMATICS_CONSIDERS_LANGUAGE_USE_V60.mp3',
        'audio/LINGUISTICS/SEMANTIC_EXPLORES_WORD_MEANINGS_V53.mp3',
        'audio/LINGUISTICS/SYNTAX_EXAMINES_SENTENCE_STRUCTURE_V57.mp3',
        'audio/LINGUISTICS/SEMANTICS_DELVES_INTO_MEANINGS_V58.mp3'
      ],
      resources: [
        'https://www.youtube.com/watch?v=9uZam0ubq-Y',
        'https://www.youtube.com/watch?v=qu4zyRqILYM'
      ],
      description:
          'Linguistics is the scientific study of language, exploring its structure, evolution, and usage, as well as the principles underlying it.'),
  SpeechModel(
      category: 'Vocalization',
      sentences: [
        "Harmonize with others in a choir.",
        "Practice your vocal warm ups.",
        "Project your voice for clarity.",
        "Project your voice with confidence.",
        "Resonate with your audience.",
        "Sing scales to improve vocal range.",
        "Singing requires proper vocal technique.",
        "Vocal exercises enhance vocal ability.",
        "Vocalize with proper breath control.",
        "Work on vocal resonance."
      ],
      index: 6,
      audioPath: [
        'audio/VOCALIZATION/HARMONIZE_WITH_OTHERS_IN_A_CHOIR_V8.mp3',
        'audio/VOCALIZATION/PRACTICE_YOUR_VOCAL_WARM_UPS_V1.mp3',
        'audio/VOCALIZATION/PROJECT_YOUR_VOICE_FOR_CLARITY_V4.mp3',
        'audio/VOCALIZATION/PROJECT_YOUR_VOICE_WITH_CONFIDENCE_V10.mp3',
        'audio/VOCALIZATION/RESONATE_WITH_YOUR_AUDIENCE_V9.mp3',
        'audio/VOCALIZATION/SING_SCALES_TO_IMPROVE_VOCAL_RANGE_V3.mp3',
        'audio/VOCALIZATION/SINGING_REQUIRES_PROPER_VOCAL_TECHNIQUE_V7.mp3',
        'audio/VOCALIZATION/VOCAL_EXERCISES_ENHANCE_VOCAL_ABILITY_V6.mp3',
        'audio/VOCALIZATION/VOCALIZE_WITH_PROPER_BREATH_CONTROL_V2.mp3',
        'audio/VOCALIZATION/WORK_ON_VOCAL_RESONANCE_V5.mp3'
      ],
      resources: [
        'https://www.youtube.com/shorts/NXU_Du_BCno',
        'https://www.youtube.com/watch?v=NMFH6Ob801I'
      ],
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
      audioPath: [
        'audio/ORATION/LADIES_AND_GENTLEMEN_TODAY_I_D_LIKE_TO_DISCUSS_ABOUT_BROADCASTING_V61.mp3',
        'audio/ORATION/IN_CONCLUSION_LET_ME_SUMMARIZE_MY_MAIN_POINTS_V62.mp3',
        'audio/ORATION/I_WANT_TO_INPIRE_YOU_WITH_MY_WORDS_V63.mp3',
        'audio/ORATION/THIS_SPEECH_AIMS_TO_INFORM_AND_PERSUADE_V64.mp3',
        'audio/ORATION/AS_A_PUBLIC_SPEAKER_I_STRIVE_FOR_IMPACT_V65.mp3',
        'audio/ORATION/GREETINGS_ESTEEMED_COLLEAGUES_V66.mp3',
        'audio/ORATION/IN_SUMMARY_LETS_RECAP_THE_MAIN_POINTS_V67.mp3',
        'audio/ORATION/I_AIM_TO_MOTIVATE_AND_UPLIFT_V68.mp3',
        'audio/ORATION/THIS_ADDRESS_SEEKS_TO_INFORM_AND_SWAY_V69.mp3',
        'audio/ORATION/MY_SPEECHES_ASPIRE_TO_LEAVE_AN_IMPACT_V70.mp3'
      ],
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
      audioPath: [
        'audio/EXPRESSION/IM_THRILLED_TO_BE_HERE_TODAY_V31.mp3',
        'audio/EXPRESSION/I_FEEL_DEEPLY_HONORED_AND_GRATEFUL_V32.mp3',
        'audio/EXPRESSION/MY_PASSION_FOR_THIS_TOPIC_IS_EVIDENT_V33.mp3',
        'audio/EXPRESSION/I_CANT_OVEREMPHATIZE_THE_IMPORTANCE_OF_THIS_ISSUE_V34.mp3',
        'audio/EXPRESSION/LET_ME_CONVEY_MY_ENTHUSIASM_FOR_OUR_PROJECT_V35.mp3',
        'audio/EXPRESSION/IM_GENUINELY_EXCITED_TO_BE_HERE_V36.mp3',
        'audio/EXPRESSION/IM_PROFOUNDLY_APPRECIATIVE_OF_THIS_OPPORTUNITY_V37.mp3',
        'audio/EXPRESSION/MY_FERVOR_FOR_THIS_PROJECT_SHINES_THROUGH_V38.mp3',
        'audio/EXPRESSION/THE_SIGNIFICANCE_OF_THIS_MATTER_CANT_BE_OVERSTATED_V39.mp3',
        'audio/EXPRESSION/ALLOW_ME_TO_CONVEY_MY_ENTHUSIASM_FOR_OUR_CAUSE_V40.mp3'
      ],
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
      audioPath: [
        'audio/INTONATION/ARE_YOU_SURE_ABOUT_THAT__V41.mp3',
        'audio/INTONATION/I_CANT_BELIEVE_YOU_DID_THAT!_V42.mp3',
        'audio/INTONATION/IT_S_A_BEAUTIFUL_DAY_ISN_T_IT__V43.mp3',
        'audio/INTONATION/YOU_RE_COMING_TO_THE_PARTY_RIGHT__V44.mp3',
        'audio/INTONATION/I_HAVE_A_QUESTIUON_FOR_YOU_V45.mp3',
        'audio/INTONATION/YOU_REALLY_THINK_SO__V46.mp3',
        'audio/INTONATION/I_CANT_HARDLY_BELIEVE_IT!_V47.mp3',
        'audio/INTONATION/IT_S_A_BEAUTIFUL_DAY_DONT_YOU_THINK__V48.mp3',
        'audio/INTONATION/YOU_LL_BE_AT_THE_GATHERING_WONT_YOU__V49.mp3',
        'audio/INTONATION/I_VE_GOT_A_QUESTION_FOR_YOU_OKAY__V50.mp3',
      ],
      resources: [
        'https://www.youtube.com/watch?v=pG1DUglSm-E',
        'https://www.youtube.com/watch?v=bSx6Zg9Ibgw'
      ],
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
      audioPath: [
        'audio/CONSISTENCY/COMSISTENCY_IS_THE_KEY_TO_SUCCESS_V1.mp3',
        'audio/CONSISTENCY/WE_NEED_TO_MAINTAIN_A_CONSISTENT_APPROACH_V2.mp3',
        'audio/CONSISTENCY/OUR_POLICIES_MUST_REMAIN_CONSISTENT_V3.mp3',
        'audio/CONSISTENCY/CONSISTENCY_BUILDS_TRUST_WITH_OUR_CUSTOMERS_V4.mp3',
        'audio/CONSISTENCY/INCONSISTENCY_CAN_LEAD_TO_CONFUSION_V5.mp3',
        'audio/CONSISTENCY/STEADINESS_IS_THE_PATHWAY_TO_ACHIEVEMENT_V6.mp3',
        'audio/CONSISTENCY/WE_MUST_STICK_TO_A_UNIFORM_STRATEGY_V7.mp3',
        'audio/CONSISTENCY/OUR_PRINCIPLES_SHOULD_REMAIN_UNWAVERING_V8.mp3',
        'audio/CONSISTENCY/RELIABILITY_FOSTERS_TRUST_AMONG_CLIENTS_V9.mp3',
        'audio/CONSISTENCY/INCONSISTENCY_LEADS_TO_AMBIGUITY_V10.mp3'
      ],
      description:
          'Consistency refers to the quality of being uniform, dependable, or reliable in behavior, speech, or action. In communication, it ensures that messages are clear and coherent over time.'),
  SpeechModel(
      category: 'Enunciation',
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
      audioPath: [
        'audio/ENUNCIATION/CLEAR_COMMUNICATION_IS_CRUCIAL_FOR_SUCCESS_V21.mp3',
        'audio/ENUNCIATION/ARTICULATE_YOUR_THOUGHTS_WITH_PRECITION_AND_CLARITY_V22.mp3',
        'audio/ENUNCIATION/ENSURE_EVERY_SYLLABLE_IS_ENUNCIATED_EFFECTIVELY_V23.mp3',
        'audio/ENUNCIATION/THE_ENUNCIATOR_ANNOUNCED_THE_IMPORTANT_NEWS_V24.mp3',
        'audio/ENUNCIATION/PROPER_ENUNCIATION_ENHANCES_UNDERSTANDING_V25.mp3',
        'audio/ENUNCIATION/ENUNCIATE_EACH_WORD_DISTINCTLY_AND_CONFIDENTLY_V26.mp3',
        'audio/ENUNCIATION/THE_SPEAKERS_ENUNCIATION_WAS_IMPECCABLE_V27.mp3',
        'audio/ENUNCIATION/ENUNCIATE_YOUR_WORDS_FOR_A_POWERFUL_IMPACT_V28.mp3',
        'audio/ENUNCIATION/ENUNCIATION_IS_THE_KEY_TO_EFFECTIVE_COMMUNICATION_V29.mp3',
        'audio/ENUNCIATION/PRACTICING_ENUNCIATION_IMPROVES_SPEECH_CLARITY_V30.mp3',
      ],
      resources: [
        'https://www.youtube.com/watch?v=qjm53hzsKPw',
        'https://www.youtube.com/watch?v=Mj3cgszearc&feature=youtu.be',
        'https://www.youtube.com/watch?v=SfTwY3_zKkQ'
      ],
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
      audioPath: [
        'audio/TONGUE TWISTERS/SHE_SELLS_SEASHELLS_BY_THE_SEASHORE_V1.mp3',
        'audio/TONGUE TWISTERS/UNIQUE_NEW_YORK_NEW_YORK_S_UNIQUE_V2.mp3',
        'audio/TONGUE TWISTERS/RED_LEATHER_YELLOW_LEATHER_V3.mp3',
        'audio/TONGUE TWISTERS/SIX_SLIPPERY_SNAILS_SLID_SLOWLY_SOUTHWARD_V4.mp3',
        'audio/TONGUE TWISTERS/HOW_CAN_A_CLAM_CRAM_IN_A_CLEAN_CREAM_CAN__V5.mp3',
        'audio/TONGUE TWISTERS/FUZZY_WUZZY_WAS_A_BEAR_FUZZY_WUZZY_HAD_NO_HAIR_FUZZY_WUZZY_WASN_T_VERY_FUZZY_WAS_HE__V6.mp3',
        'audio/TONGUE TWISTERS/SALLY_SELLS_SEASHELLS_BY_THE_SEASHORE_THE_SHELLS_SHE_SELLS_ARE_SURELY_SEASHELLS_V7.mp3',
        'audio/TONGUE TWISTERS/PETER_PIPER_PICKED_A_PECK_OF_PICKLED_PEPPERS_V1.mp3',
        'audio/TONGUE TWISTERS/SHE_SEES_CHEESE_SITTING_ON_THE_BLEACHERS_V2.mp3',
        'audio/TONGUE TWISTERS/SHE_SEES_CHEESE_SITTING_ON_THE_BLEACHERS_V2.mp3',
      ],
      description:
          'Consistency refers to the quality of being uniform, dependable, or reliable in behavior, speech, or action. In communication, it ensures that messages are clear and coherent over time.'),
];
