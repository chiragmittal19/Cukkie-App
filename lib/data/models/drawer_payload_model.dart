class DrawerItemModel {
  const DrawerItemModel({
    required this.id, // e.g. "profile", "preferences", "favourites", "settings", "logout", "login"
    required this.title,
    this.subtitle,
    this.iconUrl,
    this.route,
    this.requiresAuth = false,
  });

  final String id;
  final String title;
  final String? subtitle;
  final String? iconUrl;
  final String? route;
  final bool requiresAuth;

  factory DrawerItemModel.fromJson(Map<String, dynamic> json) => DrawerItemModel(
    id: json['id'] as String,
    title: json['title'] as String,
    subtitle: json['subtitle'] as String?,
    iconUrl: json['iconUrl'] as String?,
    route: json['route'] as String?,
    requiresAuth: json['requiresAuth'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'iconUrl': iconUrl,
    'route': route,
    'requiresAuth': requiresAuth,
  };
}

class DrawerPayloadModel {
  const DrawerPayloadModel({
    required this.isLoggedIn,
    this.phoneNumber,
    this.displayName,
    this.avatarUrl,
    required this.items,
  });

  final bool isLoggedIn;
  final String? phoneNumber;
  final String? displayName;
  final String? avatarUrl;
  final List<DrawerItemModel> items;

  factory DrawerPayloadModel.fromJson(Map<String, dynamic> json) => DrawerPayloadModel(
    isLoggedIn: json['isLoggedIn'] as bool? ?? false,
    phoneNumber: json['phoneNumber'] as String?,
    displayName: json['displayName'] as String?,
    avatarUrl: json['avatarUrl'] as String?,
    items: (json['items'] as List<dynamic>?)
            ?.map((e) => DrawerItemModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    'isLoggedIn': isLoggedIn,
    'phoneNumber': phoneNumber,
    'displayName': displayName,
    'avatarUrl': avatarUrl,
    'items': items.map((e) => e.toJson()).toList(),
  };
}
