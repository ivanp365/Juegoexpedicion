class AvatarModel {
  final String id;
  final String name;
  final String genero;
  final String imagePath;
  final int cost;

  const AvatarModel({
    required this.id,
    required this.name,
    required this.genero,
    required this.imagePath,
    this.cost = 0,
  });
}

/// Catálogo de avatares (precios: gratis, 250, 500, 900, 1300)
const List<AvatarModel> catalogoAvatares = [
  // ============ NIÑOS ============
  AvatarModel(id: 'boy_1',  name: 'Bruno', genero: 'niño', imagePath: 'assets/avatars/boy_1.webp',  cost: 0),
  AvatarModel(id: 'boy_2',  name: 'Diego', genero: 'niño', imagePath: 'assets/avatars/boy_2.webp',  cost: 250),
  AvatarModel(id: 'boy_3',  name: 'Marco', genero: 'niño', imagePath: 'assets/avatars/boy_3.webp',  cost: 500),
  AvatarModel(id: 'boy_4',  name: 'Leo',   genero: 'niño', imagePath: 'assets/avatars/boy_4.webp',  cost: 900),
  AvatarModel(id: 'boy_5',  name: 'Tomi',  genero: 'niño', imagePath: 'assets/avatars/boy_5.webp',  cost: 1300),

  // ============ NIÑAS ============
  AvatarModel(id: 'girl_1', name: 'Ana',   genero: 'niña', imagePath: 'assets/avatars/girl_1.webp', cost: 0),
  AvatarModel(id: 'girl_2', name: 'Sofía', genero: 'niña', imagePath: 'assets/avatars/girl_2.webp', cost: 250),
  AvatarModel(id: 'girl_3', name: 'Vale',  genero: 'niña', imagePath: 'assets/avatars/girl_3.webp', cost: 500),
  AvatarModel(id: 'girl_4', name: 'Luna',  genero: 'niña', imagePath: 'assets/avatars/girl_4.webp', cost: 900),
  AvatarModel(id: 'girl_5', name: 'Maya',  genero: 'niña', imagePath: 'assets/avatars/girl_5.webp', cost: 1300),
];