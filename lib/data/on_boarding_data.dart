
class OnboardingInfo{
  final String title;
  final String description;
  final String image;

  OnboardingInfo({
    required this.title,
    required this.description,
    required this.image});
}

class OnboardingData{

  List<OnboardingInfo> items = [
    OnboardingInfo(
        title: "Stay on Top of Your Day",
        description: " Manage your personal tasks effortlessly. Add, edit, and update tasks to keep your day organized.",
        image: "assets/images/onboarding1.svg"),

    OnboardingInfo(
        title: "Teamwork Made Simple",
        description: "Create and manage team tasks seamlessly. Collaborate effectively and ensure everyone is aligned.",
        image: "assets/images/onboarding2.svg"),

    OnboardingInfo(
        title: "Chat and Coordinate",
        description: "Communicate in real-time with your team. Share updates, ideas, and feedback to get work done faster.",
        image: "assets/images/onboarding3.svg"),

  ];
}