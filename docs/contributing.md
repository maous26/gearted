# Guide de contribution Gearted

## Conventions de code

### Flutter/Dart
- Utiliser la syntaxe Dart moderne (null safety)
- Suivre les [directives de style Dart](https://dart.dev/guides/language/effective-dart/style)
- Organiser le code en features (approche Domain-Driven Design)
- Préférer les widgets stateless quand possible
- Utiliser Riverpod pour la gestion d'état

### Node.js/TypeScript
- Suivre les principes SOLID
- Utiliser des interfaces pour les modèles et DTOs
- Organiser par couches (controllers, services, repositories)
- Gestion des erreurs consistante avec classes d'erreur personnalisées
- Documenter les APIs avec JSDoc

## Workflow Git
1. Créer une branche avec un nom significatif (`feature/auth-system`, `fix/login-bug`)
2. Faire des commits atomiques avec messages clairs
3. Référencer l'ID de ticket dans les messages de commit (`[GEAR-123] Add login screen`)
4. Créer une Pull Request avec description détaillée
5. Attendre la code review et les tests CI
6. Merger seulement après approbation

## Tests
- Écrire des tests unitaires pour toute nouvelle fonctionnalité
- Viser une couverture de code minimale de 70%
- Assurer que tous les tests passent avant de soumettre une PR

## Documentation
- Documenter toutes les classes, méthodes et fonctions publiques
- Maintenir la documentation à jour avec le code
- Documenter les changements significatifs dans le README

## Standards de performance
- Assurer un temps de démarrage app < 3s
- Maintenir une utilisation mémoire < 100MB
- Optimiser les requêtes API pour un temps de réponse < 500ms
