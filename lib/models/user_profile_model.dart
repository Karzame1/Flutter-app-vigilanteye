

class UserProfileModel {
  UserProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.status,
    required this.team,
    required this.roles,
  });

  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? username;
  final String? phoneNumber;
  final String? status;
  final Team? team;
  final List<Role> roles;

  factory UserProfileModel.fromJson(Map<String, dynamic> json){
    return UserProfileModel(
      id: json["id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      username: json["username"],
      phoneNumber: json["phoneNumber"],
      status: json["status"],
      team: json["team"] == null ? null : Team.fromJson(json["team"]),
      roles: json["roles"] == null ? [] : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
    );
  }

}

class Role {
  Role({
    required this.id,
    required this.slug,
    required this.name,
    required this.permissions,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });

  final int? id;
  final String? slug;
  final String? name;
  final String? permissions;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Pivot? pivot;

  factory Role.fromJson(Map<String, dynamic> json){
    return Role(
      id: json["id"],
      slug: json["slug"],
      name: json["name"],
      permissions: json["permissions"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
    );
  }

}

class Pivot {
  Pivot({
    required this.userId,
    required this.roleId,
  });

  final int? userId;
  final int? roleId;

  factory Pivot.fromJson(Map<String, dynamic> json){
    return Pivot(
      userId: json["user_id"],
      roleId: json["role_id"],
    );
  }

}

class Team {
  Team({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.isChatEnabled,
    required this.createdById,
    required this.updatedById,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? name;
  final String? description;
  final String? status;
  final int? isChatEnabled;
  final dynamic createdById;
  final dynamic updatedById;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Team.fromJson(Map<String, dynamic> json){
    return Team(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      status: json["status"],
      isChatEnabled: json["is_chat_enabled"],
      createdById: json["created_by_id"],
      updatedById: json["updated_by_id"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

}
