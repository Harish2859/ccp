class Official {
  final String id;
  final String name;
  final String email;
  final String role;
  final String profilePhoto;
  final List<String> notificationPrefs;

  Official({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.profilePhoto,
    required this.notificationPrefs,
  });
}