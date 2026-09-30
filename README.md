# Atlas Mobile PI1

Aplicativo Flutter do projeto Atlas (PI1) com autenticação Firebase e cadastro de perfil físico.

## Stack

- Flutter + Provider + go_router
- Firebase Core, Authentication (email/senha, Google, Apple)
- Firebase SQL Connect (PostgreSQL / Cloud SQL)
- Design system Atlas (cores, tipografia Inter, componentes)

## Configuração Firebase

Projeto: **`atlas-160cf`**

- Android: `android/app/google-services.json` e `lib/firebase_options.dart`
- Package: `com.atlas.atlas_mobile_pi1`
- SQL Connect: serviço `atlas-160cf-service`, instância `atlas-160cf-instance`, database `atlas-database` (região `southamerica-east1`)

### Console Firebase

1. Authentication → Sign-in method → **Email/Password** ativado (e provedores sociais, se usados)
2. Authentication → Templates → **Password reset** ativo (idioma/remetente opcional)
3. SQL Connect → serviço `atlas-160cf-service` ativo
4. **Publicar schema e connector** (após alterar GraphQL em `dataconnect/`):

```bash
firebase login
firebase use atlas-160cf
firebase dataconnect:sql:migrate --service atlas-160cf-service --force
firebase deploy --only dataconnect --force
```

Arquivos: `dataconnect/`, `firebase.json`

Após regenerar o SDK Dart do connector, aplique o patch que remove `const` inválidos do gerador:

```powershell
.\tool\patch_dataconnect_generated.ps1
```

### Recuperação de senha (Firebase Auth)

Já implementado no app:

1. Login → **Esqueceu a senha?** → `/forgot-password` ([`ForgotPasswordPage`](lib/features/auth/presentation/pages/forgot_password_page.dart))
2. App chama `AuthService.sendPasswordReset` → `FirebaseAuth.sendPasswordResetEmail`
3. O usuário recebe o e-mail do Firebase, redefine a senha na **página hospedada pelo Firebase** e volta a fazer login no app

Requisitos no Console (`atlas-160cf`):

- Email/Password ativo
- Template **Password reset** ativo
- Conta de teste com e-mail/senha (não só Google/Apple)

#### Checklist de teste manual

1. Abrir login, digitar um e-mail cadastrado e tocar em **Esqueceu a senha?**
2. Confirmar e-mail pré-preenchido → **Enviar link**
3. Tela deve mostrar confirmação e botão para voltar ao login
4. Abrir o e-mail (verifique spam) → link → definir nova senha
5. Login no app com a nova senha
6. Erros esperados: e-mail inválido (validação local); rate limit / falhas de rede via SnackBar

Deep link de volta ao app (`ActionCodeSettings`) não está no escopo — o fluxo usa a página padrão do Firebase.

### iOS / Web / Desktop

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### Catálogo de exercícios (AscendAPI EDB)

A lista de exercícios usa [EDB WITH VIDEOS AND IMAGES BY ASCENDAPI](https://rapidapi.com/ascendapi/api/edb-with-videos-and-images-by-ascendapi) (RapidAPI). Sem key, o app usa o seed local + cache offline.

```bash
flutter run --dart-define=EXERCISEDB_API_KEY=sua_chave_rapidapi
```

Não commit a key. Prefira `dart-define` ou um `.vscode/launch.json` local (já no `.gitignore`).

### Executar

```bash
flutter pub get
flutter run --dart-define=EXERCISEDB_API_KEY=sua_chave_rapidapi
```

## Funcionalidades

1. Onboarding
2. Login e cadastro (email, senha e confirmação; Google/Apple)
3. Verificação de email e reset de senha (Firebase Auth)
4. Perfil físico (dados básicos, medidas e nível de atividade)
5. Persistência de domínio via SQL Connect (Postgres)
6. Sessão com `FirebaseAuth.authStateChanges`
7. Home com logout

## Estrutura

```
lib/
  core/theme/
  core/navigation/
  core/dataconnect/
  dataconnect_generated/
  features/auth/
  services/auth_service.dart
  ui/components/
dataconnect/
  schema/
  connector/
```

## Application ID

- Android: `com.atlas.atlas_mobile_pi1`
