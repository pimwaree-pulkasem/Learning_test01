class Course {
  final String title;
  final String instructor;
  final String price;
  final String status;
  final int students;
  Course({
    required this.title,
    required this.instructor,
    required this.price,
    this.status = 'published',
    this.students = 0,
  });
}

final List<Course> studentCourses = [
  Course(title: "Python", instructor: "LearnLab Creator", price: "1500"),
  Course(
    title: "Fullstack Go & MongoDB",
    instructor: "LearnLab Creator",
    price: "2500",
  ),
];

final List<Course> creatorCourses = [
  Course(
    title: "Python",
    instructor: "You",
    price: "1500",
    status: "published",
    students: 0,
  ),
  Course(
    title: "Fullstack Go & MongoDB",
    instructor: "You",
    price: "2500",
    status: "published",
    students: 0,
  ),
];
