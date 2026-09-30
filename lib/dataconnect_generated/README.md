# atlas_dataconnect SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
AtlasConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### GetUser
#### Required Arguments
```dart
String id = ...;
AtlasConnector.instance.getUser(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetUserData, GetUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await AtlasConnector.instance.getUser(
  id: id,
);
GetUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = AtlasConnector.instance.getUser(
  id: id,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetUserByUsername
#### Required Arguments
```dart
String username = ...;
AtlasConnector.instance.getUserByUsername(
  username: username,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetUserByUsernameData, GetUserByUsernameVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await AtlasConnector.instance.getUserByUsername(
  username: username,
);
GetUserByUsernameData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String username = ...;

final ref = AtlasConnector.instance.getUserByUsername(
  username: username,
).ref();
ref.execute();

ref.subscribe(...);
```


### SearchUsersByUsername
#### Required Arguments
```dart
String q = ...;
String end = ...;
AtlasConnector.instance.searchUsersByUsername(
  q: q,
  end: end,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<SearchUsersByUsernameData, SearchUsersByUsernameVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await AtlasConnector.instance.searchUsersByUsername(
  q: q,
  end: end,
);
SearchUsersByUsernameData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String q = ...;
String end = ...;

final ref = AtlasConnector.instance.searchUsersByUsername(
  q: q,
  end: end,
).ref();
ref.execute();

ref.subscribe(...);
```


### SearchUsersByName
#### Required Arguments
```dart
String q = ...;
String end = ...;
AtlasConnector.instance.searchUsersByName(
  q: q,
  end: end,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<SearchUsersByNameData, SearchUsersByNameVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await AtlasConnector.instance.searchUsersByName(
  q: q,
  end: end,
);
SearchUsersByNameData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String q = ...;
String end = ...;

final ref = AtlasConnector.instance.searchUsersByName(
  q: q,
  end: end,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetUsersByIds
#### Required Arguments
```dart
String ids = ...;
AtlasConnector.instance.getUsersByIds(
  ids: ids,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetUsersByIdsData, GetUsersByIdsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await AtlasConnector.instance.getUsersByIds(
  ids: ids,
);
GetUsersByIdsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String ids = ...;

final ref = AtlasConnector.instance.getUsersByIds(
  ids: ids,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetWorkout
#### Required Arguments
```dart
String id = ...;
AtlasConnector.instance.getWorkout(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetWorkoutData, GetWorkoutVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await AtlasConnector.instance.getWorkout(
  id: id,
);
GetWorkoutData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = AtlasConnector.instance.getWorkout(
  id: id,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListUserWorkouts
#### Required Arguments
```dart
String userId = ...;
AtlasConnector.instance.listUserWorkouts(
  userId: userId,
).execute();
```

#### Optional Arguments
We return a builder for each query. For ListUserWorkouts, we created `ListUserWorkoutsBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ListUserWorkoutsVariablesBuilder {
  ...
   ListUserWorkoutsVariablesBuilder limit(int? t) {
   _limit.value = t;
   return this;
  }

  ...
}
AtlasConnector.instance.listUserWorkouts(
  userId: userId,
)
.limit(limit)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<ListUserWorkoutsData, ListUserWorkoutsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await AtlasConnector.instance.listUserWorkouts(
  userId: userId,
);
ListUserWorkoutsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;

final ref = AtlasConnector.instance.listUserWorkouts(
  userId: userId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetTemplate
#### Required Arguments
```dart
String id = ...;
AtlasConnector.instance.getTemplate(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetTemplateData, GetTemplateVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await AtlasConnector.instance.getTemplate(
  id: id,
);
GetTemplateData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = AtlasConnector.instance.getTemplate(
  id: id,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListUserTemplates
#### Required Arguments
```dart
String userId = ...;
AtlasConnector.instance.listUserTemplates(
  userId: userId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListUserTemplatesData, ListUserTemplatesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await AtlasConnector.instance.listUserTemplates(
  userId: userId,
);
ListUserTemplatesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;

final ref = AtlasConnector.instance.listUserTemplates(
  userId: userId,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListPublicPosts
#### Required Arguments
```dart
// No required arguments
AtlasConnector.instance.listPublicPosts().execute();
```

#### Optional Arguments
We return a builder for each query. For ListPublicPosts, we created `ListPublicPostsBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ListPublicPostsVariablesBuilder {
  ...
 
  ListPublicPostsVariablesBuilder limit(int? t) {
   _limit.value = t;
   return this;
  }

  ...
}
AtlasConnector.instance.listPublicPosts()
.limit(limit)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<ListPublicPostsData, ListPublicPostsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await AtlasConnector.instance.listPublicPosts();
ListPublicPostsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = AtlasConnector.instance.listPublicPosts().ref();
ref.execute();

ref.subscribe(...);
```


### ListUserPosts
#### Required Arguments
```dart
String userId = ...;
AtlasConnector.instance.listUserPosts(
  userId: userId,
).execute();
```

#### Optional Arguments
We return a builder for each query. For ListUserPosts, we created `ListUserPostsBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ListUserPostsVariablesBuilder {
  ...
   ListUserPostsVariablesBuilder limit(int? t) {
   _limit.value = t;
   return this;
  }

  ...
}
AtlasConnector.instance.listUserPosts(
  userId: userId,
)
.limit(limit)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<ListUserPostsData, ListUserPostsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await AtlasConnector.instance.listUserPosts(
  userId: userId,
);
ListUserPostsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;

final ref = AtlasConnector.instance.listUserPosts(
  userId: userId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetConversation
#### Required Arguments
```dart
String id = ...;
AtlasConnector.instance.getConversation(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetConversationData, GetConversationVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await AtlasConnector.instance.getConversation(
  id: id,
);
GetConversationData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = AtlasConnector.instance.getConversation(
  id: id,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListInbox
#### Required Arguments
```dart
String userId = ...;
AtlasConnector.instance.listInbox(
  userId: userId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListInboxData, ListInboxVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await AtlasConnector.instance.listInbox(
  userId: userId,
);
ListInboxData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;

final ref = AtlasConnector.instance.listInbox(
  userId: userId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetConversationByInviteToken
#### Required Arguments
```dart
String token = ...;
AtlasConnector.instance.getConversationByInviteToken(
  token: token,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetConversationByInviteTokenData, GetConversationByInviteTokenVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await AtlasConnector.instance.getConversationByInviteToken(
  token: token,
);
GetConversationByInviteTokenData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String token = ...;

final ref = AtlasConnector.instance.getConversationByInviteToken(
  token: token,
).ref();
ref.execute();

ref.subscribe(...);
```


### SearchCommunities
#### Required Arguments
```dart
String q = ...;
String end = ...;
AtlasConnector.instance.searchCommunities(
  q: q,
  end: end,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<SearchCommunitiesData, SearchCommunitiesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await AtlasConnector.instance.searchCommunities(
  q: q,
  end: end,
);
SearchCommunitiesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String q = ...;
String end = ...;

final ref = AtlasConnector.instance.searchCommunities(
  q: q,
  end: end,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListMessages
#### Required Arguments
```dart
String conversationId = ...;
AtlasConnector.instance.listMessages(
  conversationId: conversationId,
).execute();
```

#### Optional Arguments
We return a builder for each query. For ListMessages, we created `ListMessagesBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ListMessagesVariablesBuilder {
  ...
   ListMessagesVariablesBuilder limit(int? t) {
   _limit.value = t;
   return this;
  }

  ...
}
AtlasConnector.instance.listMessages(
  conversationId: conversationId,
)
.limit(limit)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<ListMessagesData, ListMessagesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await AtlasConnector.instance.listMessages(
  conversationId: conversationId,
);
ListMessagesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String conversationId = ...;

final ref = AtlasConnector.instance.listMessages(
  conversationId: conversationId,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListExpiredGeneralMessages
#### Required Arguments
```dart
Timestamp cutoff = ...;
AtlasConnector.instance.listExpiredGeneralMessages(
  cutoff: cutoff,
).execute();
```

#### Optional Arguments
We return a builder for each query. For ListExpiredGeneralMessages, we created `ListExpiredGeneralMessagesBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ListExpiredGeneralMessagesVariablesBuilder {
  ...
   ListExpiredGeneralMessagesVariablesBuilder limit(int? t) {
   _limit.value = t;
   return this;
  }

  ...
}
AtlasConnector.instance.listExpiredGeneralMessages(
  cutoff: cutoff,
)
.limit(limit)
.execute();
```

#### Return Type
`execute()` returns a `QueryResult<ListExpiredGeneralMessagesData, ListExpiredGeneralMessagesVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await AtlasConnector.instance.listExpiredGeneralMessages(
  cutoff: cutoff,
);
ListExpiredGeneralMessagesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
Timestamp cutoff = ...;

final ref = AtlasConnector.instance.listExpiredGeneralMessages(
  cutoff: cutoff,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListCoachLinksByCoach
#### Required Arguments
```dart
String coachId = ...;
AtlasConnector.instance.listCoachLinksByCoach(
  coachId: coachId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListCoachLinksByCoachData, ListCoachLinksByCoachVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await AtlasConnector.instance.listCoachLinksByCoach(
  coachId: coachId,
);
ListCoachLinksByCoachData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String coachId = ...;

final ref = AtlasConnector.instance.listCoachLinksByCoach(
  coachId: coachId,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListCoachLinksByStudent
#### Required Arguments
```dart
String studentId = ...;
AtlasConnector.instance.listCoachLinksByStudent(
  studentId: studentId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListCoachLinksByStudentData, ListCoachLinksByStudentVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await AtlasConnector.instance.listCoachLinksByStudent(
  studentId: studentId,
);
ListCoachLinksByStudentData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String studentId = ...;

final ref = AtlasConnector.instance.listCoachLinksByStudent(
  studentId: studentId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetLinkInvitation
#### Required Arguments
```dart
String token = ...;
AtlasConnector.instance.getLinkInvitation(
  token: token,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetLinkInvitationData, GetLinkInvitationVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await AtlasConnector.instance.getLinkInvitation(
  token: token,
);
GetLinkInvitationData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String token = ...;

final ref = AtlasConnector.instance.getLinkInvitation(
  token: token,
).ref();
ref.execute();

ref.subscribe(...);
```


### CountUserWorkouts
#### Required Arguments
```dart
String userId = ...;
AtlasConnector.instance.countUserWorkouts(
  userId: userId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<CountUserWorkoutsData, CountUserWorkoutsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await AtlasConnector.instance.countUserWorkouts(
  userId: userId,
);
CountUserWorkoutsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;

final ref = AtlasConnector.instance.countUserWorkouts(
  userId: userId,
).ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### UpsertUser
#### Required Arguments
```dart
String id = ...;
String email = ...;
AtlasConnector.instance.upsertUser(
  id: id,
  email: email,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertUser, we created `UpsertUserBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertUserVariablesBuilder {
  ...
   UpsertUserVariablesBuilder name(String? t) {
   _name.value = t;
   return this;
  }
  UpsertUserVariablesBuilder nameLower(String? t) {
   _nameLower.value = t;
   return this;
  }
  UpsertUserVariablesBuilder role(String? t) {
   _role.value = t;
   return this;
  }

  ...
}
AtlasConnector.instance.upsertUser(
  id: id,
  email: email,
)
.name(name)
.nameLower(nameLower)
.role(role)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertUserData, UpsertUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await AtlasConnector.instance.upsertUser(
  id: id,
  email: email,
);
UpsertUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String email = ...;

final ref = AtlasConnector.instance.upsertUser(
  id: id,
  email: email,
).ref();
ref.execute();
```


### UpdateUserName
#### Required Arguments
```dart
String id = ...;
String name = ...;
String nameLower = ...;
AtlasConnector.instance.updateUserName(
  id: id,
  name: name,
  nameLower: nameLower,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateUserNameData, UpdateUserNameVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await AtlasConnector.instance.updateUserName(
  id: id,
  name: name,
  nameLower: nameLower,
);
UpdateUserNameData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String name = ...;
String nameLower = ...;

final ref = AtlasConnector.instance.updateUserName(
  id: id,
  name: name,
  nameLower: nameLower,
).ref();
ref.execute();
```


### CompleteUserProfile
#### Required Arguments
```dart
String id = ...;
String name = ...;
String nameLower = ...;
String username = ...;
Timestamp birthDate = ...;
String gender = ...;
double height = ...;
double weight = ...;
String activityLevel = ...;
AtlasConnector.instance.completeUserProfile(
  id: id,
  name: name,
  nameLower: nameLower,
  username: username,
  birthDate: birthDate,
  gender: gender,
  height: height,
  weight: weight,
  activityLevel: activityLevel,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CompleteUserProfileData, CompleteUserProfileVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await AtlasConnector.instance.completeUserProfile(
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
CompleteUserProfileData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String name = ...;
String nameLower = ...;
String username = ...;
Timestamp birthDate = ...;
String gender = ...;
double height = ...;
double weight = ...;
String activityLevel = ...;

final ref = AtlasConnector.instance.completeUserProfile(
  id: id,
  name: name,
  nameLower: nameLower,
  username: username,
  birthDate: birthDate,
  gender: gender,
  height: height,
  weight: weight,
  activityLevel: activityLevel,
).ref();
ref.execute();
```


### ClaimUsername
#### Required Arguments
```dart
String id = ...;
String username = ...;
AtlasConnector.instance.claimUsername(
  id: id,
  username: username,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<ClaimUsernameData, ClaimUsernameVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await AtlasConnector.instance.claimUsername(
  id: id,
  username: username,
);
ClaimUsernameData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String username = ...;

final ref = AtlasConnector.instance.claimUsername(
  id: id,
  username: username,
).ref();
ref.execute();
```


### UpdateUserRole
#### Required Arguments
```dart
String id = ...;
String role = ...;
AtlasConnector.instance.updateUserRole(
  id: id,
  role: role,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateUserRoleData, UpdateUserRoleVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await AtlasConnector.instance.updateUserRole(
  id: id,
  role: role,
);
UpdateUserRoleData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String role = ...;

final ref = AtlasConnector.instance.updateUserRole(
  id: id,
  role: role,
).ref();
ref.execute();
```


### UpdateUserBanner
#### Required Arguments
```dart
String id = ...;
AtlasConnector.instance.updateUserBanner(
  id: id,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateUserBanner, we created `UpdateUserBannerBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateUserBannerVariablesBuilder {
  ...
   UpdateUserBannerVariablesBuilder bannerPreset(String? t) {
   _bannerPreset.value = t;
   return this;
  }
  UpdateUserBannerVariablesBuilder bannerUrl(String? t) {
   _bannerUrl.value = t;
   return this;
  }

  ...
}
AtlasConnector.instance.updateUserBanner(
  id: id,
)
.bannerPreset(bannerPreset)
.bannerUrl(bannerUrl)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateUserBannerData, UpdateUserBannerVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await AtlasConnector.instance.updateUserBanner(
  id: id,
);
UpdateUserBannerData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = AtlasConnector.instance.updateUserBanner(
  id: id,
).ref();
ref.execute();
```


### UpdateUserProfile
#### Required Arguments
```dart
String id = ...;
String name = ...;
String nameLower = ...;
String username = ...;
Timestamp birthDate = ...;
String gender = ...;
double height = ...;
double weight = ...;
String activityLevel = ...;
AtlasConnector.instance.updateUserProfile(
  id: id,
  name: name,
  nameLower: nameLower,
  username: username,
  birthDate: birthDate,
  gender: gender,
  height: height,
  weight: weight,
  activityLevel: activityLevel,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateUserProfile, we created `UpdateUserProfileBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateUserProfileVariablesBuilder {
  ...
   UpdateUserProfileVariablesBuilder photoUrl(String? t) {
   _photoUrl.value = t;
   return this;
  }

  ...
}
AtlasConnector.instance.updateUserProfile(
  id: id,
  name: name,
  nameLower: nameLower,
  username: username,
  birthDate: birthDate,
  gender: gender,
  height: height,
  weight: weight,
  activityLevel: activityLevel,
)
.photoUrl(photoUrl)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateUserProfileData, UpdateUserProfileVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await AtlasConnector.instance.updateUserProfile(
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
UpdateUserProfileData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String name = ...;
String nameLower = ...;
String username = ...;
Timestamp birthDate = ...;
String gender = ...;
double height = ...;
double weight = ...;
String activityLevel = ...;

final ref = AtlasConnector.instance.updateUserProfile(
  id: id,
  name: name,
  nameLower: nameLower,
  username: username,
  birthDate: birthDate,
  gender: gender,
  height: height,
  weight: weight,
  activityLevel: activityLevel,
).ref();
ref.execute();
```


### CreateWorkout
#### Required Arguments
```dart
String id = ...;
String userId = ...;
String name = ...;
AtlasConnector.instance.createWorkout(
  id: id,
  userId: userId,
  name: name,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateWorkout, we created `CreateWorkoutBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateWorkoutVariablesBuilder {
  ...
   CreateWorkoutVariablesBuilder startedAt(Timestamp? t) {
   _startedAt.value = t;
   return this;
  }
  CreateWorkoutVariablesBuilder exercisesJson(AnyValue? t) {
   _exercisesJson.value = t;
   return this;
  }
  CreateWorkoutVariablesBuilder volume(int? t) {
   _volume.value = t;
   return this;
  }
  CreateWorkoutVariablesBuilder isPublic(bool? t) {
   _isPublic.value = t;
   return this;
  }
  CreateWorkoutVariablesBuilder assignedByCoachId(String? t) {
   _assignedByCoachId.value = t;
   return this;
  }
  CreateWorkoutVariablesBuilder source(int? t) {
   _source.value = t;
   return this;
  }
  CreateWorkoutVariablesBuilder templateId(String? t) {
   _templateId.value = t;
   return this;
  }

  ...
}
AtlasConnector.instance.createWorkout(
  id: id,
  userId: userId,
  name: name,
)
.startedAt(startedAt)
.exercisesJson(exercisesJson)
.volume(volume)
.isPublic(isPublic)
.assignedByCoachId(assignedByCoachId)
.source(source)
.templateId(templateId)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateWorkoutData, CreateWorkoutVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await AtlasConnector.instance.createWorkout(
  id: id,
  userId: userId,
  name: name,
);
CreateWorkoutData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String userId = ...;
String name = ...;

final ref = AtlasConnector.instance.createWorkout(
  id: id,
  userId: userId,
  name: name,
).ref();
ref.execute();
```


### UpsertWorkout
#### Required Arguments
```dart
String id = ...;
String userId = ...;
String name = ...;
int volume = ...;
bool isPublic = ...;
int source = ...;
AtlasConnector.instance.upsertWorkout(
  id: id,
  userId: userId,
  name: name,
  volume: volume,
  isPublic: isPublic,
  source: source,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertWorkout, we created `UpsertWorkoutBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertWorkoutVariablesBuilder {
  ...
   UpsertWorkoutVariablesBuilder startedAt(Timestamp? t) {
   _startedAt.value = t;
   return this;
  }
  UpsertWorkoutVariablesBuilder finishedAt(Timestamp? t) {
   _finishedAt.value = t;
   return this;
  }
  UpsertWorkoutVariablesBuilder exercisesJson(AnyValue? t) {
   _exercisesJson.value = t;
   return this;
  }
  UpsertWorkoutVariablesBuilder assignedByCoachId(String? t) {
   _assignedByCoachId.value = t;
   return this;
  }
  UpsertWorkoutVariablesBuilder templateId(String? t) {
   _templateId.value = t;
   return this;
  }

  ...
}
AtlasConnector.instance.upsertWorkout(
  id: id,
  userId: userId,
  name: name,
  volume: volume,
  isPublic: isPublic,
  source: source,
)
.startedAt(startedAt)
.finishedAt(finishedAt)
.exercisesJson(exercisesJson)
.assignedByCoachId(assignedByCoachId)
.templateId(templateId)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertWorkoutData, UpsertWorkoutVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await AtlasConnector.instance.upsertWorkout(
  id: id,
  userId: userId,
  name: name,
  volume: volume,
  isPublic: isPublic,
  source: source,
);
UpsertWorkoutData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String userId = ...;
String name = ...;
int volume = ...;
bool isPublic = ...;
int source = ...;

final ref = AtlasConnector.instance.upsertWorkout(
  id: id,
  userId: userId,
  name: name,
  volume: volume,
  isPublic: isPublic,
  source: source,
).ref();
ref.execute();
```


### DeleteWorkout
#### Required Arguments
```dart
String id = ...;
AtlasConnector.instance.deleteWorkout(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteWorkoutData, DeleteWorkoutVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await AtlasConnector.instance.deleteWorkout(
  id: id,
);
DeleteWorkoutData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = AtlasConnector.instance.deleteWorkout(
  id: id,
).ref();
ref.execute();
```


### AssignWorkoutToStudent
#### Required Arguments
```dart
String id = ...;
String studentId = ...;
String name = ...;
Timestamp startedAt = ...;
String coachId = ...;
int source = ...;
AtlasConnector.instance.assignWorkoutToStudent(
  id: id,
  studentId: studentId,
  name: name,
  startedAt: startedAt,
  coachId: coachId,
  source: source,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<AssignWorkoutToStudentData, AssignWorkoutToStudentVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await AtlasConnector.instance.assignWorkoutToStudent(
  id: id,
  studentId: studentId,
  name: name,
  startedAt: startedAt,
  coachId: coachId,
  source: source,
);
AssignWorkoutToStudentData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String studentId = ...;
String name = ...;
Timestamp startedAt = ...;
String coachId = ...;
int source = ...;

final ref = AtlasConnector.instance.assignWorkoutToStudent(
  id: id,
  studentId: studentId,
  name: name,
  startedAt: startedAt,
  coachId: coachId,
  source: source,
).ref();
ref.execute();
```


### UpsertTemplate
#### Required Arguments
```dart
String id = ...;
String userId = ...;
String name = ...;
String notes = ...;
int defaultRestSeconds = ...;
String scheduleMode = ...;
Timestamp createdAt = ...;
Timestamp updatedAt = ...;
AtlasConnector.instance.upsertTemplate(
  id: id,
  userId: userId,
  name: name,
  notes: notes,
  defaultRestSeconds: defaultRestSeconds,
  scheduleMode: scheduleMode,
  createdAt: createdAt,
  updatedAt: updatedAt,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertTemplate, we created `UpsertTemplateBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertTemplateVariablesBuilder {
  ...
   UpsertTemplateVariablesBuilder exercisesJson(AnyValue? t) {
   _exercisesJson.value = t;
   return this;
  }
  UpsertTemplateVariablesBuilder weekdaysJson(AnyValue? t) {
   _weekdaysJson.value = t;
   return this;
  }
  UpsertTemplateVariablesBuilder restDaysBetween(int? t) {
   _restDaysBetween.value = t;
   return this;
  }

  ...
}
AtlasConnector.instance.upsertTemplate(
  id: id,
  userId: userId,
  name: name,
  notes: notes,
  defaultRestSeconds: defaultRestSeconds,
  scheduleMode: scheduleMode,
  createdAt: createdAt,
  updatedAt: updatedAt,
)
.exercisesJson(exercisesJson)
.weekdaysJson(weekdaysJson)
.restDaysBetween(restDaysBetween)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertTemplateData, UpsertTemplateVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await AtlasConnector.instance.upsertTemplate(
  id: id,
  userId: userId,
  name: name,
  notes: notes,
  defaultRestSeconds: defaultRestSeconds,
  scheduleMode: scheduleMode,
  createdAt: createdAt,
  updatedAt: updatedAt,
);
UpsertTemplateData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String userId = ...;
String name = ...;
String notes = ...;
int defaultRestSeconds = ...;
String scheduleMode = ...;
Timestamp createdAt = ...;
Timestamp updatedAt = ...;

final ref = AtlasConnector.instance.upsertTemplate(
  id: id,
  userId: userId,
  name: name,
  notes: notes,
  defaultRestSeconds: defaultRestSeconds,
  scheduleMode: scheduleMode,
  createdAt: createdAt,
  updatedAt: updatedAt,
).ref();
ref.execute();
```


### DeleteTemplate
#### Required Arguments
```dart
String id = ...;
AtlasConnector.instance.deleteTemplate(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteTemplateData, DeleteTemplateVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await AtlasConnector.instance.deleteTemplate(
  id: id,
);
DeleteTemplateData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = AtlasConnector.instance.deleteTemplate(
  id: id,
).ref();
ref.execute();
```


### CreatePost
#### Required Arguments
```dart
String userId = ...;
String caption = ...;
int volume = ...;
bool isPublic = ...;
AtlasConnector.instance.createPost(
  userId: userId,
  caption: caption,
  volume: volume,
  isPublic: isPublic,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreatePostData, CreatePostVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await AtlasConnector.instance.createPost(
  userId: userId,
  caption: caption,
  volume: volume,
  isPublic: isPublic,
);
CreatePostData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String userId = ...;
String caption = ...;
int volume = ...;
bool isPublic = ...;

final ref = AtlasConnector.instance.createPost(
  userId: userId,
  caption: caption,
  volume: volume,
  isPublic: isPublic,
).ref();
ref.execute();
```


### UpsertConversation
#### Required Arguments
```dart
String id = ...;
String type = ...;
String title = ...;
AtlasConnector.instance.upsertConversation(
  id: id,
  type: type,
  title: title,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertConversation, we created `UpsertConversationBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertConversationVariablesBuilder {
  ...
   UpsertConversationVariablesBuilder titleLower(String? t) {
   _titleLower.value = t;
   return this;
  }
  UpsertConversationVariablesBuilder lastMessage(String? t) {
   _lastMessage.value = t;
   return this;
  }
  UpsertConversationVariablesBuilder lastSenderName(String? t) {
   _lastSenderName.value = t;
   return this;
  }
  UpsertConversationVariablesBuilder createdBy(String? t) {
   _createdBy.value = t;
   return this;
  }
  UpsertConversationVariablesBuilder inviteToken(String? t) {
   _inviteToken.value = t;
   return this;
  }

  ...
}
AtlasConnector.instance.upsertConversation(
  id: id,
  type: type,
  title: title,
)
.titleLower(titleLower)
.lastMessage(lastMessage)
.lastSenderName(lastSenderName)
.createdBy(createdBy)
.inviteToken(inviteToken)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertConversationData, UpsertConversationVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await AtlasConnector.instance.upsertConversation(
  id: id,
  type: type,
  title: title,
);
UpsertConversationData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String type = ...;
String title = ...;

final ref = AtlasConnector.instance.upsertConversation(
  id: id,
  type: type,
  title: title,
).ref();
ref.execute();
```


### UpdateConversationLastMessage
#### Required Arguments
```dart
String id = ...;
String lastMessage = ...;
String lastSenderName = ...;
Timestamp updatedAt = ...;
AtlasConnector.instance.updateConversationLastMessage(
  id: id,
  lastMessage: lastMessage,
  lastSenderName: lastSenderName,
  updatedAt: updatedAt,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateConversationLastMessageData, UpdateConversationLastMessageVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await AtlasConnector.instance.updateConversationLastMessage(
  id: id,
  lastMessage: lastMessage,
  lastSenderName: lastSenderName,
  updatedAt: updatedAt,
);
UpdateConversationLastMessageData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String lastMessage = ...;
String lastSenderName = ...;
Timestamp updatedAt = ...;

final ref = AtlasConnector.instance.updateConversationLastMessage(
  id: id,
  lastMessage: lastMessage,
  lastSenderName: lastSenderName,
  updatedAt: updatedAt,
).ref();
ref.execute();
```


### AddConversationMember
#### Required Arguments
```dart
String conversationId = ...;
String userId = ...;
AtlasConnector.instance.addConversationMember(
  conversationId: conversationId,
  userId: userId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<AddConversationMemberData, AddConversationMemberVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await AtlasConnector.instance.addConversationMember(
  conversationId: conversationId,
  userId: userId,
);
AddConversationMemberData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String conversationId = ...;
String userId = ...;

final ref = AtlasConnector.instance.addConversationMember(
  conversationId: conversationId,
  userId: userId,
).ref();
ref.execute();
```


### SendMessage
#### Required Arguments
```dart
String conversationId = ...;
String text = ...;
String senderId = ...;
String senderName = ...;
Timestamp createdAt = ...;
AtlasConnector.instance.sendMessage(
  conversationId: conversationId,
  text: text,
  senderId: senderId,
  senderName: senderName,
  createdAt: createdAt,
).execute();
```

#### Optional Arguments
We return a builder for each query. For SendMessage, we created `SendMessageBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class SendMessageVariablesBuilder {
  ...
   SendMessageVariablesBuilder expiresAt(Timestamp? t) {
   _expiresAt.value = t;
   return this;
  }

  ...
}
AtlasConnector.instance.sendMessage(
  conversationId: conversationId,
  text: text,
  senderId: senderId,
  senderName: senderName,
  createdAt: createdAt,
)
.expiresAt(expiresAt)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<SendMessageData, SendMessageVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await AtlasConnector.instance.sendMessage(
  conversationId: conversationId,
  text: text,
  senderId: senderId,
  senderName: senderName,
  createdAt: createdAt,
);
SendMessageData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String conversationId = ...;
String text = ...;
String senderId = ...;
String senderName = ...;
Timestamp createdAt = ...;

final ref = AtlasConnector.instance.sendMessage(
  conversationId: conversationId,
  text: text,
  senderId: senderId,
  senderName: senderName,
  createdAt: createdAt,
).ref();
ref.execute();
```


### DeleteMessage
#### Required Arguments
```dart
String id = ...;
AtlasConnector.instance.deleteMessage(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteMessageData, DeleteMessageVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await AtlasConnector.instance.deleteMessage(
  id: id,
);
DeleteMessageData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = AtlasConnector.instance.deleteMessage(
  id: id,
).ref();
ref.execute();
```


### CreateLinkInvitation
#### Required Arguments
```dart
String token = ...;
String creatorId = ...;
String creatorRole = ...;
Timestamp expiresAt = ...;
AtlasConnector.instance.createLinkInvitation(
  token: token,
  creatorId: creatorId,
  creatorRole: creatorRole,
  expiresAt: expiresAt,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateLinkInvitationData, CreateLinkInvitationVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await AtlasConnector.instance.createLinkInvitation(
  token: token,
  creatorId: creatorId,
  creatorRole: creatorRole,
  expiresAt: expiresAt,
);
CreateLinkInvitationData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String token = ...;
String creatorId = ...;
String creatorRole = ...;
Timestamp expiresAt = ...;

final ref = AtlasConnector.instance.createLinkInvitation(
  token: token,
  creatorId: creatorId,
  creatorRole: creatorRole,
  expiresAt: expiresAt,
).ref();
ref.execute();
```


### UpdateLinkInvitationStatus
#### Required Arguments
```dart
String token = ...;
String status = ...;
AtlasConnector.instance.updateLinkInvitationStatus(
  token: token,
  status: status,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateLinkInvitationStatusData, UpdateLinkInvitationStatusVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await AtlasConnector.instance.updateLinkInvitationStatus(
  token: token,
  status: status,
);
UpdateLinkInvitationStatusData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String token = ...;
String status = ...;

final ref = AtlasConnector.instance.updateLinkInvitationStatus(
  token: token,
  status: status,
).ref();
ref.execute();
```


### CreateCoachLink
#### Required Arguments
```dart
String coachId = ...;
String studentId = ...;
AtlasConnector.instance.createCoachLink(
  coachId: coachId,
  studentId: studentId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateCoachLinkData, CreateCoachLinkVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await AtlasConnector.instance.createCoachLink(
  coachId: coachId,
  studentId: studentId,
);
CreateCoachLinkData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String coachId = ...;
String studentId = ...;

final ref = AtlasConnector.instance.createCoachLink(
  coachId: coachId,
  studentId: studentId,
).ref();
ref.execute();
```

