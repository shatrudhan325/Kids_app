import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════
//  QUIZ DATA — 10 Categories × 3 Levels = 30 Quiz Sets
// ═══════════════════════════════════════════════════════════════════

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? hint;
  final String? funFact;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.hint,
    this.funFact,
  });
}

class QuizCategory {
  final String name;
  final String icon;
  final String subtitle;
  final List<Color> colors;
  final String badge;
  final Map<int, List<QuizQuestion>> levels; // 1,2,3

  const QuizCategory({
    required this.name,
    required this.icon,
    required this.subtitle,
    required this.colors,
    this.badge = '',
    required this.levels,
  });
}

class QuizContent {
  static final List<QuizCategory> categories = [
    // ──────────────── 1. ANIMALS 🦁 ────────────────
    QuizCategory(
      name: 'Animals',
      icon: '🦁',
      subtitle: 'Wild & Pet Animals',
      colors: [const Color(0xFFFF6B35), const Color(0xFFD32F2F)],
      badge: '🔥',
      levels: {
        1: const [
          QuizQuestion(question: 'Which animal says "Moo"?', options: ['Dog', 'Cow', 'Cat', 'Duck'], correctIndex: 1, funFact: 'Cows have best friends!'),
          QuizQuestion(question: 'How many legs does a dog have?', options: ['2', '4', '6', '8'], correctIndex: 1),
          QuizQuestion(question: 'Which animal is the King of the Jungle?', options: ['Tiger', 'Elephant', 'Lion', 'Bear'], correctIndex: 2, funFact: 'Lions sleep up to 20 hours a day!'),
          QuizQuestion(question: 'Which animal can fly?', options: ['Fish', 'Bird', 'Snake', 'Frog'], correctIndex: 1),
          QuizQuestion(question: 'What does a cat say?', options: ['Woof', 'Moo', 'Meow', 'Quack'], correctIndex: 2),
          QuizQuestion(question: 'Which animal lives in water?', options: ['Lion', 'Fish', 'Dog', 'Monkey'], correctIndex: 1),
          QuizQuestion(question: 'Which animal has a trunk?', options: ['Giraffe', 'Elephant', 'Zebra', 'Horse'], correctIndex: 1, funFact: 'Elephants can smell water from 12 miles away!'),
          QuizQuestion(question: 'Which animal hops?', options: ['Cat', 'Dog', 'Rabbit', 'Cow'], correctIndex: 2),
        ],
        2: const [
          QuizQuestion(question: 'Which is the fastest land animal?', options: ['Lion', 'Cheetah', 'Horse', 'Deer'], correctIndex: 1, funFact: 'Cheetahs can run 112 km/h!'),
          QuizQuestion(question: 'What is a baby dog called?', options: ['Kitten', 'Cub', 'Puppy', 'Foal'], correctIndex: 2),
          QuizQuestion(question: 'Which animal has black & white stripes?', options: ['Horse', 'Zebra', 'Cow', 'Panda'], correctIndex: 1),
          QuizQuestion(question: 'How many legs does a spider have?', options: ['6', '8', '10', '4'], correctIndex: 1, funFact: 'Spiders are not insects — they are arachnids!'),
          QuizQuestion(question: 'Which animal changes color?', options: ['Frog', 'Chameleon', 'Snake', 'Lizard'], correctIndex: 1),
          QuizQuestion(question: 'What is the largest animal on Earth?', options: ['Elephant', 'Giraffe', 'Blue Whale', 'Shark'], correctIndex: 2),
          QuizQuestion(question: 'Which bird cannot fly?', options: ['Eagle', 'Penguin', 'Parrot', 'Sparrow'], correctIndex: 1),
          QuizQuestion(question: 'Which animal has a long neck?', options: ['Elephant', 'Giraffe', 'Horse', 'Bear'], correctIndex: 1),
          QuizQuestion(question: 'Where do bears sleep in winter?', options: ['Tree', 'Cave', 'Water', 'Nest'], correctIndex: 1, hint: 'It is called hibernation'),
          QuizQuestion(question: 'Which animal gives us wool?', options: ['Cow', 'Goat', 'Sheep', 'Horse'], correctIndex: 2),
        ],
        3: const [
          QuizQuestion(question: 'Which mammal can fly?', options: ['Squirrel', 'Bat', 'Penguin', 'Chicken'], correctIndex: 1, funFact: 'Bats are the only mammals that can truly fly!'),
          QuizQuestion(question: 'How many hearts does an octopus have?', options: ['1', '2', '3', '4'], correctIndex: 2, funFact: 'They also have blue blood!'),
          QuizQuestion(question: 'What is a group of wolves called?', options: ['Herd', 'Flock', 'Pack', 'Swarm'], correctIndex: 2),
          QuizQuestion(question: 'Which animal has the best memory?', options: ['Dog', 'Dolphin', 'Elephant', 'Cat'], correctIndex: 2),
          QuizQuestion(question: 'Which sea creature has no brain?', options: ['Octopus', 'Jellyfish', 'Dolphin', 'Shark'], correctIndex: 1, funFact: 'Jellyfish have survived 500 million years without brains!'),
          QuizQuestion(question: 'What is a baby kangaroo called?', options: ['Pup', 'Kit', 'Joey', 'Calf'], correctIndex: 2),
          QuizQuestion(question: 'Which insect makes honey?', options: ['Butterfly', 'Bee', 'Ant', 'Wasp'], correctIndex: 1),
          QuizQuestion(question: 'How many stomachs does a cow have?', options: ['1', '2', '3', '4'], correctIndex: 3),
          QuizQuestion(question: 'Which reptile can regrow its tail?', options: ['Snake', 'Crocodile', 'Lizard', 'Turtle'], correctIndex: 2),
          QuizQuestion(question: 'Which animal sleeps standing up?', options: ['Dog', 'Horse', 'Cat', 'Rabbit'], correctIndex: 1),
          QuizQuestion(question: 'What is a group of fish called?', options: ['Pack', 'Herd', 'Flock', 'School'], correctIndex: 3),
          QuizQuestion(question: 'Which animal can see behind without turning?', options: ['Rabbit', 'Cat', 'Dog', 'Horse'], correctIndex: 0, funFact: 'Rabbits have nearly 360° vision!'),
        ],
      },
    ),

    // ──────────────── 2. FRUITS 🍎 ────────────────
    QuizCategory(
      name: 'Fruits',
      icon: '🍎',
      subtitle: 'Yummy Fruits Quiz',
      colors: [const Color(0xFF43A047), const Color(0xFF1B5E20)],
      levels: {
        1: const [
          QuizQuestion(question: 'Which fruit is yellow and curved?', options: ['Apple', 'Banana', 'Orange', 'Grape'], correctIndex: 1),
          QuizQuestion(question: 'Which fruit is red and round?', options: ['Banana', 'Mango', 'Apple', 'Pear'], correctIndex: 2),
          QuizQuestion(question: 'Which fruit has many seeds on outside?', options: ['Strawberry', 'Apple', 'Banana', 'Peach'], correctIndex: 0, funFact: 'A strawberry has about 200 seeds!'),
          QuizQuestion(question: 'What color is an orange?', options: ['Red', 'Green', 'Orange', 'Blue'], correctIndex: 2),
          QuizQuestion(question: 'Which is the biggest fruit?', options: ['Mango', 'Watermelon', 'Apple', 'Banana'], correctIndex: 1),
          QuizQuestion(question: 'Which fruit do monkeys love?', options: ['Apple', 'Banana', 'Grapes', 'Mango'], correctIndex: 1),
          QuizQuestion(question: 'Which fruit is purple and small?', options: ['Apple', 'Mango', 'Grape', 'Banana'], correctIndex: 2),
          QuizQuestion(question: 'Which fruit is green inside with black seeds?', options: ['Apple', 'Kiwi', 'Banana', 'Orange'], correctIndex: 1),
        ],
        2: const [
          QuizQuestion(question: 'Which fruit is known as "King of fruits"?', options: ['Apple', 'Mango', 'Banana', 'Pineapple'], correctIndex: 1),
          QuizQuestion(question: 'Which fruit has a crown on top?', options: ['Mango', 'Pineapple', 'Apple', 'Cherry'], correctIndex: 1, funFact: 'A pineapple takes 2-3 years to grow!'),
          QuizQuestion(question: 'Which fruit is the same as its color name?', options: ['Apple', 'Orange', 'Banana', 'Grape'], correctIndex: 1),
          QuizQuestion(question: 'What fruit is dried to make raisins?', options: ['Dates', 'Grapes', 'Figs', 'Plums'], correctIndex: 1),
          QuizQuestion(question: 'Which tropical fruit has spiky skin?', options: ['Mango', 'Lychee', 'Durian', 'Papaya'], correctIndex: 2),
          QuizQuestion(question: 'Which fruit is also called "butter fruit"?', options: ['Banana', 'Avocado', 'Mango', 'Papaya'], correctIndex: 1),
          QuizQuestion(question: 'Which berries are blue?', options: ['Strawberry', 'Raspberry', 'Blueberry', 'Blackberry'], correctIndex: 2),
          QuizQuestion(question: 'Which fruit has a fuzzy skin?', options: ['Apple', 'Peach', 'Plum', 'Cherry'], correctIndex: 1),
        ],
        3: const [
          QuizQuestion(question: 'Which fruit floats in water?', options: ['Grape', 'Apple', 'Cherry', 'Pear'], correctIndex: 1, funFact: 'Apples are 25% air, so they float!'),
          QuizQuestion(question: 'Botanically, which is a berry?', options: ['Strawberry', 'Raspberry', 'Banana', 'Blackberry'], correctIndex: 2, funFact: 'Bananas are technically berries!'),
          QuizQuestion(question: 'Which fruit has the most vitamin C?', options: ['Orange', 'Guava', 'Apple', 'Banana'], correctIndex: 1),
          QuizQuestion(question: 'Which country grows the most mangoes?', options: ['Brazil', 'India', 'China', 'Mexico'], correctIndex: 1),
          QuizQuestion(question: 'What fruit is 92% water?', options: ['Apple', 'Orange', 'Watermelon', 'Grape'], correctIndex: 2),
          QuizQuestion(question: 'Which fruit can ripen other fruits nearby?', options: ['Apple', 'Banana', 'Mango', 'Both A & B'], correctIndex: 3),
          QuizQuestion(question: 'Which fruit was the first to grow on the moon?', options: ['Apple', 'Peach', 'Strawberry', 'None — trick question!'], correctIndex: 3),
          QuizQuestion(question: 'Which fruit is also called "Chinese gooseberry"?', options: ['Lychee', 'Kiwi', 'Dragon Fruit', 'Guava'], correctIndex: 1),
          QuizQuestion(question: 'How many varieties of apple exist?', options: ['500', '2000', '5000', '7500+'], correctIndex: 3),
          QuizQuestion(question: 'Which fruit has its seeds on the outside?', options: ['Kiwi', 'Strawberry', 'Raspberry', 'Fig'], correctIndex: 1),
        ],
      },
    ),

    // ──────────────── 3. COLORS 🌈 ────────────────
    QuizCategory(
      name: 'Colors',
      icon: '🌈',
      subtitle: 'Rainbow World',
      colors: [const Color(0xFF7C4DFF), const Color(0xFFE040FB)],
      badge: 'NEW',
      levels: {
        1: const [
          QuizQuestion(question: 'What color is the sky on a clear day?', options: ['Red', 'Blue', 'Green', 'Yellow'], correctIndex: 1),
          QuizQuestion(question: 'What color are bananas?', options: ['Red', 'Blue', 'Yellow', 'Green'], correctIndex: 2),
          QuizQuestion(question: 'What color is grass?', options: ['Blue', 'Green', 'Yellow', 'Red'], correctIndex: 1),
          QuizQuestion(question: 'What color do you get mixing red + yellow?', options: ['Green', 'Purple', 'Orange', 'Pink'], correctIndex: 2),
          QuizQuestion(question: 'What color is snow?', options: ['Blue', 'White', 'Yellow', 'Grey'], correctIndex: 1),
          QuizQuestion(question: 'What color is a fire truck?', options: ['Blue', 'Yellow', 'Red', 'Green'], correctIndex: 2),
          QuizQuestion(question: 'Which color means "STOP"?', options: ['Green', 'Yellow', 'Blue', 'Red'], correctIndex: 3),
          QuizQuestion(question: 'What color is the sun in drawings?', options: ['Orange', 'Yellow', 'Red', 'White'], correctIndex: 1),
        ],
        2: const [
          QuizQuestion(question: 'Red + Blue = ?', options: ['Green', 'Orange', 'Purple', 'Brown'], correctIndex: 2),
          QuizQuestion(question: 'Blue + Yellow = ?', options: ['Purple', 'Green', 'Orange', 'Brown'], correctIndex: 1),
          QuizQuestion(question: 'Red + White = ?', options: ['Orange', 'Pink', 'Purple', 'Peach'], correctIndex: 1),
          QuizQuestion(question: 'How many colors in a rainbow?', options: ['5', '6', '7', '8'], correctIndex: 2, funFact: 'VIBGYOR — 7 colors!'),
          QuizQuestion(question: 'Which is NOT a primary color?', options: ['Red', 'Blue', 'Green', 'Yellow'], correctIndex: 2),
          QuizQuestion(question: 'What color is chocolate?', options: ['Black', 'Brown', 'Red', 'Orange'], correctIndex: 1),
          QuizQuestion(question: 'Which color is opposite of black?', options: ['Red', 'Grey', 'White', 'Blue'], correctIndex: 2),
          QuizQuestion(question: 'What color are most leaves in autumn?', options: ['Green', 'Orange', 'Blue', 'Purple'], correctIndex: 1),
        ],
        3: const [
          QuizQuestion(question: 'Which color has the longest wavelength?', options: ['Blue', 'Green', 'Red', 'Violet'], correctIndex: 2, funFact: 'That is why the sunset looks red!'),
          QuizQuestion(question: 'What are the 3 primary colors of light?', options: ['Red, Yellow, Blue', 'Red, Green, Blue', 'Red, Orange, Yellow', 'Blue, Yellow, Green'], correctIndex: 1),
          QuizQuestion(question: 'What color do all rainbow colors make?', options: ['Black', 'White', 'Grey', 'Brown'], correctIndex: 1),
          QuizQuestion(question: 'Which color represents peace?', options: ['Red', 'Blue', 'White', 'Green'], correctIndex: 2),
          QuizQuestion(question: 'What is the rarest color in nature?', options: ['Red', 'Green', 'Blue', 'Yellow'], correctIndex: 2),
          QuizQuestion(question: 'Black + White = ?', options: ['Brown', 'Cream', 'Grey', 'Beige'], correctIndex: 2),
          QuizQuestion(question: 'Which color calms people the most?', options: ['Red', 'Yellow', 'Blue', 'Orange'], correctIndex: 2),
          QuizQuestion(question: 'What color is the Indian flag\'s middle stripe?', options: ['Green', 'Orange', 'White', 'Blue'], correctIndex: 2),
        ],
      },
    ),

    // ──────────────── 4. SHAPES 📐 ────────────────
    QuizCategory(
      name: 'Shapes',
      icon: '📐',
      subtitle: 'Geometry Fun',
      colors: [const Color(0xFF00BCD4), const Color(0xFF006064)],
      levels: {
        1: const [
          QuizQuestion(question: 'How many sides does a triangle have?', options: ['2', '3', '4', '5'], correctIndex: 1),
          QuizQuestion(question: 'What shape is a ball?', options: ['Square', 'Circle', 'Triangle', 'Rectangle'], correctIndex: 1),
          QuizQuestion(question: 'How many sides does a square have?', options: ['3', '4', '5', '6'], correctIndex: 1),
          QuizQuestion(question: 'What shape is a TV screen?', options: ['Circle', 'Triangle', 'Rectangle', 'Oval'], correctIndex: 2),
          QuizQuestion(question: 'Which shape has no corners?', options: ['Square', 'Triangle', 'Circle', 'Rectangle'], correctIndex: 2),
          QuizQuestion(question: 'What shape is a pizza slice?', options: ['Square', 'Circle', 'Triangle', 'Rectangle'], correctIndex: 2),
          QuizQuestion(question: 'What shape is an egg?', options: ['Circle', 'Oval', 'Square', 'Triangle'], correctIndex: 1),
          QuizQuestion(question: 'How many corners does a rectangle have?', options: ['2', '3', '4', '5'], correctIndex: 2),
        ],
        2: const [
          QuizQuestion(question: 'How many sides does a hexagon have?', options: ['5', '6', '7', '8'], correctIndex: 1),
          QuizQuestion(question: 'What shape is a stop sign?', options: ['Circle', 'Square', 'Octagon', 'Hexagon'], correctIndex: 2),
          QuizQuestion(question: 'What is a 3D circle called?', options: ['Cube', 'Sphere', 'Cone', 'Cylinder'], correctIndex: 1),
          QuizQuestion(question: 'How many sides does a pentagon have?', options: ['4', '5', '6', '7'], correctIndex: 1),
          QuizQuestion(question: 'What shape is a dice?', options: ['Sphere', 'Cube', 'Cone', 'Cylinder'], correctIndex: 1),
          QuizQuestion(question: 'A shape with 8 sides is called?', options: ['Hexagon', 'Heptagon', 'Octagon', 'Nonagon'], correctIndex: 2),
          QuizQuestion(question: 'What shape is an ice cream cone?', options: ['Sphere', 'Cone', 'Cylinder', 'Cube'], correctIndex: 1),
          QuizQuestion(question: 'Which shape has equal sides and angles?', options: ['Rectangle', 'Triangle', 'Square', 'Oval'], correctIndex: 2),
        ],
        3: const [
          QuizQuestion(question: 'What is a 10-sided shape called?', options: ['Nonagon', 'Decagon', 'Dodecagon', 'Hendecagon'], correctIndex: 1),
          QuizQuestion(question: 'How many faces does a cube have?', options: ['4', '6', '8', '12'], correctIndex: 1, funFact: 'A cube has 6 faces, 12 edges, and 8 vertices!'),
          QuizQuestion(question: 'What shape is a honeycomb cell?', options: ['Square', 'Pentagon', 'Hexagon', 'Circle'], correctIndex: 2),
          QuizQuestion(question: 'Which shape has exactly one curved surface?', options: ['Cube', 'Cone', 'Sphere', 'Cylinder'], correctIndex: 2),
          QuizQuestion(question: 'A parallelogram with all equal sides is a?', options: ['Rectangle', 'Rhombus', 'Trapezoid', 'Square'], correctIndex: 1),
          QuizQuestion(question: 'What is a triangle with all sides equal?', options: ['Isosceles', 'Scalene', 'Right', 'Equilateral'], correctIndex: 3),
          QuizQuestion(question: 'How many edges does a triangular prism have?', options: ['6', '9', '12', '8'], correctIndex: 1),
          QuizQuestion(question: 'What 3D shape has 1 vertex and 1 circular face?', options: ['Cylinder', 'Hemisphere', 'Cone', 'Sphere'], correctIndex: 2),
        ],
      },
    ),

    // ──────────────── 5. NUMBERS 🔢 ────────────────
    QuizCategory(
      name: 'Numbers',
      icon: '🔢',
      subtitle: 'Math Wizardry',
      colors: [const Color(0xFF1565C0), const Color(0xFF0D47A1)],
      badge: '⚡',
      levels: {
        1: const [
          QuizQuestion(question: '2 + 3 = ?', options: ['4', '5', '6', '7'], correctIndex: 1),
          QuizQuestion(question: '5 - 2 = ?', options: ['1', '2', '3', '4'], correctIndex: 2),
          QuizQuestion(question: 'What comes after 9?', options: ['8', '10', '11', '12'], correctIndex: 1),
          QuizQuestion(question: 'How many fingers on one hand?', options: ['3', '4', '5', '6'], correctIndex: 2),
          QuizQuestion(question: '1 + 1 = ?', options: ['1', '2', '3', '0'], correctIndex: 1),
          QuizQuestion(question: 'Which is bigger: 7 or 4?', options: ['4', '7', 'Same', 'None'], correctIndex: 1),
          QuizQuestion(question: '10 - 5 = ?', options: ['3', '4', '5', '6'], correctIndex: 2),
          QuizQuestion(question: 'Count: 🍎🍎🍎 = ?', options: ['2', '3', '4', '5'], correctIndex: 1),
        ],
        2: const [
          QuizQuestion(question: '7 × 3 = ?', options: ['18', '20', '21', '24'], correctIndex: 2),
          QuizQuestion(question: '48 ÷ 6 = ?', options: ['6', '7', '8', '9'], correctIndex: 2),
          QuizQuestion(question: 'What is 15 + 27?', options: ['42', '43', '41', '40'], correctIndex: 0),
          QuizQuestion(question: 'Which is an even number?', options: ['3', '7', '12', '15'], correctIndex: 2),
          QuizQuestion(question: '100 - 45 = ?', options: ['55', '65', '45', '50'], correctIndex: 0),
          QuizQuestion(question: '9 × 9 = ?', options: ['72', '81', '90', '99'], correctIndex: 1),
          QuizQuestion(question: 'What is half of 50?', options: ['20', '25', '30', '35'], correctIndex: 1),
          QuizQuestion(question: 'Which is odd: 8, 14, 23, 36?', options: ['8', '14', '23', '36'], correctIndex: 2),
        ],
        3: const [
          QuizQuestion(question: 'What is 12 × 12?', options: ['124', '132', '144', '156'], correctIndex: 2),
          QuizQuestion(question: 'Square root of 64?', options: ['6', '7', '8', '9'], correctIndex: 2, funFact: '8 × 8 = 64!'),
          QuizQuestion(question: 'First 3 prime numbers are?', options: ['1,2,3', '2,3,5', '1,3,5', '2,3,7'], correctIndex: 1),
          QuizQuestion(question: '1000 ÷ 8 = ?', options: ['120', '125', '130', '135'], correctIndex: 1),
          QuizQuestion(question: 'What is 25% of 200?', options: ['25', '40', '50', '75'], correctIndex: 2),
          QuizQuestion(question: 'Roman numeral IX = ?', options: ['6', '9', '11', '4'], correctIndex: 1),
          QuizQuestion(question: 'What is 7³?', options: ['343', '353', '243', '49'], correctIndex: 0),
          QuizQuestion(question: 'Fibonacci: 1,1,2,3,5,8,?', options: ['11', '12', '13', '15'], correctIndex: 2),
        ],
      },
    ),

    // ──────────────── 6. SCIENCE 🔬 ────────────────
    QuizCategory(
      name: 'Science',
      icon: '🔬',
      subtitle: 'Discover & Explore',
      colors: [const Color(0xFF4CAF50), const Color(0xFF1B5E20)],
      levels: {
        1: const [
          QuizQuestion(question: 'What do plants need to grow?', options: ['Music', 'Sunlight', 'Darkness', 'Ice'], correctIndex: 1),
          QuizQuestion(question: 'What is water made of?', options: ['Air', 'Ice', 'H₂O', 'Salt'], correctIndex: 2),
          QuizQuestion(question: 'Which planet do we live on?', options: ['Mars', 'Moon', 'Earth', 'Sun'], correctIndex: 2),
          QuizQuestion(question: 'What keeps us on the ground?', options: ['Wind', 'Gravity', 'Magnets', 'Air'], correctIndex: 1),
          QuizQuestion(question: 'The Sun is a?', options: ['Planet', 'Moon', 'Star', 'Comet'], correctIndex: 2, funFact: 'The Sun is so big that 1.3 million Earths could fit inside!'),
          QuizQuestion(question: 'Ice is frozen what?', options: ['Milk', 'Juice', 'Water', 'Air'], correctIndex: 2),
          QuizQuestion(question: 'What gives us light during day?', options: ['Moon', 'Stars', 'Sun', 'Fire'], correctIndex: 2),
          QuizQuestion(question: 'How many senses do we have?', options: ['3', '4', '5', '6'], correctIndex: 2),
        ],
        2: const [
          QuizQuestion(question: 'Which gas do we breathe in?', options: ['Nitrogen', 'Oxygen', 'Carbon dioxide', 'Hydrogen'], correctIndex: 1),
          QuizQuestion(question: 'What organ pumps blood?', options: ['Brain', 'Lungs', 'Heart', 'Liver'], correctIndex: 2),
          QuizQuestion(question: 'Which planet is known as the Red Planet?', options: ['Venus', 'Mars', 'Jupiter', 'Saturn'], correctIndex: 1),
          QuizQuestion(question: 'What do caterpillars become?', options: ['Bees', 'Butterflies', 'Beetles', 'Ladybugs'], correctIndex: 1),
          QuizQuestion(question: 'How many bones does a human body have?', options: ['106', '206', '306', '150'], correctIndex: 1),
          QuizQuestion(question: 'Which force pulls things down?', options: ['Friction', 'Gravity', 'Magnetism', 'Wind'], correctIndex: 1),
          QuizQuestion(question: 'What makes rainbows appear?', options: ['Wind', 'Clouds', 'Sunlight + Rain', 'Thunder'], correctIndex: 2),
          QuizQuestion(question: 'What is the hardest natural substance?', options: ['Gold', 'Iron', 'Diamond', 'Silver'], correctIndex: 2),
        ],
        3: const [
          QuizQuestion(question: 'What is the powerhouse of the cell?', options: ['Nucleus', 'Ribosome', 'Mitochondria', 'Golgi body'], correctIndex: 2),
          QuizQuestion(question: 'Speed of light is approximately?', options: ['300,000 km/s', '150,000 km/s', '100,000 km/s', '500,000 km/s'], correctIndex: 0),
          QuizQuestion(question: 'Which element has symbol "Fe"?', options: ['Fluorine', 'Iron', 'Francium', 'Fermium'], correctIndex: 1),
          QuizQuestion(question: 'What is the chemical formula of table salt?', options: ['NaOH', 'NaCl', 'KCl', 'HCl'], correctIndex: 1),
          QuizQuestion(question: 'Which planet has the most moons?', options: ['Jupiter', 'Saturn', 'Uranus', 'Neptune'], correctIndex: 1, funFact: 'Saturn has 146 confirmed moons!'),
          QuizQuestion(question: 'What type of energy does the Sun give?', options: ['Chemical', 'Nuclear', 'Electrical', 'Mechanical'], correctIndex: 1),
          QuizQuestion(question: 'What is the pH of pure water?', options: ['5', '7', '9', '10'], correctIndex: 1),
          QuizQuestion(question: 'Who is known as the father of gravity?', options: ['Einstein', 'Newton', 'Galileo', 'Tesla'], correctIndex: 1),
        ],
      },
    ),

    // ──────────────── 7. SPACE 🚀 ────────────────
    QuizCategory(
      name: 'Space',
      icon: '🚀',
      subtitle: 'Explore the Universe',
      colors: [const Color(0xFF283593), const Color(0xFF1A237E)],
      badge: '🌟',
      levels: {
        1: const [
          QuizQuestion(question: 'What is closest to Earth?', options: ['Sun', 'Moon', 'Mars', 'Stars'], correctIndex: 1),
          QuizQuestion(question: 'How many planets in our solar system?', options: ['7', '8', '9', '10'], correctIndex: 1),
          QuizQuestion(question: 'The Sun is a?', options: ['Planet', 'Star', 'Moon', 'Asteroid'], correctIndex: 1),
          QuizQuestion(question: 'Which planet has rings?', options: ['Mars', 'Venus', 'Saturn', 'Mercury'], correctIndex: 2),
          QuizQuestion(question: 'What do astronauts wear?', options: ['Suits', 'Space Suits', 'Jackets', 'Armor'], correctIndex: 1),
          QuizQuestion(question: 'Stars come out at?', options: ['Morning', 'Afternoon', 'Night', 'Noon'], correctIndex: 2),
          QuizQuestion(question: 'What color is the Moon?', options: ['Blue', 'Green', 'Grey/White', 'Yellow'], correctIndex: 2),
          QuizQuestion(question: 'Earth goes around the?', options: ['Moon', 'Stars', 'Sun', 'Mars'], correctIndex: 2),
        ],
        2: const [
          QuizQuestion(question: 'Which is the largest planet?', options: ['Saturn', 'Jupiter', 'Neptune', 'Uranus'], correctIndex: 1, funFact: 'Jupiter is so big that all other planets could fit inside it!'),
          QuizQuestion(question: 'Which planet is closest to the Sun?', options: ['Venus', 'Earth', 'Mercury', 'Mars'], correctIndex: 2),
          QuizQuestion(question: 'What is the Milky Way?', options: ['A candy', 'A river', 'Our galaxy', 'A star'], correctIndex: 2),
          QuizQuestion(question: 'How long does Earth take to orbit the Sun?', options: ['30 days', '365 days', '7 days', '100 days'], correctIndex: 1),
          QuizQuestion(question: 'Which planet is hottest?', options: ['Mercury', 'Venus', 'Mars', 'Jupiter'], correctIndex: 1),
          QuizQuestion(question: 'What is a shooting star?', options: ['A star', 'A meteor', 'A planet', 'Satellite'], correctIndex: 1),
          QuizQuestion(question: 'Who was the first person on the Moon?', options: ['Buzz Aldrin', 'Neil Armstrong', 'Yuri Gagarin', 'John Glenn'], correctIndex: 1),
          QuizQuestion(question: 'Which planet is known as Earth\'s twin?', options: ['Mars', 'Venus', 'Mercury', 'Neptune'], correctIndex: 1),
        ],
        3: const [
          QuizQuestion(question: 'What is a light year?', options: ['Time', 'Distance', 'Speed', 'Weight'], correctIndex: 1, funFact: '1 light year = 9.46 trillion km!'),
          QuizQuestion(question: 'Which planet rotates on its side?', options: ['Neptune', 'Uranus', 'Saturn', 'Jupiter'], correctIndex: 1),
          QuizQuestion(question: 'What is the largest moon in our solar system?', options: ['Europa', 'Titan', 'Ganymede', 'Luna'], correctIndex: 2),
          QuizQuestion(question: 'Black holes are formed when?', options: ['Stars are born', 'Stars die', 'Planets collide', 'Comets explode'], correctIndex: 1),
          QuizQuestion(question: 'What is the ISS?', options: ['A planet', 'A space station', 'A rocket', 'A satellite'], correctIndex: 1),
          QuizQuestion(question: 'Which planet has the Great Red Spot?', options: ['Mars', 'Saturn', 'Jupiter', 'Neptune'], correctIndex: 2),
          QuizQuestion(question: 'How old is the Sun approximately?', options: ['1 billion yrs', '4.6 billion yrs', '10 billion yrs', '100 million yrs'], correctIndex: 1),
          QuizQuestion(question: 'Pluto is now classified as?', options: ['Planet', 'Star', 'Dwarf planet', 'Asteroid'], correctIndex: 2),
        ],
      },
    ),

    // ──────────────── 8. BODY 🧠 ────────────────
    QuizCategory(
      name: 'Body',
      icon: '🧠',
      subtitle: 'Human Body Facts',
      colors: [const Color(0xFFE91E63), const Color(0xFF880E4F)],
      levels: {
        1: const [
          QuizQuestion(question: 'What do we use to see?', options: ['Ears', 'Nose', 'Eyes', 'Mouth'], correctIndex: 2),
          QuizQuestion(question: 'What organ do we think with?', options: ['Heart', 'Brain', 'Lungs', 'Stomach'], correctIndex: 1),
          QuizQuestion(question: 'How many arms do we have?', options: ['1', '2', '3', '4'], correctIndex: 1),
          QuizQuestion(question: 'What do we breathe with?', options: ['Heart', 'Brain', 'Lungs', 'Stomach'], correctIndex: 2),
          QuizQuestion(question: 'Where is food digested?', options: ['Heart', 'Brain', 'Lungs', 'Stomach'], correctIndex: 3),
          QuizQuestion(question: 'What covers our body?', options: ['Fur', 'Skin', 'Feathers', 'Scales'], correctIndex: 1),
          QuizQuestion(question: 'We hear with our?', options: ['Eyes', 'Nose', 'Ears', 'Mouth'], correctIndex: 2),
          QuizQuestion(question: 'How many teeth do adults have?', options: ['20', '28', '32', '36'], correctIndex: 2),
        ],
        2: const [
          QuizQuestion(question: 'Which is the largest organ?', options: ['Heart', 'Brain', 'Skin', 'Liver'], correctIndex: 2),
          QuizQuestion(question: 'How many bones does a baby have?', options: ['206', '270', '300', '350'], correctIndex: 2, funFact: 'Babies have about 300 bones — some fuse together as they grow!'),
          QuizQuestion(question: 'What carries blood away from the heart?', options: ['Veins', 'Arteries', 'Nerves', 'Muscles'], correctIndex: 1),
          QuizQuestion(question: 'Which blood type is universal donor?', options: ['A', 'B', 'AB', 'O'], correctIndex: 3),
          QuizQuestion(question: 'The smallest bone is in the?', options: ['Toe', 'Ear', 'Finger', 'Nose'], correctIndex: 1),
          QuizQuestion(question: 'How many muscles does it take to smile?', options: ['5', '12', '17', '30'], correctIndex: 2),
          QuizQuestion(question: 'Which part of the brain controls balance?', options: ['Cerebrum', 'Cerebellum', 'Brain stem', 'Hypothalamus'], correctIndex: 1),
          QuizQuestion(question: 'How much of our body is water?', options: ['30%', '45%', '60%', '80%'], correctIndex: 2),
        ],
        3: const [
          QuizQuestion(question: 'How fast do nerve signals travel?', options: ['100 m/s', '200 m/s', '120 m/s', '50 m/s'], correctIndex: 2),
          QuizQuestion(question: 'How many taste buds does a tongue have?', options: ['2000', '5000', '8000', '10000'], correctIndex: 3, funFact: 'You get new taste buds every 2 weeks!'),
          QuizQuestion(question: 'Which organ can regenerate itself?', options: ['Heart', 'Brain', 'Liver', 'Lungs'], correctIndex: 2),
          QuizQuestion(question: 'How long is the small intestine?', options: ['3 m', '6 m', '9 m', '1 m'], correctIndex: 1),
          QuizQuestion(question: 'Red blood cells are made in?', options: ['Heart', 'Brain', 'Bone marrow', 'Kidneys'], correctIndex: 2),
          QuizQuestion(question: 'How many chromosomes do humans have?', options: ['23', '42', '46', '48'], correctIndex: 2),
          QuizQuestion(question: 'Which vitamin does sunlight give us?', options: ['A', 'B', 'C', 'D'], correctIndex: 3),
          QuizQuestion(question: 'The cornea gets oxygen from?', options: ['Blood', 'Air', 'Water', 'Food'], correctIndex: 1),
        ],
      },
    ),

    // ──────────────── 9. HINDI 🕉️ ────────────────
    QuizCategory(
      name: 'Hindi',
      icon: '🕉️',
      subtitle: 'हिंदी सीखो',
      colors: [const Color(0xFFFF9800), const Color(0xFFE65100)],
      levels: {
        1: const [
          QuizQuestion(question: 'Hindi mein "Dog" ko kya kehte hain?', options: ['बिल्ली', 'कुत्ता', 'घोड़ा', 'गाय'], correctIndex: 1),
          QuizQuestion(question: '"अ" se kya shuru hota hai?', options: ['आम', 'अनार', 'इमली', 'उल्लू'], correctIndex: 1),
          QuizQuestion(question: '"Cat" ko Hindi mein kya kehte hain?', options: ['कुत्ता', 'बिल्ली', 'चूहा', 'खरगोश'], correctIndex: 1),
          QuizQuestion(question: '"1" ko Hindi mein kya likhte hain?', options: ['एक', 'दो', 'तीन', 'चार'], correctIndex: 0),
          QuizQuestion(question: '"Red" ko Hindi mein kya kehte hain?', options: ['नीला', 'हरा', 'लाल', 'पीला'], correctIndex: 2),
          QuizQuestion(question: '"Sun" ko Hindi mein kya kehte hain?', options: ['चाँद', 'तारा', 'सूरज', 'बादल'], correctIndex: 2),
          QuizQuestion(question: '"Water" ko Hindi mein kya kehte hain?', options: ['हवा', 'पानी', 'आग', 'मिट्टी'], correctIndex: 1),
          QuizQuestion(question: 'Hindi mein kitne swar hain?', options: ['10', '11', '12', '13'], correctIndex: 3),
        ],
        2: const [
          QuizQuestion(question: '"क" se "ज्ञ" tak kitne vyanjan hain?', options: ['33', '36', '39', '41'], correctIndex: 0),
          QuizQuestion(question: '"Elephant" ko Hindi mein kya kehte hain?', options: ['शेर', 'हाथी', 'भालू', 'बन्दर'], correctIndex: 1),
          QuizQuestion(question: '"ई" kaunsa swar hai?', options: ['Pehla', 'Doosra', 'Teesra', 'Chautha'], correctIndex: 3),
          QuizQuestion(question: '"School" ko Hindi mein kya kehte?', options: ['पाठशाला', 'दुकान', 'अस्पताल', 'बाज़ार'], correctIndex: 0),
          QuizQuestion(question: '"Book" ka Hindi naam kya hai?', options: ['कलम', 'किताब', 'कागज़', 'दवात'], correctIndex: 1),
          QuizQuestion(question: '"Flower" ko Hindi mein kya kehte hain?', options: ['पत्ता', 'फूल', 'फल', 'जड़'], correctIndex: 1),
          QuizQuestion(question: '"100" ko Hindi mein kya kehte hain?', options: ['हज़ार', 'सौ', 'दस', 'लाख'], correctIndex: 1),
          QuizQuestion(question: '"Country" ko Hindi mein kya likhein?', options: ['राज्य', 'शहर', 'देश', 'गाँव'], correctIndex: 2),
        ],
        3: const [
          QuizQuestion(question: 'Hindi ki lipi kya hai?', options: ['Roman', 'Arabic', 'Devanagari', 'Gurumukhi'], correctIndex: 2),
          QuizQuestion(question: '"संयुक्त अक्षर" ka matlab kya hai?', options: ['Single letter', 'Combined letters', 'Vowel', 'Number'], correctIndex: 1),
          QuizQuestion(question: 'Hindi Diwas kab manaya jaata hai?', options: ['14 Sept', '15 Aug', '26 Jan', '2 Oct'], correctIndex: 0),
          QuizQuestion(question: '"अनुस्वार" ki pehchaan kya hai?', options: ['◌ा', '◌ं', '◌ः', '◌ी'], correctIndex: 1),
          QuizQuestion(question: 'Hindi bhasha ka udagam kin se hua?', options: ['Urdu', 'Sanskrit', 'Pali', 'Persian'], correctIndex: 1),
          QuizQuestion(question: '"विसर्ग" ka chihna kya hai?', options: ['◌ं', '◌ँ', '◌ः', '◌्'], correctIndex: 2),
          QuizQuestion(question: '"Chandrabindu" ka chihna kya hai?', options: ['◌ं', '◌ँ', '◌ः', '◌ी'], correctIndex: 1),
          QuizQuestion(question: 'Hindi mein "maatra" kise kehte hain?', options: ['Vyanjan ke roop', 'Swar ke chihna', 'Number signs', 'Punctuation'], correctIndex: 1),
        ],
      },
    ),

    // ──────────────── 10. GK 🌍 ────────────────
    QuizCategory(
      name: 'GK',
      icon: '🌍',
      subtitle: 'General Knowledge',
      colors: [const Color(0xFF6D4C41), const Color(0xFF3E2723)],
      badge: '🏆',
      levels: {
        1: const [
          QuizQuestion(question: 'How many days in a week?', options: ['5', '6', '7', '8'], correctIndex: 2),
          QuizQuestion(question: 'Which is the largest ocean?', options: ['Atlantic', 'Indian', 'Arctic', 'Pacific'], correctIndex: 3),
          QuizQuestion(question: 'How many months in a year?', options: ['10', '11', '12', '13'], correctIndex: 2),
          QuizQuestion(question: 'Capital of India?', options: ['Mumbai', 'Delhi', 'Kolkata', 'Chennai'], correctIndex: 1),
          QuizQuestion(question: 'Who built the Taj Mahal?', options: ['Akbar', 'Shah Jahan', 'Babur', 'Aurangzeb'], correctIndex: 1),
          QuizQuestion(question: 'Which country has the most people?', options: ['USA', 'India', 'China', 'Russia'], correctIndex: 1),
          QuizQuestion(question: 'How many continents are there?', options: ['5', '6', '7', '8'], correctIndex: 2),
          QuizQuestion(question: 'What is the national bird of India?', options: ['Eagle', 'Peacock', 'Sparrow', 'Parrot'], correctIndex: 1),
        ],
        2: const [
          QuizQuestion(question: 'Which is the longest river?', options: ['Amazon', 'Nile', 'Ganga', 'Yangtze'], correctIndex: 1),
          QuizQuestion(question: 'Who invented the light bulb?', options: ['Tesla', 'Edison', 'Newton', 'Bell'], correctIndex: 1),
          QuizQuestion(question: 'Which is the smallest country?', options: ['Monaco', 'Vatican City', 'Malta', 'Luxembourg'], correctIndex: 1),
          QuizQuestion(question: 'How many states in India?', options: ['25', '28', '29', '30'], correctIndex: 1),
          QuizQuestion(question: 'Which festival is called "Festival of Lights"?', options: ['Holi', 'Diwali', 'Eid', 'Christmas'], correctIndex: 1),
          QuizQuestion(question: 'What is the currency of Japan?', options: ['Won', 'Yen', 'Yuan', 'Dollar'], correctIndex: 1),
          QuizQuestion(question: 'Mount Everest is in?', options: ['India', 'Nepal', 'China', 'Nepal/China border'], correctIndex: 3),
          QuizQuestion(question: 'Which instrument has 88 keys?', options: ['Guitar', 'Violin', 'Piano', 'Flute'], correctIndex: 2),
        ],
        3: const [
          QuizQuestion(question: 'Which is the driest continent?', options: ['Africa', 'Asia', 'Antarctica', 'Australia'], correctIndex: 2, funFact: 'Antarctica is technically a desert!'),
          QuizQuestion(question: 'Who painted the Mona Lisa?', options: ['Picasso', 'Da Vinci', 'Van Gogh', 'Rembrandt'], correctIndex: 1),
          QuizQuestion(question: 'What year did India gain independence?', options: ['1945', '1947', '1950', '1952'], correctIndex: 1),
          QuizQuestion(question: 'Which gas makes up most of Earth\'s atmosphere?', options: ['Oxygen', 'Carbon dioxide', 'Nitrogen', 'Hydrogen'], correctIndex: 2),
          QuizQuestion(question: 'What is the national flower of India?', options: ['Rose', 'Lily', 'Lotus', 'Sunflower'], correctIndex: 2),
          QuizQuestion(question: 'Which is the hardest rock?', options: ['Granite', 'Marble', 'Diamond', 'Basalt'], correctIndex: 2),
          QuizQuestion(question: 'How many time zones does India have?', options: ['1', '2', '3', '4'], correctIndex: 0),
          QuizQuestion(question: 'What is the largest desert in the world?', options: ['Sahara', 'Antarctic', 'Gobi', 'Arabian'], correctIndex: 1),
        ],
      },
    ),
  ];
}
