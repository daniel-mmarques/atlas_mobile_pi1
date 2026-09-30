library;

import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'upsert_user.dart';

part 'update_user_name.dart';

part 'complete_user_profile.dart';

part 'claim_username.dart';

part 'update_user_role.dart';

part 'update_user_banner.dart';

part 'update_user_profile.dart';

part 'create_workout.dart';

part 'upsert_workout.dart';

part 'delete_workout.dart';

part 'assign_workout_to_student.dart';

part 'upsert_template.dart';

part 'delete_template.dart';

part 'create_post.dart';

part 'upsert_conversation.dart';

part 'update_conversation_last_message.dart';

part 'add_conversation_member.dart';

part 'send_message.dart';

part 'delete_message.dart';

part 'create_link_invitation.dart';

part 'update_link_invitation_status.dart';

part 'create_coach_link.dart';

part 'get_user.dart';

part 'get_user_by_username.dart';

part 'search_users_by_username.dart';

part 'search_users_by_name.dart';

part 'get_users_by_ids.dart';

part 'get_workout.dart';

part 'list_user_workouts.dart';

part 'get_template.dart';

part 'list_user_templates.dart';

part 'list_public_posts.dart';

part 'list_user_posts.dart';

part 'get_conversation.dart';

part 'list_inbox.dart';

part 'get_conversation_by_invite_token.dart';

part 'search_communities.dart';

part 'list_messages.dart';

part 'list_expired_general_messages.dart';

part 'list_coach_links_by_coach.dart';

part 'list_coach_links_by_student.dart';

part 'get_link_invitation.dart';

part 'count_user_workouts.dart';

class AtlasConnector {
  UpsertUserVariablesBuilder upsertUser({
    required String id,
    required String email,
  }) {
    return UpsertUserVariablesBuilder(dataConnect, id: id, email: email);
  }

  UpdateUserNameVariablesBuilder updateUserName({
    required String id,
    required String name,
    required String nameLower,
  }) {
    return UpdateUserNameVariablesBuilder(
      dataConnect,
      id: id,
      name: name,
      nameLower: nameLower,
    );
  }

  CompleteUserProfileVariablesBuilder completeUserProfile({
    required String id,
    required String name,
    required String nameLower,
    required String username,
    required Timestamp birthDate,
    required String gender,
    required double height,
    required double weight,
    required String activityLevel,
  }) {
    return CompleteUserProfileVariablesBuilder(
      dataConnect,
      id: id,
      name: name,
      nameLower: nameLower,
      username: username,
      birthDate: birthDate,
      gender: gender,
      height: height,
      weight: weight,
      activityLevel: activityLevel,
    );
  }

  ClaimUsernameVariablesBuilder claimUsername({
    required String id,
    required String username,
  }) {
    return ClaimUsernameVariablesBuilder(
      dataConnect,
      id: id,
      username: username,
    );
  }

  UpdateUserRoleVariablesBuilder updateUserRole({
    required String id,
    required String role,
  }) {
    return UpdateUserRoleVariablesBuilder(dataConnect, id: id, role: role);
  }

  UpdateUserBannerVariablesBuilder updateUserBanner({required String id}) {
    return UpdateUserBannerVariablesBuilder(dataConnect, id: id);
  }

  UpdateUserProfileVariablesBuilder updateUserProfile({
    required String id,
    required String name,
    required String nameLower,
    required String username,
    required Timestamp birthDate,
    required String gender,
    required double height,
    required double weight,
    required String activityLevel,
  }) {
    return UpdateUserProfileVariablesBuilder(
      dataConnect,
      id: id,
      name: name,
      nameLower: nameLower,
      username: username,
      birthDate: birthDate,
      gender: gender,
      height: height,
      weight: weight,
      activityLevel: activityLevel,
    );
  }

  CreateWorkoutVariablesBuilder createWorkout({
    required String id,
    required String userId,
    required String name,
  }) {
    return CreateWorkoutVariablesBuilder(
      dataConnect,
      id: id,
      userId: userId,
      name: name,
    );
  }

  UpsertWorkoutVariablesBuilder upsertWorkout({
    required String id,
    required String userId,
    required String name,
    required int volume,
    required bool isPublic,
    required int source,
  }) {
    return UpsertWorkoutVariablesBuilder(
      dataConnect,
      id: id,
      userId: userId,
      name: name,
      volume: volume,
      isPublic: isPublic,
      source: source,
    );
  }

  DeleteWorkoutVariablesBuilder deleteWorkout({required String id}) {
    return DeleteWorkoutVariablesBuilder(dataConnect, id: id);
  }

  AssignWorkoutToStudentVariablesBuilder assignWorkoutToStudent({
    required String id,
    required String studentId,
    required String name,
    required Timestamp startedAt,
    required String coachId,
    required int source,
  }) {
    return AssignWorkoutToStudentVariablesBuilder(
      dataConnect,
      id: id,
      studentId: studentId,
      name: name,
      startedAt: startedAt,
      coachId: coachId,
      source: source,
    );
  }

  UpsertTemplateVariablesBuilder upsertTemplate({
    required String id,
    required String userId,
    required String name,
    required String notes,
    required int defaultRestSeconds,
    required String scheduleMode,
    required Timestamp createdAt,
    required Timestamp updatedAt,
  }) {
    return UpsertTemplateVariablesBuilder(
      dataConnect,
      id: id,
      userId: userId,
      name: name,
      notes: notes,
      defaultRestSeconds: defaultRestSeconds,
      scheduleMode: scheduleMode,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  DeleteTemplateVariablesBuilder deleteTemplate({required String id}) {
    return DeleteTemplateVariablesBuilder(dataConnect, id: id);
  }

  CreatePostVariablesBuilder createPost({
    required String userId,
    required String caption,
    required int volume,
    required bool isPublic,
  }) {
    return CreatePostVariablesBuilder(
      dataConnect,
      userId: userId,
      caption: caption,
      volume: volume,
      isPublic: isPublic,
    );
  }

  UpsertConversationVariablesBuilder upsertConversation({
    required String id,
    required String type,
    required String title,
  }) {
    return UpsertConversationVariablesBuilder(
      dataConnect,
      id: id,
      type: type,
      title: title,
    );
  }

  UpdateConversationLastMessageVariablesBuilder updateConversationLastMessage({
    required String id,
    required String lastMessage,
    required String lastSenderName,
    required Timestamp updatedAt,
  }) {
    return UpdateConversationLastMessageVariablesBuilder(
      dataConnect,
      id: id,
      lastMessage: lastMessage,
      lastSenderName: lastSenderName,
      updatedAt: updatedAt,
    );
  }

  AddConversationMemberVariablesBuilder addConversationMember({
    required String conversationId,
    required String userId,
  }) {
    return AddConversationMemberVariablesBuilder(
      dataConnect,
      conversationId: conversationId,
      userId: userId,
    );
  }

  SendMessageVariablesBuilder sendMessage({
    required String conversationId,
    required String text,
    required String senderId,
    required String senderName,
    required Timestamp createdAt,
  }) {
    return SendMessageVariablesBuilder(
      dataConnect,
      conversationId: conversationId,
      text: text,
      senderId: senderId,
      senderName: senderName,
      createdAt: createdAt,
    );
  }

  DeleteMessageVariablesBuilder deleteMessage({required String id}) {
    return DeleteMessageVariablesBuilder(dataConnect, id: id);
  }

  CreateLinkInvitationVariablesBuilder createLinkInvitation({
    required String token,
    required String creatorId,
    required String creatorRole,
    required Timestamp expiresAt,
  }) {
    return CreateLinkInvitationVariablesBuilder(
      dataConnect,
      token: token,
      creatorId: creatorId,
      creatorRole: creatorRole,
      expiresAt: expiresAt,
    );
  }

  UpdateLinkInvitationStatusVariablesBuilder updateLinkInvitationStatus({
    required String token,
    required String status,
  }) {
    return UpdateLinkInvitationStatusVariablesBuilder(
      dataConnect,
      token: token,
      status: status,
    );
  }

  CreateCoachLinkVariablesBuilder createCoachLink({
    required String coachId,
    required String studentId,
  }) {
    return CreateCoachLinkVariablesBuilder(
      dataConnect,
      coachId: coachId,
      studentId: studentId,
    );
  }

  GetUserVariablesBuilder getUser({required String id}) {
    return GetUserVariablesBuilder(dataConnect, id: id);
  }

  GetUserByUsernameVariablesBuilder getUserByUsername({
    required String username,
  }) {
    return GetUserByUsernameVariablesBuilder(dataConnect, username: username);
  }

  SearchUsersByUsernameVariablesBuilder searchUsersByUsername({
    required String q,
    required String end,
  }) {
    return SearchUsersByUsernameVariablesBuilder(dataConnect, q: q, end: end);
  }

  SearchUsersByNameVariablesBuilder searchUsersByName({
    required String q,
    required String end,
  }) {
    return SearchUsersByNameVariablesBuilder(dataConnect, q: q, end: end);
  }

  GetUsersByIdsVariablesBuilder getUsersByIds({required List<String> ids}) {
    return GetUsersByIdsVariablesBuilder(dataConnect, ids: ids);
  }

  GetWorkoutVariablesBuilder getWorkout({required String id}) {
    return GetWorkoutVariablesBuilder(dataConnect, id: id);
  }

  ListUserWorkoutsVariablesBuilder listUserWorkouts({required String userId}) {
    return ListUserWorkoutsVariablesBuilder(dataConnect, userId: userId);
  }

  GetTemplateVariablesBuilder getTemplate({required String id}) {
    return GetTemplateVariablesBuilder(dataConnect, id: id);
  }

  ListUserTemplatesVariablesBuilder listUserTemplates({
    required String userId,
  }) {
    return ListUserTemplatesVariablesBuilder(dataConnect, userId: userId);
  }

  ListPublicPostsVariablesBuilder listPublicPosts() {
    return ListPublicPostsVariablesBuilder(dataConnect);
  }

  ListUserPostsVariablesBuilder listUserPosts({required String userId}) {
    return ListUserPostsVariablesBuilder(dataConnect, userId: userId);
  }

  GetConversationVariablesBuilder getConversation({required String id}) {
    return GetConversationVariablesBuilder(dataConnect, id: id);
  }

  ListInboxVariablesBuilder listInbox({required String userId}) {
    return ListInboxVariablesBuilder(dataConnect, userId: userId);
  }

  GetConversationByInviteTokenVariablesBuilder getConversationByInviteToken({
    required String token,
  }) {
    return GetConversationByInviteTokenVariablesBuilder(
      dataConnect,
      token: token,
    );
  }

  SearchCommunitiesVariablesBuilder searchCommunities({
    required String q,
    required String end,
  }) {
    return SearchCommunitiesVariablesBuilder(dataConnect, q: q, end: end);
  }

  ListMessagesVariablesBuilder listMessages({required String conversationId}) {
    return ListMessagesVariablesBuilder(
      dataConnect,
      conversationId: conversationId,
    );
  }

  ListExpiredGeneralMessagesVariablesBuilder listExpiredGeneralMessages({
    required Timestamp cutoff,
  }) {
    return ListExpiredGeneralMessagesVariablesBuilder(
      dataConnect,
      cutoff: cutoff,
    );
  }

  ListCoachLinksByCoachVariablesBuilder listCoachLinksByCoach({
    required String coachId,
  }) {
    return ListCoachLinksByCoachVariablesBuilder(dataConnect, coachId: coachId);
  }

  ListCoachLinksByStudentVariablesBuilder listCoachLinksByStudent({
    required String studentId,
  }) {
    return ListCoachLinksByStudentVariablesBuilder(
      dataConnect,
      studentId: studentId,
    );
  }

  GetLinkInvitationVariablesBuilder getLinkInvitation({required String token}) {
    return GetLinkInvitationVariablesBuilder(dataConnect, token: token);
  }

  CountUserWorkoutsVariablesBuilder countUserWorkouts({
    required String userId,
  }) {
    return CountUserWorkoutsVariablesBuilder(dataConnect, userId: userId);
  }

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'southamerica-east1',
    'atlas',
    'atlas-160cf-service',
  );

  AtlasConnector({required this.dataConnect});
  static AtlasConnector get instance {
    return AtlasConnector(
      dataConnect: FirebaseDataConnect.instanceFor(
        connectorConfig: connectorConfig,

        sdkType: CallerSDKType.generated,
      ),
    );
  }

  FirebaseDataConnect dataConnect;
}
