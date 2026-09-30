# Basic Usage

```dart
AtlasConnector.instance.UpsertUser(upsertUserVariables).execute();
AtlasConnector.instance.UpdateUserName(updateUserNameVariables).execute();
AtlasConnector.instance.CompleteUserProfile(completeUserProfileVariables).execute();
AtlasConnector.instance.ClaimUsername(claimUsernameVariables).execute();
AtlasConnector.instance.UpdateUserRole(updateUserRoleVariables).execute();
AtlasConnector.instance.UpdateUserBanner(updateUserBannerVariables).execute();
AtlasConnector.instance.UpdateUserProfile(updateUserProfileVariables).execute();
AtlasConnector.instance.CreateWorkout(createWorkoutVariables).execute();
AtlasConnector.instance.UpsertWorkout(upsertWorkoutVariables).execute();
AtlasConnector.instance.DeleteWorkout(deleteWorkoutVariables).execute();

```

## Optional Fields

Some operations may have optional fields. In these cases, the Flutter SDK exposes a builder method, and will have to be set separately.

Optional fields can be discovered based on classes that have `Optional` object types.

This is an example of a mutation with an optional field:

```dart
await AtlasConnector.instance.ListExpiredGeneralMessages({ ... })
.limit(...)
.execute();
```

Note: the above example is a mutation, but the same logic applies to query operations as well. Additionally, `createMovie` is an example, and may not be available to the user.

