import 'package:flutter/material.dart';

class Bird {
  final String name;
  final String description;
  final String imageUrl;

  const Bird({
    required this.name,
    required this.description,
    required this.imageUrl,
  });
}

const Bird corujaBuraqueira = Bird(
  name: 'Coruja Buraqueira',
  description:
      'A coruja-buraqueira é uma ave strigiforme da família Strigidae. Também conhecida pelos nomes de caburé, caburé-de-cupim, caburé-do-campo, coruja-barata, coruja-do-campo, coruja-mineira, corujinha-buraqueira, corujinha-do-buraco, corujinha-do-campo, guedé, urucuera, urucureia, urucuriá, coruja-cupinzeira (algumas cidades de Goiás) e capotinha. Com o nome científico cunicularia (“pequeno mineiro”), recebe esse nome por cavar buracos no solo. Vive cerca de 9 anos em habitat selvagem. Costuma viver em campos, pastos, restingas, desertos, planícies, praias e aeroportos.',
  imageUrl:
      'https://agron.com.br/wp-content/uploads/2025/05/Como-a-coruja-buraqueira-vive-em-grupo-2.webp',
);

const Bird rolinhaDoPlanalto = Bird(
  name: 'Rolinha-do-planalto',
  description:
      'A rolinha-do-planalto (Columbina cyanopis) é uma espécie de ave da família Columbidae, endêmica do Brasil. É uma das aves mais raras e ameaçadas de extinção do mundo, restrita a pequenas áreas do Cerrado. Sua plumagem é predominantemente azul-acinzentada, com asas arroxeadas e manchas brancas.',
  imageUrl:
      'data:image/jpeg;base64,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',
);

class BirdDetailPage extends StatelessWidget {
  final Bird bird;
  final String otherBirdName;
  final VoidCallback onNavigateToOtherBird;

  /// Creates a [BirdDetailPage].
  const BirdDetailPage({
    super.key,
    required this.bird,
    required this.otherBirdName,
    required this.onNavigateToOtherBird,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[400],
      appBar: AppBar(
        title: Text(bird.name),
        backgroundColor: Colors.lightGreen[800],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  bird.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  bird.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 300),
                  color: Colors.lightBlue,
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(10),
                  child: Image.network(
                    bird.imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return const Icon(
                        Icons.broken_image,
                        size: 100,
                        color: Colors.white,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onNavigateToOtherBird,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Ver $otherBirdName'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const BirdApp());
}

class BirdApp extends StatelessWidget {
  const BirdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Informações sobre Aves',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Builder(
        builder: (BuildContext context) {
          return BirdDetailPage(
            bird: corujaBuraqueira,
            otherBirdName: rolinhaDoPlanalto.name,
            onNavigateToOtherBird: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext pageContext) {
                    return BirdDetailPage(
                      bird: rolinhaDoPlanalto,
                      otherBirdName: corujaBuraqueira.name,
                      onNavigateToOtherBird: () {
                        Navigator.pop(pageContext);
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
