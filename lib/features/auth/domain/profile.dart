class UserProfile {
  final String userId;
  final String? fullName;
  final String? dni;
  final String? cmp;
  final String role;
  final DateTime? approvedAt;
  final String? approvedBy;

  const UserProfile({
    required this.userId,
    required this.role,
    this.fullName,
    this.dni,
    this.cmp,
    this.approvedAt,
    this.approvedBy,
  });

  bool get isAdmin => role == 'admin';
  bool get isApproved => approvedAt != null;

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      userId: map['user_id']?.toString() ?? '',
      fullName: map['full_name'] as String?,
      dni: map['dni'] as String?,
      cmp: map['cmp'] as String?,
      role: map['role']?.toString() ?? 'medico',
      approvedAt: map['approved_at'] != null ? DateTime.tryParse(map['approved_at'].toString()) : null,
      approvedBy: map['approved_by']?.toString(),
    );
  }
}
