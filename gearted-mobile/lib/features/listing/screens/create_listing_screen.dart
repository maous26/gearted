import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  String? _selectedCategory;
  String? _selectedCondition;
  bool _isNegotiable = false;
  List<String> _selectedImages = [];

  final List<String> _categories = [
    'Répliques',
    'Gearbox & Moteurs',
    'Optiques & Viseurs',
    'Batteries & Chargeurs',
    'Tenues & Équipements',
    'Accessoires',
    'Pièces détachées',
  ];

  final List<String> _conditions = [
    'Neuf',
    'Comme neuf',
    'Très bon état',
    'Bon état',
    'État correct',
    'À réparer',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendre un article'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
        actions: [
          TextButton(
            onPressed: _submitListing,
            child: const Text(
              'Publier',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photos Section
              _buildSectionTitle('Photos'),
              _buildPhotosSection(),
              const SizedBox(height: 24),

              // Title
              _buildSectionTitle('Titre de l\'annonce'),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Ex: M4A1 Daniel Defense en excellent état',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Le titre est obligatoire';
                  }
                  if (value.length < 10) {
                    return 'Le titre doit contenir au moins 10 caractères';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category
              _buildSectionTitle('Catégorie'),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Sélectionner une catégorie'),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner une catégorie';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Condition
              _buildSectionTitle('État'),
              DropdownButtonFormField<String>(
                value: _selectedCondition,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Sélectionner l\'état'),
                items: _conditions.map((condition) {
                  return DropdownMenuItem(
                    value: condition,
                    child: Text(condition),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCondition = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner l\'état';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Price
              _buildSectionTitle('Prix'),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        hintText: '0',
                        border: OutlineInputBorder(),
                        suffixText: '€',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Le prix est obligatoire';
                        }
                        final price = int.tryParse(value);
                        if (price == null || price <= 0) {
                          return 'Veuillez saisir un prix valide';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _isNegotiable,
                        onChanged: (value) {
                          setState(() {
                            _isNegotiable = value ?? false;
                          });
                        },
                      ),
                      const Text('Prix négociable'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description
              _buildSectionTitle('Description'),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Décrivez votre article en détail...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La description est obligatoire';
                  }
                  if (value.length < 20) {
                    return 'La description doit contenir au moins 20 caractères';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPhotosSection() {
    return Container(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Add photo button
          Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: InkWell(
              onTap: _addPhoto,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo,
                    size: 32,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Ajouter',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Selected photos (mock)
          ..._selectedImages.map((image) => Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey.shade400,
                        child: const Icon(
                          Icons.image,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _removePhoto(image),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void _addPhoto() {
    // TODO: Implement photo picker
    setState(() {
      _selectedImages.add('photo_${_selectedImages.length + 1}');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Photo ajoutée (simulation)'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _removePhoto(String photo) {
    setState(() {
      _selectedImages.remove(photo);
    });
  }

  void _submitListing() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez ajouter au moins une photo'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // TODO: Submit the listing to the backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Annonce créée avec succès !'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop();
    }
  }
}
