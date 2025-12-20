import 'package:durbar_physics/features/live_classes/data/models/live_class_model.dart';
import 'package:durbar_physics/features/live_classes/domain/repos/live_classes_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LiveClassesRepo)
class MockLiveClassesRepo implements LiveClassesRepo {
  @override
  Future<List<LiveClassModel>> getLiveClasses() async {
    // Mock Data
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return [
      LiveClassModel(
        id: 1,
        title: "Physics: Quantum Mechanics Live",
        thumbnailUrl:
            "https://img.freepik.com/free-vector/physics-education-concept_23-2148530062.jpg",
        teacherName: "Dr. A. Einstein",
        startTime: DateTime.now().subtract(const Duration(minutes: 10)),
        status: "live",
        meetingUrl:
            "https://us04web.zoom.us/j/3117772972?pwd=oQOKC681rjGaeyA8ZiixJe8T2sW9pN.1", // Example link, normally distinct
      ),
      LiveClassModel(
        id: 2,
        title: "Thermodynamics - Doubt Clearing",
        thumbnailUrl:
            "https://img.freepik.com/free-vector/science-education-background_23-2148486901.jpg",
        teacherName: "Prof. Newton",
        startTime: DateTime.now().add(const Duration(hours: 2)),
        status: "upcoming",
        meetingUrl: "https://zoom.us/j/123456789",
      ),
      LiveClassModel(
        id: 3,
        title: "Motion in 1D - Rapid Revision",
        thumbnailUrl:
            "https://img.freepik.com/free-vector/science-word-concept_23-2148539207.jpg",
        teacherName: "Prof. H.C. Verma",
        startTime: DateTime.now().add(const Duration(days: 1)),
        status: "upcoming",
        meetingUrl: "https://zoom.us/j/987654321",
      ),
    ];
  }
}
