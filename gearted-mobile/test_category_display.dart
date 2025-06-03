import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'lib/widgets/common/category_display_widget.dart';
import 'lib/core/constants/airsoft_categories.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Category Display Test',
      routerConfig: _router,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const TestCategoryScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) {
        final category = state.uri.queryParameters['category'] ?? 'No category';
        return SearchTestScreen(category: category);
      },
    ),
  ],
);

class TestCategoryScreen extends StatelessWidget {
  const TestCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('🧪 Testing Category Display Widget');
    print('🧪 Total categories: ${AirsoftCategories.allCategories.length}');
    print('🧪 Main categories: ${AirsoftCategories.mainCategories.length}');
    print('🧪 Clean main categories: ${AirsoftCategories.cleanMainCategories.length}');
    print('🧪 First clean main category: ${AirsoftCategories.cleanMainCategories.first}');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Display Test'),
        backgroundColor: Colors.blue,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Testing New Category Display Widget',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CategoryDisplayWidget(),
          ],
        ),
      ),
    );
  }
}

class SearchTestScreen extends StatelessWidget {
  final String category;
  
  const SearchTestScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    print('🎯 Navigation test: Selected category = $category');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Test'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Category Navigation Test Success!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 20),
            const Text(
              'Selected Category:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              width: double.infinity,
              child: Text(
                category,
                style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Back to Category Test'),
            ),
          ],
        ),
      ),
    );
  }
}
