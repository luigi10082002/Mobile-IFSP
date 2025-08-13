import 'package:flutter/material.dart';

class Person {
  final String name;
  final int age;
  final String imageUrl;
  final List<String> favoriteMovies;
  final List<String> favoriteBooks;

  const Person({
    required this.name,
    required this.age,
    required this.imageUrl,
    required this.favoriteMovies,
    required this.favoriteBooks,
  });
}

const Person myProfile = Person(
  name: 'João da Silva',
  age: 30,
  imageUrl: '',
  favoriteMovies: <String>[
    'A Chegada',
    'Blade Runner 2049',
    'Parasita',
    'Whiplash: Em Busca da Perfeição',
    'Divertida Mente',
  ],
  favoriteBooks: <String>[
    '1984',
    'Admirável Mundo Novo',
    'Dom Quixote',
  ],
);

class MoviesPage extends StatelessWidget {
  final List<String> movies;

  const MoviesPage({
    super.key,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filmes Favoritos'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.movie),
              title: Text(
                movies[index],
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          );
        },
      ),
    );
  }
}

class BooksPage extends StatelessWidget {
  final List<String> books;

  const BooksPage({
    super.key,
    required this.books,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livros Favoritos'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: books.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.book),
              title: Text(
                books[index],
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          );
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final Person person;

  const HomePage({
    super.key,
    required this.person,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 24),
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey[300],
                  child: ClipOval(
                    child: Image.network(
                      person.imageUrl,
                      fit: BoxFit.cover,
                      width: 160,
                      height: 160,
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
                          Icons.person,
                          size: 100,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  person.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Idade: ${person.age} anos',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext pageContext) {
                          return MoviesPage(movies: person.favoriteMovies);
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.movie, size: 24),
                  label: const Text('Ver Filmes'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext pageContext) {
                          return BooksPage(books: person.favoriteBooks);
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.book, size: 24),
                  label: const Text('Ver Livros'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
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
  runApp(const MyProfileApp());
}

class MyProfileApp extends StatelessWidget {
  const MyProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meu Perfil',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
        ),
      ),
      home: HomePage(person: myProfile),
    );
  }
}
