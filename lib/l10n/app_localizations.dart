import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In pt, this message translates to:
  /// **'Atlas'**
  String get appTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Configurações'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Como acompanhar treinos e métricas'**
  String get settingsSubtitle;

  /// No description provided for @settingsPreferredUnit.
  ///
  /// In pt, this message translates to:
  /// **'Unidade preferida'**
  String get settingsPreferredUnit;

  /// No description provided for @settingsUnitImperial.
  ///
  /// In pt, this message translates to:
  /// **'Libras e milhas'**
  String get settingsUnitImperial;

  /// No description provided for @settingsUnitMetric.
  ///
  /// In pt, this message translates to:
  /// **'Quilos e metros'**
  String get settingsUnitMetric;

  /// No description provided for @settingsAppearance.
  ///
  /// In pt, this message translates to:
  /// **'Aparência'**
  String get settingsAppearance;

  /// No description provided for @settingsLanguage.
  ///
  /// In pt, this message translates to:
  /// **'Idioma'**
  String get settingsLanguage;

  /// No description provided for @langPortuguese.
  ///
  /// In pt, this message translates to:
  /// **'Português'**
  String get langPortuguese;

  /// No description provided for @langEnglish.
  ///
  /// In pt, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langSpanish.
  ///
  /// In pt, this message translates to:
  /// **'Español'**
  String get langSpanish;

  /// No description provided for @settingsCoachMode.
  ///
  /// In pt, this message translates to:
  /// **'Modo coach'**
  String get settingsCoachMode;

  /// No description provided for @settingsCoachActive.
  ///
  /// In pt, this message translates to:
  /// **'Ativo — área do coach disponível'**
  String get settingsCoachActive;

  /// No description provided for @settingsCoachInactive.
  ///
  /// In pt, this message translates to:
  /// **'Desativado'**
  String get settingsCoachInactive;

  /// No description provided for @settingsCoachArea.
  ///
  /// In pt, this message translates to:
  /// **'Área do coach'**
  String get settingsCoachArea;

  /// No description provided for @settingsCoachAreaSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Alunos e vínculos'**
  String get settingsCoachAreaSubtitle;

  /// No description provided for @settingsLogout.
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get settingsLogout;

  /// No description provided for @settingsLogoutSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Encerrar sessão da conta'**
  String get settingsLogoutSubtitle;

  /// No description provided for @themeLight.
  ///
  /// In pt, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeSunset.
  ///
  /// In pt, this message translates to:
  /// **'Sunset'**
  String get themeSunset;

  /// No description provided for @themeCyberpunk.
  ///
  /// In pt, this message translates to:
  /// **'Cyberpunk 2077'**
  String get themeCyberpunk;

  /// No description provided for @themeStorm.
  ///
  /// In pt, this message translates to:
  /// **'Storm'**
  String get themeStorm;

  /// No description provided for @themeOcean.
  ///
  /// In pt, this message translates to:
  /// **'Ocean'**
  String get themeOcean;

  /// No description provided for @themeDark.
  ///
  /// In pt, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeMidnight.
  ///
  /// In pt, this message translates to:
  /// **'Midnight'**
  String get themeMidnight;

  /// No description provided for @authSetupTitle.
  ///
  /// In pt, this message translates to:
  /// **'Vamos configurar\nsua conta'**
  String get authSetupTitle;

  /// No description provided for @authSetupSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Entre ou cadastre-se para a melhor experiência de treino'**
  String get authSetupSubtitle;

  /// No description provided for @authLogin.
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get authLogin;

  /// No description provided for @authRegister.
  ///
  /// In pt, this message translates to:
  /// **'Cadastrar'**
  String get authRegister;

  /// No description provided for @authForgotPassword.
  ///
  /// In pt, this message translates to:
  /// **'Esqueceu a senha?'**
  String get authForgotPassword;

  /// No description provided for @authEmailHint.
  ///
  /// In pt, this message translates to:
  /// **'Email'**
  String get authEmailHint;

  /// No description provided for @authPasswordHint.
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get authPasswordHint;

  /// No description provided for @authConfirmPasswordHint.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar senha'**
  String get authConfirmPasswordHint;

  /// No description provided for @authOrContinueWith.
  ///
  /// In pt, this message translates to:
  /// **'Ou continue com'**
  String get authOrContinueWith;

  /// No description provided for @authGoogle.
  ///
  /// In pt, this message translates to:
  /// **'Google'**
  String get authGoogle;

  /// No description provided for @authApple.
  ///
  /// In pt, this message translates to:
  /// **'Apple'**
  String get authApple;

  /// No description provided for @authGetStarted.
  ///
  /// In pt, this message translates to:
  /// **'Começar'**
  String get authGetStarted;

  /// No description provided for @authWelcomeSlide.
  ///
  /// In pt, this message translates to:
  /// **'Bem-vindo à revolução na forma de treinar'**
  String get authWelcomeSlide;

  /// No description provided for @onboardingTitle1.
  ///
  /// In pt, this message translates to:
  /// **'Treine com método'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In pt, this message translates to:
  /// **'Planos estruturados para força, hipertrofia e performance.'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In pt, this message translates to:
  /// **'Acompanhe sua evolução'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In pt, this message translates to:
  /// **'Registre cargas, séries e veja seu progresso.'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In pt, this message translates to:
  /// **'Constância gera resultado'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In pt, this message translates to:
  /// **'Disciplina hoje. Corpo diferente amanhã.'**
  String get onboardingSubtitle3;

  /// No description provided for @signUpStepAccount.
  ///
  /// In pt, this message translates to:
  /// **'Conta'**
  String get signUpStepAccount;

  /// No description provided for @signUpStepProfile.
  ///
  /// In pt, this message translates to:
  /// **'Perfil'**
  String get signUpStepProfile;

  /// No description provided for @signUpStepBody.
  ///
  /// In pt, this message translates to:
  /// **'Corpo'**
  String get signUpStepBody;

  /// No description provided for @signUpTitleAccount.
  ///
  /// In pt, this message translates to:
  /// **'Crie sua conta'**
  String get signUpTitleAccount;

  /// No description provided for @signUpTitleProfile.
  ///
  /// In pt, this message translates to:
  /// **'Seu perfil'**
  String get signUpTitleProfile;

  /// No description provided for @signUpTitleBody.
  ///
  /// In pt, this message translates to:
  /// **'Dados físicos'**
  String get signUpTitleBody;

  /// No description provided for @signUpNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Nome completo'**
  String get signUpNameHint;

  /// No description provided for @signUpUsernameHint.
  ///
  /// In pt, this message translates to:
  /// **'@username'**
  String get signUpUsernameHint;

  /// No description provided for @signUpBirthHint.
  ///
  /// In pt, this message translates to:
  /// **'Data de nascimento'**
  String get signUpBirthHint;

  /// No description provided for @signUpWeightHint.
  ///
  /// In pt, this message translates to:
  /// **'Peso (kg)'**
  String get signUpWeightHint;

  /// No description provided for @signUpHeightHint.
  ///
  /// In pt, this message translates to:
  /// **'Altura (m)'**
  String get signUpHeightHint;

  /// No description provided for @signUpGenderHint.
  ///
  /// In pt, this message translates to:
  /// **'Sexo'**
  String get signUpGenderHint;

  /// No description provided for @signUpActivityHint.
  ///
  /// In pt, this message translates to:
  /// **'Nível de atividade'**
  String get signUpActivityHint;

  /// No description provided for @signUpNext.
  ///
  /// In pt, this message translates to:
  /// **'Próximo'**
  String get signUpNext;

  /// No description provided for @signUpFinish.
  ///
  /// In pt, this message translates to:
  /// **'Finalizar'**
  String get signUpFinish;

  /// No description provided for @signUpBack.
  ///
  /// In pt, this message translates to:
  /// **'Voltar'**
  String get signUpBack;

  /// No description provided for @genderMale.
  ///
  /// In pt, this message translates to:
  /// **'Masculino'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In pt, this message translates to:
  /// **'Feminino'**
  String get genderFemale;

  /// No description provided for @genderOther.
  ///
  /// In pt, this message translates to:
  /// **'Outro'**
  String get genderOther;

  /// No description provided for @activitySedentary.
  ///
  /// In pt, this message translates to:
  /// **'Sedentário'**
  String get activitySedentary;

  /// No description provided for @activityLightly.
  ///
  /// In pt, this message translates to:
  /// **'Pouco ativo'**
  String get activityLightly;

  /// No description provided for @activityModerately.
  ///
  /// In pt, this message translates to:
  /// **'Moderadamente ativo'**
  String get activityModerately;

  /// No description provided for @activityVery.
  ///
  /// In pt, this message translates to:
  /// **'Muito ativo'**
  String get activityVery;

  /// No description provided for @activityExtremely.
  ///
  /// In pt, this message translates to:
  /// **'Extremamente ativo'**
  String get activityExtremely;

  /// No description provided for @validationNameRequired.
  ///
  /// In pt, this message translates to:
  /// **'Informe seu nome'**
  String get validationNameRequired;

  /// No description provided for @validationNameMin.
  ///
  /// In pt, this message translates to:
  /// **'O nome precisa ter pelo menos 3 caracteres'**
  String get validationNameMin;

  /// No description provided for @validationNameMax.
  ///
  /// In pt, this message translates to:
  /// **'O nome deve ter no máximo 80 caracteres'**
  String get validationNameMax;

  /// No description provided for @validationNameInvalid.
  ///
  /// In pt, this message translates to:
  /// **'Informe um nome válido'**
  String get validationNameInvalid;

  /// No description provided for @validationEmailRequired.
  ///
  /// In pt, this message translates to:
  /// **'Informe o email'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In pt, this message translates to:
  /// **'Informe um email válido'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In pt, this message translates to:
  /// **'Informe a senha'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordMin.
  ///
  /// In pt, this message translates to:
  /// **'A senha deve ter no mínimo 6 caracteres'**
  String get validationPasswordMin;

  /// No description provided for @validationPasswordMax.
  ///
  /// In pt, this message translates to:
  /// **'A senha deve ter no máximo 72 caracteres'**
  String get validationPasswordMax;

  /// No description provided for @validationConfirmRequired.
  ///
  /// In pt, this message translates to:
  /// **'Confirme a senha'**
  String get validationConfirmRequired;

  /// No description provided for @validationConfirmMismatch.
  ///
  /// In pt, this message translates to:
  /// **'As senhas não coincidem'**
  String get validationConfirmMismatch;

  /// No description provided for @validationBirthRequired.
  ///
  /// In pt, this message translates to:
  /// **'Informe sua data de nascimento'**
  String get validationBirthRequired;

  /// No description provided for @validationBirthInvalid.
  ///
  /// In pt, this message translates to:
  /// **'Data inválida'**
  String get validationBirthInvalid;

  /// No description provided for @validationBirthFuture.
  ///
  /// In pt, this message translates to:
  /// **'A data não pode ser no futuro'**
  String get validationBirthFuture;

  /// No description provided for @validationBirthInvalidRange.
  ///
  /// In pt, this message translates to:
  /// **'Informe uma data de nascimento válida'**
  String get validationBirthInvalidRange;

  /// No description provided for @validationAgeMin.
  ///
  /// In pt, this message translates to:
  /// **'Idade mínima é 15 anos'**
  String get validationAgeMin;

  /// No description provided for @validationWeightRequired.
  ///
  /// In pt, this message translates to:
  /// **'Informe seu peso'**
  String get validationWeightRequired;

  /// No description provided for @validationWeightNumeric.
  ///
  /// In pt, this message translates to:
  /// **'Informe um peso numérico'**
  String get validationWeightNumeric;

  /// No description provided for @validationWeightRange.
  ///
  /// In pt, this message translates to:
  /// **'Peso deve estar entre 30 e 300 kg'**
  String get validationWeightRange;

  /// No description provided for @validationHeightRequired.
  ///
  /// In pt, this message translates to:
  /// **'Informe sua altura'**
  String get validationHeightRequired;

  /// No description provided for @validationHeightNumeric.
  ///
  /// In pt, this message translates to:
  /// **'Informe uma altura numérica'**
  String get validationHeightNumeric;

  /// No description provided for @validationHeightRange.
  ///
  /// In pt, this message translates to:
  /// **'Altura deve estar entre 1,00 e 2,50 m'**
  String get validationHeightRange;

  /// No description provided for @validationGenderRequired.
  ///
  /// In pt, this message translates to:
  /// **'Selecione o sexo'**
  String get validationGenderRequired;

  /// No description provided for @validationActivityRequired.
  ///
  /// In pt, this message translates to:
  /// **'Selecione o nível de atividade'**
  String get validationActivityRequired;

  /// No description provided for @validationUsernameRequired.
  ///
  /// In pt, this message translates to:
  /// **'Informe seu @'**
  String get validationUsernameRequired;

  /// No description provided for @validationUsernameMin.
  ///
  /// In pt, this message translates to:
  /// **'O @ precisa ter pelo menos 3 caracteres'**
  String get validationUsernameMin;

  /// No description provided for @validationUsernameMax.
  ///
  /// In pt, this message translates to:
  /// **'O @ deve ter no máximo 30 caracteres'**
  String get validationUsernameMax;

  /// No description provided for @validationUsernameChars.
  ///
  /// In pt, this message translates to:
  /// **'Use apenas letras minúsculas, números, . e _'**
  String get validationUsernameChars;

  /// No description provided for @validationUsernameInvalid.
  ///
  /// In pt, this message translates to:
  /// **'Informe um @ válido'**
  String get validationUsernameInvalid;

  /// No description provided for @validationUsernameTaken.
  ///
  /// In pt, this message translates to:
  /// **'Este @ já está em uso.'**
  String get validationUsernameTaken;

  /// No description provided for @claimUsernameTitle.
  ///
  /// In pt, this message translates to:
  /// **'Escolha seu @'**
  String get claimUsernameTitle;

  /// No description provided for @claimUsernameSave.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get claimUsernameSave;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get save;

  /// No description provided for @continueAction.
  ///
  /// In pt, this message translates to:
  /// **'Continuar'**
  String get continueAction;

  /// No description provided for @delete.
  ///
  /// In pt, this message translates to:
  /// **'Excluir'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In pt, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @share.
  ///
  /// In pt, this message translates to:
  /// **'Compartilhar'**
  String get share;

  /// No description provided for @copyLink.
  ///
  /// In pt, this message translates to:
  /// **'Copiar link'**
  String get copyLink;

  /// No description provided for @linkCopied.
  ///
  /// In pt, this message translates to:
  /// **'Link copiado'**
  String get linkCopied;

  /// No description provided for @search.
  ///
  /// In pt, this message translates to:
  /// **'Buscar'**
  String get search;

  /// No description provided for @notAuthenticated.
  ///
  /// In pt, this message translates to:
  /// **'Não autenticado'**
  String get notAuthenticated;

  /// No description provided for @loading.
  ///
  /// In pt, this message translates to:
  /// **'Carregando…'**
  String get loading;

  /// No description provided for @errorGeneric.
  ///
  /// In pt, this message translates to:
  /// **'Algo deu errado'**
  String get errorGeneric;

  /// No description provided for @widgetStreak.
  ///
  /// In pt, this message translates to:
  /// **'Streak'**
  String get widgetStreak;

  /// No description provided for @widgetVolume.
  ///
  /// In pt, this message translates to:
  /// **'Volume'**
  String get widgetVolume;

  /// No description provided for @widgetFrequency.
  ///
  /// In pt, this message translates to:
  /// **'Frequência'**
  String get widgetFrequency;

  /// No description provided for @widgetPrs.
  ///
  /// In pt, this message translates to:
  /// **'PRs'**
  String get widgetPrs;

  /// No description provided for @widgetDuration.
  ///
  /// In pt, this message translates to:
  /// **'Duração'**
  String get widgetDuration;

  /// No description provided for @widgetStreakSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Dias consecutivos treinando'**
  String get widgetStreakSubtitle;

  /// No description provided for @widgetVolumeSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Volume total por semana'**
  String get widgetVolumeSubtitle;

  /// No description provided for @widgetFrequencySubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Treinos na semana e no mês'**
  String get widgetFrequencySubtitle;

  /// No description provided for @widgetPrsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Melhores cargas recentes'**
  String get widgetPrsSubtitle;

  /// No description provided for @widgetDurationSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Tempo médio por treino'**
  String get widgetDurationSubtitle;

  /// No description provided for @widgetAddStreak.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar streak ao painel'**
  String get widgetAddStreak;

  /// No description provided for @widgetAddVolume.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar volume semanal ao painel'**
  String get widgetAddVolume;

  /// No description provided for @widgetAddFrequency.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar frequência ao painel'**
  String get widgetAddFrequency;

  /// No description provided for @widgetAddPrs.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar PRs ao painel'**
  String get widgetAddPrs;

  /// No description provided for @widgetAddDuration.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar duração ao painel'**
  String get widgetAddDuration;

  /// No description provided for @widgetTrackStreak.
  ///
  /// In pt, this message translates to:
  /// **'Acompanhe sua consistência.'**
  String get widgetTrackStreak;

  /// No description provided for @widgetTrackVolume.
  ///
  /// In pt, this message translates to:
  /// **'Veja quanto esforço você coloca.'**
  String get widgetTrackVolume;

  /// No description provided for @widgetTrackFrequency.
  ///
  /// In pt, this message translates to:
  /// **'Veja com que frequência você treina.'**
  String get widgetTrackFrequency;

  /// No description provided for @widgetTrackPrs.
  ///
  /// In pt, this message translates to:
  /// **'Celebre suas melhores cargas.'**
  String get widgetTrackPrs;

  /// No description provided for @widgetTrackDuration.
  ///
  /// In pt, this message translates to:
  /// **'Saiba quanto duram as sessões.'**
  String get widgetTrackDuration;

  /// No description provided for @widgetNotLogged.
  ///
  /// In pt, this message translates to:
  /// **'Sem registro'**
  String get widgetNotLogged;

  /// No description provided for @widgetCreateTitle.
  ///
  /// In pt, this message translates to:
  /// **'Criar um widget'**
  String get widgetCreateTitle;

  /// No description provided for @widgetCreateSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Escolha o que mostrar na Home.'**
  String get widgetCreateSubtitle;

  /// No description provided for @widgetStyleNumber.
  ///
  /// In pt, this message translates to:
  /// **'Número'**
  String get widgetStyleNumber;

  /// No description provided for @widgetStyleChart.
  ///
  /// In pt, this message translates to:
  /// **'Gráfico'**
  String get widgetStyleChart;

  /// No description provided for @widgetStyleList.
  ///
  /// In pt, this message translates to:
  /// **'Lista'**
  String get widgetStyleList;

  /// No description provided for @widgetStyleCalendar.
  ///
  /// In pt, this message translates to:
  /// **'Calendário'**
  String get widgetStyleCalendar;

  /// No description provided for @widgetRename.
  ///
  /// In pt, this message translates to:
  /// **'Renomear'**
  String get widgetRename;

  /// No description provided for @widgetChangeStyle.
  ///
  /// In pt, this message translates to:
  /// **'Alterar estilo'**
  String get widgetChangeStyle;

  /// No description provided for @widgetChangeSize.
  ///
  /// In pt, this message translates to:
  /// **'Alterar tamanho'**
  String get widgetChangeSize;

  /// No description provided for @widgetNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Nome do widget'**
  String get widgetNameHint;

  /// No description provided for @widgetStyleTitle.
  ///
  /// In pt, this message translates to:
  /// **'Estilo'**
  String get widgetStyleTitle;

  /// No description provided for @widgetApplySize.
  ///
  /// In pt, this message translates to:
  /// **'Aplicar tamanho'**
  String get widgetApplySize;

  /// No description provided for @widgetAddToWorkouts.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar aos treinos'**
  String get widgetAddToWorkouts;

  /// No description provided for @addSheetWorkout.
  ///
  /// In pt, this message translates to:
  /// **'Treino'**
  String get addSheetWorkout;

  /// No description provided for @addSheetWorkoutSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Criar um novo treino'**
  String get addSheetWorkoutSubtitle;

  /// No description provided for @addSheetRoutine.
  ///
  /// In pt, this message translates to:
  /// **'Rotina sob medida'**
  String get addSheetRoutine;

  /// No description provided for @addSheetRoutineSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Receba uma rotina de academia'**
  String get addSheetRoutineSubtitle;

  /// No description provided for @addSheetMetrics.
  ///
  /// In pt, this message translates to:
  /// **'Métricas corporais'**
  String get addSheetMetrics;

  /// No description provided for @addSheetMetricsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Acompanhe mudanças ao longo do tempo'**
  String get addSheetMetricsSubtitle;

  /// No description provided for @addSheetFolder.
  ///
  /// In pt, this message translates to:
  /// **'Pasta'**
  String get addSheetFolder;

  /// No description provided for @addSheetFolderSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Agrupe itens no painel'**
  String get addSheetFolderSubtitle;

  /// No description provided for @addSheetComingSoon.
  ///
  /// In pt, this message translates to:
  /// **'{label} em breve'**
  String addSheetComingSoon(String label);

  /// No description provided for @homeWorkouts.
  ///
  /// In pt, this message translates to:
  /// **'Treinos'**
  String get homeWorkouts;

  /// No description provided for @feedTitle.
  ///
  /// In pt, this message translates to:
  /// **'Feed'**
  String get feedTitle;

  /// No description provided for @feedDiscover.
  ///
  /// In pt, this message translates to:
  /// **'Descobrir'**
  String get feedDiscover;

  /// No description provided for @feedFriends.
  ///
  /// In pt, this message translates to:
  /// **'Amigos'**
  String get feedFriends;

  /// No description provided for @feedLoginRequired.
  ///
  /// In pt, this message translates to:
  /// **'Faça login para ver seus posts.'**
  String get feedLoginRequired;

  /// No description provided for @feedCommentsSoon.
  ///
  /// In pt, this message translates to:
  /// **'Comentários em breve'**
  String get feedCommentsSoon;

  /// No description provided for @messagesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Mensagens'**
  String get messagesTitle;

  /// No description provided for @messagesGeneral.
  ///
  /// In pt, this message translates to:
  /// **'Geral'**
  String get messagesGeneral;

  /// No description provided for @messagesCommunity.
  ///
  /// In pt, this message translates to:
  /// **'Comunidade'**
  String get messagesCommunity;

  /// No description provided for @messagesNewCommunity.
  ///
  /// In pt, this message translates to:
  /// **'Nova comunidade'**
  String get messagesNewCommunity;

  /// No description provided for @messagesSearchHint.
  ///
  /// In pt, this message translates to:
  /// **'Nome de pessoa ou comunidade'**
  String get messagesSearchHint;

  /// No description provided for @messagesMessageHint.
  ///
  /// In pt, this message translates to:
  /// **'Mensagem'**
  String get messagesMessageHint;

  /// No description provided for @messagesMembers.
  ///
  /// In pt, this message translates to:
  /// **'{count} membros'**
  String messagesMembers(int count);

  /// No description provided for @messagesInviteTitle.
  ///
  /// In pt, this message translates to:
  /// **'Convidar para {title}'**
  String messagesInviteTitle(String title);

  /// No description provided for @messagesScan.
  ///
  /// In pt, this message translates to:
  /// **'Escanear'**
  String get messagesScan;

  /// No description provided for @messagesCoachLinkCreated.
  ///
  /// In pt, this message translates to:
  /// **'Vínculo coach criado'**
  String get messagesCoachLinkCreated;

  /// No description provided for @chatTitle.
  ///
  /// In pt, this message translates to:
  /// **'Chat'**
  String get chatTitle;

  /// No description provided for @workoutsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Treinos'**
  String get workoutsTitle;

  /// No description provided for @workoutsStartEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Treino vazio'**
  String get workoutsStartEmpty;

  /// No description provided for @workoutsSavedRoutines.
  ///
  /// In pt, this message translates to:
  /// **'Rotinas salvas'**
  String get workoutsSavedRoutines;

  /// No description provided for @workoutsNoRoutines.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma rotina salva ainda.'**
  String get workoutsNoRoutines;

  /// No description provided for @workoutsExerciseCount.
  ///
  /// In pt, this message translates to:
  /// **'{count} exercícios'**
  String workoutsExerciseCount(int count);

  /// No description provided for @workoutsDurationRange.
  ///
  /// In pt, this message translates to:
  /// **'{low} - {high} min'**
  String workoutsDurationRange(int low, int high);

  /// No description provided for @workoutsNoExercises.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum exercício neste treino ainda.'**
  String get workoutsNoExercises;

  /// No description provided for @workoutsNewRoutine.
  ///
  /// In pt, this message translates to:
  /// **'Nova rotina'**
  String get workoutsNewRoutine;

  /// No description provided for @workoutsExercises.
  ///
  /// In pt, this message translates to:
  /// **'Exercícios'**
  String get workoutsExercises;

  /// No description provided for @workoutsSearchExercise.
  ///
  /// In pt, this message translates to:
  /// **'Buscar exercício'**
  String get workoutsSearchExercise;

  /// No description provided for @workoutsExerciseNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Nome do exercício'**
  String get workoutsExerciseNameHint;

  /// No description provided for @workoutsFolderHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: Treinos manhã'**
  String get workoutsFolderHint;

  /// No description provided for @workoutsInProgress.
  ///
  /// In pt, this message translates to:
  /// **'Em andamento'**
  String get workoutsInProgress;

  /// No description provided for @workoutsDiscardTitle.
  ///
  /// In pt, this message translates to:
  /// **'Descartar treino?'**
  String get workoutsDiscardTitle;

  /// No description provided for @workoutsDiscardBody.
  ///
  /// In pt, this message translates to:
  /// **'Esta ação não pode ser desfeita.'**
  String get workoutsDiscardBody;

  /// No description provided for @workoutsDiscard.
  ///
  /// In pt, this message translates to:
  /// **'Descartar'**
  String get workoutsDiscard;

  /// No description provided for @workoutsFinish.
  ///
  /// In pt, this message translates to:
  /// **'Finalizar'**
  String get workoutsFinish;

  /// No description provided for @workoutsAddSet.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar série'**
  String get workoutsAddSet;

  /// No description provided for @workoutsAddExercise.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar exercício'**
  String get workoutsAddExercise;

  /// No description provided for @workoutsSet.
  ///
  /// In pt, this message translates to:
  /// **'SÉRIE'**
  String get workoutsSet;

  /// No description provided for @workoutsPrevious.
  ///
  /// In pt, this message translates to:
  /// **'ANTERIOR'**
  String get workoutsPrevious;

  /// No description provided for @workoutsKg.
  ///
  /// In pt, this message translates to:
  /// **'KG'**
  String get workoutsKg;

  /// No description provided for @workoutsReps.
  ///
  /// In pt, this message translates to:
  /// **'REPS'**
  String get workoutsReps;

  /// No description provided for @workoutsRest.
  ///
  /// In pt, this message translates to:
  /// **'Descanso: {minutes}m {seconds}s'**
  String workoutsRest(int minutes, int seconds);

  /// No description provided for @workoutsVolume.
  ///
  /// In pt, this message translates to:
  /// **'Volume'**
  String get workoutsVolume;

  /// No description provided for @workoutsSets.
  ///
  /// In pt, this message translates to:
  /// **'Séries'**
  String get workoutsSets;

  /// No description provided for @workoutsDeleted.
  ///
  /// In pt, this message translates to:
  /// **'Treino excluído'**
  String get workoutsDeleted;

  /// No description provided for @workoutsAssignedByCoach.
  ///
  /// In pt, this message translates to:
  /// **'Atribuído pelo coach'**
  String get workoutsAssignedByCoach;

  /// No description provided for @workoutsNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Treino não encontrado'**
  String get workoutsNotFound;

  /// No description provided for @workoutsGetStarted.
  ///
  /// In pt, this message translates to:
  /// **'Deslize para iniciar'**
  String get workoutsGetStarted;

  /// No description provided for @calendarLoginRequired.
  ///
  /// In pt, this message translates to:
  /// **'Faça login para ver o histórico.'**
  String get calendarLoginRequired;

  /// No description provided for @calendarThisWeek.
  ///
  /// In pt, this message translates to:
  /// **'Esta semana'**
  String get calendarThisWeek;

  /// No description provided for @calendarThisMonth.
  ///
  /// In pt, this message translates to:
  /// **'Este mês'**
  String get calendarThisMonth;

  /// No description provided for @calendarWeeklyAvg.
  ///
  /// In pt, this message translates to:
  /// **'Média/sem'**
  String get calendarWeeklyAvg;

  /// No description provided for @profileWorkouts.
  ///
  /// In pt, this message translates to:
  /// **'Treinos'**
  String get profileWorkouts;

  /// No description provided for @profileFollowers.
  ///
  /// In pt, this message translates to:
  /// **'Seguidores'**
  String get profileFollowers;

  /// No description provided for @profileFollowing.
  ///
  /// In pt, this message translates to:
  /// **'Seguindo'**
  String get profileFollowing;

  /// No description provided for @profileShare.
  ///
  /// In pt, this message translates to:
  /// **'Compartilhar perfil'**
  String get profileShare;

  /// No description provided for @profileDuplicate.
  ///
  /// In pt, this message translates to:
  /// **'Duplicar'**
  String get profileDuplicate;

  /// No description provided for @coachTitle.
  ///
  /// In pt, this message translates to:
  /// **'Coach'**
  String get coachTitle;

  /// No description provided for @coachMyStudents.
  ///
  /// In pt, this message translates to:
  /// **'Meus alunos'**
  String get coachMyStudents;

  /// No description provided for @coachGenerateQr.
  ///
  /// In pt, this message translates to:
  /// **'Gerar QR Code'**
  String get coachGenerateQr;

  /// No description provided for @coachGenerateNewQr.
  ///
  /// In pt, this message translates to:
  /// **'Gerar novo QR coach'**
  String get coachGenerateNewQr;

  /// No description provided for @coachGenerateNew.
  ///
  /// In pt, this message translates to:
  /// **'Gerar novo'**
  String get coachGenerateNew;

  /// No description provided for @coachLinkStudent.
  ///
  /// In pt, this message translates to:
  /// **'Vincular aluno'**
  String get coachLinkStudent;

  /// No description provided for @coachScanInvite.
  ///
  /// In pt, this message translates to:
  /// **'Escanear convite'**
  String get coachScanInvite;

  /// No description provided for @coachLinkSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Vínculo criado com sucesso'**
  String get coachLinkSuccess;

  /// No description provided for @coachAssignWorkout.
  ///
  /// In pt, this message translates to:
  /// **'Atribuir treino'**
  String get coachAssignWorkout;

  /// No description provided for @coachAssign.
  ///
  /// In pt, this message translates to:
  /// **'Atribuir'**
  String get coachAssign;

  /// No description provided for @coachAssigned.
  ///
  /// In pt, this message translates to:
  /// **'Treino atribuído'**
  String get coachAssigned;

  /// No description provided for @coachOpenScanner.
  ///
  /// In pt, this message translates to:
  /// **'Abrir scanner'**
  String get coachOpenScanner;

  /// No description provided for @coachStudentNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Aluno não encontrado'**
  String get coachStudentNotFound;

  /// No description provided for @coachWorkoutsCount.
  ///
  /// In pt, this message translates to:
  /// **'{count} treinos'**
  String coachWorkoutsCount(int count);

  /// No description provided for @commonMin.
  ///
  /// In pt, this message translates to:
  /// **'min'**
  String get commonMin;

  /// No description provided for @commonKg.
  ///
  /// In pt, this message translates to:
  /// **'kg'**
  String get commonKg;

  /// No description provided for @addTitle.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar'**
  String get addTitle;

  /// No description provided for @addSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Crie treinos, receba uma rotina sob medida e adicione widgets ao painel.'**
  String get addSubtitle;

  /// No description provided for @addActionCreate.
  ///
  /// In pt, this message translates to:
  /// **'Criar'**
  String get addActionCreate;

  /// No description provided for @addActionGet.
  ///
  /// In pt, this message translates to:
  /// **'Obter'**
  String get addActionGet;

  /// No description provided for @addActionAdd.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar'**
  String get addActionAdd;

  /// No description provided for @emptyWorkoutName.
  ///
  /// In pt, this message translates to:
  /// **'Treino vazio'**
  String get emptyWorkoutName;

  /// No description provided for @widgetNameTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get widgetNameTitle;

  /// No description provided for @widgetNameCustomize.
  ///
  /// In pt, this message translates to:
  /// **'Personalize o nome se quiser'**
  String get widgetNameCustomize;

  /// No description provided for @swipeToDelete.
  ///
  /// In pt, this message translates to:
  /// **'Deslize para excluir >>'**
  String get swipeToDelete;

  /// No description provided for @addNotesHint.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar notas...'**
  String get addNotesHint;

  /// No description provided for @calendarDone.
  ///
  /// In pt, this message translates to:
  /// **'Concluído'**
  String get calendarDone;

  /// No description provided for @calendarPlanned.
  ///
  /// In pt, this message translates to:
  /// **'Previsto'**
  String get calendarPlanned;

  /// No description provided for @calendarEmptyDay.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum treino neste dia'**
  String get calendarEmptyDay;

  /// No description provided for @messagesEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma conversa ainda'**
  String get messagesEmpty;

  /// No description provided for @yesterday.
  ///
  /// In pt, this message translates to:
  /// **'Ontem'**
  String get yesterday;

  /// No description provided for @feedEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum post ainda'**
  String get feedEmpty;

  /// No description provided for @seeAllExercises.
  ///
  /// In pt, this message translates to:
  /// **'Ver todos os exercícios'**
  String get seeAllExercises;

  /// No description provided for @profileRecent.
  ///
  /// In pt, this message translates to:
  /// **'Recentes'**
  String get profileRecent;

  /// No description provided for @coachHistory.
  ///
  /// In pt, this message translates to:
  /// **'Histórico'**
  String get coachHistory;

  /// No description provided for @coachWorkout.
  ///
  /// In pt, this message translates to:
  /// **'Treino do coach'**
  String get coachWorkout;

  /// No description provided for @coachNoStudents.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum aluno vinculado'**
  String get coachNoStudents;

  /// No description provided for @myRoutine.
  ///
  /// In pt, this message translates to:
  /// **'Minha rotina'**
  String get myRoutine;

  /// No description provided for @routine.
  ///
  /// In pt, this message translates to:
  /// **'Rotina'**
  String get routine;

  /// No description provided for @localCatalog.
  ///
  /// In pt, this message translates to:
  /// **'Catálogo local'**
  String get localCatalog;

  /// No description provided for @saving.
  ///
  /// In pt, this message translates to:
  /// **'Salvando…'**
  String get saving;

  /// No description provided for @remove.
  ///
  /// In pt, this message translates to:
  /// **'Remover'**
  String get remove;

  /// No description provided for @routinePresetCustom.
  ///
  /// In pt, this message translates to:
  /// **'Personalizado'**
  String get routinePresetCustom;

  /// No description provided for @routineCreateTitle.
  ///
  /// In pt, this message translates to:
  /// **'Criar um treino'**
  String get routineCreateTitle;

  /// No description provided for @routineCreateSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Vamos ajudar você a escolher os exercícios depois.'**
  String get routineCreateSubtitle;

  /// No description provided for @routineCreateNamedTitle.
  ///
  /// In pt, this message translates to:
  /// **'Criar um treino {name}'**
  String routineCreateNamedTitle(String name);

  /// No description provided for @routinePresetCustomTitle.
  ///
  /// In pt, this message translates to:
  /// **'Criar do zero'**
  String get routinePresetCustomTitle;

  /// No description provided for @routinePresetCustomSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Escolha qualquer combinação de objetivos'**
  String get routinePresetCustomSubtitle;

  /// No description provided for @routinePresetAlreadyExists.
  ///
  /// In pt, this message translates to:
  /// **'{name} já está nos seus treinos'**
  String routinePresetAlreadyExists(String name);

  /// No description provided for @routineNameTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get routineNameTitle;

  /// No description provided for @routineNameSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Personalize o nome se quiser.'**
  String get routineNameSubtitle;

  /// No description provided for @routineNameRequired.
  ///
  /// In pt, this message translates to:
  /// **'Digite um nome para a rotina'**
  String get routineNameRequired;

  /// No description provided for @routineExerciseNoteHint.
  ///
  /// In pt, this message translates to:
  /// **'Escreva qualquer coisa...'**
  String get routineExerciseNoteHint;

  /// No description provided for @routineExerciseSetsHint.
  ///
  /// In pt, this message translates to:
  /// **'Preencha peso e reps de cada série'**
  String get routineExerciseSetsHint;

  /// No description provided for @settingsIntensityTitle.
  ///
  /// In pt, this message translates to:
  /// **'Intensidade das séries'**
  String get settingsIntensityTitle;

  /// No description provided for @settingsIntensityNone.
  ///
  /// In pt, this message translates to:
  /// **'Desativado'**
  String get settingsIntensityNone;

  /// No description provided for @settingsIntensityRpe.
  ///
  /// In pt, this message translates to:
  /// **'RPE'**
  String get settingsIntensityRpe;

  /// No description provided for @settingsIntensityRir.
  ///
  /// In pt, this message translates to:
  /// **'RIR'**
  String get settingsIntensityRir;

  /// No description provided for @settingsIntensitySubtitleNone.
  ///
  /// In pt, this message translates to:
  /// **'Só peso e reps'**
  String get settingsIntensitySubtitleNone;

  /// No description provided for @settingsIntensitySubtitleRpe.
  ///
  /// In pt, this message translates to:
  /// **'Mostrar coluna RPE'**
  String get settingsIntensitySubtitleRpe;

  /// No description provided for @settingsIntensitySubtitleRir.
  ///
  /// In pt, this message translates to:
  /// **'Mostrar coluna RIR'**
  String get settingsIntensitySubtitleRir;

  /// No description provided for @workoutsLb.
  ///
  /// In pt, this message translates to:
  /// **'LB'**
  String get workoutsLb;

  /// No description provided for @workoutsRpe.
  ///
  /// In pt, this message translates to:
  /// **'RPE'**
  String get workoutsRpe;

  /// No description provided for @workoutsRir.
  ///
  /// In pt, this message translates to:
  /// **'RIR'**
  String get workoutsRir;

  /// No description provided for @routineRestTimerLabel.
  ///
  /// In pt, this message translates to:
  /// **'Rest timer: {time}'**
  String routineRestTimerLabel(String time);

  /// No description provided for @routineDefaultRestTitle.
  ///
  /// In pt, this message translates to:
  /// **'Descanso padrão'**
  String get routineDefaultRestTitle;

  /// No description provided for @routinePreferencesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Preferências do treino'**
  String get routinePreferencesTitle;

  /// No description provided for @routineSaved.
  ///
  /// In pt, this message translates to:
  /// **'Rotina salva'**
  String get routineSaved;

  /// No description provided for @routineUpdated.
  ///
  /// In pt, this message translates to:
  /// **'Rotina atualizada'**
  String get routineUpdated;

  /// No description provided for @routineDeleted.
  ///
  /// In pt, this message translates to:
  /// **'Rotina excluída'**
  String get routineDeleted;

  /// No description provided for @routineDeleteConfirmTitle.
  ///
  /// In pt, this message translates to:
  /// **'Excluir rotina?'**
  String get routineDeleteConfirmTitle;

  /// No description provided for @routineDeleteConfirmBody.
  ///
  /// In pt, this message translates to:
  /// **'Isso remove a rotina salva. Treinos anteriores continuam no histórico.'**
  String get routineDeleteConfirmBody;

  /// No description provided for @routineEditName.
  ///
  /// In pt, this message translates to:
  /// **'Editar nome'**
  String get routineEditName;

  /// No description provided for @routineEditSchedule.
  ///
  /// In pt, this message translates to:
  /// **'Editar periodicidade'**
  String get routineEditSchedule;

  /// No description provided for @routineSaveAsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Salvar como rotina?'**
  String get routineSaveAsTitle;

  /// No description provided for @routineSaveAsBody.
  ///
  /// In pt, this message translates to:
  /// **'Guardar estes exercícios como rotina para a próxima vez.'**
  String get routineSaveAsBody;

  /// No description provided for @routineSaveAsConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Salvar rotina'**
  String get routineSaveAsConfirm;

  /// No description provided for @routineSignInRequired.
  ///
  /// In pt, this message translates to:
  /// **'Entre para criar uma rotina'**
  String get routineSignInRequired;

  /// No description provided for @routineAddExercises.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar exercícios'**
  String get routineAddExercises;

  /// No description provided for @routineAddExercisesFirst.
  ///
  /// In pt, this message translates to:
  /// **'Adicione pelo menos um exercício para iniciar'**
  String get routineAddExercisesFirst;

  /// No description provided for @routineBuilderEmptyHint.
  ///
  /// In pt, this message translates to:
  /// **'Monte este treino adicionando alguns exercícios'**
  String get routineBuilderEmptyHint;

  /// No description provided for @routineCustomWorkout.
  ///
  /// In pt, this message translates to:
  /// **'Treino personalizado'**
  String get routineCustomWorkout;

  /// No description provided for @routineStart.
  ///
  /// In pt, this message translates to:
  /// **'Iniciar'**
  String get routineStart;

  /// No description provided for @routineSetCount.
  ///
  /// In pt, this message translates to:
  /// **'{count} séries'**
  String routineSetCount(int count);

  /// No description provided for @routineScheduleNone.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma'**
  String get routineScheduleNone;

  /// No description provided for @routineScheduleWeekdays.
  ///
  /// In pt, this message translates to:
  /// **'Dias'**
  String get routineScheduleWeekdays;

  /// No description provided for @routineScheduleFrequency.
  ///
  /// In pt, this message translates to:
  /// **'Frequência'**
  String get routineScheduleFrequency;

  /// No description provided for @routineScheduleNoneTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sem periodicidade'**
  String get routineScheduleNoneTitle;

  /// No description provided for @routineScheduleNoneBody.
  ///
  /// In pt, this message translates to:
  /// **'Você pode criar esta rotina sem um dia recorrente. Inicie quando quiser.'**
  String get routineScheduleNoneBody;

  /// No description provided for @routineScheduleThis.
  ///
  /// In pt, this message translates to:
  /// **'este'**
  String get routineScheduleThis;

  /// No description provided for @routineScheduleWeekdaysPromptPrefix.
  ///
  /// In pt, this message translates to:
  /// **'Em quais '**
  String get routineScheduleWeekdaysPromptPrefix;

  /// No description provided for @routineScheduleWeekdaysPromptBold.
  ///
  /// In pt, this message translates to:
  /// **'dias da semana'**
  String get routineScheduleWeekdaysPromptBold;

  /// No description provided for @routineScheduleWeekdaysPromptSuffix.
  ///
  /// In pt, this message translates to:
  /// **' você planeja fazer treinos de {name}?'**
  String routineScheduleWeekdaysPromptSuffix(String name);

  /// No description provided for @routineScheduleWeekdaysHint.
  ///
  /// In pt, this message translates to:
  /// **'Escolha os dias para repetir este treino.'**
  String get routineScheduleWeekdaysHint;

  /// No description provided for @routineScheduleWorkOnDays.
  ///
  /// In pt, this message translates to:
  /// **'Treinar nestes dias: {days}'**
  String routineScheduleWorkOnDays(String days);

  /// No description provided for @routineScheduleFrequencyPromptPrefix.
  ///
  /// In pt, this message translates to:
  /// **'Quantos '**
  String get routineScheduleFrequencyPromptPrefix;

  /// No description provided for @routineScheduleFrequencyPromptBold.
  ///
  /// In pt, this message translates to:
  /// **'dias de descanso'**
  String get routineScheduleFrequencyPromptBold;

  /// No description provided for @routineScheduleFrequencyPromptSuffix.
  ///
  /// In pt, this message translates to:
  /// **' você precisa entre treinos de {name}?'**
  String routineScheduleFrequencyPromptSuffix(String name);

  /// No description provided for @routineScheduleWorkPrefix.
  ///
  /// In pt, this message translates to:
  /// **'Treinar '**
  String get routineScheduleWorkPrefix;

  /// No description provided for @routineScheduleEveryDay.
  ///
  /// In pt, this message translates to:
  /// **'todos os dias'**
  String get routineScheduleEveryDay;

  /// No description provided for @routineScheduleEveryNDays.
  ///
  /// In pt, this message translates to:
  /// **'a cada {days} dias'**
  String routineScheduleEveryNDays(int days);

  /// No description provided for @weekdaySunday.
  ///
  /// In pt, this message translates to:
  /// **'Domingo'**
  String get weekdaySunday;

  /// No description provided for @weekdayMonday.
  ///
  /// In pt, this message translates to:
  /// **'Segunda'**
  String get weekdayMonday;

  /// No description provided for @weekdayTuesday.
  ///
  /// In pt, this message translates to:
  /// **'Terça'**
  String get weekdayTuesday;

  /// No description provided for @weekdayWednesday.
  ///
  /// In pt, this message translates to:
  /// **'Quarta'**
  String get weekdayWednesday;

  /// No description provided for @weekdayThursday.
  ///
  /// In pt, this message translates to:
  /// **'Quinta'**
  String get weekdayThursday;

  /// No description provided for @weekdayFriday.
  ///
  /// In pt, this message translates to:
  /// **'Sexta'**
  String get weekdayFriday;

  /// No description provided for @weekdaySaturday.
  ///
  /// In pt, this message translates to:
  /// **'Sábado'**
  String get weekdaySaturday;

  /// No description provided for @setTypeTitle.
  ///
  /// In pt, this message translates to:
  /// **'Tipo de série'**
  String get setTypeTitle;

  /// No description provided for @setTypeWarmUp.
  ///
  /// In pt, this message translates to:
  /// **'Aquecimento'**
  String get setTypeWarmUp;

  /// No description provided for @setTypeWork.
  ///
  /// In pt, this message translates to:
  /// **'Normal'**
  String get setTypeWork;

  /// No description provided for @setTypeFailure.
  ///
  /// In pt, this message translates to:
  /// **'Falha'**
  String get setTypeFailure;

  /// No description provided for @setTypeDrop.
  ///
  /// In pt, this message translates to:
  /// **'Dropset'**
  String get setTypeDrop;

  /// No description provided for @setTypeBackoff.
  ///
  /// In pt, this message translates to:
  /// **'Backoff'**
  String get setTypeBackoff;

  /// No description provided for @calendarScheduledRoutine.
  ///
  /// In pt, this message translates to:
  /// **'Rotina agendada'**
  String get calendarScheduledRoutine;

  /// No description provided for @workoutsRestCountdown.
  ///
  /// In pt, this message translates to:
  /// **'Descanso {minutes}:{seconds}'**
  String workoutsRestCountdown(String minutes, String seconds);

  /// No description provided for @authUsernameAlreadyOwned.
  ///
  /// In pt, this message translates to:
  /// **'Você já possui um @. Não é possível alterá-lo.'**
  String get authUsernameAlreadyOwned;

  /// No description provided for @authUsernameSaveFailed.
  ///
  /// In pt, this message translates to:
  /// **'Este @ já está em uso ou não foi possível salvar.'**
  String get authUsernameSaveFailed;

  /// No description provided for @authUsernameReserveFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível reservar o @. Tente novamente.'**
  String get authUsernameReserveFailed;

  /// No description provided for @authWeakPassword.
  ///
  /// In pt, this message translates to:
  /// **'A senha é muito fraca!'**
  String get authWeakPassword;

  /// No description provided for @authEmailInUse.
  ///
  /// In pt, this message translates to:
  /// **'Este email já está cadastrado'**
  String get authEmailInUse;

  /// No description provided for @authUserNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Email não encontrado. Cadastre-se.'**
  String get authUserNotFound;

  /// No description provided for @authWrongPassword.
  ///
  /// In pt, this message translates to:
  /// **'Senha incorreta. Tente novamente'**
  String get authWrongPassword;

  /// No description provided for @authInvalidCredential.
  ///
  /// In pt, this message translates to:
  /// **'Email ou senha incorretos.'**
  String get authInvalidCredential;

  /// No description provided for @authInvalidEmail.
  ///
  /// In pt, this message translates to:
  /// **'Email inválido'**
  String get authInvalidEmail;

  /// No description provided for @authUserDisabled.
  ///
  /// In pt, this message translates to:
  /// **'Esta conta foi desabilitada.'**
  String get authUserDisabled;

  /// No description provided for @authTooManyRequests.
  ///
  /// In pt, this message translates to:
  /// **'Muitas tentativas. Tente mais tarde.'**
  String get authTooManyRequests;

  /// No description provided for @authNetworkFailed.
  ///
  /// In pt, this message translates to:
  /// **'Sem conexão com a internet. Verifique sua rede e tente novamente.'**
  String get authNetworkFailed;

  /// No description provided for @authAccountExistsDifferent.
  ///
  /// In pt, this message translates to:
  /// **'Já existe uma conta com este email usando outro método de login.'**
  String get authAccountExistsDifferent;

  /// No description provided for @authGenericError.
  ///
  /// In pt, this message translates to:
  /// **'Erro de autenticação. Tente novamente.'**
  String get authGenericError;

  /// No description provided for @authGoogleFailed.
  ///
  /// In pt, this message translates to:
  /// **'Falha no login com Google.'**
  String get authGoogleFailed;

  /// No description provided for @authGoogleCancelled.
  ///
  /// In pt, this message translates to:
  /// **'Login com Google cancelado ou indisponível.'**
  String get authGoogleCancelled;

  /// No description provided for @authAppleFailed.
  ///
  /// In pt, this message translates to:
  /// **'Falha no login com Apple.'**
  String get authAppleFailed;

  /// No description provided for @authAppleUnavailable.
  ///
  /// In pt, this message translates to:
  /// **'Login com Apple indisponível neste dispositivo.'**
  String get authAppleUnavailable;

  /// No description provided for @authAppleTokenFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível obter o token da Apple.'**
  String get authAppleTokenFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
