import "package:freezed_annotation/freezed_annotation.dart";
import "package:regalia/features/helix/data/transfer/get_users_response.dart";

part "twitch_user.freezed.dart";

/// Represents a Twitch user.
@freezed
class TwitchUser with _$TwitchUser {
  const factory TwitchUser(
      {required String id,
      required String login,
      required String displayName,
      required String profileImageUrl,
      required String offlineImageUrl,
      required DateTime createdAt,
      required TwitchMembership membership,
      required TwitchRole role,
      required}) = _TwitchUser;

  factory TwitchUser.fromUserInformation(UserInformationPayload payload) {
    TwitchMembership membership;
    TwitchRole role;

    switch (payload.broadcasterType) {
      case "partner":
        membership = TwitchMembership.partner;
        break;
      case "affiliate":
        membership = TwitchMembership.affiliate;
        break;
      default:
        membership = TwitchMembership.none;
    }

    switch (payload.type) {
      case "staff":
        role = TwitchRole.staff;
        break;
      case "admin":
        role = TwitchRole.admin;
        break;
      case "global_mod":
        role = TwitchRole.globalMod;
        break;
      default:
        role = TwitchRole.none;
    }

    return TwitchUser(
      id: payload.id,
      login: payload.login,
      displayName: payload.displayName,
      profileImageUrl: payload.profileImageUrl,
      offlineImageUrl: payload.offlineImageUrl,
      createdAt: payload.createdAt,
      membership: membership,
      role: role,
    );
  }
}

/// Represents the 'broadcaster_type' field on a user in the Twitch API.
///
/// Renamed to membership as I feel it's more accurate. The broadcaster (user)
/// is still a regular user but they can be a member of the partner program
/// or affiliate program. Does that make sense?
enum TwitchMembership { none, partner, affiliate }

/// Represents the 'type' field on a user in the Twitch API.
///
/// Renamed for a similar reason to membership. Also I did not want to name
/// a property 'type' as that is a pseudo reserved word in a typed language.
enum TwitchRole { none, staff, admin, globalMod }
