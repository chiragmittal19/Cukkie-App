import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/router/app_router.dart';
import 'core/services/sensory_service.dart';
import 'core/services/tts_service.dart';
import 'core/theme/app_theme.dart';
import 'data/services/api/auth_service.dart';
import 'data/services/api/content_service.dart';
import 'data/services/api/log_service.dart';
import 'data/services/api/recipe_service.dart';
import 'data/services/http/http_auth_service.dart';
import 'data/services/http/http_content_service.dart';
import 'data/services/http/http_log_service.dart';
import 'data/services/http/http_recipe_service.dart';
import 'data/services/local/local_sql_database_service.dart';
import 'data/services/local/secure_prefs_service.dart';
import 'l10n/generated/app_localizations.dart';
import 'ui/features/auth/view_models/auth_view_model.dart';
import 'ui/features/home/view_models/home_view_model.dart';
import 'ui/features/preferences/view_models/preferences_view_model.dart';
import 'ui/features/recipe/view_models/recipe_view_model.dart';
import 'ui/features/settings/view_models/settings_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local client-isolated databases & preferences
  await SecurePrefsService.instance.init();
  await LocalSqlDatabaseService.instance.init();

  runApp(const CukkieAppRoot());
}

class CukkieAppRoot extends StatefulWidget {
  const CukkieAppRoot({super.key});

  @override
  State<CukkieAppRoot> createState() => _CukkieAppRootState();
}

class _CukkieAppRootState extends State<CukkieAppRoot> {
  late final AuthService _authService;
  late final RecipeService _recipeService;
  late final LogService _logService;
  late final ContentService _contentService;
  late final TtsService _ttsService;

  late final AuthViewModel _authViewModel;
  late final SettingsViewModel _settingsViewModel;

  final _router = createAppRouter();

  @override
  void initState() {
    super.initState();
    // Live Backend Services (Rust microservices)
    _authService = HttpAuthService();
    _recipeService = HttpRecipeService();
    _logService = HttpLogService();
    _contentService = HttpContentService();
    _ttsService = TtsService();

    _authViewModel = AuthViewModel(authService: _authService);
    _settingsViewModel = SettingsViewModel(
      prefsService: SecurePrefsService.instance,
      sensoryService: SensoryService.instance,
      contentService: _contentService,
      ttsService: _ttsService,
    );

    // Initial auth profile fetch
    _authViewModel.loadProfile();
  }

  @override
  void dispose() {
    _authViewModel.dispose();
    _settingsViewModel.dispose();
    _ttsService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider<AuthService>.value(value: _authService),
        Provider<RecipeService>.value(value: _recipeService),
        Provider<LogService>.value(value: _logService),
        Provider<ContentService>.value(value: _contentService),
        ChangeNotifierProvider<TtsService>.value(value: _ttsService),

        // Core ViewModels
        ChangeNotifierProvider<AuthViewModel>.value(value: _authViewModel),
        ChangeNotifierProvider<SettingsViewModel>.value(value: _settingsViewModel),

        // Feature ViewModels
        ChangeNotifierProvider<PreferencesViewModel>(
          create: (_) => PreferencesViewModel(
            authViewModel: _authViewModel,
            settingsViewModel: _settingsViewModel,
            contentService: _contentService,
          ),
        ),
        ChangeNotifierProvider<HomeViewModel>(
          create: (_) => HomeViewModel(
            recipeService: _recipeService,
            authViewModel: _authViewModel,
            settingsViewModel: _settingsViewModel,
          ),
        ),
        ChangeNotifierProvider<RecipeViewModel>(
          create: (_) => RecipeViewModel(
            recipeService: _recipeService,
            ttsService: _ttsService,
            settingsViewModel: _settingsViewModel,
          ),
        ),
      ],
      child: Consumer<SettingsViewModel>(
        builder: (context, settingsVm, _) {
          return MaterialApp.router(
            title: 'Cukkie',
            debugShowCheckedModeBanner: false,
            routerConfig: _router,
            locale: settingsVm.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsVm.themeMode,
          );
        },
      ),
    );
  }
}
