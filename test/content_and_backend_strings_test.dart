import 'package:cukkie/data/models/app_strings_model.dart';
import 'package:cukkie/data/services/mock/mock_content_service.dart';
import 'package:cukkie/data/services/mock/mock_recipe_service.dart';
import 'package:cukkie/data/services/mock/mock_auth_service.dart';
import 'package:cukkie/data/services/local/secure_prefs_service.dart';
import 'package:cukkie/ui/features/auth/view_models/auth_view_model.dart';
import 'package:cukkie/ui/features/home/view_models/home_view_model.dart';
import 'package:cukkie/ui/features/recipe/view_models/recipe_view_model.dart';
import 'package:cukkie/ui/features/settings/view_models/settings_view_model.dart';
import 'package:cukkie/core/services/tts_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeTtsService extends TtsService {
  @override
  Future<void> speak(String text) async {}
  @override
  Future<void> stop() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Backend Content & Dynamic Strings Tests', () {
    late MockContentService contentService;
    late SecurePrefsService prefsService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      contentService = MockContentService();
      prefsService = SecurePrefsService.instance;
      await prefsService.init();
    });

    test('MockContentService provides strings for en, hi, and ar locales', () async {
      final enStrings = await contentService.getAppStrings('en');
      final hiStrings = await contentService.getAppStrings('hi');
      final arStrings = await contentService.getAppStrings('ar');

      expect(enStrings.appName, 'Cukkie');
      expect(enStrings.searchHint, 'Search dishes, ingredients, cuisines...');
      
      expect(hiStrings.appName, 'कुकी (Cukkie)');
      expect(hiStrings.searchHint, 'व्यंजन, सामग्री, भोजन शैली खोजें...');

      expect(arStrings.appName, 'كوكي (Cukkie)');
      expect(arStrings.searchHint, 'ابحث عن الأطباق والمكونات...');
    });

    test('AppStringsModel interpolation formatters work dynamically', () {
      final strings = AppStringsModel({
        'resumeAt': 'Resume at: {stepHeading}',
        'scaledFor': 'Scaled for {portion} {unit}',
        'stepProgress': 'Step {step} of {total}',
      });

      expect(strings.resumeAt('Prep Paneer'), 'Resume at: Prep Paneer');
      expect(strings.scaledFor(4, 'servings'), 'Scaled for 4 servings');
      expect(strings.stepProgress(2, 5), 'Step 2 of 5');
    });

    test('AppStringsModel returns fallback when key is absent', () {
      final strings = AppStringsModel({});
      expect(strings.get('nonExistentKey', 'Fallback Value'), 'Fallback Value');
      expect(strings.appName, 'Cukkie');
      expect(strings.resumeAt('Prep Paneer'), 'Resume at: Prep Paneer');
    });

    test('PreferencesConfigModel parses backend groups and options', () async {
      final config = await contentService.getPreferencesConfig('en');

      expect(config.groups.isNotEmpty, true);
      expect(config.groups.any((g) => g.id == 'cuisines'), true);
      expect(config.groups.any((g) => g.id == 'dietary'), true);
      expect(config.groups.any((g) => g.id == 'spice'), true);

      final cuisines = config.groups.firstWhere((g) => g.id == 'cuisines');
      expect(cuisines.isMultiSelect, true);
      expect(cuisines.options.any((opt) => opt.id == 'North Indian'), true);
    });

    test('SettingsViewModel updates backend strings when language changes', () async {
      final settingsVm = SettingsViewModel(
        prefsService: prefsService,
        contentService: contentService,
      );

      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 100));
      expect(settingsVm.locale.languageCode, 'en');
      expect(settingsVm.strings.searchHint, 'Search dishes, ingredients, cuisines...');

      await settingsVm.setLanguage('hi');
      expect(settingsVm.locale.languageCode, 'hi');
      expect(settingsVm.strings.searchHint, 'व्यंजन, सामग्री, भोजन शैली खोजें...');

      await settingsVm.setLanguage('ar');
      expect(settingsVm.locale.languageCode, 'ar');
      expect(settingsVm.strings.searchHint, 'ابحث عن الأطباق والمكونات...');
      expect(settingsVm.isRtl, true);
    });

    test('MockRecipeService delivers fully localized content based on language header', () async {
      final recipeService = MockRecipeService(prefsService: prefsService);

      // 1. English
      await prefsService.setLanguageCode('en');
      final enHome = await recipeService.getHomePageData();
      expect(enHome.headerTitle, 'Cukkie Recipes');
      expect(enHome.searchBarHint, 'Search dishes, cuisines, ingredients...');
      expect(enHome.dishes.first.name, 'Paneer Butter Masala');
      expect(enHome.dishes.firstWhere((d) => d.id == 'dish_paratha').name, 'Aloo Gobi Paratha');

      final enDetail = await recipeService.getDishDetail('dish_paratha');
      expect(enDetail.name, 'Aloo Gobi Paratha');
      expect(enDetail.steps.first.heading, 'Dish Overview');
      expect(enDetail.steps[1].heading, 'Portion Size');

      // 2. Hindi
      await prefsService.setLanguageCode('hi');
      final hiHome = await recipeService.getHomePageData();
      expect(hiHome.headerTitle, 'कुक्की रेसिपीज़');
      expect(hiHome.searchBarHint, 'व्यंजन, सामग्री, भोजन शैली खोजें...');
      expect(hiHome.dishes.first.name, 'पनीर बटर मसाला');
      expect(hiHome.dishes.firstWhere((d) => d.id == 'dish_paratha').name, 'आलू गोभी परांठा');

      final hiDetail = await recipeService.getDishDetail('dish_paratha');
      expect(hiDetail.name, 'आलू गोभी परांठा');
      expect(hiDetail.steps.first.heading, 'व्यंजन का परिचय');
      expect(hiDetail.steps[1].heading, 'भाग का आकार चुनें');
      expect(hiDetail.ingredients.first.name, 'गेहूं का आटा');

      final hiDrawer = await recipeService.getDrawerConfig();
      expect(hiDrawer.items.any((item) => item.id == 'settings' && item.title == 'सेटिंग्स'), true);

      // 3. Arabic
      await prefsService.setLanguageCode('ar');
      final arHome = await recipeService.getHomePageData();
      expect(arHome.headerTitle, 'وصفات كوكي');
      expect(arHome.searchBarHint, 'ابحث عن أطباق، مطابخ، مكونات...');
      expect(arHome.dishes.first.name, 'بانير زبدة ماسالا');
      expect(arHome.dishes.firstWhere((d) => d.id == 'dish_paratha').name, 'باراثا البطاطس والقرنبيط');

      final arDetail = await recipeService.getDishDetail('dish_paratha');
      expect(arDetail.name, 'باراثا البطاطس والقرنبيط');
      expect(arDetail.steps.first.heading, 'نظرة عامة على الطبق');
      expect(arDetail.steps[1].heading, 'تحديد عدد الحصص');
      expect(arDetail.ingredients.first.name, 'طحين القمح الكامل');

      final arDrawer = await recipeService.getDrawerConfig();
      expect(arDrawer.items.any((item) => item.id == 'settings' && item.title == 'الإعدادات'), true);
    });

    test('HomeViewModel and RecipeViewModel automatically react to language changes', () async {
      final recipeService = MockRecipeService(prefsService: prefsService);
      final authService = MockAuthService();
      final authVm = AuthViewModel(authService: authService);
      final fakeTts = _FakeTtsService();
      final settingsVm = SettingsViewModel(
        prefsService: prefsService,
        contentService: contentService,
      );
      await settingsVm.setLanguage('en');

      final homeVm = HomeViewModel(
        recipeService: recipeService,
        authViewModel: authVm,
        settingsViewModel: settingsVm,
      );
      await homeVm.loadHomePageData();
      await homeVm.loadDrawerConfig();

      expect(homeVm.homePayload?.headerTitle, 'Cukkie Recipes');
      expect(homeVm.drawerPayload?.items.any((item) => item.id == 'settings' && item.title == 'Settings'), true);

      final recipeVm = RecipeViewModel(
        recipeService: recipeService,
        ttsService: fakeTts,
        settingsViewModel: settingsVm,
      );
      await recipeVm.loadRecipe('dish_paratha');
      expect(recipeVm.dish?.name, 'Aloo Gobi Paratha');

      // Now switch language to Hindi via settingsVm
      await settingsVm.setLanguage('hi');

      // Allow async listeners to settle
      await Future.delayed(const Duration(milliseconds: 500));

      expect(homeVm.homePayload?.headerTitle, 'कुक्की रेसिपीज़');
      expect(homeVm.homePayload?.dishes.first.name, 'पनीर बटर मसाला');
      expect(homeVm.drawerPayload?.items.any((item) => item.id == 'settings' && item.title == 'सेटिंग्स'), true);
      expect(recipeVm.dish?.name, 'आलू गोभी परांठा');
      expect(recipeVm.dish?.steps.first.heading, 'व्यंजन का परिचय');

      // Now switch language to Arabic via settingsVm
      await settingsVm.setLanguage('ar');
      await Future.delayed(const Duration(milliseconds: 500));

      expect(homeVm.homePayload?.headerTitle, 'وصفات كوكي');
      expect(homeVm.homePayload?.dishes.first.name, 'بانير زبدة ماسالا');
      expect(homeVm.drawerPayload?.items.any((item) => item.id == 'settings' && item.title == 'الإعدادات'), true);
      expect(recipeVm.dish?.name, 'باراثا البطاطس والقرنبيط');

      homeVm.dispose();
      recipeVm.dispose();
      authVm.dispose();
    });


    test('TtsService instance initializes and sets language tags gracefully', () async {
      final tts = TtsService();
      // Verifies fallback/accent logic executes safely without unhandled exceptions
      await tts.setLanguage('en');
      await tts.setLanguage('hi');
      await tts.setLanguage('ar');
    });

  });
}
