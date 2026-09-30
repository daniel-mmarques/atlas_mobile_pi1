// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Atlas';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsSubtitle => 'Como acompanhar treinos e métricas';

  @override
  String get settingsPreferredUnit => 'Unidade preferida';

  @override
  String get settingsUnitImperial => 'Libras e milhas';

  @override
  String get settingsUnitMetric => 'Quilos e metros';

  @override
  String get settingsAppearance => 'Aparência';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get langPortuguese => 'Português';

  @override
  String get langEnglish => 'English';

  @override
  String get langSpanish => 'Español';

  @override
  String get settingsCoachMode => 'Modo coach';

  @override
  String get settingsCoachActive => 'Ativo — área do coach disponível';

  @override
  String get settingsCoachInactive => 'Desativado';

  @override
  String get settingsCoachArea => 'Área do coach';

  @override
  String get settingsCoachAreaSubtitle => 'Alunos e vínculos';

  @override
  String get settingsLogout => 'Sair';

  @override
  String get settingsLogoutSubtitle => 'Encerrar sessão da conta';

  @override
  String get themeLight => 'Light';

  @override
  String get themeSakura => 'Sakura';

  @override
  String get themeSunset => 'Sunset';

  @override
  String get themeArctic => 'Arctic';

  @override
  String get themeCoffee => 'Coffee';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeOcean => 'Ocean';

  @override
  String get themeCyberpunk => 'Cyberpunk 2077';

  @override
  String get themeStorm => 'Storm';

  @override
  String get themeMidnight => 'Midnight';

  @override
  String get authSetupTitle => 'Vamos configurar\nsua conta';

  @override
  String get authSetupSubtitle =>
      'Entre ou cadastre-se para a melhor experiência de treino';

  @override
  String get authLogin => 'Entrar';

  @override
  String get authRegister => 'Cadastrar';

  @override
  String get authForgotPassword => 'Esqueceu a senha?';

  @override
  String get authForgotPasswordTitle => 'Redefinir senha';

  @override
  String get authForgotPasswordSubtitle =>
      'Informe o email da conta. Enviaremos um link para criar uma nova senha.';

  @override
  String get authForgotPasswordSend => 'Enviar link';

  @override
  String get authForgotPasswordSent =>
      'Se essa conta existir, enviamos um email com o link para redefinir a senha.';

  @override
  String get authForgotPasswordBack => 'Voltar ao login';

  @override
  String get authVerifyTitle => 'Confirme seu email';

  @override
  String authVerifySubtitle(String email) {
    return 'Enviamos um link para $email. Abra o email, clique no link e volte aqui.';
  }

  @override
  String get authVerifyResend => 'Reenviar email';

  @override
  String get authVerifyResent => 'Email reenviado.';

  @override
  String get authVerifyAlreadyDone => 'Já verifiquei';

  @override
  String get authVerifyStillPending =>
      'Ainda não detectamos a confirmação. Abra o link do email e tente de novo.';

  @override
  String get authVerifySignOut => 'Usar outro email';

  @override
  String get authEmailHint => 'Email';

  @override
  String get authPasswordHint => 'Senha';

  @override
  String get authConfirmPasswordHint => 'Confirmar senha';

  @override
  String get authOrContinueWith => 'Ou continue com';

  @override
  String get authGoogle => 'Google';

  @override
  String get authApple => 'Apple';

  @override
  String get authGetStarted => 'Começar';

  @override
  String get authWelcomeSlide => 'Bem-vindo à revolução na forma de treinar';

  @override
  String get onboardingTitle1 => 'Treine com método';

  @override
  String get onboardingSubtitle1 =>
      'Planos estruturados para força, hipertrofia e performance.';

  @override
  String get onboardingTitle2 => 'Acompanhe sua evolução';

  @override
  String get onboardingSubtitle2 =>
      'Registre cargas, séries e veja seu progresso.';

  @override
  String get onboardingTitle3 => 'Constância gera resultado';

  @override
  String get onboardingSubtitle3 => 'Disciplina hoje. Corpo diferente amanhã.';

  @override
  String get signUpStepAccount => 'Conta';

  @override
  String get signUpStepProfile => 'Perfil';

  @override
  String get signUpStepBody => 'Corpo';

  @override
  String get signUpTitleAccount => 'Crie sua conta';

  @override
  String get signUpTitleProfile => 'Seu perfil';

  @override
  String get signUpTitleBody => 'Dados físicos';

  @override
  String get signUpNameHint => 'Nome completo';

  @override
  String get signUpUsernameHint => '@username';

  @override
  String get signUpBirthHint => 'Data de nascimento';

  @override
  String get signUpWeightHint => 'Peso (kg)';

  @override
  String get signUpHeightHint => 'Altura (m)';

  @override
  String get signUpGenderHint => 'Sexo';

  @override
  String get signUpActivityHint => 'Nível de atividade';

  @override
  String get signUpNext => 'Próximo';

  @override
  String get signUpFinish => 'Finalizar';

  @override
  String get signUpBack => 'Voltar';

  @override
  String get genderMale => 'Masculino';

  @override
  String get genderFemale => 'Feminino';

  @override
  String get genderOther => 'Outro';

  @override
  String get activitySedentary => 'Sedentário';

  @override
  String get activityLightly => 'Pouco ativo';

  @override
  String get activityModerately => 'Moderadamente ativo';

  @override
  String get activityVery => 'Muito ativo';

  @override
  String get activityExtremely => 'Extremamente ativo';

  @override
  String get validationNameRequired => 'Informe seu nome';

  @override
  String get validationNameMin => 'O nome precisa ter pelo menos 3 caracteres';

  @override
  String get validationNameMax => 'O nome deve ter no máximo 80 caracteres';

  @override
  String get validationNameInvalid => 'Informe um nome válido';

  @override
  String get validationEmailRequired => 'Informe o email';

  @override
  String get validationEmailInvalid => 'Informe um email válido';

  @override
  String get validationPasswordRequired => 'Informe a senha';

  @override
  String get validationPasswordMin => 'A senha deve ter no mínimo 6 caracteres';

  @override
  String get validationPasswordMax =>
      'A senha deve ter no máximo 72 caracteres';

  @override
  String get validationConfirmRequired => 'Confirme a senha';

  @override
  String get validationConfirmMismatch => 'As senhas não coincidem';

  @override
  String get validationBirthRequired => 'Informe sua data de nascimento';

  @override
  String get validationBirthInvalid => 'Data inválida';

  @override
  String get validationBirthFuture => 'A data não pode ser no futuro';

  @override
  String get validationBirthInvalidRange =>
      'Informe uma data de nascimento válida';

  @override
  String get validationAgeMin => 'Idade mínima é 15 anos';

  @override
  String get validationWeightRequired => 'Informe seu peso';

  @override
  String get validationWeightNumeric => 'Informe um peso numérico';

  @override
  String get validationWeightRange => 'Peso deve estar entre 30 e 300 kg';

  @override
  String get validationHeightRequired => 'Informe sua altura';

  @override
  String get validationHeightNumeric => 'Informe uma altura numérica';

  @override
  String get validationHeightRange => 'Altura deve estar entre 1,00 e 2,50 m';

  @override
  String get validationGenderRequired => 'Selecione o sexo';

  @override
  String get validationActivityRequired => 'Selecione o nível de atividade';

  @override
  String get validationUsernameRequired => 'Informe seu @';

  @override
  String get validationUsernameMin => 'O @ precisa ter pelo menos 3 caracteres';

  @override
  String get validationUsernameMax => 'O @ deve ter no máximo 30 caracteres';

  @override
  String get validationUsernameChars =>
      'Use apenas letras minúsculas, números, . e _';

  @override
  String get validationUsernameInvalid => 'Informe um @ válido';

  @override
  String get validationUsernameTaken => 'Este @ já está em uso.';

  @override
  String get claimUsernameTitle => 'Escolha seu @';

  @override
  String get claimUsernameSave => 'Salvar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get continueAction => 'Continuar';

  @override
  String get delete => 'Excluir';

  @override
  String get edit => 'Editar';

  @override
  String get share => 'Compartilhar';

  @override
  String get copyLink => 'Copiar link';

  @override
  String get linkCopied => 'Link copiado';

  @override
  String get search => 'Buscar';

  @override
  String get notAuthenticated => 'Não autenticado';

  @override
  String get loading => 'Carregando…';

  @override
  String get errorGeneric => 'Algo deu errado';

  @override
  String get widgetStreak => 'Streak';

  @override
  String get widgetVolume => 'Volume';

  @override
  String get widgetFrequency => 'Frequência';

  @override
  String get widgetPrs => 'PRs';

  @override
  String get widgetDuration => 'Duração';

  @override
  String get widgetStreakSubtitle => 'Dias consecutivos treinando';

  @override
  String get widgetVolumeSubtitle => 'Volume total por semana';

  @override
  String get widgetFrequencySubtitle => 'Treinos na semana e no mês';

  @override
  String get widgetPrsSubtitle => 'Melhores cargas recentes';

  @override
  String get widgetDurationSubtitle => 'Tempo médio por treino';

  @override
  String get widgetAddStreak => 'Adicionar streak ao painel';

  @override
  String get widgetAddVolume => 'Adicionar volume semanal ao painel';

  @override
  String get widgetAddFrequency => 'Adicionar frequência ao painel';

  @override
  String get widgetAddPrs => 'Adicionar PRs ao painel';

  @override
  String get widgetAddDuration => 'Adicionar duração ao painel';

  @override
  String get widgetTrackStreak => 'Acompanhe sua consistência.';

  @override
  String get widgetTrackVolume => 'Veja quanto esforço você coloca.';

  @override
  String get widgetTrackFrequency => 'Veja com que frequência você treina.';

  @override
  String get widgetTrackPrs => 'Celebre suas melhores cargas.';

  @override
  String get widgetTrackDuration => 'Saiba quanto duram as sessões.';

  @override
  String get widgetNotLogged => 'Sem registro';

  @override
  String get widgetThisMonth => 'Este mês';

  @override
  String get widgetAvgPerWeek => 'Média/sem';

  @override
  String get widgetWeeklyVolume => 'Volume semanal';

  @override
  String get widgetAvgSession => 'Sessão média';

  @override
  String get widgetDaysStreak => 'dias de sequência';

  @override
  String get widgetDayStreak => 'dia de sequência';

  @override
  String widgetBestStreak(int count) {
    return 'Melhor: $count';
  }

  @override
  String get widgetPersonalRecords => 'Recordes pessoais';

  @override
  String get widgetNoPrsYet => 'Sem PRs ainda';

  @override
  String widgetMonthCount(int count) {
    return '$count este mês';
  }

  @override
  String get widgetCreateTitle => 'Criar um widget';

  @override
  String get widgetCreateSubtitle => 'Escolha o que mostrar na Home.';

  @override
  String get widgetStyleNumber => 'Número';

  @override
  String get widgetStyleChart => 'Gráfico';

  @override
  String get widgetStyleList => 'Lista';

  @override
  String get widgetStyleCalendar => 'Calendário';

  @override
  String get widgetRename => 'Renomear';

  @override
  String get widgetChangeStyle => 'Alterar estilo';

  @override
  String get widgetChangeSize => 'Alterar tamanho';

  @override
  String get widgetNameHint => 'Nome do widget';

  @override
  String get widgetStyleTitle => 'Estilo';

  @override
  String get widgetApplySize => 'Aplicar tamanho';

  @override
  String get widgetAddToWorkouts => 'Adicionar aos treinos';

  @override
  String get addSheetWorkout => 'Treino';

  @override
  String get addSheetWorkoutSubtitle => 'Criar um novo treino';

  @override
  String get addSheetRoutine => 'Rotina sob medida';

  @override
  String get addSheetRoutineSubtitle => 'Receba uma rotina de academia';

  @override
  String get addSheetMetrics => 'Métricas corporais';

  @override
  String get addSheetMetricsSubtitle => 'Acompanhe mudanças ao longo do tempo';

  @override
  String get addSheetFolder => 'Pasta';

  @override
  String get addSheetFolderSubtitle => 'Agrupe itens no painel';

  @override
  String addSheetComingSoon(String label) {
    return '$label em breve';
  }

  @override
  String get homeWorkouts => 'Treinos';

  @override
  String get feedTitle => 'Feed';

  @override
  String get feedDiscover => 'Descobrir';

  @override
  String get feedFriends => 'Amigos';

  @override
  String get feedLoginRequired => 'Faça login para ver seus posts.';

  @override
  String get feedCommentsSoon => 'Comentários em breve';

  @override
  String get messagesTitle => 'Mensagens';

  @override
  String get messagesGeneral => 'Geral';

  @override
  String get messagesCommunity => 'Comunidade';

  @override
  String get messagesNewCommunity => 'Nova comunidade';

  @override
  String get messagesSearchHint => 'Nome de pessoa ou comunidade';

  @override
  String get messagesMessageHint => 'Mensagem';

  @override
  String messagesMembers(int count) {
    return '$count membros';
  }

  @override
  String messagesInviteTitle(String title) {
    return 'Convidar para $title';
  }

  @override
  String get messagesScan => 'Escanear';

  @override
  String get messagesCoachLinkCreated => 'Vínculo coach criado';

  @override
  String get chatTitle => 'Chat';

  @override
  String get workoutsTitle => 'Rotinas';

  @override
  String get workoutsStartEmpty => 'Treino vazio';

  @override
  String get workoutsSavedRoutines => 'Rotinas salvas';

  @override
  String get workoutsNoRoutines => 'Nenhuma rotina salva ainda.';

  @override
  String workoutsExerciseCount(int count) {
    return '$count exercícios';
  }

  @override
  String workoutsDurationRange(int low, int high) {
    return '$low - $high min';
  }

  @override
  String get workoutsNoExercises => 'Nenhum exercício neste treino ainda.';

  @override
  String get workoutsNewRoutine => 'Nova rotina';

  @override
  String get workoutsExercises => 'Exercícios';

  @override
  String get workoutsSearchExercise => 'Buscar exercício';

  @override
  String get workoutsExerciseNameHint => 'Nome do exercício';

  @override
  String get workoutsFolderHint => 'Ex.: Treinos manhã';

  @override
  String get workoutsInProgress => 'Em andamento';

  @override
  String get workoutsDiscardTitle => 'Descartar treino?';

  @override
  String get workoutsDiscardBody => 'Esta ação não pode ser desfeita.';

  @override
  String get workoutsDiscard => 'Descartar';

  @override
  String get workoutsFinish => 'Finalizar';

  @override
  String get workoutsAddSet => 'Adicionar série';

  @override
  String get workoutsAddExercise => 'Adicionar exercício';

  @override
  String get workoutsSet => 'SÉRIE';

  @override
  String get workoutsPrevious => 'ANTERIOR';

  @override
  String get workoutsKg => 'KG';

  @override
  String get workoutsReps => 'REPS';

  @override
  String workoutsRest(int minutes, int seconds) {
    return 'Descanso: ${minutes}m ${seconds}s';
  }

  @override
  String get workoutsVolume => 'Volume';

  @override
  String get workoutsSets => 'Séries';

  @override
  String get workoutsDeleted => 'Treino excluído';

  @override
  String get workoutsAssignedByCoach => 'Atribuído pelo coach';

  @override
  String get workoutsNotFound => 'Treino não encontrado';

  @override
  String get workoutsGetStarted => 'Deslize para iniciar';

  @override
  String get calendarLoginRequired => 'Faça login para ver o histórico.';

  @override
  String get calendarThisWeek => 'Esta semana';

  @override
  String get calendarThisMonth => 'Este mês';

  @override
  String get calendarWeeklyAvg => 'Média/sem';

  @override
  String get profileWorkouts => 'Treinos';

  @override
  String get profileFollowers => 'Seguidores';

  @override
  String get profileFollowing => 'Seguindo';

  @override
  String get profileShare => 'Compartilhar perfil';

  @override
  String get profileDuplicate => 'Duplicar';

  @override
  String get profileFollow => 'Seguir';

  @override
  String get profileCustomizeBanner => 'Personalizar capa';

  @override
  String get profileChoosePhoto => 'Escolher foto';

  @override
  String get profileBannerPresets => 'Cores';

  @override
  String get profileClearPhoto => 'Remover foto';

  @override
  String get profileBannerUpdated => 'Capa atualizada';

  @override
  String get profileBannerError => 'Não foi possível atualizar a capa';

  @override
  String get profileEditTitle => 'Editar perfil';

  @override
  String get profileEditSave => 'Salvar';

  @override
  String get profileEditPhoto => 'Alterar foto';

  @override
  String get profileEditSaved => 'Perfil atualizado';

  @override
  String get profileEditError => 'Não foi possível salvar o perfil';

  @override
  String get coachTitle => 'Coach';

  @override
  String get coachMyStudents => 'Meus alunos';

  @override
  String get coachGenerateQr => 'Gerar QR Code';

  @override
  String get coachGenerateNewQr => 'Gerar novo QR coach';

  @override
  String get coachGenerateNew => 'Gerar novo';

  @override
  String get coachLinkStudent => 'Vincular aluno';

  @override
  String get coachScanInvite => 'Escanear convite';

  @override
  String get coachLinkSuccess => 'Vínculo criado com sucesso';

  @override
  String get coachAssignWorkout => 'Atribuir treino';

  @override
  String get coachAssign => 'Atribuir';

  @override
  String get coachAssigned => 'Treino atribuído';

  @override
  String get coachOpenScanner => 'Abrir scanner';

  @override
  String get coachStudentNotFound => 'Aluno não encontrado';

  @override
  String coachWorkoutsCount(int count) {
    return '$count treinos';
  }

  @override
  String get commonMin => 'min';

  @override
  String get commonKg => 'kg';

  @override
  String get addTitle => 'Adicionar';

  @override
  String get addSubtitle =>
      'Crie treinos, receba uma rotina sob medida e adicione widgets ao painel.';

  @override
  String get addActionCreate => 'Criar';

  @override
  String get addActionGet => 'Obter';

  @override
  String get addActionAdd => 'Adicionar';

  @override
  String get emptyWorkoutName => 'Treino vazio';

  @override
  String get widgetNameTitle => 'Nome';

  @override
  String get widgetNameCustomize => 'Personalize o nome se quiser';

  @override
  String get swipeToDelete => 'Deslize para excluir >>';

  @override
  String get addNotesHint => 'Adicionar notas...';

  @override
  String get calendarDone => 'Concluído';

  @override
  String get calendarPlanned => 'Previsto';

  @override
  String get calendarEmptyDay => 'Nenhum treino neste dia';

  @override
  String get messagesEmpty => 'Nenhuma conversa ainda';

  @override
  String get yesterday => 'Ontem';

  @override
  String get feedEmpty => 'Nenhum post ainda';

  @override
  String get seeAllExercises => 'Ver todos os exercícios';

  @override
  String get profileRecent => 'Recentes';

  @override
  String get coachHistory => 'Histórico';

  @override
  String get coachWorkout => 'Treino do coach';

  @override
  String get coachNoStudents => 'Nenhum aluno vinculado';

  @override
  String get myRoutine => 'Minha rotina';

  @override
  String get routine => 'Rotina';

  @override
  String get localCatalog => 'Catálogo local';

  @override
  String get saving => 'Salvando…';

  @override
  String get remove => 'Remover';

  @override
  String get routinePresetCustom => 'Personalizado';

  @override
  String get routineCreateTitle => 'Criar um treino';

  @override
  String get routineCreateSubtitle =>
      'Vamos ajudar você a escolher os exercícios depois.';

  @override
  String routineCreateNamedTitle(String name) {
    return 'Criar um treino $name';
  }

  @override
  String get routinePresetCustomTitle => 'Criar do zero';

  @override
  String get routinePresetCustomSubtitle =>
      'Escolha qualquer combinação de objetivos';

  @override
  String routinePresetAlreadyExists(String name) {
    return '$name já está nos seus treinos';
  }

  @override
  String get routineNameTitle => 'Nome';

  @override
  String get routineNameSubtitle => 'Personalize o nome se quiser.';

  @override
  String get routineNameRequired => 'Digite um nome para a rotina';

  @override
  String get routineExerciseNoteHint => 'Escreva qualquer coisa...';

  @override
  String get routineExerciseSetsHint => 'Preencha peso e reps de cada série';

  @override
  String get settingsIntensityTitle => 'Intensidade das séries';

  @override
  String get settingsIntensityNone => 'Desativado';

  @override
  String get settingsIntensityRpe => 'RPE';

  @override
  String get settingsIntensityRir => 'RIR';

  @override
  String get settingsIntensitySubtitleNone => 'Só peso e reps';

  @override
  String get settingsIntensitySubtitleRpe => 'Mostrar coluna RPE';

  @override
  String get settingsIntensitySubtitleRir => 'Mostrar coluna RIR';

  @override
  String get workoutsLb => 'LB';

  @override
  String get workoutsRpe => 'RPE';

  @override
  String get workoutsRir => 'RIR';

  @override
  String routineRestTimerLabel(String time) {
    return 'Rest timer: $time';
  }

  @override
  String get routineDefaultRestTitle => 'Descanso padrão';

  @override
  String get routinePreferencesTitle => 'Preferências do treino';

  @override
  String get routineSaved => 'Rotina salva';

  @override
  String get routineUpdated => 'Rotina atualizada';

  @override
  String get routineDeleted => 'Rotina excluída';

  @override
  String get routineDeleteConfirmTitle => 'Excluir rotina?';

  @override
  String get routineDeleteConfirmBody =>
      'Isso remove a rotina salva. Treinos anteriores continuam no histórico.';

  @override
  String get routineEditName => 'Editar nome';

  @override
  String get routineEditSchedule => 'Editar periodicidade';

  @override
  String get routineSaveAsTitle => 'Salvar como rotina?';

  @override
  String get routineSaveAsBody =>
      'Guardar estes exercícios como rotina para a próxima vez.';

  @override
  String get routineSaveAsConfirm => 'Salvar rotina';

  @override
  String get routineSignInRequired => 'Entre para criar uma rotina';

  @override
  String get routineAddExercises => 'Adicionar exercícios';

  @override
  String get routineAddExercisesFirst =>
      'Adicione pelo menos um exercício para iniciar';

  @override
  String get routineBuilderEmptyHint =>
      'Monte este treino adicionando alguns exercícios';

  @override
  String get routineCustomWorkout => 'Treino personalizado';

  @override
  String get routineStart => 'Iniciar';

  @override
  String routineSetCount(int count) {
    return '$count séries';
  }

  @override
  String get routineScheduleNone => 'Nenhuma';

  @override
  String get routineScheduleWeekdays => 'Dias';

  @override
  String get routineScheduleFrequency => 'Frequência';

  @override
  String get routineScheduleNoneTitle => 'Sem periodicidade';

  @override
  String get routineScheduleNoneBody =>
      'Você pode criar esta rotina sem um dia recorrente. Inicie quando quiser.';

  @override
  String get routineScheduleThis => 'este';

  @override
  String get routineScheduleWeekdaysPromptPrefix => 'Em quais ';

  @override
  String get routineScheduleWeekdaysPromptBold => 'dias da semana';

  @override
  String routineScheduleWeekdaysPromptSuffix(String name) {
    return ' você planeja fazer treinos de $name?';
  }

  @override
  String get routineScheduleWeekdaysHint =>
      'Escolha os dias para repetir este treino.';

  @override
  String routineScheduleWorkOnDays(String days) {
    return 'Treinar nestes dias: $days';
  }

  @override
  String get routineScheduleFrequencyPromptPrefix => 'Quantos ';

  @override
  String get routineScheduleFrequencyPromptBold => 'dias de descanso';

  @override
  String routineScheduleFrequencyPromptSuffix(String name) {
    return ' você precisa entre treinos de $name?';
  }

  @override
  String get routineScheduleWorkPrefix => 'Treinar ';

  @override
  String get routineScheduleEveryDay => 'todos os dias';

  @override
  String routineScheduleEveryNDays(int days) {
    return 'a cada $days dias';
  }

  @override
  String get weekdaySunday => 'Domingo';

  @override
  String get weekdayMonday => 'Segunda';

  @override
  String get weekdayTuesday => 'Terça';

  @override
  String get weekdayWednesday => 'Quarta';

  @override
  String get weekdayThursday => 'Quinta';

  @override
  String get weekdayFriday => 'Sexta';

  @override
  String get weekdaySaturday => 'Sábado';

  @override
  String get setTypeTitle => 'Tipo de série';

  @override
  String get setTypeWarmUp => 'Aquecimento';

  @override
  String get setTypeWork => 'Normal';

  @override
  String get setTypeFailure => 'Falha';

  @override
  String get setTypeDrop => 'Dropset';

  @override
  String get setTypeBackoff => 'Backoff';

  @override
  String get calendarScheduledRoutine => 'Rotina agendada';

  @override
  String workoutsRestCountdown(String minutes, String seconds) {
    return 'Descanso $minutes:$seconds';
  }

  @override
  String get authUsernameAlreadyOwned =>
      'Você já possui um @. Não é possível alterá-lo.';

  @override
  String get authUsernameSaveFailed =>
      'Este @ já está em uso ou não foi possível salvar.';

  @override
  String get authUsernameReserveFailed =>
      'Não foi possível reservar o @. Tente novamente.';

  @override
  String get authWeakPassword => 'A senha é muito fraca!';

  @override
  String get authEmailInUse => 'Este email já está cadastrado';

  @override
  String get authUserNotFound => 'Email não encontrado. Cadastre-se.';

  @override
  String get authWrongPassword => 'Senha incorreta. Tente novamente';

  @override
  String get authInvalidCredential => 'Email ou senha incorretos.';

  @override
  String get authInvalidEmail => 'Email inválido';

  @override
  String get authUserDisabled => 'Esta conta foi desabilitada.';

  @override
  String get authTooManyRequests => 'Muitas tentativas. Tente mais tarde.';

  @override
  String get authNetworkFailed =>
      'Sem conexão com a internet. Verifique sua rede e tente novamente.';

  @override
  String get authAccountExistsDifferent =>
      'Já existe uma conta com este email usando outro método de login.';

  @override
  String get authGenericError => 'Erro de autenticação. Tente novamente.';

  @override
  String get authGoogleFailed => 'Falha no login com Google.';

  @override
  String get authGoogleCancelled =>
      'Login com Google cancelado ou indisponível.';

  @override
  String get authAppleFailed => 'Falha no login com Apple.';

  @override
  String get authAppleUnavailable =>
      'Login com Apple indisponível neste dispositivo.';

  @override
  String get authAppleTokenFailed => 'Não foi possível obter o token da Apple.';
}
