import 'package:cloud_firestore/cloud_firestore.dart';

class SampleDataPopulator {
  final FirebaseFirestore _firestore;

  SampleDataPopulator(this._firestore);

  Future<void> populateSampleData() async {
    // Populate News
    await _populateNewsData();

    // Populate Events
    await _populateEventsData();

    // Populate Projects
    await _populateProjectsData();
  }

  Future<void> _populateNewsData() async {
    final newsCollection = _firestore.collection('news');

    final newsSamples = [
      {
        'id': 'news1',
        'title': 'Latest Flutter Update Released',
        'content': 'Flutter 3.0 brings exciting new features including Material You support, new widgets, and improved performance. The update focuses on enhanced developer productivity and better user experience.',
        'lastUpdated': DateTime.now().toIso8601String(),
        'additionalData': {
          'author': 'Flutter Team',
          'category': 'Technology',
          'readTime': '5 mins',
          'tags': ['flutter', 'update', 'mobile']
        }
      },
      {
        'id': 'news2',
        'title': 'Firebase Extends Free Tier',
        'content': 'Firebase announces extended free tier limits for developers. The new limits include increased storage, hosting bandwidth, and realtime database connections.',
        'lastUpdated': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        'additionalData': {
          'author': 'Firebase Team',
          'category': 'Cloud Services',
          'readTime': '3 mins',
          'tags': ['firebase', 'cloud', 'pricing']
        }
      },
      {
        'id': 'news3',
        'title': 'New Clean Architecture Guidelines',
        'content': 'The Flutter team releases new guidelines for implementing clean architecture in Flutter applications. The guidelines focus on scalability and maintainability.',
        'lastUpdated': DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
        'additionalData': {
          'author': 'Architecture Team',
          'category': 'Best Practices',
          'readTime': '7 mins',
          'tags': ['architecture', 'flutter', 'guidelines']
        }
      },
    ];

    for (final news in newsSamples) {
      await newsCollection.doc(news['id'] as String).set(news);
    }
  }

  Future<void> _populateEventsData() async {
    final eventsCollection = _firestore.collection('events');

    final eventsSamples = [
      {
        'id': 'event1',
        'title': 'Flutter Developer Meetup',
        'content': 'Join us for our monthly Flutter developer meetup where we\'ll discuss clean architecture and best practices. Network with fellow developers and share your experiences.',
        'lastUpdated': DateTime.now().toIso8601String(),
        'additionalData': {
          'date': '2024-03-20',
          'time': '18:00',
          'location': 'Tech Hub',
          'organizer': 'Flutter Community',
          'maxParticipants': 50
        }
      },
      {
        'id': 'event2',
        'title': 'Firebase Workshop',
        'content': 'Learn how to integrate Firebase services into your Flutter applications. Topics include authentication, Firestore, and real-time updates.',
        'lastUpdated': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
        'additionalData': {
          'date': '2024-03-25',
          'time': '14:00',
          'location': 'Online',
          'organizer': 'Firebase Team',
          'maxParticipants': 100
        }
      },
      {
        'id': 'event3',
        'title': 'Mobile App Testing Seminar',
        'content': 'Comprehensive seminar on testing Flutter applications. Learn about unit testing, widget testing, and integration testing.',
        'lastUpdated': DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
        'additionalData': {
          'date': '2024-03-30',
          'time': '10:00',
          'location': 'Developer Center',
          'organizer': 'Testing Experts',
          'maxParticipants': 75
        }
      },
    ];

    for (final event in eventsSamples) {
      await eventsCollection.doc(event['id'] as String).set(event);
    }
  }

  Future<void> _populateProjectsData() async {
    final projectsCollection = _firestore.collection('projects');

    final projectsSamples = [
      {
        'id': 'project1',
        'title': 'E-commerce App',
        'content': 'A full-featured e-commerce application built with Flutter and Firebase, implementing clean architecture. Features include product catalog, cart management, and order tracking.',
        'lastUpdated': DateTime.now().toIso8601String(),
        'additionalData': {
          'status': 'In Progress',
          'team': ['John', 'Sarah', 'Mike'],
          'deadline': '2024-04-15',
          'priority': 'High',
          'technologies': ['Flutter', 'Firebase', 'Bloc']
        }
      },
      {
        'id': 'project2',
        'title': 'Social Media Dashboard',
        'content': 'Analytics dashboard for social media management. Track engagement, user growth, and content performance across multiple platforms.',
        'lastUpdated': DateTime.now().subtract(const Duration(hours: 6)).toIso8601String(),
        'additionalData': {
          'status': 'Planning',
          'team': ['Emma', 'David'],
          'deadline': '2024-05-01',
          'priority': 'Medium',
          'technologies': ['Flutter', 'Firebase', 'Charts']
        }
      },
      {
        'id': 'project3',
        'title': 'Fitness Tracker',
        'content': 'Mobile application for tracking fitness activities, nutrition, and health metrics. Includes real-time synchronization and progress analytics.',
        'lastUpdated': DateTime.now().subtract(const Duration(hours: 12)).toIso8601String(),
        'additionalData': {
          'status': 'Completed',
          'team': ['Alex', 'Lisa', 'Tom'],
          'deadline': '2024-03-01',
          'priority': 'High',
          'technologies': ['Flutter', 'Firebase', 'Health SDK']
        }
      },
    ];

    for (final project in projectsSamples) {
      await projectsCollection.doc(project['id'] as String).set(project);
    }
  }
}