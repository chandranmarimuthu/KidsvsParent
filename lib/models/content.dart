import 'package:flutter/material.dart';

class QuizQuestion {
  const QuizQuestion({required this.prompt, required this.options, required this.answerIndex, required this.explanation, this.id, this.learningPathId});
  final String prompt;
  final List<String> options;
  final int answerIndex;
  final String explanation;
  final String? id;
  final String? learningPathId;
}

class ParentTopic {
  const ParentTopic({required this.title, required this.subtitle, required this.icon, required this.color, required this.guidance, required this.questions});
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String guidance;
  final List<QuizQuestion> questions;
}

enum LearningKind { regular, dictionary, kural, tracing, drawing, story }

class LearningTopic {
  const LearningTopic({required this.id, required this.title, required this.subtitle, required this.icon, required this.color, required this.kind, required this.description, required this.questions});
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final LearningKind kind;
  final String description;
  final List<QuizQuestion> questions;
}

class ScienceLesson {
  const ScienceLesson({required this.title, required this.explanation, required this.observation});
  final String title;
  final String explanation;
  final String observation;
}

abstract final class AppContent {
  static List<QuizQuestion> dailyQuizForPath(String learningPathId, DateTime date, {Iterable<QuizQuestion> importedQuestions = const []}) {
    final topic = learningTopics.firstWhere((candidate) => candidate.id == learningPathId);
    final bank = [
      ...topic.questions,
      ...importedQuestions.where((question) => question.learningPathId == learningPathId),
    ];
    if (bank.isEmpty) return const [];
    final dayNumber = DateTime(date.year, date.month, date.day).difference(DateTime(2026, 1, 1)).inDays;
    final start = (dayNumber % bank.length + bank.length) % bank.length;
    final count = bank.length < 5 ? bank.length : 5;
    return List.generate(count, (index) => bank[(start + index) % bank.length]);
  }

  static List<QuizQuestion> dailyScienceQuiz(DateTime date, {Iterable<QuizQuestion> additionalQuestions = const []}) =>
      dailyQuizForPath('science', date, importedQuestions: additionalQuestions);

  static const scienceLessons = <ScienceLesson>[
    ScienceLesson(title: 'How plants make food', explanation: 'Leaves use energy from sunlight, water from the roots, and carbon dioxide from the air to make sugar. Chlorophyll helps leaves capture light and gives many of them their green color.', observation: 'Compare a plant near a bright window with one farther away. What is the same, and what is different?'),
    ScienceLesson(title: 'Water travels in a cycle', explanation: 'Sunlight warms water and some of it evaporates into invisible water vapor. Higher in the air it cools and condenses into tiny droplets in clouds. When droplets gather, water can fall as rain.', observation: 'Look for water changing places today: a drying puddle, dew, or clouds. What might have warmed or cooled it?'),
    ScienceLesson(title: 'Light makes shadows', explanation: 'Light usually travels in straight lines. An opaque object blocks some light, making a darker shape called a shadow. The shadow changes when the light or object moves.', observation: 'With a grown-up, place a toy near a lamp and move it closer or farther away. Notice how its shadow changes.'),
    ScienceLesson(title: 'Sound is a vibration', explanation: 'A sound begins when something vibrates, or moves back and forth. Those vibrations travel through air to our ears. A faster vibration usually sounds higher in pitch.', observation: 'With a grown-up, gently pluck a rubber band stretched around an empty box. Watch it move and listen to its sound.'),
    ScienceLesson(title: 'Forces can push and pull', explanation: 'A force is a push or a pull. Forces can start or stop motion, change direction, or change an object’s shape. Friction is a force that can slow sliding objects down.', observation: 'Slide the same toy across a smooth book and a folded towel. Which surface slows it sooner?'),
    ScienceLesson(title: 'Animals need a habitat', explanation: 'A habitat is a place where a living thing finds what it needs, such as food, water, shelter, and space. Different plants and animals are suited to different habitats.', observation: 'Notice a small outdoor space. What living things are there, and what might they use for food or shelter?'),
  ];

  static const scienceQuestions = <QuizQuestion>[
    QuizQuestion(prompt: 'What do most green plants use to make food?', options: ['Light from the Sun', 'Moonlight only', 'Plastic'], answerIndex: 0, explanation: 'Plants use light energy, water, and carbon dioxide to make sugar.'),
    QuizQuestion(prompt: 'Which part usually takes in water from the soil?', options: ['Flower petals', 'Roots', 'Fruit'], answerIndex: 1, explanation: 'Roots absorb water and minerals from the soil and help anchor the plant.'),
    QuizQuestion(prompt: 'What is evaporation?', options: ['Water vapor cooling into droplets', 'Liquid water changing into gas', 'Ice changing straight into a rock'], answerIndex: 1, explanation: 'When liquid water gains enough heat, some molecules escape into the air as water vapor.'),
    QuizQuestion(prompt: 'How does an opaque object make a shadow?', options: ['It blocks some light', 'It creates its own sunlight', 'It turns light into sound'], answerIndex: 0, explanation: 'A shadow forms where an object blocks light traveling toward a surface.'),
    QuizQuestion(prompt: 'What starts most sounds?', options: ['A vibration', 'A shadow', 'A smell'], answerIndex: 0, explanation: 'A vibrating object makes nearby air vibrate, and those vibrations can reach our ears.'),
    QuizQuestion(prompt: 'Which material is a magnet most likely to attract?', options: ['Paper', 'Glass', 'Iron'], answerIndex: 2, explanation: 'Magnets attract iron and some other metals, but not every metal.'),
    QuizQuestion(prompt: 'What happens to liquid water when it freezes?', options: ['It becomes solid ice', 'It becomes sunlight', 'It disappears forever'], answerIndex: 0, explanation: 'As water cools enough, its particles settle into a solid structure called ice.'),
    QuizQuestion(prompt: 'What makes a science test fair?', options: ['Change one thing and observe', 'Change everything at once', 'Choose the answer before testing'], answerIndex: 0, explanation: 'Changing one thing at a time helps us notice what may have caused a result.'),
    QuizQuestion(prompt: 'What can a habitat provide to an animal?', options: ['Food, water, and shelter', 'Only toys', 'The same weather everywhere'], answerIndex: 0, explanation: 'A habitat provides resources and conditions that help an organism live.'),
    QuizQuestion(prompt: 'Why is soil useful to many plants?', options: ['It can hold water and support roots', 'It makes every plant move', 'It replaces sunlight'], answerIndex: 0, explanation: 'Soil can anchor roots and hold water and nutrients plants need.'),
    QuizQuestion(prompt: 'Why do we see day and night on Earth?', options: ['Earth spins as it orbits the Sun', 'The Sun switches off each evening', 'The Moon covers the whole Earth'], answerIndex: 0, explanation: 'As Earth spins, places turn toward the Sun for day and away from it for night.'),
    QuizQuestion(prompt: 'Which is an observation rather than a guess?', options: ['The leaf feels smooth', 'The plant is happy', 'It will grow tomorrow'], answerIndex: 0, explanation: 'An observation describes something you can notice with your senses or a tool.'),
  ];

  static const parentTopics = <ParentTopic>[
    ParentTopic(title: 'Child’s emotions', subtitle: 'Notice feelings and meet them with care', icon: Icons.mood_rounded, color: Color(0xFFEAAE6B), guidance: 'Name the feeling, stay curious, and let your child know you are there before trying to solve the problem.', questions: [
      QuizQuestion(prompt: 'A child is upset after a hard day. What is a helpful first step?', options: ['Listen and name what you notice', 'Tell them not to worry', 'Change the subject quickly'], answerIndex: 0, explanation: 'Feeling heard can help a child settle enough to talk about what might help next.'),
      QuizQuestion(prompt: 'Which question invites a child to share more?', options: ['Why are you being difficult?', 'Would you like to tell me what felt hard?', 'You are fine, right?'], answerIndex: 1, explanation: 'An open, gentle question gives the child room to describe their experience.'),
    ]),
    ParentTopic(title: 'Friendships', subtitle: 'Help children build kind connections', icon: Icons.diversity_1_rounded, color: Color(0xFF82B7A2), guidance: 'Help your child consider each person’s point of view and practise a kind way to repair a disagreement.', questions: [
      QuizQuestion(prompt: 'Two friends disagree about a game. What can an adult encourage?', options: ['Hear both ideas and find a fair turn', 'Choose who is right immediately', 'End the friendship'], answerIndex: 0, explanation: 'Listening and taking turns gives children practice solving small conflicts together.'),
      QuizQuestion(prompt: 'What is a useful way to talk about friendship?', options: ['Only popular children make good friends', 'Notice how a friend makes you feel', 'Friends should always agree'], answerIndex: 1, explanation: 'Kindness, respect, and feeling safe matter more than popularity or constant agreement.'),
    ]),
    ParentTopic(title: 'Stress and calm', subtitle: 'Spot pressure and practise small resets', icon: Icons.spa_rounded, color: Color(0xFF8C9CCB), guidance: 'Look for changes in sleep, energy, or routines. A quiet pause, a simple choice, or a trusted conversation can help.', questions: [
      QuizQuestion(prompt: 'A task feels too big. What is a helpful next move?', options: ['Break it into one small first step', 'Add more pressure', 'Avoid talking about it'], answerIndex: 0, explanation: 'Small steps can make a challenging task feel more manageable.'),
      QuizQuestion(prompt: 'Which response can help a child settle?', options: ['A calm pause and a trusted adult nearby', 'A lecture while they are overwhelmed', 'A promise that nothing will ever go wrong'], answerIndex: 0, explanation: 'Calm presence offers support without making promises no one can guarantee.'),
    ]),
    ParentTopic(title: 'Study interests', subtitle: 'Make room for curiosity and choice', icon: Icons.lightbulb_rounded, color: Color(0xFFE8C35F), guidance: 'Notice which questions keep returning. Offer a choice of small activities and celebrate effort, not just correct answers.', questions: [
      QuizQuestion(prompt: 'How can a parent encourage a new interest?', options: ['Offer a small choice of ways to explore it', 'Compare the child with a classmate', 'Expect mastery right away'], answerIndex: 0, explanation: 'Choice and low-pressure exploration help curiosity grow at the child’s pace.'),
      QuizQuestion(prompt: 'What is worth praising during learning?', options: ['Trying a new strategy', 'Only being the fastest', 'Never making a mistake'], answerIndex: 0, explanation: 'Recognizing effort and strategy supports confidence through challenge.'),
    ]),
    ParentTopic(title: 'Listening skills', subtitle: 'Build trust through everyday attention', icon: Icons.hearing_rounded, color: Color(0xFFDC8C7A), guidance: 'Pause distractions, get to your child’s level when comfortable, and reflect back what you heard before giving advice.', questions: [
      QuizQuestion(prompt: 'What can show a child they have your attention?', options: ['Pause and reflect back their words', 'Keep scrolling while they talk', 'Finish every sentence for them'], answerIndex: 0, explanation: 'A brief reflection helps check that you understood and shows you are listening.'),
      QuizQuestion(prompt: 'When is advice usually most useful?', options: ['After understanding what the child needs', 'Before hearing the story', 'Instead of asking questions'], answerIndex: 0, explanation: 'Understanding first helps make support relevant to the child’s actual concern.'),
    ]),
  ];

  static const learningTopics = <LearningTopic>[
    LearningTopic(id: 'dictionary', title: 'Dictionary', subtitle: 'Words open little doors', icon: Icons.menu_book_rounded, color: Color(0xFF70A99A), kind: LearningKind.dictionary, description: 'Explore a few everyday words in English and Tamil.', questions: [
      QuizQuestion(prompt: 'What does “curious” mean?', options: ['Wanting to learn more', 'Feeling sleepy', 'Moving very fast'], answerIndex: 0, explanation: 'Curious means eager to know or learn something.'),
      QuizQuestion(prompt: 'Which word means “to notice with care”?', options: ['Observe', 'Forget', 'Rush'], answerIndex: 0, explanation: 'To observe is to watch or notice something carefully.'),
    ]),
    LearningTopic(id: 'thirukkural', title: 'Thirukkural', subtitle: 'Wisdom in two short lines', icon: Icons.format_quote_rounded, color: Color(0xFFDF9C62), kind: LearningKind.kural, description: 'Read a classic couplet and explore a child-friendly meaning.', questions: [
      QuizQuestion(prompt: 'What can a short piece of wisdom help us do?', options: ['Pause and think about our choices', 'Avoid learning anything new', 'Win every argument'], answerIndex: 0, explanation: 'A kural invites reflection on how we live and treat one another.'),
      QuizQuestion(prompt: 'The first Kural compares the start of the world to what?', options: ['The first letter', 'A mountain path', 'A river bend'], answerIndex: 0, explanation: 'It begins with the comparison of the letter “A” and the beginning of the world.'),
    ]),
    LearningTopic(id: 'letter_tracing', title: 'Letter studio', subtitle: 'Trace a letter, then try it freehand', icon: Icons.gesture_rounded, color: Color(0xFF8395C3), kind: LearningKind.tracing, description: 'Practise the shape of a letter with your finger.', questions: [
      QuizQuestion(prompt: 'Which is a vowel in English?', options: ['A', 'K', 'T'], answerIndex: 0, explanation: 'A is one of the English vowels: A, E, I, O, and U.'),
      QuizQuestion(prompt: 'What helps make handwriting easier to read?', options: ['Taking time with each shape', 'Pressing as hard as possible', 'Writing without looking'], answerIndex: 0, explanation: 'Slow, relaxed practice helps build control and clear letter shapes.'),
    ]),
    LearningTopic(id: 'drawing', title: 'Sketch garden', subtitle: 'Make a picture of your own', icon: Icons.draw_rounded, color: Color(0xFFD9826E), kind: LearningKind.drawing, description: 'Try a free drawing or choose a color and follow your ideas.', questions: [
      QuizQuestion(prompt: 'Which tool helps show a lighter color?', options: ['Use less pressure', 'Press harder', 'Draw faster'], answerIndex: 0, explanation: 'Lighter pressure can make a softer line.'),
      QuizQuestion(prompt: 'What is a good next step when a drawing feels tricky?', options: ['Start with one simple shape', 'Erase every idea', 'Stop trying forever'], answerIndex: 0, explanation: 'Simple shapes give you a starting point for more detailed drawings.'),
    ]),
    LearningTopic(id: 'stories', title: 'Brave little stories', subtitle: 'A short story about trying again', icon: Icons.auto_stories_rounded, color: Color(0xFF8AAF79), kind: LearningKind.story, description: 'Meet a small seed that finds its own way to grow.', questions: [
      QuizQuestion(prompt: 'What helped the seed grow in the story?', options: ['Time, care, and trying again', 'Being the biggest seed', 'Giving up after one day'], answerIndex: 0, explanation: 'Growth can take time, and care helps us keep going.'),
      QuizQuestion(prompt: 'What can you do when something is new?', options: ['Try one small step', 'Expect to know it already', 'Never ask for help'], answerIndex: 0, explanation: 'A small first step makes a new challenge easier to approach.'),
    ]),
    LearningTopic(id: 'coding', title: 'Code patterns', subtitle: 'Give clear steps to a tiny robot', icon: Icons.code_rounded, color: Color(0xFF6D9EAD), kind: LearningKind.regular, description: 'Coding starts with instructions, patterns, and helpful mistakes.', questions: [
      QuizQuestion(prompt: 'A sequence is…', options: ['Steps in an order', 'A kind of paint', 'A sound you hear once'], answerIndex: 0, explanation: 'A sequence is an ordered set of steps or events.'),
      QuizQuestion(prompt: 'If a robot turns the wrong way, what is useful?', options: ['Check and change the instruction', 'Blame the robot', 'Remove every step'], answerIndex: 0, explanation: 'Debugging means checking what happened and improving the instructions.'),
    ]),
    LearningTopic(id: 'puzzles', title: 'Puzzle path', subtitle: 'Look for clues and patterns', icon: Icons.extension_rounded, color: Color(0xFFE0B54E), kind: LearningKind.regular, description: 'Take your time, spot a pattern, and test one idea at a time.', questions: [
      QuizQuestion(prompt: 'What comes next: 2, 4, 6, …?', options: ['8', '7', '10'], answerIndex: 0, explanation: 'The pattern adds two each time, so 8 comes next.'),
      QuizQuestion(prompt: 'What is a helpful puzzle strategy?', options: ['Look for a repeated clue', 'Guess without looking', 'Change every answer at once'], answerIndex: 0, explanation: 'Patterns and clues help narrow down possible answers.'),
    ]),
    LearningTopic(id: 'science', title: 'Science around us', subtitle: 'Learn a little, then look closely', icon: Icons.science_rounded, color: Color(0xFF6CA6A0), kind: LearningKind.regular, description: 'Discover how plants, water, light, sound, forces, and habitats work.', questions: scienceQuestions),
    LearningTopic(id: 'india_history', title: 'India, state by state', subtitle: 'Places, people, and shared stories', icon: Icons.temple_hindu_rounded, color: Color(0xFFE18C67), kind: LearningKind.regular, description: 'Begin exploring India’s states, landmarks, and history.', questions: [
      QuizQuestion(prompt: 'How many states does India have?', options: ['28', '18', '36'], answerIndex: 0, explanation: 'India has 28 states and 8 union territories.'),
      QuizQuestion(prompt: 'What is one way to learn about a place?', options: ['Explore its people, language, and history', 'Assume every place is the same', 'Only learn its name'], answerIndex: 0, explanation: 'Places are shaped by people, languages, nature, and history.'),
    ]),
  ];
}