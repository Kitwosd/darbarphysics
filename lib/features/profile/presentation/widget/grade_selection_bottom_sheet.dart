import 'package:durbar_physics/common/widgets/text_widget.dart';
import 'package:durbar_physics/features/profile/data/models/academic_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradeSelectionBottomSheet extends StatefulWidget {
  final List<AcademicModel> grades;
  final int? currentGradeId; // Current selected grade ID (int)
  final Function(AcademicModel) onGradeSelected; // Returns full AcademicModel

  const GradeSelectionBottomSheet({
    Key? key,
    required this.grades,
    this.currentGradeId,
    required this.onGradeSelected,
  }) : super(key: key);

  @override
  State<GradeSelectionBottomSheet> createState() =>
      _GradeSelectionBottomSheetState();
}

class _GradeSelectionBottomSheetState extends State<GradeSelectionBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<AcademicModel> _filteredGrades = [];
  AcademicModel? _selectedGrade;

  @override
  void initState() {
    super.initState();
    _filteredGrades = widget.grades;

    // Pre-select current grade using ID comparison
    if (widget.currentGradeId != null) {
      try {
        _selectedGrade = widget.grades.firstWhere(
          (grade) => grade.id == widget.currentGradeId,
        );
      } catch (e) {
        // Grade not found, no pre-selection
        _selectedGrade = null;
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterGrades(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredGrades = widget.grades;
      } else {
        final searchLower = query.toLowerCase();
        // IMPORTANT: Matched items come first, then unmatched
        final matched = widget.grades
            .where((grade) => grade.name.toLowerCase().contains(searchLower))
            .toList();
        final unmatched = widget.grades
            .where((grade) => !grade.name.toLowerCase().contains(searchLower))
            .toList();
        _filteredGrades = [...matched, ...unmatched];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          // Handle bar for swipe down
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  word: 'Select Grade',
                  size: 20.sp,
                  weight: FontWeight.bold,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, size: 24.sp),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: TextField(
              controller: _searchController,
              onChanged: _filterGrades,
              decoration: InputDecoration(
                hintText: 'Search grades...',
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[400]),
                        onPressed: () {
                          _searchController.clear();
                          _filterGrades('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Grades List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: _filteredGrades.length,
              itemBuilder: (context, index) {
                final grade = _filteredGrades[index];
                final isSelected =
                    _selectedGrade?.id == grade.id; // ID comparison

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedGrade = grade;
                    });
                  },
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue.shade50
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? Colors.blue.shade400
                            : Colors.grey.shade200,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                word: grade.name,
                                size: 16.sp,
                                weight: FontWeight.w600,
                                textColor: isSelected
                                    ? Colors.blue.shade900
                                    : Colors.black87,
                              ),
                              // Show capacity and streams if available
                              // if (grade.capacity != null ||
                              //     grade.allowedStreams) ...[
                              //   SizedBox(height: 4.h),
                              //   Row(
                              //     children: [
                              //       if (grade.capacity != null) ...[
                              //         Icon(
                              //           Icons.people_outline,
                              //           size: 14.sp,
                              //           color: Colors.grey[600],
                              //         ),
                              //         SizedBox(width: 4.w),
                              //         TextWidget(
                              //           word: 'Capacity: ${grade.capacity}',
                              //           size: 12.sp,
                              //           textColor: Colors.grey[600],
                              //         ),
                              //         SizedBox(width: 12.w),
                              //       ],
                              //       if (grade.allowedStreams)
                              //         Container(
                              //           padding: EdgeInsets.symmetric(
                              //             horizontal: 8.w,
                              //             vertical: 2.h,
                              //           ),
                              //           decoration: BoxDecoration(
                              //             color: Colors.green.shade100,
                              //             borderRadius:
                              //                 BorderRadius.circular(8.r),
                              //           ),
                              //           child: TextWidget(
                              //             word: 'Streams',
                              //             size: 10.sp,
                              //             textColor: Colors.green.shade700,
                              //             weight: FontWeight.w600,
                              //           ),
                              //         ),
                              //     ],
                              // ),
                              // ],
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: Colors.blue.shade600,
                            size: 24.sp,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Action Button
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedGrade != null
                    ? () {
                        // Return the full AcademicModel object
                        widget.onGradeSelected(_selectedGrade!);
                        Navigator.pop(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  disabledBackgroundColor: Colors.grey[300],
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: TextWidget(
                  word: _selectedGrade != null
                      ? 'Select ${_selectedGrade!.name}'
                      : 'Select a Grade',
                  size: 16.sp,
                  weight: FontWeight.w600,
                  textColor: _selectedGrade != null
                      ? Colors.white
                      : Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
