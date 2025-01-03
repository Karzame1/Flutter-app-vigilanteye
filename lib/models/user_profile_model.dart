
class UserProfileModel {
  UserProfileModel({
    required this.users,
  });

  final Users? users;

  factory UserProfileModel.fromJson(Map<String, dynamic> json){
    return UserProfileModel(
      users: json["users"] == null ? null : Users.fromJson(json["users"]),
    );
  }

}

class Users {
  Users({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.designation,
    required this.coy,
    required this.phoneNumber,
    required this.emailVerifiedAt,
    required this.type,
    required this.permissions,
    required this.lastLogin,
    required this.parentId,
    required this.uniqueId,
    required this.profilePicture,
    required this.address,
    required this.alternateNumber,
    required this.dob,
    required this.dateOfJoining,
    required this.baseSalary,
    required this.hourlyRate,
    required this.overtimeRate,
    required this.createdById,
    required this.availableLeaves,
    required this.primarySalesTarget,
    required this.secondarySalesTarget,
    required this.shiftId,
    required this.teamId,
    required this.companyId,
    required this.status,
    required this.gender,
    required this.state,
    required this.lga,
    required this.community,
    required this.division,
    required this.sector,
    required this.forceName,
    required this.securityNetworkId,
    required this.operationalStateId,
    required this.userTypeId,
    required this.cRoleId,
    required this.roleType,
    required this.createdAt,
    required this.updatedAt,
    required this.roles,
    required this.team,
  });

  final int? id;
  final String? firstName;
  final String? lastName;
  final String? userName;
  final String? email;
  final String? designation;
  final String? coy;
  final String? phoneNumber;
  final dynamic emailVerifiedAt;
  final dynamic type;
  final dynamic permissions;
  final dynamic lastLogin;
  final int? parentId;
  final dynamic uniqueId;
  final dynamic profilePicture;
  final dynamic address;
  final dynamic alternateNumber;
  final dynamic dob;
  final dynamic dateOfJoining;
  final dynamic baseSalary;
  final dynamic hourlyRate;
  final dynamic overtimeRate;
  final dynamic createdById;
  final dynamic availableLeaves;
  final dynamic primarySalesTarget;
  final dynamic secondarySalesTarget;
  final int? shiftId;
  final int? teamId;
  final dynamic companyId;
  final String? status;
  final String? gender;
  final String? state;
  final String? lga;
  final String? community;
  final String? division;
  final String? sector;
  final String? forceName;
  final dynamic securityNetworkId;
  final dynamic operationalStateId;
  final dynamic userTypeId;
  final dynamic cRoleId;
  final int? roleType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Role> roles;
  final Team? team;

  factory Users.fromJson(Map<String, dynamic> json){
    return Users(
      id: json["id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      userName: json["user_name"],
      email: json["email"],
      designation: json["designation"],
      coy: json["coy"],
      phoneNumber: json["phone_number"],
      emailVerifiedAt: json["email_verified_at"],
      type: json["type"],
      permissions: json["permissions"],
      lastLogin: json["last_login"],
      parentId: json["parent_id"],
      uniqueId: json["unique_id"],
      profilePicture: json["profile_picture"],
      address: json["address"],
      alternateNumber: json["alternateNumber"],
      dob: json["dob"],
      dateOfJoining: json["date_of_joining"],
      baseSalary: json["base_salary"],
      hourlyRate: json["hourly_rate"],
      overtimeRate: json["overtime_rate"],
      createdById: json["created_by_id"],
      availableLeaves: json["available_leaves"],
      primarySalesTarget: json["primary_sales_target"],
      secondarySalesTarget: json["secondary_sales_target"],
      shiftId: json["shift_id"],
      teamId: json["team_id"],
      companyId: json["company_id"],
      status: json["status"],
      gender: json["gender"],
      state: json["state"],
      lga: json["lga"],
      community: json["community"],
      division: json["division"],
      sector: json["sector"],
      forceName: json["forceName"],
      securityNetworkId: json["security_network_id"],
      operationalStateId: json["operational_state_id"],
      userTypeId: json["user_type_id"],
      cRoleId: json["c_role_id"],
      roleType: json["role_type"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      roles: json["roles"] == null ? [] : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
      team: json["team"] == null ? null : Team.fromJson(json["team"]),
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

