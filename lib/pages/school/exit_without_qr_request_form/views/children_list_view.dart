import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scaner_manrique/BRAUXComponents/Texts/BRAText.dart';
import '../controller/exit_request_form_controller.dart';

class ChildrenListView extends StatelessWidget {
  const ChildrenListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExitRequestFormController>();

    return Column(
      children: [
        // Select all checkbox
        SizedBox(height: 16,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFC3C3C3)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Obx(() => SizedBox(
                  height: 22,
                  width: 22,
                  child: Checkbox(
                    value: controller.selectAll.value,
                    activeColor: const Color(0xFF85736F),
                    onChanged: controller.isHistoricMode ? null : (_) => controller.toggleSelectAll(),
                  ),
                )),
                const Expanded(
                  child: Center(
                    child: BRAText(
                      text: 'Seleccionar todos',
                      size: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Students list grouped by course
        Expanded(
          child: Obx(() {
            // Group students by course
            Map<String, List<StudentData>> groupedStudents = {};
            for (var student in controller.students) {
              final course = student.course.isEmpty ? 'Sin aula' : student.course;
              if (!groupedStudents.containsKey(course)) {
                groupedStudents[course] = [];
              }
              groupedStudents[course]!.add(student);
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(24.0),
              itemCount: groupedStudents.length,
              itemBuilder: (context, sectionIndex) {
                final course = groupedStudents.keys.elementAt(sectionIndex);
                final studentsInCourse = groupedStudents[course]!;
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course header
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0, top: sectionIndex == 0 ? 0 : 16.0),
                      child: BRAText(
                        text: course,
                        size: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF202023),
                      ),
                    ),
                    
                    // Students in this course
                    ...studentsInCourse.asMap().entries.map((entry) {
                      final studentIndex = controller.students.indexOf(entry.value);
                      final student = entry.value;
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: GestureDetector(
                          onTap: () => controller.toggleStudentSelection(studentIndex),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(69, 63, 61, 0.1),
                                  blurRadius: 15,
                                  offset: Offset(0, 4),
                                ),
                                BoxShadow(
                                  color: Color.fromRGBO(69, 63, 61, 0.03),
                                  blurRadius: 50,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // Course name and date
                                Positioned(
                                  top: 16,
                                  left: 17,
                                  child: BRAText(
                                    text: student.course,
                                    size: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF202023),
                                  ),
                                ),
                                Positioned(
                                  top: 16,
                                  right: 18,
                                  child: BRAText(
                                    text: 'Fecha: ${student.date}',
                                    size: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF5B5856),
                                  ),
                                ),

                                // Student icon and details
                                Positioned(
                                  top: 46,
                                  left: 17,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.school_outlined,
                                        size: 24,
                                        color: Color(0xFF5B5856),
                                      ),
                                      const SizedBox(width: 17),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          BRAText(
                                            text: student.name,
                                            size: 16,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF202023),
                                          ),
                                          BRAText(
                                            text: student.representativeName,
                                            size: 12,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF5B5856),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Checkbox
                                Positioned(
                                  top: 51,
                                  right: 18,
                                  child: SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: Checkbox(
                                      value: student.isSelected,
                                      checkColor: Colors.white,
                                      onChanged: controller.isHistoricMode ? null : (_) => controller.toggleStudentSelection(studentIndex),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            );
          }),
        ),

        // Withdraw button - only show if not in historic mode
        if (!controller.isHistoricMode)
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Obx(() {
              final isAnyChildSelected = controller.students.any((student) => student.isSelected);
              return GestureDetector(
                onTap: isAnyChildSelected
                    ? () async {
                        if (!controller.isLoading.value) {
                          controller.isLoading.value = true;
                          await controller.handleWithdraw();
                          controller.isLoading.value = false;
                        }
                      }
                    : null,
                child: Container(
                  width: 342,
                  height: 46,
                  decoration: BoxDecoration(
                    color: isAnyChildSelected
                        ? (controller.isLoading.value ? Colors.grey : const Color(0xFFEB472A))
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : BRAText(
                            text: 'Retirar',
                            size: 16,
                            fontWeight: FontWeight.w600,
                            color: isAnyChildSelected ? Colors.white : Colors.black38,
                          ),
                  ),
                ),
              );
            }),
          ),
      ],
    );
  }
}
