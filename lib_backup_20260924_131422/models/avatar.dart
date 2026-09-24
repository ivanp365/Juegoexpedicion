enum AvatarGender { boy, girl }

class AvatarData {
  final String id;
  final String name;
  final int price;
  final AvatarGender gender;
  final String imageAsset;

  const AvatarData({
    required this.id, required this.name, required this.price,
    required this.gender, required this.imageAsset,
  });

  bool get isFree => price == 0;
}

const List<AvatarData> kBoyAvatars = [
  AvatarData(id: 'boy_1', name: 'Básico', price: 0, gender: AvatarGender.boy, imageAsset: 'assets/avatars/boy_1.png'),
  AvatarData(id: 'boy_2', name: 'Tecnológico', price: 250, gender: AvatarGender.boy, imageAsset: 'assets/avatars/boy_2.png'),
  AvatarData(id: 'boy_3', name: 'Explorador', price: 550, gender: AvatarGender.boy, imageAsset: 'assets/avatars/boy_3.png'),
  AvatarData(id: 'boy_4', name: 'Gamer', price: 900, gender: AvatarGender.boy, imageAsset: 'assets/avatars/boy_4.png'),
  AvatarData(id: 'boy_5', name: 'Guardabosques', price: 1400, gender: AvatarGender.boy, imageAsset: 'assets/avatars/boy_5.png'),
];

const List<AvatarData> kGirlAvatars = [
  AvatarData(id: 'girl_1', name: 'Básica', price: 0, gender: AvatarGender.girl, imageAsset: 'assets/avatars/girl_1.png'),
  AvatarData(id: 'girl_2', name: 'Aventurera', price: 250, gender: AvatarGender.girl, imageAsset: 'assets/avatars/girl_2.png'),
  AvatarData(id: 'girl_3', name: 'Artista', price: 550, gender: AvatarGender.girl, imageAsset: 'assets/avatars/girl_3.png'),
  AvatarData(id: 'girl_4', name: 'Científica', price: 900, gender: AvatarGender.girl, imageAsset: 'assets/avatars/girl_4.png'),
  AvatarData(id: 'girl_5', name: 'Estudiosa', price: 1400, gender: AvatarGender.girl, imageAsset: 'assets/avatars/girl_5.png'),
];

const List<AvatarData> kTodosLosAvatares = [...kBoyAvatars, ...kGirlAvatars];

AvatarData? buscarAvatarPorId(String id) {
  for (final avatar in kTodosLosAvatares) {
    if (avatar.id == id) return avatar;
  }
  return null;
}