import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

enum Tense {
  past,
  present,
  future,
}

class Flashcard {
  final String verb;
  final String sentence;
  final Tense tense;
  final String imageUrl;
  bool isMemorized;

  Flashcard({
    required this.verb,
    required this.sentence,
    required this.tense,
    required this.imageUrl,
    this.isMemorized = false,
  });
}

class FlashcardData extends ChangeNotifier {
  final List<Flashcard> _flashcards = [
    Flashcard(
      verb: 'Run',
      sentence: 'He runs every morning.',
      tense: Tense.present,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRCcpYYqgNwpQPtQtoAazz2kcErduHrVgkcpw&s',
    ),
    Flashcard(
      verb: 'Write',
      sentence: 'She wrote a letter yesterday.',
      tense: Tense.past,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTChPEFwKXjAsAKBpg-8BhtJEXsj8S2UXTvOg&s',
    ),
    Flashcard(
      verb: 'Sing',
      sentence: 'They will sing at the concert.',
      tense: Tense.future,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSreWWbSFPfmSl17WpUfnSP18x8eyHUwkfxg&s',
    ),
    Flashcard(
      verb: 'Drive',
      sentence: 'I drove to the beach last week.',
      tense: Tense.past,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQn_EVdRJS2HNMfmm1b23NCwFaoUJI3Iys-zQ&s',
    ),
    Flashcard(
      verb: 'Teach',
      sentence: 'My teacher teaches math.',
      tense: Tense.present,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgjJDwEvzm4TFGPqjq5cDPHdl5X6CGv0MBRw&s',
    ),
    Flashcard(
      verb: 'Build',
      sentence: 'We will build a new house next year.',
      tense: Tense.future,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzkComHD1Ze9_Vmkc-PHiy_7Ot5wIT8EWHgA&s',
    ),
    Flashcard(
      verb: 'Swim',
      sentence: 'She swims in the pool.',
      tense: Tense.present,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRh7b6psWTwNzeavYTGpdK-isRq31isCNHbGg&s',
    ),
    Flashcard(
      verb: 'Speak',
      sentence: 'He spoke to me yesterday.',
      tense: Tense.past,
      imageUrl:
          'data:image/jpeg;base64,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',
    ),
  ];

  List<Flashcard> get flashcards => List<Flashcard>.unmodifiable(_flashcards);

  void toggleMemorized(Flashcard card) {
    final int index = _flashcards.indexOf(card);
    if (index != -1) {
      _flashcards[index].isMemorized = !_flashcards[index].isMemorized;
      notifyListeners();
    }
  }
}

class FlashcardWidget extends StatelessWidget {
  final Flashcard flashcard;

  const FlashcardWidget({
    super.key,
    required this.flashcard,
  });

  IconData _getTenseIcon(Tense tense) {
    switch (tense) {
      case Tense.past:
        return Icons.history;
      case Tense.present:
        return Icons.wb_sunny;
      case Tense.future:
        return Icons.event;
    }
  }

  String _getTenseText(Tense tense) {
    switch (tense) {
      case Tense.past:
        return 'Past Tense';
      case Tense.present:
        return 'Present Tense';
      case Tense.future:
        return 'Future Tense';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                flashcard.imageUrl,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) =>
                    Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: Center(
                    child: Icon(Icons.image_not_supported,
                        size: 50, color: Colors.grey[600]),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              flashcard.verb,
              style: GoogleFonts.rampartOne(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              flashcard.sentence,
              style: GoogleFonts.quicksand(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  _getTenseIcon(flashcard.tense),
                  color: Colors.redAccent,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  _getTenseText(flashcard.tense),
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(flashcard.isMemorized
                  ? Icons.check_circle
                  : Icons.bookmark_add),
              label: Text(
                flashcard.isMemorized ? 'Memorized!' : 'Mark as Memorized',
                style: GoogleFonts.quicksand(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Provider.of<FlashcardData>(context, listen: false)
                    .toggleMemorized(flashcard);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    flashcard.isMemorized ? Colors.green : Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FlashcardData>(
      create: (BuildContext context) => FlashcardData(),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
              title: Text(
                'English Verb Flashcards',
                style: GoogleFonts.rampartOne(
                  color: Colors.white,
                  fontSize: 26,
                ),
              ),
              backgroundColor: Colors.red,
              centerTitle: true,
            ),
            body: Consumer<FlashcardData>(
              builder: (BuildContext context, FlashcardData flashcardData,
                  Widget? child) {
                return ListView.builder(
                  itemCount: flashcardData.flashcards.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Flashcard card = flashcardData.flashcards[index];
                    return Column(
                      children: <Widget>[
                        FlashcardWidget(flashcard: card),
                        if (index < flashcardData.flashcards.length - 1)
                          const Divider(
                            color: Colors.grey,
                            height: 20,
                            thickness: 1,
                            indent: 24,
                            endIndent: 24,
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
