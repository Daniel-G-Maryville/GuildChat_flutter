import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guild_chat/ui/user_profile/user_profile_provider.dart';

class HomeScreenData {
  const HomeScreenData(this.userProfile);

  // Declare as dynamic this ultimately will resolve to DataState<UserProfile>
  final dynamic userProfile;

  List<String> get userGuilds => List.unmodifiable(userProfile.data?.guilds);
  String get userEmail => userProfile.data?.email;
}

final homeScreenProvider = Provider<HomeScreenData>((ref) {
  final userProfile = ref.watch(userProfileNotifierProvider);
  return HomeScreenData(userProfile);
});
