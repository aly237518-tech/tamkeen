class OnboardingModel {
  final String image;
  final String title;
  final String description;

  const OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
  });
}

const onboardingData = [
  OnboardingModel(
    image: "assets/images/onboarding/job.png",
    title: "اعثري على الوظيفة المناسبة",
    description:
        "آلاف الفرص الوظيفية من شركات موثوقة في جميع محافظات العراق.",
  ),
  OnboardingModel(
    image: "assets/images/onboarding/learning.png",
    title: "طوري مهاراتك",
    description:
        "دورات تدريبية، وإرشاد مهني يساعدك على بناء مستقبلك الوظيفي.",
  ),
  OnboardingModel(
    image: "assets/images/onboarding/success.png",
    title: "ابدئي رحلتك مع تمكين",
    description:
        "أنشئي حسابك، وابحثي عن الفرص، وقدمي على الوظائف بسهولة وأمان.",
  ),
];