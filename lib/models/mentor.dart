class Mentor {
  final String name;
  final String region;
  final String intro;
  final String registerDate;
  final String fields;
  final String imageUrl;
  final String field;

  Mentor({
    required this.name,
    required this.region,
    required this.intro,
    required this.registerDate,
    required this.fields,
    required this.imageUrl,
    required this.field,
  });
}

List<Mentor> mentors = [
  Mentor(
    name: "김진수",
    region: "서울 강남구 잠실동",
    intro: "대기업 IT 개발 팀장 경력을 지니고 있으며, IT  스타트업을 운영하면서 콘텐츠 개발팀 실무를 겸하고 있습니다.",
    registerDate: "2023.08.11",
    fields: "앱기획,마케팅,국가프로젝트",
    imageUrl: "https://randomuser.me/api/portraits/men/32.jpg",
    field: "앱기획 분야 멘토",
  ),
  Mentor(
    name: "이동은",
    region: "부산시 동래구 온천동",
    intro: "디자인학 석사 보유자로서, 다년간 디자인 및 관련분야 실무 경험을 가지고 있습니다.",
    registerDate: "2023.06.01",
    fields: "프론트엔드,UI/UX,브랜딩",
    imageUrl: "https://randomuser.me/api/portraits/women/44.jpg",
    field: "앱기획 분야 멘토",
  ),
  Mentor(
    name: "김하나",
    region: "서울 강남 강남역",
    intro:
        "대기업 인사팀 경험 후 스타트업 피플팀 리더를 맡고 있습니다. 대기업에서 스타트업 이직 고민하고 있는 분 티타임 신청해 주세요 :)",
    registerDate: "2023.08.01",
    fields: "프론트엔드,앱기획,마케팅",
    imageUrl: "https://randomuser.me/api/portraits/women/44.jpg",
    field: "앱기획 분야 멘토",
  ),
  Mentor(
    name: "김하나",
    region: "서울 강남 강남역",
    intro:
        "대기업 인사팀 경험 후 스타트업 피플팀 리더를 맡고 있습니다. 대기업에서 스타트업 이직 고민하고 있는 분 티타임 신청해 주세요 :)",
    registerDate: "2023.08.01",
    fields: "프론트엔드,앱기획,마케팅",
    imageUrl: "https://randomuser.me/api/portraits/women/44.jpg",
    field: "앱기획 분야 멘토",
  ),
];
