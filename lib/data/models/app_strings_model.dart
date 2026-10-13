class AppStringsModel {
  const AppStringsModel(this._map);

  final Map<String, String> _map;

  String get(String key, [String fallback = '']) => _map[key] ?? fallback;

  // App Name
  String get appName => get('appName', 'Cukkie');

  // Onboarding & Language
  String get welcomeTitle => get('welcomeTitle', 'Discover Delicious Recipes');
  String get welcomeSubtitle => get('welcomeSubtitle', 'Cook step-by-step with real-time portions, audio narration, and curated culinary secrets.');
  String get selectLanguage => get('selectLanguage', 'Select Language');
  String get continueButton => get('continueButton', 'Continue');
  String get skip => get('skip', 'Skip');
  String get next => get('next', 'Next');
  String get previous => get('previous', 'Previous');
  String get finish => get('finish', 'Finish');
  String get share => get('share', 'Share');
  String get exit => get('exit', 'Exit');
  String get choosePhotoSource => get('choosePhotoSource', 'Upload Dish Photo');
  String get camera => get('camera', 'Camera');
  String get gallery => get('gallery', 'Gallery');

  // Authentication
  String get loginTitle => get('loginTitle', 'Enter Your Phone Number');
  String get loginSubtitle => get('loginSubtitle', 'We will send an OTP verification code to log you in.');
  String get phoneNumberHint => get('phoneNumberHint', 'Phone Number (e.g. +91 98765 43210)');
  String get sendOtp => get('sendOtp', 'Send Verification Code');
  String get enterOtp => get('enterOtp', 'Enter 4-Digit Code');
  String get verifyAndProceed => get('verifyAndProceed', 'Verify & Proceed');
  String get resendCode => get('resendCode', 'Resend Code');

  // Food Preferences
  String get preferencesTitle => get('preferencesTitle', 'Your Food Preferences');
  String get preferencesSubtitle => get('preferencesSubtitle', 'Personalize recommendations based on what you love to cook and eat.');
  String get cuisines => get('cuisines', 'Cuisines');
  String get dietaryChoices => get('dietaryChoices', 'Dietary Preferences');
  String get spiceLevel => get('spiceLevel', 'Spice Preference');
  String get sweetnessLevel => get('sweetnessLevel', 'Sweetness Preference');
  String get savePreferences => get('savePreferences', 'Save Preferences');

  // Home & Feed
  String get searchHint => get('searchHint', 'Search dishes, ingredients, cuisines...');
  String get unfinishedRecipes => get('unfinishedRecipes', 'Resume Cooking');
  String resumeAt(String stepHeading) {
    final template = get('resumeAt', 'Resume at: {stepHeading}');
    return template.replaceAll('{stepHeading}', stepHeading);
  }
  String get favouriteAdded => get('favouriteAdded', 'Added to Favourites');
  String get favouriteRemoved => get('favouriteRemoved', 'Removed from Favourites');
  String get loginRequiredForFavourite => get('loginRequiredForFavourite', 'Please log in to save recipes to your favourites');
  String get noDishesFound => get('noDishesFound', 'No dishes found');
  String get noDishesSubtitle => get('noDishesSubtitle', 'Try adjusting your search or resetting filters to explore recipes.');
  String get resetAllFilters => get('resetAllFilters', 'Reset All Filters');
  String get dismiss => get('dismiss', 'Dismiss');
  String get filtersAndSorting => get('filtersAndSorting', 'Filters & Sorting');
  String get resetAll => get('resetAll', 'Reset All');
  String get sortBy => get('sortBy', 'Sort By');
  String get applyFilters => get('applyFilters', 'Apply Filters');

  // Cooking Flow
  String get portionSize => get('portionSize', 'Portion Size');
  String get portionSubtitle => get('portionSubtitle', 'Adjust portions to automatically scale all ingredient measurements');
  String get choosePortionSize => get('choosePortionSize', 'Choose Your Portion Size');
  String get portionInstructions => get('portionInstructions', 'Whether cooking just for yourself or hosting a feast, adjust the portion size below. All ingredient measurements will scale automatically.');
  String get quantityToPrepare => get('quantityToPrepare', 'Quantity to Prepare');
  String get portionTip => get('portionTip', 'You can navigate back to this step at any point during cooking to recalibrate portion sizes.');
  String get ingredients => get('ingredients', 'Ingredients Required');
  String get ingredientsSubtitle => get('ingredientsSubtitle', 'Check off what you have ready before cooking');
  String get miseEnPlace => get('miseEnPlace', 'Mise en Place (Prep)');
  String scaledFor(dynamic portion, String unit) {
    final template = get('scaledFor', 'Scaled for {portion} {unit}');
    return template.replaceAll('{portion}', portion.toString()).replaceAll('{unit}', unit);
  }
  String get ingredientsChecklistInstructions => get('ingredientsChecklistInstructions', 'Check off each ingredient as you assemble it on your countertop. Proper prep leads to effortless culinary excellence.');
  String get optional => get('optional', 'Optional');
  String get nutritionFacts => get('nutritionFacts', 'Nutritional Facts');
  String get aboutThisDish => get('aboutThisDish', 'About this Dish');
  String get culinaryHeritage => get('culinaryHeritage', 'Culinary Heritage & Story');
  String get nutritionalProfile => get('nutritionalProfile', 'Nutritional Profile (per portion)');
  String get actionChecklist => get('actionChecklist', 'Action Checklist');
  String stepProgress(int step, int total) {
    final template = get('stepProgress', 'Step {step} of {total}');
    return template.replaceAll('{step}', step.toString()).replaceAll('{total}', total.toString());
  }
  String get tasteAndFeedback => get('tasteAndFeedback', 'Tasting & Feedback');
  String get tastingFeedbackSubtitle => get('tastingFeedbackSubtitle', 'Rate and review your culinary masterpiece');
  String get tastingFeedbackInstructions => get('tastingFeedbackInstructions', 'Plate your dish, take a warm bite, and tell us how your cooking turned out!');
  String get submitFeedback => get('submitFeedback', 'Submit Feedback & Complete');
  String get feedbackValidationWarning => get('feedbackValidationWarning', 'Please complete all required fields.');
  String get feedbackSuccessMessage => get('feedbackSuccessMessage', 'Feedback submitted! Recipe complete.');
  String get bonAppetit => get('bonAppetit', 'Bon Appétit!');
  String get recipeCompleteMessage => get('recipeCompleteMessage', 'Your feedback was successfully submitted and your cooking session is complete. Great job, Chef!');
  String get returnToHome => get('returnToHome', 'Return to Home');
  String get photoAttached => get('photoAttached', 'Photo Attached ✓');
  String get tapToCapturePhoto => get('tapToCapturePhoto', 'Tap to capture / upload dish photo');

  // Navigation & Drawer
  String get profile => get('profile', 'Profile');
  String get favourites => get('favourites', 'Favourites');
  String get settings => get('settings', 'Settings');
  String get theme => get('theme', 'Theme');
  String get darkMode => get('darkMode', 'Dark Mode');
  String get lightMode => get('lightMode', 'Light Mode');
  String get systemMode => get('systemMode', 'Device Default');
  String get soundEffects => get('soundEffects', 'Sound Effects & Haptics');
  String get tactileHaptic => get('tactileHaptic', 'Tactile Haptic Feedback');
  String get tactileHapticSubtitle => get('tactileHapticSubtitle', 'Vibrations on step completion & actions');
  String get soundAudio => get('soundAudio', 'Cooking Audio & Narration');
  String get soundAudioSubtitle => get('soundAudioSubtitle', 'Speech synthesis and step audio cues');
  String get langStoredLocally => get('langStoredLocally', 'Language preferences are stored directly on your device.');
  String get logout => get('logout', 'Log Out');
  String get logoutConfirmTitle => get('logoutConfirmTitle', 'Log out from Cukkie?');
  String get logoutConfirmMessage => get('logoutConfirmMessage', 'You can always log back in with your phone number to access your saved preferences and favourites.');
  String get cancel => get('cancel', 'Cancel');
  String get welcomeToCukkie => get('welcomeToCukkie', 'Welcome to Cukkie');
  String get viewProfileAndPreferences => get('viewProfileAndPreferences', 'View Profile & Preferences');
  String get loginToSyncFavourites => get('loginToSyncFavourites', 'Log in to sync your favourites');
  String get login => get('login', 'Log In');
  String get english => get('english', 'English');
  String get hindi => get('hindi', 'हिन्दी (Hindi)');
  String get arabic => get('arabic', 'العربية (Arabic)');
  String get unit => get('unit', 'Unit');

  Map<String, String> toMap() => Map.unmodifiable(_map);

  factory AppStringsModel.fallback() => const AppStringsModel({});
}
