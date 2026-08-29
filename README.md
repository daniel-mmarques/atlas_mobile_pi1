# Atlas Mobile PI1

Aplicativo Flutter do projeto Atlas (PI1) com autenticação Firebase e cadastro de perfil físico.

## Stack

- Flutter + Provider + go_router
- Firebase Core, Authentication (email/senha), Cloud Firestore
- Design system Atlas (cores, tipografia Inter, componentes)

## Configuração Firebase

Projeto: **`atlas-160cf`**

- Android: `android/app/google-services.json` e `lib/firebase_options.dart`
- Package: `com.atlas.atlas_mobile_pi1`

### Console Firebase

1. Authentication → Email/Password ativado
2. Cloud Firestore criado
3. **Publicar regras e índices** (obrigatório após clonar/atualizar):

```bash
npx firebase-tools login
npx firebase-tools use atlas-160cf
npx firebase-tools deploy --only firestore
```

Ou no Console: cole o conteúdo de `firestore.rules` em Firestore → Rules, e crie os índices compostos pedidos pelos links de erro no log (posts + conversations).

Arquivos: `firestore.rules`, `firestore.indexes.json`, `firebase.json`

### iOS / Web / Desktop

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### Executar

```bash
flutter pub get
flutter run
```

## Funcionalidades

1. Onboarding
2. Login e cadastro (email, senha e confirmação)
3. Perfil físico (dados básicos, medidas e nível de atividade)
4. Persistência em `users/{uid}` no Firestore
5. Sessão com `FirebaseAuth.authStateChanges`
6. Home com logout

## Estrutura

```
lib/
  core/theme/
  core/navigation/
  features/auth/
  services/auth_service.dart
  ui/components/
```

## Application ID

- Android: `com.atlas.atlas_mobile_pi1`
