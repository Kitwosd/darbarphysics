import 'package:dubar_physics/features/home/data/models/class_model.dart';
import 'package:dubar_physics/features/courses/data/model/course_model.dart';
import 'package:dubar_physics/features/courses/data/model/lesson_model.dart';
import 'package:dubar_physics/features/home/data/models/live_class_model.dart';
import 'package:dubar_physics/features/home/data/models/stream_model.dart';
import 'package:dubar_physics/features/home/data/models/video_model.dart';
import 'package:dubar_physics/features/home/domain/repos/home_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: HomeRepo)
class MockHomeRepo implements HomeRepo {
  @override
  Future<List<ClassModel>> getClasses() async {
    return [
      ClassModel(id: 1, name: "Grade 11", allowedStreams: true, capacity: 500),
      ClassModel(id: 2, name: "Grade 12", allowedStreams: true, capacity: 500),
      ClassModel(
        id: 3,
        name: "SEE Preparation",
        allowedStreams: false,
        capacity: 100,
      ),
    ];
  }

  @override
  Future<List<CourseModel>> getCourses() async {
    // Shared Lessons
    final lessons = List.generate(10, (index) {
      final isUnlocked = index < 3;
      return LessonModel(
        id: index,
        title:
            "Lesson ${index + 1}: ${isUnlocked ? 'Introduction' : 'Advanced Concept'}",
        duration: "0${index + 4}:30",
        isLocked: !isUnlocked,
        thumbnail: "https://img.youtube.com/vi/dQw4w9WgXcQ/0.jpg",
        videoUrl: isUnlocked
            ? "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4" // Sample valid video
            : "",
      );
    });

    return [
      CourseModel(
        id: 101,
        title: "Complete Physics for NEB Class 11",
        description:
            "Master Physics with this comprehensive course designed for NEB students. Covers Mechanics, Thermodynamics, and more.",
        cost: "Rs. 2500",
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(days: 90)),
        image:
            "https://images.unsplash.com/photo-1636466497217-26a8cbeaf0aa?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
        createdAt: DateTime.now(),
        rating: 4.8,
        reviewCount: 120,
        studentCount: 1540,
        totalDuration: "12h 30m",
        lessonCount: 20,
        lessons: lessons,
      ),
      CourseModel(
        id: 102,
        title: "Thermodynamics Masterclass",
        description:
            "Deep dive into heat and temperature. Perfect for exam preparation.",
        cost: "Rs. 1500",
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(days: 45)),
        image:
            "https://images.unsplash.com/photo-1532094349884-543bc11b234d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
        createdAt: DateTime.now(),
        rating: 4.5,
        reviewCount: 85,
        studentCount: 900,
        totalDuration: "8h 15m",
        lessonCount: 12,
        lessons: lessons,
      ),
    ];
  }

  @override
  Future<List<LiveClassModel>> getLiveClasses() async {
    return [];
  }

  @override
  Future<List<StreamModel>> getStreams() async {
    return [
      StreamModel(id: 1, name: "Science", level: 11),
      StreamModel(id: 2, name: "Management", level: 11),
    ];
  }

  @override
  Future<List<VideoModel>> getVideos() async {
    return [
      const VideoModel(
        id: 1,
        title: "Understanding Newton's Laws",
        teacher: 101,
        videoUrl:
            "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
        thumbnail:
            "https://images.unsplash.com/photo-1532094349884-543bc11b234d?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      ),
      const VideoModel(
        id: 2,
        title: "Kinematics in One Shot",
        teacher: 102,
        videoUrl:
            "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
        thumbnail:
            "https://images.unsplash.com/photo-1636466497217-26a8cbeaf0aa?q=80&w=2574&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      ),
    ];
  }
}
