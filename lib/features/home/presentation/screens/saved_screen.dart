import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/features/courses/data/model/course_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock saved list
    final List<CourseModel> savedCourses = [
      CourseModel(
        id: 1,
        title: "Adobe illustrator for all beginner artist",
        description: "Graphic design",
        cost: "0.00",
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        image:
            "https://images.unsplash.com/photo-1626785774573-4b799314346d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80",
        createdAt: DateTime.now(),
      ),
      CourseModel(
        id: 2,
        title: "Digital illustration technique for procreate",
        description: "Graphic design",
        cost: "0.00",
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        image:
            "https://images.unsplash.com/photo-1544531586-fde5298cdd40?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80",
        createdAt: DateTime.now(),
      ),
    ];

    if (savedCourses.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: TextWidget(
            word: "My save list",
            weight: FontWeight.bold,
            size: 18,
            textColor: Theme.of(context).appBarTheme.titleTextStyle?.color,
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                "https://cdni.iconscout.com/illustration/premium/thumb/empty-cart-2130356-1800917.png",
                height: 200.h,
              ), // Placeholder
              SizedBox(height: 20.h),
              TextWidget(
                word: "Nothing is here!",
                size: 20,
                weight: FontWeight.bold,
              ),
              SizedBox(height: 10.h),
              TextWidget(
                word:
                    "We found nothing in your save list! Want to \nhave some? Try something best",
                align: TextAlign.center,
                textColor: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              SizedBox(height: 30.h),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                child: TextWidget(word: "Recommended", textColor: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          word: "My save list",
          weight: FontWeight.bold,
          size: 18,
          textColor:
              Theme.of(context).appBarTheme.titleTextStyle?.color ??
              Theme.of(context).textTheme.titleLarge?.color,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20.w),
        itemCount: savedCourses.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 15.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    savedCourses[index].image,
                    height: 80.h,
                    width: 80.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 80.h,
                      width: 80.w,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        word: savedCourses[index].title,
                        maxLines: 2,
                        weight: FontWeight.bold,
                      ),
                      SizedBox(height: 5.h),
                      TextWidget(
                        word: "Samule Doe",
                        textColor: Colors.grey,
                        size: 12,
                      ), // Mock
                      SizedBox(height: 5.h),
                      Row(
                        children: [
                          Icon(Icons.person, size: 14.sp, color: Colors.grey),
                          TextWidget(
                            word: " 4k student",
                            textColor: Colors.grey,
                            size: 12,
                          ),
                          SizedBox(width: 10.w),
                          Icon(Icons.star, size: 14.sp, color: Colors.amber),
                          TextWidget(
                            word: " 4.7",
                            textColor: Colors.grey,
                            size: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
        child: TextWidget(word: "Add more", textColor: Colors.white),
      ),
    );
  }
}
