import '../../models/dish_detail_model.dart';
import '../../models/dish_summary_model.dart';
import '../../models/drawer_payload_model.dart';
import '../../models/dynamic_form_model.dart';
import '../../models/home_payload_model.dart';

class MockRecipeData {
  // =================== HOME HEADERS ===================

  static String getHeaderTitle(String lang) {
    switch (lang) {
      case 'hi':
        return 'कुक्की रेसिपीज़';
      case 'ar':
        return 'وصفات كوكي';
      case 'en':
      default:
        return 'Cukkie Recipes';
    }
  }

  static String getHeaderSubtitle(String lang) {
    switch (lang) {
      case 'hi':
        return 'अपनी पसंद और स्वाद के अनुसार प्रामाणिक व्यंजन खोजें';
      case 'ar':
        return 'استكشف أشهى الأطباق الأصيلة المصممة حسب رغباتك';
      case 'en':
      default:
        return 'Explore authentic dishes tailored to your cravings';
    }
  }

  static String getSearchBarHint(String lang) {
    switch (lang) {
      case 'hi':
        return 'व्यंजन, सामग्री, भोजन शैली खोजें...';
      case 'ar':
        return 'ابحث عن أطباق، مطابخ، مكونات...';
      case 'en':
      default:
        return 'Search dishes, cuisines, ingredients...';
    }
  }

  static String getChefDisplayName(String lang) {
    switch (lang) {
      case 'hi':
        return 'शेफ फूडी';
      case 'ar':
        return 'شيف فودي';
      case 'en':
      default:
        return 'Chef Foodie';
    }
  }

  // =================== FILTERS ===================

  static List<FilterGroup> getFilterGroups(String lang) {
    if (lang == 'hi') {
      return const [
        FilterGroup(
          id: 'cuisines',
          title: 'व्यंजन शैलियाँ (Cuisines)',
          options: [
            FilterOption(id: 'North Indian', label: 'उत्तर भारतीय', iconUrl: 'https://cdn-icons-png.flaticon.com/512/706/706164.png'),
            FilterOption(id: 'Maharashtrian', label: 'महाराष्ट्रीयन', iconUrl: 'https://cdn-icons-png.flaticon.com/512/3075/3075977.png'),
            FilterOption(id: 'Italian', label: 'इटैलियन', iconUrl: 'https://cdn-icons-png.flaticon.com/512/1404/1404945.png'),
            FilterOption(id: 'Pan-Asian', label: 'पैन-एशियाई', iconUrl: 'https://cdn-icons-png.flaticon.com/512/2276/2276931.png'),
          ],
        ),
        FilterGroup(
          id: 'dietary',
          title: 'आहार संबंधी विकल्प (Dietary)',
          options: [
            FilterOption(id: 'Vegetarian', label: 'शाकाहारी', iconUrl: 'https://cdn-icons-png.flaticon.com/512/723/723633.png'),
            FilterOption(id: 'Vegan', label: 'वीगन', iconUrl: 'https://cdn-icons-png.flaticon.com/512/1415/1415433.png'),
            FilterOption(id: 'Jain', label: 'जैन', iconUrl: 'https://cdn-icons-png.flaticon.com/512/3233/3233483.png'),
          ],
        ),
        FilterGroup(
          id: 'taste',
          title: 'स्वाद प्रोफ़ाइल (Taste)',
          options: [
            FilterOption(id: 'Savory', label: 'स्वादिष्ट'),
            FilterOption(id: 'Spicy', label: 'तीखा'),
            FilterOption(id: 'Sweet', label: 'मीठा'),
            FilterOption(id: 'Tangy', label: 'चटपटा'),
            FilterOption(id: 'Sour', label: 'खट्टा'),
            FilterOption(id: 'Bitter', label: 'कड़वा'),
          ],
        ),
      ];
    } else if (lang == 'ar') {
      return const [
        FilterGroup(
          id: 'cuisines',
          title: 'المطابخ',
          options: [
            FilterOption(id: 'North Indian', label: 'شمال الهند', iconUrl: 'https://cdn-icons-png.flaticon.com/512/706/706164.png'),
            FilterOption(id: 'Maharashtrian', label: 'ماهاراشترا', iconUrl: 'https://cdn-icons-png.flaticon.com/512/3075/3075977.png'),
            FilterOption(id: 'Italian', label: 'إيطالي', iconUrl: 'https://cdn-icons-png.flaticon.com/512/1404/1404945.png'),
            FilterOption(id: 'Pan-Asian', label: 'آسيوي', iconUrl: 'https://cdn-icons-png.flaticon.com/512/2276/2276931.png'),
          ],
        ),
        FilterGroup(
          id: 'dietary',
          title: 'الخيارات الغذائية',
          options: [
            FilterOption(id: 'Vegetarian', label: 'نباتي', iconUrl: 'https://cdn-icons-png.flaticon.com/512/723/723633.png'),
            FilterOption(id: 'Vegan', label: 'نباتي صرف', iconUrl: 'https://cdn-icons-png.flaticon.com/512/1415/1415433.png'),
            FilterOption(id: 'Jain', label: 'جين', iconUrl: 'https://cdn-icons-png.flaticon.com/512/3233/3233483.png'),
          ],
        ),
        FilterGroup(
          id: 'taste',
          title: 'النكهات والذوق',
          options: [
            FilterOption(id: 'Savory', label: 'مالح'),
            FilterOption(id: 'Spicy', label: 'حار'),
            FilterOption(id: 'Sweet', label: 'حلو'),
            FilterOption(id: 'Tangy', label: 'لاذع'),
            FilterOption(id: 'Sour', label: 'حامض'),
            FilterOption(id: 'Bitter', label: 'مر'),
          ],
        ),
      ];
    }

    return const [
      FilterGroup(
        id: 'cuisines',
        title: 'Cuisines',
        options: [
          FilterOption(id: 'North Indian', label: 'North Indian', iconUrl: 'https://cdn-icons-png.flaticon.com/512/706/706164.png'),
          FilterOption(id: 'Maharashtrian', label: 'Maharashtrian', iconUrl: 'https://cdn-icons-png.flaticon.com/512/3075/3075977.png'),
          FilterOption(id: 'Italian', label: 'Italian', iconUrl: 'https://cdn-icons-png.flaticon.com/512/1404/1404945.png'),
          FilterOption(id: 'Pan-Asian', label: 'Pan-Asian', iconUrl: 'https://cdn-icons-png.flaticon.com/512/2276/2276931.png'),
        ],
      ),
      FilterGroup(
        id: 'dietary',
        title: 'Dietary',
        options: [
          FilterOption(id: 'Vegetarian', label: 'Vegetarian', iconUrl: 'https://cdn-icons-png.flaticon.com/512/723/723633.png'),
          FilterOption(id: 'Vegan', label: 'Vegan', iconUrl: 'https://cdn-icons-png.flaticon.com/512/1415/1415433.png'),
          FilterOption(id: 'Jain', label: 'Jain', iconUrl: 'https://cdn-icons-png.flaticon.com/512/3233/3233483.png'),
        ],
      ),
      FilterGroup(
        id: 'taste',
        title: 'Taste Profile',
        options: [
          FilterOption(id: 'Savory', label: 'Savory'),
          FilterOption(id: 'Spicy', label: 'Spicy'),
          FilterOption(id: 'Sweet', label: 'Sweet'),
          FilterOption(id: 'Tangy', label: 'Tangy'),
          FilterOption(id: 'Sour', label: 'Sour'),
          FilterOption(id: 'Bitter', label: 'Bitter'),
        ],
      ),
    ];
  }

  // =================== SORTERS ===================

  static List<SortOption> getSorters(String lang) {
    if (lang == 'hi') {
      return const [
        SortOption(id: 'rating_desc', label: 'शीर्ष मूल्यांकित', isDefault: true),
        SortOption(id: 'prep_time_asc', label: 'सबसे कम समय'),
        SortOption(id: 'calories_asc', label: 'सबसे कम कैलोरी'),
      ];
    } else if (lang == 'ar') {
      return const [
        SortOption(id: 'rating_desc', label: 'الأعلى تقييماً', isDefault: true),
        SortOption(id: 'prep_time_asc', label: 'الأسرع تحضيراً'),
        SortOption(id: 'calories_asc', label: 'أقل سعرات حرارية'),
      ];
    }

    return const [
      SortOption(id: 'rating_desc', label: 'Top Rated', isDefault: true),
      SortOption(id: 'prep_time_asc', label: 'Fastest Prep'),
      SortOption(id: 'calories_asc', label: 'Lowest Calories'),
    ];
  }

  // =================== DRAWER ITEMS ===================

  static List<DrawerItemModel> getDrawerItems(String lang, bool isLoggedIn) {
    if (isLoggedIn) {
      if (lang == 'hi') {
        return const [
          DrawerItemModel(
            id: 'profile',
            title: 'प्रोफ़ाइल',
            subtitle: 'अपना फ़ोन व सुरक्षा प्रबंधित करें',
            iconUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
            route: '/profile',
            requiresAuth: true,
          ),
          DrawerItemModel(
            id: 'preferences',
            title: 'भोजन प्राथमिकताएँ',
            subtitle: 'व्यंजन, आहार व स्वाद लक्ष्य',
            iconUrl: 'https://cdn-icons-png.flaticon.com/512/3565/3565418.png',
            route: '/preferences',
            requiresAuth: true,
          ),
          DrawerItemModel(
            id: 'favourites',
            title: 'पसंदीदा',
            subtitle: 'वे व्यंजन जिन्हें पकाना आपको पसंद है',
            iconUrl: 'https://cdn-icons-png.flaticon.com/512/2589/2589175.png',
            route: '/favourites',
            requiresAuth: true,
          ),
          DrawerItemModel(
            id: 'settings',
            title: 'सेटिंग्स',
            subtitle: 'भाषा, थीम और स्पर्श',
            iconUrl: 'https://cdn-icons-png.flaticon.com/512/3524/3524659.png',
            route: '/settings',
          ),
          DrawerItemModel(
            id: 'logout',
            title: 'लॉग आउट',
            subtitle: 'वर्तमान सत्र से बाहर निकलें',
            iconUrl: 'https://cdn-icons-png.flaticon.com/512/1828/1828479.png',
            requiresAuth: true,
          ),
        ];
      } else if (lang == 'ar') {
        return const [
          DrawerItemModel(
            id: 'profile',
            title: 'الملف الشخصي',
            subtitle: 'إدارة رقم هاتفك والأمان',
            iconUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
            route: '/profile',
            requiresAuth: true,
          ),
          DrawerItemModel(
            id: 'preferences',
            title: 'تفضيلات الطعام',
            subtitle: 'المطابخ والنظام الغذائي والنكهات',
            iconUrl: 'https://cdn-icons-png.flaticon.com/512/3565/3565418.png',
            route: '/preferences',
            requiresAuth: true,
          ),
          DrawerItemModel(
            id: 'favourites',
            title: 'المفضلة',
            subtitle: 'الأطباق التي تحب طهيها دائماً',
            iconUrl: 'https://cdn-icons-png.flaticon.com/512/2589/2589175.png',
            route: '/favourites',
            requiresAuth: true,
          ),
          DrawerItemModel(
            id: 'settings',
            title: 'الإعدادات',
            subtitle: 'اللغة، المظهر والمؤثرات الصوتية',
            iconUrl: 'https://cdn-icons-png.flaticon.com/512/3524/3524659.png',
            route: '/settings',
          ),
          DrawerItemModel(
            id: 'logout',
            title: 'تسجيل الخروج',
            subtitle: 'إنهاء جلستك الحالية بأمان',
            iconUrl: 'https://cdn-icons-png.flaticon.com/512/1828/1828479.png',
            requiresAuth: true,
          ),
        ];
      }

      return const [
        DrawerItemModel(
          id: 'profile',
          title: 'Profile',
          subtitle: 'Manage your phone & security',
          iconUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
          route: '/profile',
          requiresAuth: true,
        ),
        DrawerItemModel(
          id: 'preferences',
          title: 'Food Preferences',
          subtitle: 'Cuisines, diets & flavor goals',
          iconUrl: 'https://cdn-icons-png.flaticon.com/512/3565/3565418.png',
          route: '/preferences',
          requiresAuth: true,
        ),
        DrawerItemModel(
          id: 'favourites',
          title: 'Favourites',
          subtitle: 'Dishes you love to cook',
          iconUrl: 'https://cdn-icons-png.flaticon.com/512/2589/2589175.png',
          route: '/favourites',
          requiresAuth: true,
        ),
        DrawerItemModel(
          id: 'settings',
          title: 'Settings',
          subtitle: 'Language, themes & haptics',
          iconUrl: 'https://cdn-icons-png.flaticon.com/512/3524/3524659.png',
          route: '/settings',
        ),
        DrawerItemModel(
          id: 'logout',
          title: 'Log Out',
          subtitle: 'Exit your current session',
          iconUrl: 'https://cdn-icons-png.flaticon.com/512/1828/1828479.png',
          requiresAuth: true,
        ),
      ];
    } else {
      if (lang == 'hi') {
        return const [
          DrawerItemModel(
            id: 'login',
            title: 'लॉग इन / पंजीकरण',
            subtitle: 'प्राथमिकताएं व पसंदीदा व्यंजन सहेजें',
            iconUrl: 'https://cdn-icons-png.flaticon.com/512/1828/1828466.png',
            route: '/login',
          ),
          DrawerItemModel(
            id: 'settings',
            title: 'सेटिंग्स',
            subtitle: 'भाषा, थीम और स्पर्श',
            iconUrl: 'https://cdn-icons-png.flaticon.com/512/3524/3524659.png',
            route: '/settings',
          ),
        ];
      } else if (lang == 'ar') {
        return const [
          DrawerItemModel(
            id: 'login',
            title: 'تسجيل الدخول / التسجيل',
            subtitle: 'حفظ تفضيلاتك والأطباق المفضلة',
            iconUrl: 'https://cdn-icons-png.flaticon.com/512/1828/1828466.png',
            route: '/login',
          ),
          DrawerItemModel(
            id: 'settings',
            title: 'الإعدادات',
            subtitle: 'اللغة، المظهر والمؤثرات الصوتية',
            iconUrl: 'https://cdn-icons-png.flaticon.com/512/3524/3524659.png',
            route: '/settings',
          ),
        ];
      }

      return const [
        DrawerItemModel(
          id: 'login',
          title: 'Log In / Register',
          subtitle: 'Save preferences & favorite dishes',
          iconUrl: 'https://cdn-icons-png.flaticon.com/512/1828/1828466.png',
          route: '/login',
        ),
        DrawerItemModel(
          id: 'settings',
          title: 'Settings',
          subtitle: 'Language, themes & haptics',
          iconUrl: 'https://cdn-icons-png.flaticon.com/512/3524/3524659.png',
          route: '/settings',
        ),
      ];
    }
  }

  // =================== DISH SUMMARIES ===================

  static List<DishSummaryModel> getDishes(String lang) {
    if (lang == 'hi') {
      return const [
        DishSummaryModel(
          id: 'dish_pbm',
          name: 'पनीर बटर मसाला',
          imageUrl: 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=600',
          tasteProfiles: ['स्वादिष्ट', 'मलाईदार', 'चटपटा'],
          prepTimeMinutes: 30,
          caloriesKcal: 380,
          proteinGrams: 14,
          isFavourite: true,
          cuisine: 'उत्तर भारतीय',
          dietaryType: 'शाकाहारी',
          rating: 4.9,
        ),
        DishSummaryModel(
          id: 'dish_paratha',
          name: 'आलू गोभी परांठा',
          imageUrl: 'https://images.unsplash.com/photo-1626074353765-517a681e40be?w=600',
          tasteProfiles: ['स्वादिष्ट', 'तीखा'],
          prepTimeMinutes: 25,
          caloriesKcal: 290,
          proteinGrams: 7,
          isFavourite: false,
          cuisine: 'उत्तर भारतीय',
          dietaryType: 'शाकाहारी',
          rating: 4.8,
        ),
        DishSummaryModel(
          id: 'dish_misal',
          name: 'प्रामाणिक मिसल पाव',
          imageUrl: 'https://images.unsplash.com/photo-1606491956689-2ea866880c84?w=600',
          tasteProfiles: ['तीखा', 'चटपटा', 'स्वादिष्ट'],
          prepTimeMinutes: 35,
          caloriesKcal: 420,
          proteinGrams: 16,
          isFavourite: false,
          cuisine: 'महाराष्ट्रीयन',
          dietaryType: 'वीगन',
          rating: 4.9,
        ),
        DishSummaryModel(
          id: 'dish_halwa',
          name: 'सूजी का हलवा (शीरा)',
          imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600',
          tasteProfiles: ['मीठा', 'सुगंधित'],
          prepTimeMinutes: 20,
          caloriesKcal: 310,
          proteinGrams: 5,
          isFavourite: true,
          cuisine: 'महाराष्ट्रीयन',
          dietaryType: 'जैन',
          rating: 4.7,
        ),
        DishSummaryModel(
          id: 'dish_pizza',
          name: 'नेपोलिटन मार्गेरिटा पिज़्ज़ा',
          imageUrl: 'https://images.unsplash.com/photo-1604382355076-af4b0eb60143?w=600',
          tasteProfiles: ['स्वादिष्ट', 'चीज़ी', 'जड़ी-बूटी युक्त'],
          prepTimeMinutes: 25,
          caloriesKcal: 350,
          proteinGrams: 13,
          isFavourite: false,
          cuisine: 'इटैलियन',
          dietaryType: 'शाकाहारी',
          rating: 4.8,
        ),
        DishSummaryModel(
          id: 'dish_arrabbiata',
          name: 'पेने ऑल-अराबियाता',
          imageUrl: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=800',
          tasteProfiles: ['तीखा', 'चटपटा', 'स्वादिष्ट'],
          prepTimeMinutes: 20,
          caloriesKcal: 330,
          proteinGrams: 10,
          isFavourite: false,
          cuisine: 'इटैलियन',
          dietaryType: 'वीगन',
          rating: 4.6,
        ),
      ];
    } else if (lang == 'ar') {
      return const [
        DishSummaryModel(
          id: 'dish_pbm',
          name: 'بانير زبدة ماسالا',
          imageUrl: 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=600',
          tasteProfiles: ['مالح', 'كريمي', 'لاذع'],
          prepTimeMinutes: 30,
          caloriesKcal: 380,
          proteinGrams: 14,
          isFavourite: true,
          cuisine: 'شمال الهند',
          dietaryType: 'نباتي',
          rating: 4.9,
        ),
        DishSummaryModel(
          id: 'dish_paratha',
          name: 'باراثا البطاطس والقرنبيط',
          imageUrl: 'https://images.unsplash.com/photo-1626074353765-517a681e40be?w=600',
          tasteProfiles: ['مالح', 'حار'],
          prepTimeMinutes: 25,
          caloriesKcal: 290,
          proteinGrams: 7,
          isFavourite: false,
          cuisine: 'شمال الهند',
          dietaryType: 'نباتي',
          rating: 4.8,
        ),
        DishSummaryModel(
          id: 'dish_misal',
          name: 'ميسال باف الأصيل',
          imageUrl: 'https://images.unsplash.com/photo-1606491956689-2ea866880c84?w=600',
          tasteProfiles: ['حار', 'لاذع', 'مالح'],
          prepTimeMinutes: 35,
          caloriesKcal: 420,
          proteinGrams: 16,
          isFavourite: false,
          cuisine: 'ماهاراشترا',
          dietaryType: 'نباتي صرف',
          rating: 4.9,
        ),
        DishSummaryModel(
          id: 'dish_halwa',
          name: 'حلوى السميد (شيرا)',
          imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600',
          tasteProfiles: ['حلو', 'عطري'],
          prepTimeMinutes: 20,
          caloriesKcal: 310,
          proteinGrams: 5,
          isFavourite: true,
          cuisine: 'ماهاراشترا',
          dietaryType: 'جين',
          rating: 4.7,
        ),
        DishSummaryModel(
          id: 'dish_pizza',
          name: 'بيتزا مارغريتا نابوليتان',
          imageUrl: 'https://images.unsplash.com/photo-1604382355076-af4b0eb60143?w=600',
          tasteProfiles: ['مالح', 'جبني', 'عشبي'],
          prepTimeMinutes: 25,
          caloriesKcal: 350,
          proteinGrams: 13,
          isFavourite: false,
          cuisine: 'إيطالي',
          dietaryType: 'نباتي',
          rating: 4.8,
        ),
        DishSummaryModel(
          id: 'dish_arrabbiata',
          name: 'بيني ألارابياتا الحارة',
          imageUrl: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=800',
          tasteProfiles: ['حار', 'لاذع', 'مالح'],
          prepTimeMinutes: 20,
          caloriesKcal: 330,
          proteinGrams: 10,
          isFavourite: false,
          cuisine: 'إيطالي',
          dietaryType: 'نباتي صرف',
          rating: 4.6,
        ),
      ];
    }

    return const [
      DishSummaryModel(
        id: 'dish_pbm',
        name: 'Paneer Butter Masala',
        imageUrl: 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=600',
        tasteProfiles: ['Savory', 'Creamy', 'Tangy'],
        prepTimeMinutes: 30,
        caloriesKcal: 380,
        proteinGrams: 14,
        isFavourite: true,
        cuisine: 'North Indian',
        dietaryType: 'Vegetarian',
        rating: 4.9,
      ),
      DishSummaryModel(
        id: 'dish_paratha',
        name: 'Aloo Gobi Paratha',
        imageUrl: 'https://images.unsplash.com/photo-1626074353765-517a681e40be?w=600',
        tasteProfiles: ['Savory', 'Spicy'],
        prepTimeMinutes: 25,
        caloriesKcal: 290,
        proteinGrams: 7,
        isFavourite: false,
        cuisine: 'North Indian',
        dietaryType: 'Vegetarian',
        rating: 4.8,
      ),
      DishSummaryModel(
        id: 'dish_misal',
        name: 'Authentic Misal Pav',
        imageUrl: 'https://images.unsplash.com/photo-1606491956689-2ea866880c84?w=600',
        tasteProfiles: ['Spicy', 'Tangy', 'Savory'],
        prepTimeMinutes: 35,
        caloriesKcal: 420,
        proteinGrams: 16,
        isFavourite: false,
        cuisine: 'Maharashtrian',
        dietaryType: 'Vegan',
        rating: 4.9,
      ),
      DishSummaryModel(
        id: 'dish_halwa',
        name: 'Suji Ka Halwa (Sheera)',
        imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=600',
        tasteProfiles: ['Sweet', 'Aromatic'],
        prepTimeMinutes: 20,
        caloriesKcal: 310,
        proteinGrams: 5,
        isFavourite: true,
        cuisine: 'Maharashtrian',
        dietaryType: 'Jain',
        rating: 4.7,
      ),
      DishSummaryModel(
        id: 'dish_pizza',
        name: 'Neapolitan Margherita Pizza',
        imageUrl: 'https://images.unsplash.com/photo-1604382355076-af4b0eb60143?w=600',
        tasteProfiles: ['Savory', 'Cheesy', 'Herbaceous'],
        prepTimeMinutes: 25,
        caloriesKcal: 350,
        proteinGrams: 13,
        isFavourite: false,
        cuisine: 'Italian',
        dietaryType: 'Vegetarian',
        rating: 4.8,
      ),
      DishSummaryModel(
        id: 'dish_arrabbiata',
        name: 'Penne all\'Arrabbiata',
        imageUrl: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=800',
        tasteProfiles: ['Spicy', 'Tangy', 'Savory'],
        prepTimeMinutes: 20,
        caloriesKcal: 330,
        proteinGrams: 10,
        isFavourite: false,
        cuisine: 'Italian',
        dietaryType: 'Vegan',
        rating: 4.6,
      ),
    ];
  }

  // Canonical mapping for robust filtering across languages
  static const Map<String, String> canonicalCuisines = {
    'dish_pbm': 'North Indian',
    'dish_paratha': 'North Indian',
    'dish_misal': 'Maharashtrian',
    'dish_halwa': 'Maharashtrian',
    'dish_pizza': 'Italian',
    'dish_arrabbiata': 'Italian',
  };

  static const Map<String, String> canonicalDietary = {
    'dish_pbm': 'Vegetarian',
    'dish_paratha': 'Vegetarian',
    'dish_misal': 'Vegan',
    'dish_halwa': 'Jain',
    'dish_pizza': 'Vegetarian',
    'dish_arrabbiata': 'Vegan',
  };

  static const Map<String, List<String>> canonicalTastes = {
    'dish_pbm': ['Savory', 'Creamy', 'Tangy'],
    'dish_paratha': ['Savory', 'Spicy'],
    'dish_misal': ['Spicy', 'Tangy', 'Savory'],
    'dish_halwa': ['Sweet', 'Aromatic'],
    'dish_pizza': ['Savory', 'Cheesy', 'Herbaceous'],
    'dish_arrabbiata': ['Spicy', 'Tangy', 'Savory'],
  };

  // =================== DISH DETAILS ===================

  static DishDetailModel getDishDetail(String dishId, String lang) {
    final detailsMap = _getDetailsMap(lang);
    var dish = detailsMap[dishId];
    if (dish != null) return dish;

    // Fallback to English detail if available
    dish = _getDetailsMap('en')[dishId];
    if (dish != null) return dish;

    return _getDetailsMap(lang).values.first;
  }

  static Map<String, DishDetailModel> _getDetailsMap(String lang) {
    switch (lang) {
      case 'hi':
        return _hindiDishDetails;
      case 'ar':
        return _arabicDishDetails;
      case 'en':
      default:
        return _englishDishDetails;
    }
  }

  // ---------- ENGLISH RECIPES ----------
  static final Map<String, DishDetailModel> _englishDishDetails = {
    'dish_paratha': DishDetailModel(
      id: 'dish_paratha',
      name: 'Aloo Gobi Paratha',
      imageUrl: 'https://images.unsplash.com/photo-1626074353765-517a681e40be?w=800',
      shareUrl: 'https://cukkie.com/recipe/dish_paratha',
      description: 'Golden, crispy whole-wheat flatbread stuffed with spiced potato and tender cauliflower mash, toasted on a smoking hot tawa with pure desi ghee.',
      history: 'Originating from the agrarian hearths of Punjab, stuffed parathas evolved as hearty breakfasts fueling farmers with sustained energy throughout the morning harvest.',
      nutritionalBreakdown: {
        'Calories': '290 kcal',
        'Protein': '7 g',
        'Carbohydrates': '48 g',
        'Dietary Fiber': '6 g',
        'Fats': '8 g',
      },
      portionDefinition: const PortionDefinition(
        unit: 'pieces',
        defaultAmount: 4.0,
        stepIncrement: 1.0,
        minAmount: 1.0,
        maxAmount: 12.0,
      ),
      ingredients: const [
        IngredientItem(id: 'i1', name: 'Whole Wheat Flour', baseQuantity: 2.0, unit: 'cups'),
        IngredientItem(id: 'i2', name: 'Boiled Potatoes', baseQuantity: 3.0, unit: 'medium pieces'),
        IngredientItem(id: 'i3', name: 'Grated Cauliflower (Gobi)', baseQuantity: 1.0, unit: 'cup'),
        IngredientItem(id: 'i4', name: 'Finely Chopped Green Chillies', baseQuantity: 2.0, unit: 'chillies'),
        IngredientItem(id: 'i5', name: 'Ajwain (Carom Seeds)', baseQuantity: 0.5, unit: 'tsp'),
        IngredientItem(id: 'i6', name: 'Amchur (Dry Mango Powder)', baseQuantity: 1.0, unit: 'tsp'),
        IngredientItem(id: 'i7', name: 'Desi Ghee or Butter', baseQuantity: 3.0, unit: 'tbsp'),
        IngredientItem(id: 'i8', name: 'Fresh Coriander', baseQuantity: 0.25, unit: 'cup'),
      ],
      steps: const [
        RecipeStepItem(
          index: 0,
          heading: 'Dish Overview',
          instructionText: 'Explore the culinary heritage, cultural story, and wholesome nutritional foundation of traditional Aloo Gobi Paratha.',
          audioNarrationText: 'Welcome to Cukkie. Let us begin with the story and wholesome nutrients of Aloo Gobi Paratha.',
        ),
        RecipeStepItem(
          index: 1,
          heading: 'Portion Size',
          instructionText: 'Select how many crispy parathas you wish to prepare today. All ingredient quantities in the next steps will automatically adjust.',
          audioNarrationText: 'Choose the number of parathas you are cooking. All quantities will instantly recalculate.',
        ),
        RecipeStepItem(
          index: 2,
          heading: 'Ingredients Checklist',
          instructionText: 'Verify and assemble your fresh ingredients. Check off each item once laid out on your prep counter.',
          audioNarrationText: 'Here is your fresh ingredients checklist. Gather them on your countertop and check them off.',
        ),
        RecipeStepItem(
          index: 3,
          heading: 'Prepare the Dough',
          instructionText: 'Knead the whole wheat flour with a pinch of salt and warm water into a soft, pliable dough. Coat with a drop of ghee and let it rest for 15 minutes.',
          audioNarrationText: 'Knead your dough until soft and pliable. Let it rest under a damp cloth for fifteen minutes.',
          todos: [
            'Add whole wheat flour and pinch of salt to mixing bowl',
            'Gradually incorporate lukewarm water while kneading',
            'Knead for 5 minutes until soft and non-sticky',
            'Brush with 1/2 tsp ghee, cover and rest for 15 minutes',
          ],
        ),
        RecipeStepItem(
          index: 4,
          heading: 'Mix Spiced Stuffing',
          instructionText: 'In a large bowl, mash the boiled potatoes thoroughly. Fold in grated cauliflower, green chillies, dry spices, and fresh cilantro. Mix evenly without making it watery.',
          audioNarrationText: 'Mash the potatoes and combine with cauliflower, aromatics, and roasted spices.',
          todos: [
            'Thoroughly mash boiled potatoes ensuring no hard lumps remain',
            'Add grated cauliflower and finely minced green chillies',
            'Incorporate ajwain, amchur powder, garam masala and salt',
            'Fold in freshly chopped coriander leaves',
          ],
        ),
        RecipeStepItem(
          index: 5,
          heading: 'Roll and Stuff',
          instructionText: 'Pinch a lemon-sized dough ball, flatten the edges, place a generous ball of spiced stuffing in the center, pleat the edges to seal completely, and gently roll out into an even round circle.',
          audioNarrationText: 'Encase the fragrant filling into the dough circle and roll out with light, even pressure.',
        ),
        RecipeStepItem(
          index: 6,
          heading: 'Roast on Smoking Tawa',
          instructionText: 'Cook the paratha on a medium-hot cast-iron tawa until golden spots appear on both sides. Generously baste with desi ghee until crisp and puffed.',
          audioNarrationText: 'Roast on a hot tawa with generous ghee until crispy, golden brown, and delightfully puffed.',
          todos: [
            'Place rolled paratha onto preheated cast iron tawa',
            'Flip after 45 seconds when bubbles form',
            'Brush 1 teaspoon of desi ghee over the surface',
            'Flip and press edges lightly with spatula until golden and crisp',
          ],
        ),
        RecipeStepItem(
          index: 7,
          heading: 'Tasting & Feedback',
          instructionText: 'Serve piping hot with a dollop of white butter, cold curd, and spicy mango pickle. Rate your cooking experience below.',
          audioNarrationText: 'Congratulations on completing your parathas! Taste your creation and share your valuable feedback.',
        ),
      ],
      feedbackFormFields: const [
        DynamicFormFieldModel(
          id: 'dish_rating',
          title: 'How delicious did your parathas turn out?',
          type: FormFieldType.rating,
          isRequired: true,
          initialValue: 5,
        ),
        DynamicFormFieldModel(
          id: 'crispiness_choice',
          title: 'How was the crust texture?',
          type: FormFieldType.singleChoice,
          options: ['Wonderfully Crispy', 'Soft & Fluffy', 'Slightly Doughy'],
          isRequired: true,
        ),
        DynamicFormFieldModel(
          id: 'side_pairings',
          title: 'What did you pair with your parathas?',
          type: FormFieldType.multipleChoice,
          options: ['Fresh Curd / Raita', 'Desi White Butter', 'Mango Pickle', 'Hot Chai'],
        ),
        DynamicFormFieldModel(
          id: 'chef_notes',
          title: 'Any culinary notes or personal twists?',
          type: FormFieldType.text,
          placeholder: 'E.g. Added a pinch of kasuri methi to the filling...',
        ),
        DynamicFormFieldModel(
          id: 'dish_photo',
          title: 'Snap a picture of your finished dish',
          type: FormFieldType.imageUpload,
        ),
      ],
    ),
    'dish_halwa': DishDetailModel(
      id: 'dish_halwa',
      name: 'Suji Ka Halwa (Sheera)',
      imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=800',
      shareUrl: 'https://cukkie.com/recipe/dish_halwa',
      description: 'Rich, melt-in-mouth semolina pudding roasted to a nutty amber in pure ghee, perfumed with green cardamom, saffron threads, and crunchy toasted almonds.',
      history: 'A sacred culinary preparation across Indian households, Sheera has been shared as prasad and celebration sweets across festivities since Vedic antiquity.',
      nutritionalBreakdown: {
        'Calories': '310 kcal',
        'Protein': '5 g',
        'Carbohydrates': '52 g',
        'Fats': '11 g',
      },
      portionDefinition: const PortionDefinition(
        unit: 'grams',
        defaultAmount: 250.0,
        stepIncrement: 50.0,
        minAmount: 100.0,
        maxAmount: 1000.0,
      ),
      ingredients: const [
        IngredientItem(id: 'i1', name: 'Fine Suji / Rava (Semolina)', baseQuantity: 100.0, unit: 'grams'),
        IngredientItem(id: 'i2', name: 'Pure Desi Ghee', baseQuantity: 80.0, unit: 'grams'),
        IngredientItem(id: 'i3', name: 'Granulated Sugar', baseQuantity: 90.0, unit: 'grams'),
        IngredientItem(id: 'i4', name: 'Water / Whole Milk', baseQuantity: 300.0, unit: 'ml'),
        IngredientItem(id: 'i5', name: 'Cardamom Powder', baseQuantity: 0.5, unit: 'tsp'),
        IngredientItem(id: 'i6', name: 'Saffron Strands', baseQuantity: 8.0, unit: 'threads', isOptional: true),
        IngredientItem(id: 'i7', name: 'Sliced Almonds & Cashews', baseQuantity: 20.0, unit: 'grams'),
      ],
      steps: const [
        RecipeStepItem(
          index: 0,
          heading: 'Dish Overview',
          instructionText: 'Discover the fragrant heritage of traditional ghee-roasted Suji Halwa.',
          audioNarrationText: 'Welcome. Discover the rich heritage and sweet aroma of authentic Suji Halwa.',
        ),
        RecipeStepItem(
          index: 1,
          heading: 'Portion Size',
          instructionText: 'Select the batch size in grams for your preparation.',
          audioNarrationText: 'Choose the total weight in grams you wish to cook.',
        ),
        RecipeStepItem(
          index: 2,
          heading: 'Ingredients Checklist',
          instructionText: 'Assemble semolina, ghee, sugar, and whole milk.',
          audioNarrationText: 'Measure out your semolina, pure ghee, and sweet aromatics.',
        ),
        RecipeStepItem(
          index: 3,
          heading: 'Roast Nuts & Semolina',
          instructionText: 'Melt ghee in a heavy kadai, fry nuts until golden, remove them, then slowly roast suji on low heat until aromatic and light golden brown.',
          audioNarrationText: 'Roast your rava in hot ghee on low flame until a nutty aroma fills your kitchen.',
          todos: [
            'Melt 2 tbsp ghee in heavy-bottomed pan and fry cashews and almonds',
            'Drain toasted nuts and set aside for garnish',
            'Add semolina to remaining ghee and stir continuously on low heat',
            'Roast for 8-10 minutes until aromatic and pinkish-golden',
          ],
        ),
        RecipeStepItem(
          index: 4,
          heading: 'Simmer with Infused Milk',
          instructionText: 'Gradually pour hot saffron milk into roasted semolina while stirring vigorously to avoid any lumps. Cover and cook on low heat until moisture is absorbed.',
          audioNarrationText: 'Carefully pour warm saffron milk into the roasted semolina while stirring constantly.',
          todos: [
            'Bring milk and saffron to a gentle boil in a separate saucepan',
            'Slowly pour warm milk into semolina while whisking constantly',
            'Cover pan and let semolina grains swell on low heat for 3 minutes',
          ],
        ),
        RecipeStepItem(
          index: 5,
          heading: 'Fold Sugar and Garnish',
          instructionText: 'Stir in sugar and cardamom powder. The halwa will loosen then quickly glisten as sugar melts. Garnish with toasted nuts.',
          audioNarrationText: 'Add sugar and fragrant cardamom. Watch the halwa take on a glossy, luscious sheen.',
        ),
        RecipeStepItem(
          index: 6,
          heading: 'Tasting & Feedback',
          instructionText: 'Enjoy warm spoonfuls of aromatic halwa. Tell us how sweet and balanced it turned out!',
          audioNarrationText: 'Enjoy your aromatic creation! Please share your feedback with our kitchen team.',
        ),
      ],
      feedbackFormFields: const [
        DynamicFormFieldModel(
          id: 'dish_rating',
          title: 'How was the halwa taste and texture?',
          type: FormFieldType.rating,
          isRequired: true,
          initialValue: 5,
        ),
        DynamicFormFieldModel(
          id: 'sweetness_rating',
          title: 'Was the sweetness level right for you?',
          type: FormFieldType.singleChoice,
          options: ['Perfect Balance', 'Too Sweet', 'Needed More Sugar'],
          isRequired: true,
        ),
        DynamicFormFieldModel(
          id: 'feedback_notes',
          title: 'Feedback / Chef Notes',
          type: FormFieldType.text,
          placeholder: 'Notes about roasting time or texture...',
        ),
        DynamicFormFieldModel(
          id: 'halwa_photo',
          title: 'Upload picture of your Sheera',
          type: FormFieldType.imageUpload,
        ),
      ],
    ),
    'dish_pbm': DishDetailModel(
      id: 'dish_pbm',
      name: 'Paneer Butter Masala',
      imageUrl: 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=800',
      shareUrl: 'https://cukkie.com/recipe/dish_pbm',
      description: 'Succulent cubes of fresh cottage cheese simmered in a velvet-smooth, spiced tomato-cashew satin gravy finished with fenugreek and butter.',
      history: 'Invented in the legendary kitchens of Delhi in the 1950s, this gravy perfected the harmony between sweet ripened tomatoes, rich dairy butter, and toasted fenugreek.',
      nutritionalBreakdown: {
        'Calories': '380 kcal',
        'Protein': '14 g',
        'Carbohydrates': '22 g',
        'Fats': '28 g',
      },
      portionDefinition: const PortionDefinition(
        unit: 'servings',
        defaultAmount: 3.0,
        stepIncrement: 1.0,
        minAmount: 1.0,
        maxAmount: 8.0,
      ),
      ingredients: const [
        IngredientItem(id: 'i1', name: 'Fresh Paneer Cubes', baseQuantity: 250.0, unit: 'grams'),
        IngredientItem(id: 'i2', name: 'Vine-Ripened Tomatoes', baseQuantity: 4.0, unit: 'large'),
        IngredientItem(id: 'i3', name: 'Cashew Nuts', baseQuantity: 15.0, unit: 'pieces'),
        IngredientItem(id: 'i4', name: 'Fresh Butter', baseQuantity: 2.0, unit: 'tbsp'),
        IngredientItem(id: 'i5', name: 'Heavy Cream', baseQuantity: 3.0, unit: 'tbsp'),
        IngredientItem(id: 'i6', name: 'Kasuri Methi (Fenugreek)', baseQuantity: 1.0, unit: 'tsp'),
        IngredientItem(id: 'i7', name: 'Ginger-Garlic Paste', baseQuantity: 1.0, unit: 'tbsp'),
      ],
      steps: const [
        RecipeStepItem(
          index: 0,
          heading: 'Dish Overview',
          instructionText: 'Explore the royal culinary heritage and macronutrients of Paneer Butter Masala.',
          audioNarrationText: 'Discover the velvet texture and rich flavors of royal Paneer Butter Masala.',
        ),
        RecipeStepItem(
          index: 1,
          heading: 'Portion Size',
          instructionText: 'Select number of dining servings to cook.',
          audioNarrationText: 'Choose how many servings you wish to prepare.',
        ),
        RecipeStepItem(
          index: 2,
          heading: 'Ingredients Checklist',
          instructionText: 'Assemble paneer, ripened tomatoes, soaked cashews, and butter.',
          audioNarrationText: 'Lay out your ingredients and check each off your list.',
        ),
        RecipeStepItem(
          index: 3,
          heading: 'Prepare Velvet Gravy Base',
          instructionText: 'Boil tomatoes with soaked cashews and spices for 10 minutes until tender, then blend into an ultra-smooth silk purée.',
          audioNarrationText: 'Boil ripe tomatoes with cashews and blend into an ultra smooth silky purée.',
          todos: [
            'Roughly chop tomatoes and add to pan with cashews and water',
            'Simmer for 10 minutes until tomato skins loosen completely',
            'Cool slightly and blend until completely silky and velvety',
            'Strain through a fine mesh sieve for luxurious restaurant texture',
          ],
        ),
        RecipeStepItem(
          index: 4,
          heading: 'Simmer Gravy with Aromatics',
          instructionText: 'Heat butter in a pan, sauté ginger-garlic paste, add chili and coriander powders, pour in the strained tomato purée, and simmer until butter releases at the edges.',
          audioNarrationText: 'Cook the strained purée with butter and aromatics until rich and glistening.',
        ),
        RecipeStepItem(
          index: 5,
          heading: 'Add Paneer & Cream',
          instructionText: 'Gently slip in fresh paneer cubes. Simmer on low heat for 3 minutes, then finish with crushed kasuri methi and a swirl of heavy cream.',
          audioNarrationText: 'Slip in the soft paneer cubes and finish with crushed kasuri methi and cream.',
          todos: [
            'Soak paneer cubes in warm water for 5 minutes for pillow softness',
            'Gently fold paneer into bubbling gravy without breaking cubes',
            'Crush kasuri methi between palms and sprinkle evenly',
            'Swirl in fresh cream and turn off heat immediately',
          ],
        ),
        RecipeStepItem(
          index: 6,
          heading: 'Tasting & Feedback',
          instructionText: 'Serve with warm naan or jeera rice. Rate your culinary masterpiece!',
          audioNarrationText: 'Serve hot with warm naan or rice. Please share your rating and review.',
        ),
      ],
      feedbackFormFields: const [
        DynamicFormFieldModel(
          id: 'dish_rating',
          title: 'How creamy and flavorful was the masala?',
          type: FormFieldType.rating,
          isRequired: true,
          initialValue: 5,
        ),
        DynamicFormFieldModel(
          id: 'richness_choice',
          title: 'How was the gravy consistency?',
          type: FormFieldType.singleChoice,
          options: ['Silky & Perfect', 'Slightly Thick', 'Too Runny'],
          isRequired: true,
        ),
        DynamicFormFieldModel(
          id: 'pairing_options',
          title: 'What did you serve it with?',
          type: FormFieldType.multipleChoice,
          options: ['Butter Naan', 'Jeera Rice', 'Tandoori Roti', 'Paratha'],
        ),
        DynamicFormFieldModel(
          id: 'comments',
          title: 'Personal Tasting Notes',
          type: FormFieldType.text,
          placeholder: 'Tell us how your family enjoyed it...',
        ),
        DynamicFormFieldModel(
          id: 'curry_photo',
          title: 'Upload a photo of your Paneer Butter Masala',
          type: FormFieldType.imageUpload,
        ),
      ],
    ),
    'dish_misal': DishDetailModel(
      id: 'dish_misal',
      name: 'Authentic Misal Pav',
      imageUrl: 'https://images.unsplash.com/photo-1606491956689-2ea866880c84?w=800',
      shareUrl: 'https://cukkie.com/recipe/dish_misal',
      description: 'A fiery, multi-layered Maharashtrian curry made from tender sprouted moth beans (matki), bathed in a rich spiced red kat (rassa), crowned with crunchy farsan, fresh onions, and served with warm, pillowy pav.',
      history: 'Originating from the bustling working-class streets of Kolhapur and Pune, Misal Pav evolved into Maharashtra’s most iconic, protein-packed breakfast, renowned for its layered textures and signature bubbling red tarri.',
      nutritionalBreakdown: {
        'Calories': '420 kcal',
        'Protein': '16 g',
        'Carbohydrates': '54 g',
        'Dietary Fiber': '9 g',
        'Fats': '14 g',
      },
      portionDefinition: const PortionDefinition(
        unit: 'plates',
        defaultAmount: 2.0,
        stepIncrement: 1.0,
        minAmount: 1.0,
        maxAmount: 8.0,
      ),
      ingredients: const [
        IngredientItem(id: 'i1', name: 'Sprouted Moth Beans (Matki)', baseQuantity: 1.5, unit: 'cups'),
        IngredientItem(id: 'i2', name: 'Fresh Pav Buns', baseQuantity: 4.0, unit: 'pieces'),
        IngredientItem(id: 'i3', name: 'Mixed Farsan / Spicy Chiwda', baseQuantity: 1.0, unit: 'cup'),
        IngredientItem(id: 'i4', name: 'Finely Chopped Red Onions', baseQuantity: 2.0, unit: 'medium'),
        IngredientItem(id: 'i5', name: 'Ripe Tomatoes', baseQuantity: 2.0, unit: 'medium'),
        IngredientItem(id: 'i6', name: 'Roasted Dry Coconut (Copra)', baseQuantity: 0.25, unit: 'cup'),
        IngredientItem(id: 'i7', name: 'Misal / Goda Masala', baseQuantity: 2.0, unit: 'tbsp'),
        IngredientItem(id: 'i8', name: 'Ginger-Garlic Paste', baseQuantity: 1.0, unit: 'tbsp'),
        IngredientItem(id: 'i9', name: 'Mustard Seeds & Curry Leaves', baseQuantity: 1.0, unit: 'tsp'),
        IngredientItem(id: 'i10', name: 'Fresh Lemon Wedges', baseQuantity: 2.0, unit: 'pieces'),
      ],
      steps: const [
        RecipeStepItem(
          index: 0,
          heading: 'Dish Overview',
          instructionText: 'Discover the heritage, explosive flavors, and nutritional richness of authentic Kolhapuri & Puneri Misal Pav.',
          audioNarrationText: 'Welcome to the world of authentic Misal Pav. Let us explore its fiery heritage and protein-packed roots.',
        ),
        RecipeStepItem(
          index: 1,
          heading: 'Portion Size',
          instructionText: 'Select how many hearty plates of Misal Pav you are serving today. Ingredients will scale automatically.',
          audioNarrationText: 'Choose the number of plates you wish to prepare.',
        ),
        RecipeStepItem(
          index: 2,
          heading: 'Ingredients Checklist',
          instructionText: 'Assemble your sprouted matki, fresh baker pav, mixed farsan, spices, and aromatics.',
          audioNarrationText: 'Check off your sprouted beans, farsan, and aromatics before lighting the stove.',
        ),
        RecipeStepItem(
          index: 3,
          heading: 'Cook Sprouted Matki',
          instructionText: 'Boil the sprouted moth beans with water, turmeric, and half a teaspoon of salt until tender yet holding their shape (about 7-8 minutes). Do not overcook into mush.',
          audioNarrationText: 'Simmer the sprouted matki with turmeric until tender but firm to the bite.',
          todos: [
            'Rinse sprouted matki thoroughly in cold water',
            'Add to pan with 2 cups of water and 1/4 tsp turmeric',
            'Simmer for 7-8 minutes until beans are soft when pinched',
            'Turn off heat and keep the cooked beans in their cooking broth',
          ],
        ),
        RecipeStepItem(
          index: 4,
          heading: 'Roast Maharashtrian Vatan Paste',
          instructionText: 'In a hot pan, roast dry shredded coconut until golden brown. Sauté sliced onions until deeply caramelized. Cool and blend with ginger and garlic into a fragrant, smooth spice paste.',
          audioNarrationText: 'Roast the dry coconut and onions until deeply browned, then blend into a rich vatan paste.',
          todos: [
            'Dry roast coconut shreds over low heat until deeply golden',
            'Sauté sliced onions with 1 tsp oil until dark caramel brown',
            'Combine in blender jar with ginger, garlic, and 2 tbsp water',
            'Purée until thick and smooth',
          ],
        ),
        RecipeStepItem(
          index: 5,
          heading: 'Simmer the Fiery Kat (Tarri)',
          instructionText: 'Heat oil in a kadai. Splutter mustard seeds and crackle curry leaves. Add the prepared vatan paste and sauté until oil separates. Stir in misal masala, red chili powder, chopped tomatoes, and boiled sprout water. Simmer on low heat until the vibrant red oil layer (tarri) floats on top.',
          audioNarrationText: 'Fry the vatan paste with misal masala and simmer until the iconic red oil tarri floats gracefully to the top.',
          todos: [
            'Heat 2 tbsp oil in heavy bottom kadai',
            'Crack mustard seeds and fresh curry leaves',
            'Sauté vatan paste for 3-4 minutes until oil glimmers on edges',
            'Stir in misal masala, Kashmiri chili powder, and tomatoes',
            'Pour in 3 cups of water including sprout broth',
            'Simmer gently for 10 minutes until the fiery red kat shines on the surface',
          ],
        ),
        RecipeStepItem(
          index: 6,
          heading: 'Assemble & Toast Pav',
          instructionText: 'In a deep serving bowl, add a generous ladle of cooked matki sprouts. Pour piping hot fiery kat over it. Heap high with crunchy mixed farsan, finely diced onions, and fresh coriander. Warm soft pav buns with butter on a griddle.',
          audioNarrationText: 'Layer the cooked sprouts, drown in hot spicy kat, crown with farsan, and serve with butter-toasted pav and lemon.',
          todos: [
            'Place 1 ladle of cooked matki at the bottom of each bowl',
            'Pour 2 generous ladles of boiling red kat (rassa) over the beans',
            'Top generously with crispy farsan',
            'Garnish with finely diced onions and chopped cilantro',
            'Toast pav buns with butter on hot pan and serve immediately with lemon wedges',
          ],
        ),
        RecipeStepItem(
          index: 7,
          heading: 'Tasting & Feedback',
          instructionText: 'Squeeze fresh lemon juice over the bubbling bowl, dip the warm pav into the kat, and savor the unforgettable crunch and spice.',
          audioNarrationText: 'Enjoy your sensational Misal Pav! Please share your feedback and cooking photo.',
        ),
      ],
      feedbackFormFields: const [
        DynamicFormFieldModel(
          id: 'dish_rating',
          title: 'How delicious was your Misal Pav?',
          type: FormFieldType.rating,
          isRequired: true,
          initialValue: 5,
        ),
        DynamicFormFieldModel(
          id: 'spice_level_choice',
          title: 'How was the spice level of the kat/rassa?',
          type: FormFieldType.singleChoice,
          options: ['Authentically Fiery & Zesty', 'Pleasantly Spicy', 'Too Hot!'],
          isRequired: true,
        ),
        DynamicFormFieldModel(
          id: 'texture_rating',
          title: 'Did the farsan maintain the perfect crunch?',
          type: FormFieldType.singleChoice,
          options: ['Crisp & Crunchy', 'Slightly Softened', 'Soggy'],
        ),
        DynamicFormFieldModel(
          id: 'notes',
          title: 'Chef Notes or Variations',
          type: FormFieldType.text,
          placeholder: 'E.g., Added potato pohe at the base or extra lemon...',
        ),
        DynamicFormFieldModel(
          id: 'misal_photo',
          title: 'Upload a picture of your fiery Misal Pav bowl',
          type: FormFieldType.imageUpload,
        ),
      ],
    ),
    'dish_pizza': DishDetailModel(
      id: 'dish_pizza',
      name: 'Neapolitan Margherita Pizza',
      imageUrl: 'https://images.unsplash.com/photo-1604382355076-af4b0eb60143?w=800',
      shareUrl: 'https://cukkie.com/recipe/dish_pizza',
      description: 'Artisan wood-fired style crust blistered with signature leopard spots, layered with sweet crushed Italian tomatoes, melted pools of creamy fresh mozzarella, fragrant sweet basil, and extra virgin olive oil.',
      history: 'Created in Naples in 1889 by pizzaiolo Raffaele Esposito to honor the visit of Queen Margherita of Savoy, this masterpiece proudly reflects the Italian tricolor: vibrant red tomatoes, white mozzarella, and fragrant green basil.',
      nutritionalBreakdown: {
        'Calories': '350 kcal',
        'Protein': '13 g',
        'Carbohydrates': '42 g',
        'Dietary Fiber': '3 g',
        'Fats': '12 g',
      },
      portionDefinition: const PortionDefinition(
        unit: 'pizzas',
        defaultAmount: 2.0,
        stepIncrement: 1.0,
        minAmount: 1.0,
        maxAmount: 6.0,
      ),
      ingredients: const [
        IngredientItem(id: 'i1', name: 'Tipo 00 or Strong Bread Flour', baseQuantity: 2.5, unit: 'cups'),
        IngredientItem(id: 'i2', name: 'Lukewarm Water', baseQuantity: 1.0, unit: 'cup'),
        IngredientItem(id: 'i3', name: 'Active Dry Yeast', baseQuantity: 1.0, unit: 'tsp'),
        IngredientItem(id: 'i4', name: 'Crushed Whole Peeled Italian Tomatoes', baseQuantity: 1.5, unit: 'cups'),
        IngredientItem(id: 'i5', name: 'Fresh Mozzarella Cheese (Torn)', baseQuantity: 200.0, unit: 'grams'),
        IngredientItem(id: 'i6', name: 'Fresh Sweet Basil Leaves', baseQuantity: 10.0, unit: 'leaves'),
        IngredientItem(id: 'i7', name: 'Extra Virgin Olive Oil', baseQuantity: 2.0, unit: 'tbsp'),
        IngredientItem(id: 'i8', name: 'Fine Sea Salt', baseQuantity: 1.0, unit: 'tsp'),
      ],
      steps: const [
        RecipeStepItem(
          index: 0,
          heading: 'Dish Overview',
          instructionText: 'Explore the storied heritage and authentic simplicity of Naples’ beloved Pizza Margherita.',
          audioNarrationText: 'Welcome to the art of Neapolitan pizza making. Let us craft pure artisan magic.',
        ),
        RecipeStepItem(
          index: 1,
          heading: 'Portion Size',
          instructionText: 'Choose how many 10-inch pizzas you will be baking today.',
          audioNarrationText: 'Select how many pizzas you are making today.',
        ),
        RecipeStepItem(
          index: 2,
          heading: 'Ingredients Checklist',
          instructionText: 'Gather your flour, yeast, crushed tomatoes, fresh mozzarella, and fresh sweet basil.',
          audioNarrationText: 'Prepare your flour, mozzarella, and fresh basil leaves on the prep counter.',
        ),
        RecipeStepItem(
          index: 3,
          heading: 'Knead and Proof Dough',
          instructionText: 'Whisk yeast into lukewarm water. Combine with flour and salt. Knead for 8-10 minutes until smooth, supple, and elastic. Cover with a damp towel and let rise for 1 hour until doubled.',
          audioNarrationText: 'Knead your dough until smooth and elastic, then allow it to rise until doubled in size.',
          todos: [
            'Dissolve yeast in lukewarm water for 5 minutes until frothy',
            'Mix flour and salt in large bowl, pour in yeast water',
            'Knead vigorously for 8-10 minutes until supple and non-sticky',
            'Shape into round balls, cover with damp cloth, rest for 60 minutes',
          ],
        ),
        RecipeStepItem(
          index: 4,
          heading: 'Stretch the Cornicione',
          instructionText: 'Press dough gently from center outward with fingertips, pushing air bubbles into the outer rim (cornicione). Stretch into a 10-inch round disc without tearing the center.',
          audioNarrationText: 'Gently push air bubbles to the crust rim and stretch into a classic round pizza disc.',
          todos: [
            'Dust work surface generously with semolina or flour',
            'Press fingers from center towards edges to form a raised rim',
            'Pick up dough and gently stretch over fists into a 10-inch round',
            'Transfer onto baking peel or preheated cast-iron surface',
          ],
        ),
        RecipeStepItem(
          index: 5,
          heading: 'Top with Sauce & Mozzarella',
          instructionText: 'Spoon crushed tomato sauce evenly, leaving a 1-inch border at the rim. Scatter torn fresh mozzarella chunks and drizzle lightly with extra virgin olive oil.',
          audioNarrationText: 'Spread sweet tomato sauce, scatter torn mozzarella, and drizzle fragrant olive oil.',
        ),
        RecipeStepItem(
          index: 6,
          heading: 'Bake at Blistering Heat',
          instructionText: 'Bake at highest possible oven temperature (250°C / 500°F or higher) on a preheated stone or cast iron pan until the crust blisters with charred leopard spots and the cheese bubbles golden.',
          audioNarrationText: 'Bake at maximum heat until the crust puffs up with golden blisters and melted cheese.',
          todos: [
            'Preheat oven and baking stone at maximum temperature for 30 minutes',
            'Slide pizza onto hot stone',
            'Bake for 6-8 minutes until crust is puffed and blistered',
            'Remove carefully with peel or tongs',
          ],
        ),
        RecipeStepItem(
          index: 7,
          heading: 'Tasting & Feedback',
          instructionText: 'Garnish immediately with fresh torn basil leaves and a final glug of cold olive oil. Slice and enjoy piping hot!',
          audioNarrationText: 'Crown with fresh sweet basil and extra virgin olive oil. Rate your artisan pizza below!',
        ),
      ],
      feedbackFormFields: const [
        DynamicFormFieldModel(
          id: 'dish_rating',
          title: 'How delicious was your Margherita Pizza?',
          type: FormFieldType.rating,
          isRequired: true,
          initialValue: 5,
        ),
        DynamicFormFieldModel(
          id: 'crust_texture',
          title: 'How was the crust texture?',
          type: FormFieldType.singleChoice,
          options: ['Crispy with Light Airy Chew', 'Soft & Pillowy', 'A Bit Dense'],
          isRequired: true,
        ),
        DynamicFormFieldModel(
          id: 'cheese_melt',
          title: 'How was the cheese melt?',
          type: FormFieldType.singleChoice,
          options: ['Creamy & Stretchy', 'Slightly Oily', 'Needed More Cheese'],
        ),
        DynamicFormFieldModel(
          id: 'notes',
          title: 'Baking notes or adjustments',
          type: FormFieldType.text,
          placeholder: 'E.g., Added red pepper flakes or garlic drizzle...',
        ),
        DynamicFormFieldModel(
          id: 'pizza_photo',
          title: 'Upload a picture of your bubbly pizza',
          type: FormFieldType.imageUpload,
        ),
      ],
    ),
    'dish_arrabbiata': DishDetailModel(
      id: 'dish_arrabbiata',
      name: 'Penne all\'Arrabbiata',
      imageUrl: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=800',
      shareUrl: 'https://cukkie.com/recipe/dish_arrabbiata',
      description: 'Al dente penne rigate coated in an intensely zesty Roman tomato sauce infused with toasted sliced garlic, fiery red chili flakes, extra virgin olive oil, and fresh flat-leaf parsley.',
      history: 'Born in early 20th century Rome, \'Arrabbiata\' translates literally to \'angry\', playfully named after the flushed red cheeks and sparkling eyes of diners enjoying its unmistakable chili heat.',
      nutritionalBreakdown: {
        'Calories': '330 kcal',
        'Protein': '10 g',
        'Carbohydrates': '56 g',
        'Dietary Fiber': '4 g',
        'Fats': '7 g',
      },
      portionDefinition: const PortionDefinition(
        unit: 'servings',
        defaultAmount: 2.0,
        stepIncrement: 1.0,
        minAmount: 1.0,
        maxAmount: 8.0,
      ),
      ingredients: const [
        IngredientItem(id: 'i1', name: 'Penne Rigate Pasta', baseQuantity: 250.0, unit: 'grams'),
        IngredientItem(id: 'i2', name: 'Whole Peeled Italian Tomatoes', baseQuantity: 400.0, unit: 'grams'),
        IngredientItem(id: 'i3', name: 'Fresh Garlic (Thinly Sliced)', baseQuantity: 4.0, unit: 'cloves'),
        IngredientItem(id: 'i4', name: 'Crushed Red Pepper Flakes', baseQuantity: 1.5, unit: 'tsp'),
        IngredientItem(id: 'i5', name: 'Extra Virgin Olive Oil', baseQuantity: 3.0, unit: 'tbsp'),
        IngredientItem(id: 'i6', name: 'Fresh Flat-Leaf Parsley (Chopped)', baseQuantity: 0.25, unit: 'cup'),
        IngredientItem(id: 'i7', name: 'Sea Salt for Pasta Water', baseQuantity: 1.0, unit: 'tbsp'),
      ],
      steps: const [
        RecipeStepItem(
          index: 0,
          heading: 'Dish Overview',
          instructionText: 'Explore Rome’s fiery culinary staple, celebrated for its minimal ingredients and maximum flavor.',
          audioNarrationText: 'Discover the fiery Roman classic, Penne all\'Arrabbiata. Simple, bold, and irresistible.',
        ),
        RecipeStepItem(
          index: 1,
          heading: 'Portion Size',
          instructionText: 'Select how many servings of pasta you wish to prepare.',
          audioNarrationText: 'Choose the number of servings to prepare.',
        ),
        RecipeStepItem(
          index: 2,
          heading: 'Ingredients Checklist',
          instructionText: 'Assemble your dry penne rigate, garlic cloves, red pepper flakes, tomatoes, and fresh parsley.',
          audioNarrationText: 'Lay out your pasta, sliced garlic, chili flakes, and olive oil on your counter.',
        ),
        RecipeStepItem(
          index: 3,
          heading: 'Boil Pasta al Dente',
          instructionText: 'Bring a large pot of water to a rolling boil with generous salt. Cook penne until 1 minute before al dente. Crucial: Reserve 1/2 cup of starchy pasta cooking water before draining.',
          audioNarrationText: 'Boil penne until just shy of al dente, and reserve half a cup of the starchy cooking water.',
          todos: [
            'Bring 3 liters of water to a vigorous boil with 1 tbsp coarse salt',
            'Drop in penne rigate and stir occasionally to prevent sticking',
            'Cook for 9-10 minutes until firm to the tooth (al dente)',
            'Scoop out and reserve 1/2 cup of cooking water before draining',
          ],
        ),
        RecipeStepItem(
          index: 4,
          heading: 'Sauté Garlic & Chili',
          instructionText: 'Warm extra virgin olive oil in a wide pan over gentle medium-low heat. Add thinly sliced garlic and crushed chili flakes. Swirl gently for 2 minutes until garlic turns pale gold and fragrant without browning.',
          audioNarrationText: 'Gently infuse the olive oil with sliced garlic and red chili flakes.',
          todos: [
            'Heat olive oil gently in skillet over medium-low heat',
            'Add sliced garlic and red chili flakes',
            'Sizzle for 90 seconds until garlic is fragrant and translucent',
            'Ensure garlic does not scorch or burn',
          ],
        ),
        RecipeStepItem(
          index: 5,
          heading: 'Simmer Fiery Sauce',
          instructionText: 'Pour in crushed Italian tomatoes with a pinch of salt. Simmer gently for 10-12 minutes until the sauce thickens and oil begins to separate.',
          audioNarrationText: 'Add tomatoes and simmer until thick, rich, and fragrant.',
        ),
        RecipeStepItem(
          index: 6,
          heading: 'Toss Pasta with Starchy Emulsion',
          instructionText: 'Transfer drained penne directly into the simmering sauce. Splash in 2-3 tablespoons of reserved pasta water. Toss vigorously over high heat for 1 minute until sauce clings glossily to every ridge.',
          audioNarrationText: 'Toss hot penne with the bubbling sauce and starchy water until completely coated.',
          todos: [
            'Add drained hot penne directly to the sauce pan',
            'Pour in 3 tablespoons of starchy reserved pasta water',
            'Toss vigorously for 60 seconds until sauce emulsifies into a glossy coat',
            'Turn off heat and stir in freshly chopped parsley',
          ],
        ),
        RecipeStepItem(
          index: 7,
          heading: 'Tasting & Feedback',
          instructionText: 'Plate immediately with a drizzle of virgin olive oil and more parsley. Savor the warm Roman heat!',
          audioNarrationText: 'Enjoy your hot, zesty Penne all\'Arrabbiata! Please leave your feedback.',
        ),
      ],
      feedbackFormFields: const [
        DynamicFormFieldModel(
          id: 'dish_rating',
          title: 'How did you enjoy your Penne all\'Arrabbiata?',
          type: FormFieldType.rating,
          isRequired: true,
          initialValue: 5,
        ),
        DynamicFormFieldModel(
          id: 'spice_balance',
          title: 'How was the chili kick?',
          type: FormFieldType.singleChoice,
          options: ['Authentic Fiery Roman Kick', 'Mild & Pleasant', 'Too Spicy!'],
          isRequired: true,
        ),
        DynamicFormFieldModel(
          id: 'pasta_doneness',
          title: 'How was the pasta firmness?',
          type: FormFieldType.singleChoice,
          options: ['Perfect Al Dente Chew', 'Slightly Soft', 'Too Firm'],
        ),
        DynamicFormFieldModel(
          id: 'notes',
          title: 'Chef notes',
          type: FormFieldType.text,
          placeholder: 'E.g., Added Pecorino Romano or extra parsley...',
        ),
        DynamicFormFieldModel(
          id: 'pasta_photo',
          title: 'Upload a picture of your glossy Arrabbiata',
          type: FormFieldType.imageUpload,
        ),
      ],
    ),
  };

  // ---------- HINDI RECIPES ----------
  static final Map<String, DishDetailModel> _hindiDishDetails = {
    'dish_paratha': DishDetailModel(
      id: 'dish_paratha',
      name: 'आलू गोभी परांठा',
      imageUrl: 'https://images.unsplash.com/photo-1626074353765-517a681e40be?w=800',
      shareUrl: 'https://cukkie.com/recipe/dish_paratha',
      description: 'सुनहरा, कुरकुरा साबुत गेहूं का परांठा, मसालेदार आलू और फूलगोभी के भरावन से भरपूर, गर्म तवे पर शुद्ध देसी घी में सिका हुआ।',
      history: 'पंजाब के उपजाऊ खेतों और पारंपरिक रसोइयों से उपजा भरावां परांठा हमेशा से ऊर्जा और ताजगी से भरपूर नाश्ता रहा है।',
      nutritionalBreakdown: {
        'कैलोरी': '290 किलोकैलोरी',
        'प्रोटीन': '7 ग्राम',
        'कार्बोहाइड्रेट': '48 ग्राम',
        'आहारीय फाइबर': '6 ग्राम',
        'वसा': '8 ग्राम',
      },
      portionDefinition: const PortionDefinition(
        unit: 'परांठे',
        defaultAmount: 4.0,
        stepIncrement: 1.0,
        minAmount: 1.0,
        maxAmount: 12.0,
      ),
      ingredients: const [
        IngredientItem(id: 'i1', name: 'गेहूं का आटा', baseQuantity: 2.0, unit: 'कप'),
        IngredientItem(id: 'i2', name: 'उबले आलू', baseQuantity: 3.0, unit: 'मध्यम टुकड़े'),
        IngredientItem(id: 'i3', name: 'कद्दूकस की हुई फूलगोभी', baseQuantity: 1.0, unit: 'कप'),
        IngredientItem(id: 'i4', name: 'बारीक कटी हरी मिर्च', baseQuantity: 2.0, unit: 'मिर्च'),
        IngredientItem(id: 'i5', name: 'अजवाइन', baseQuantity: 0.5, unit: 'छोटा चम्मच'),
        IngredientItem(id: 'i6', name: 'आमचूर पाउडर', baseQuantity: 1.0, unit: 'छोटा चम्मच'),
        IngredientItem(id: 'i7', name: 'देसी घी या मक्खन', baseQuantity: 3.0, unit: 'बड़ा चम्मच'),
        IngredientItem(id: 'i8', name: 'ताजा हरा धनिया', baseQuantity: 0.25, unit: 'कप'),
      ],
      steps: const [
        RecipeStepItem(
          index: 0,
          heading: 'व्यंजन का परिचय',
          instructionText: 'पारंपरिक आलू गोभी परांठे के समृद्ध इतिहास और पौष्टिक तत्वों के बारे में जानें।',
          audioNarrationText: 'कुकी में आपका स्वागत है। आइए आलू गोभी परांठे की स्वादिष्ट यात्रा शुरू करते हैं।',
        ),
        RecipeStepItem(
          index: 1,
          heading: 'भाग का आकार चुनें',
          instructionText: 'आज आप कितने कुरकुरे परांठे बनाना चाहते हैं, चुनें। सामग्री की मात्रा स्वतः बदल जाएगी।',
          audioNarrationText: 'जितने परांठे बनाने हैं, संख्या चुनें। सभी सामग्री अपने आप समायोजित हो जाएगी।',
        ),
        RecipeStepItem(
          index: 2,
          heading: 'सामग्री चेकलिस्ट',
          instructionText: 'सामग्री की जांच करें और रसोई काउंटर पर सजाएं। प्रत्येक सामग्री पर टिक लगाएं।',
          audioNarrationText: 'यहाँ आपकी ताज़ा सामग्री की सूची है। सब कुछ इकट्ठा करें और टिक लगाएं।',
        ),
        RecipeStepItem(
          index: 3,
          heading: 'आटा गूंथें',
          instructionText: 'गेहूं के आटे में चुटकी भर नमक और गुनगुना पानी डालकर नरम और लचीला आटा गूंथें। थोड़ा घी लगाकर 15 मिनट के लिए ढककर रख दें।',
          audioNarrationText: 'आटे को नरम और लचीला होने तक गूंथें। पंद्रह मिनट के लिए कपड़े से ढककर रख दें।',
          todos: [
            'मिक्सिंग बाउल में गेहूं का आटा और चुटकी भर नमक डालें',
            'गूंथते समय धीरे-धीरे गुनगुना पानी मिलाएं',
            'नरम और चिकना होने तक 5 मिनट तक अच्छी तरह गूंथें',
            'आधा चम्मच घी लगाएं, ढकें और 15 मिनट आराम दें',
          ],
        ),
        RecipeStepItem(
          index: 4,
          heading: 'मसालेदार भरावन तैयार करें',
          instructionText: 'एक बड़े कटोरे में उबले आलू अच्छी तरह मैश करें। कद्दूकस गोभी, हरी मिर्च, मसाले और धनिया मिलाएं।',
          audioNarrationText: 'आलू को मैश करें और उसमें गोभी, हरी मिर्च और सुगंधित मसाले मिलाएं।',
          todos: [
            'उबले आलू को बिना किसी गांठ के अच्छी तरह मैश करें',
            'कद्दूकस गोभी और बारीक कटी हरी मिर्च मिलाएं',
            'अजवाइन, आमचूर पाउडर, गरम मसाला और नमक डालें',
            'बारीक कटा हरा धनिया डालकर एकसार मिलाएं',
          ],
        ),
        RecipeStepItem(
          index: 5,
          heading: 'परांठा भरें और बेलें',
          instructionText: 'आटे की लोई बनाएं, किनारों को पतला करें, बीच में भरावन रखें, किनारों को मोड़कर सील करें और हल्के हाथ से गोल बेलें।',
          audioNarrationText: 'मसालेदार भरावन को आटे की लोई में भरें और हल्के हाथों से गोल परांठा बेलें।',
        ),
        RecipeStepItem(
          index: 6,
          heading: 'तवे पर कुरकुरा सेकें',
          instructionText: 'मध्यम आंच पर गर्म तवे पर परांठा डालें। दोनों तरफ सुनहरे धब्बे आने तक सेकें और देसी घी लगाकर फूलाएं।',
          audioNarrationText: 'गर्म तवे पर परांठे को दोनों तरफ देसी घी लगाकर सुनहरा और कुरकुरा सेकें।',
          todos: [
            'बेले हुए परांठे को पहले से गर्म तवे पर डालें',
            'बुलबुले उठने पर 45 सेकंड बाद पलटें',
            'ऊपरी सतह पर 1 चम्मच देसी घी लगाएं',
            'पलटकर किनारों को दबाते हुए सुनहरा और कुरकुरा होने तक सेकें',
          ],
        ),
        RecipeStepItem(
          index: 7,
          heading: 'स्वाद और प्रतिक्रिया',
          instructionText: 'सफेद मक्खन, ठंडे दही और आम के अचार के साथ गरमागरम परोसें। नीचे अपना अनुभव साझा करें।',
          audioNarrationText: 'बधाई हो! आपके गरमागरम परांठे तैयार हैं। स्वाद लें और अपनी प्रतिक्रिया दें।',
        ),
      ],
      feedbackFormFields: const [
        DynamicFormFieldModel(
          id: 'dish_rating',
          title: 'आपके परांठे कितने स्वादिष्ट बने?',
          type: FormFieldType.rating,
          isRequired: true,
          initialValue: 5,
        ),
        DynamicFormFieldModel(
          id: 'crispiness_choice',
          title: 'परांठे की बनावट कैसी थी?',
          type: FormFieldType.singleChoice,
          options: ['एकदम कुरकुरी और खस्ता', 'नरम और मुलायम', 'थोड़ी कच्ची'],
          isRequired: true,
        ),
        DynamicFormFieldModel(
          id: 'side_pairings',
          title: 'आपने परांठे किसके साथ परोसे?',
          type: FormFieldType.multipleChoice,
          options: ['ताजा दही / रायता', 'देसी सफेद मक्खन', 'आम का अचार', 'गरमागरम चाय'],
        ),
        DynamicFormFieldModel(
          id: 'chef_notes',
          title: 'कोई विशेष पाक सुझाव या बदलाव?',
          type: FormFieldType.text,
          placeholder: 'उदा. भरावन में थोड़ी कसूरी मेथी मिलाई...',
        ),
        DynamicFormFieldModel(
          id: 'dish_photo',
          title: 'तैयार परांठे की तस्वीर अपलोड करें',
          type: FormFieldType.imageUpload,
        ),
      ],
    ),
    'dish_halwa': DishDetailModel(
      id: 'dish_halwa',
      name: 'सूजी का हलवा (शीरा)',
      imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=800',
      shareUrl: 'https://cukkie.com/recipe/dish_halwa',
      description: 'शुद्ध देसी घी में धीमी आंच पर भुनी हुई सूजी, हरी इलायची, केसर और भुने बादाम-काजू की खुशबू से महकता पारंपरिक मीठा व्यंजन।',
      history: 'भारतीय घरों में प्रसाद और उत्सवों की मिठास के रूप में सूजी का हलवा सदियों से प्रेम और सत्कार का प्रतीक रहा है।',
      nutritionalBreakdown: {
        'कैलोरी': '310 किलोकैलोरी',
        'प्रोटीन': '5 ग्राम',
        'कार्बोहाइड्रेट': '52 ग्राम',
        'वसा': '11 ग्राम',
      },
      portionDefinition: const PortionDefinition(
        unit: 'ग्राम',
        defaultAmount: 250.0,
        stepIncrement: 50.0,
        minAmount: 100.0,
        maxAmount: 1000.0,
      ),
      ingredients: const [
        IngredientItem(id: 'i1', name: 'बारीक सूजी / रवा', baseQuantity: 100.0, unit: 'ग्राम'),
        IngredientItem(id: 'i2', name: 'शुद्ध देसी घी', baseQuantity: 80.0, unit: 'ग्राम'),
        IngredientItem(id: 'i3', name: 'चीनी', baseQuantity: 90.0, unit: 'ग्राम'),
        IngredientItem(id: 'i4', name: 'पानी / दूध', baseQuantity: 300.0, unit: 'मिली'),
        IngredientItem(id: 'i5', name: 'इलायची पाउडर', baseQuantity: 0.5, unit: 'छोटा चम्मच'),
        IngredientItem(id: 'i6', name: 'केसर के धागे', baseQuantity: 8.0, unit: 'धागे', isOptional: true),
        IngredientItem(id: 'i7', name: 'कटे हुए बादाम और काजू', baseQuantity: 20.0, unit: 'ग्राम'),
      ],
      steps: const [
        RecipeStepItem(
          index: 0,
          heading: 'व्यंजन का परिचय',
          instructionText: 'पारंपरिक देसी घी से बने सूजी के हलवे की मीठी विरासत और खुशबू का अनुभव करें।',
          audioNarrationText: 'नमस्ते! आइए मिलकर बनाएं सुगंधित और स्वादिष्ट पारंपरिक सूजी का हलवा।',
        ),
        RecipeStepItem(
          index: 1,
          heading: 'मात्रा का चयन',
          instructionText: 'हलवे की मात्रा (ग्राम में) चुनें। सामग्री उसी अनुसार समायोजित होगी।',
          audioNarrationText: 'हलवे की कुल मात्रा चुनें। सभी माप अपने आप बदल जाएंगे।',
        ),
        RecipeStepItem(
          index: 2,
          heading: 'सामग्री चेकलिस्ट',
          instructionText: 'सूजी, घी, चीनी, दूध और मेवे इकट्ठे करें और सूची में टिक लगाएं।',
          audioNarrationText: 'सूजी, शुद्ध देसी घी और मेवे निकाल लें और चेकलिस्ट पर टिक करें।',
        ),
        RecipeStepItem(
          index: 3,
          heading: 'मेवे और सूजी भूनें',
          instructionText: 'कड़ाही में घी गर्म करें, मेवे तलकर निकालें, फिर सूजी डालकर धीमी आंच पर गुलाबी और खुशबूदार होने तक भूनें।',
          audioNarrationText: 'धीमी आंच पर सूजी को घी में तब तक भूनें जब तक सौंधी खुशबू न आने लगे।',
          todos: [
            'भारी कड़ाही में 2 चम्मच घी गर्म करें और काजू-बादाम तलें',
            'मेवे निकालकर सजावट के लिए अलग रख लें',
            'बचे हुए घी में सूजी डालें और धीमी आंच पर लगातार चलाते रहें',
            '8-10 मिनट तक हल्का गुलाबी होने तक भूनें',
          ],
        ),
        RecipeStepItem(
          index: 4,
          heading: 'गर्म दूध और केसर मिलाएं',
          instructionText: 'भुनी सूजी में गर्म केसरिया दूध धीरे-धीरे डालें और गांठ न पड़ने दें। ढककर धीमी आंच पर 3 मिनट पकाएं।',
          audioNarrationText: 'लगातार चलाते हुए गर्म केसर का दूध मिलाएं ताकि कोई गांठ न बने।',
          todos: [
            'अलग बर्तन में दूध और केसर को हल्का उबालें',
            'सूजी में धीरे-धीरे गर्म दूध डालें और व्हिस्क से मिलाएं',
            'कड़ाही को ढकें और सूजी को फूलने दें',
          ],
        ),
        RecipeStepItem(
          index: 5,
          heading: 'चीनी और इलायची मिलाएं',
          instructionText: 'चीनी और इलायची पाउडर डालकर मिलाएं। हलवा चमकदार और घी छोड़ने लगेगा। ऊपर से भुने मेवे डालें।',
          audioNarrationText: 'चीनी और इलायची पाउडर मिलाएं और हलवे की मखमली चमक देखें।',
        ),
        RecipeStepItem(
          index: 6,
          heading: 'स्वाद और समीक्षा',
          instructionText: 'गरमागरम हलवे का आनंद लें और बताएं कि मिठास कैसी रही!',
          audioNarrationText: 'स्वादिष्ट हलवे का आनंद लें और अपनी राय हमारे साथ साझा करें।',
        ),
      ],
      feedbackFormFields: const [
        DynamicFormFieldModel(
          id: 'dish_rating',
          title: 'हलवे का स्वाद और बनावट कैसी थी?',
          type: FormFieldType.rating,
          isRequired: true,
          initialValue: 5,
        ),
        DynamicFormFieldModel(
          id: 'sweetness_rating',
          title: 'क्या मिठास एकदम सही थी?',
          type: FormFieldType.singleChoice,
          options: ['बिल्कुल संतुलित मिठास', 'ज्यादा मीठा', 'कम मीठा'],
          isRequired: true,
        ),
        DynamicFormFieldModel(
          id: 'feedback_notes',
          title: 'आपकी टिप्पणी या अनुभव',
          type: FormFieldType.text,
          placeholder: 'भूनने का समय, बनावट आदि के बारे में...',
        ),
        DynamicFormFieldModel(
          id: 'halwa_photo',
          title: 'अपने बने हुए शीरा/हलवे की तस्वीर अपलोड करें',
          type: FormFieldType.imageUpload,
        ),
      ],
    ),
    'dish_pbm': DishDetailModel(
      id: 'dish_pbm',
      name: 'पनीर बटर मसाला',
      imageUrl: 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=800',
      shareUrl: 'https://cukkie.com/recipe/dish_pbm',
      description: 'ताजे मखमली पनीर के टुकड़े, टमाटर-काजू की मखमली ग्रेवी में कसूरी मेथी और मक्खन के साथ धीमी आंच पर पकाए गए।',
      history: '1950 के दशक में दिल्ली के शाही बावर्चीखानों में जन्मी यह ग्रेवी पके टमाटरों, मक्खन और कसूरी मेथी का सर्वोत्तम संगम है।',
      nutritionalBreakdown: {
        'कैलोरी': '380 किलोकैलोरी',
        'प्रोटीन': '14 ग्राम',
        'कार्बोहाइड्रेट': '22 ग्राम',
        'वसा': '28 ग्राम',
      },
      portionDefinition: const PortionDefinition(
        unit: 'भाग (सर्विंग्स)',
        defaultAmount: 3.0,
        stepIncrement: 1.0,
        minAmount: 1.0,
        maxAmount: 8.0,
      ),
      ingredients: const [
        IngredientItem(id: 'i1', name: 'ताजा पनीर (क्यूब्स)', baseQuantity: 250.0, unit: 'ग्राम'),
        IngredientItem(id: 'i2', name: 'पके लाल टमाटर', baseQuantity: 4.0, unit: 'बड़े'),
        IngredientItem(id: 'i3', name: 'काजू', baseQuantity: 15.0, unit: 'दाने'),
        IngredientItem(id: 'i4', name: 'ताजा मक्खन', baseQuantity: 2.0, unit: 'बड़ा चम्मच'),
        IngredientItem(id: 'i5', name: 'ताजा मलाई (क्रीम)', baseQuantity: 3.0, unit: 'बड़ा चम्मच'),
        IngredientItem(id: 'i6', name: 'कसूरी मेथी', baseQuantity: 1.0, unit: 'छोटा चम्मच'),
        IngredientItem(id: 'i7', name: 'अदरक-लहसुन पेस्ट', baseQuantity: 1.0, unit: 'बड़ा चम्मच'),
      ],
      steps: const [
        RecipeStepItem(
          index: 0,
          heading: 'व्यंजन का परिचय',
          instructionText: 'शाही पनीर बटर मसाला की मखमली ग्रेवी और पौष्टिक तत्वों के बारे में जानें।',
          audioNarrationText: 'शाही पनीर बटर मसाला की समृद्ध खुशबू और मखमली स्वाद की दुनिया में आपका स्वागत है।',
        ),
        RecipeStepItem(
          index: 1,
          heading: 'सर्विंग्स चुनें',
          instructionText: 'जितने लोगों के लिए बनाना है, संख्या चुनें। सामग्री अपने आप स्केल हो जाएगी।',
          audioNarrationText: 'कितने लोगों के लिए पकाना है, चुनें। सभी मात्राएं स्वतः बदल जाएंगी।',
        ),
        RecipeStepItem(
          index: 2,
          heading: 'सामग्री चेकलिस्ट',
          instructionText: 'पनीर, टमाटर, भीगे काजू, मक्खन और मसाले तैयार करें।',
          audioNarrationText: 'अपनी सामग्री रसोई पटल पर रखें और एक-एक करके टिक करें।',
        ),
        RecipeStepItem(
          index: 3,
          heading: 'मखमली ग्रेवी बेस तैयार करें',
          instructionText: 'टमाटर और काजू को पानी में 10 मिनट उबालें, फिर मिक्सी में पीसकर रेशमी प्यूरी बनाएं और छान लें।',
          audioNarrationText: 'टमाटर और काजू उबालकर बिल्कुल मखमली प्यूरी बना लें और छलनी से छान लें।',
          todos: [
            'टमाटर काटकर काजू और पानी के साथ पैन में डालें',
            'टमाटर का छिलका अलग होने तक 10 मिनट उबालें',
            'ठंडा करके मिक्सी में एकदम बारीक मखमली पेस्ट बनाएं',
            'रेस्टोरेंट जैसी बनावट के लिए छलनी से छान लें',
          ],
        ),
        RecipeStepItem(
          index: 4,
          heading: 'ग्रेवी को मक्खन में पकाएं',
          instructionText: 'कड़ाही में मक्खन पिघलाएं, अदरक-लहसुन पेस्ट भूनें, मसाले डालें और छानी हुई प्यूरी डालकर मक्खन छूटने तक पकाएं।',
          audioNarrationText: 'मक्खन में अदरक-लहसुन और मसालों के साथ ग्रेवी को तब तक पकाएं जब तक मक्खन न तैरने लगे।',
        ),
        RecipeStepItem(
          index: 5,
          heading: 'पनीर और मलाई मिलाएं',
          instructionText: 'पनीर के टुकड़े धीरे से डालें। 3 मिनट धीमी आंच पर पकाएं, फिर कसूरी मेथी और ताजी मलाई डालकर गैस बंद कर दें।',
          audioNarrationText: 'नरम पनीर के टुकड़े डालें, ऊपर से कसूरी मेथी और ताजी मलाई डालकर आंच बंद करें।',
          todos: [
            'पनीर को 5 मिनट गुनगुने पानी में रखें ताकि वह स्पंजी रहे',
            'पनीर को ग्रेवी में बिना तोड़े हल्के हाथ से मिलाएं',
            'कसूरी मेथी को हथेलियों से रगड़कर छिड़कें',
            'ताजी क्रीम मिलाएं और तुरंत आंच बंद कर दें',
          ],
        ),
        RecipeStepItem(
          index: 6,
          heading: 'स्वाद और समीक्षा',
          instructionText: 'गरमागरम नान या जीरा राइस के साथ परोसें और अपने अनुभव की समीक्षा करें!',
          audioNarrationText: 'गरमागरम नान के साथ परोसें। कृपया अपनी रेटिंग और समीक्षा दें।',
        ),
      ],
      feedbackFormFields: const [
        DynamicFormFieldModel(
          id: 'dish_rating',
          title: 'पनीर बटर मसाला कितना स्वादिष्ट बना?',
          type: FormFieldType.rating,
          isRequired: true,
          initialValue: 5,
        ),
        DynamicFormFieldModel(
          id: 'richness_choice',
          title: 'ग्रेवी की मखमली बनावट कैसी थी?',
          type: FormFieldType.singleChoice,
          options: ['एकदम रेशमी व परफेक्ट', 'थोड़ी गाढ़ी', 'ज्यादा पतली'],
          isRequired: true,
        ),
        DynamicFormFieldModel(
          id: 'pairing_options',
          title: 'आपने किसके साथ परोसा?',
          type: FormFieldType.multipleChoice,
          options: ['बटर नान', 'जीरा राइस', 'तंदूरी रोटी', 'परांठा'],
        ),
        DynamicFormFieldModel(
          id: 'comments',
          title: 'व्यक्तिगत सुझाव या पाक नोट्स',
          type: FormFieldType.text,
          placeholder: 'बताएं कि आपके परिवार को यह कैसा लगा...',
        ),
        DynamicFormFieldModel(
          id: 'curry_photo',
          title: 'पनीर बटर मसाला की तस्वीर अपलोड करें',
          type: FormFieldType.imageUpload,
        ),
      ],
    ),
    'dish_misal': DishDetailModel(
      id: 'dish_misal',
      name: 'प्रामाणिक मिसल पाव',
      imageUrl: 'https://images.unsplash.com/photo-1606491956689-2ea866880c84?w=800',
      shareUrl: 'https://cukkie.com/recipe/dish_misal',
      description: 'अंकुरित मोठ की तीखी और चटपटी महाराष्ट्रीयन करी, तीखी लाल तरी और कुरकुरे फरसाण के साथ, गर्म पाव संग परोसी गई।',
      history: 'कोल्हापुर और पुणे की जीवंत गलियों से निकली मिसल पाव महाराष्ट्र का सबसे प्रिय और प्रोटीन से भरपूर नाश्ता है।',
      nutritionalBreakdown: {
        'कैलोरी': '420 किलोकैलोरी',
        'प्रोटीन': '16 ग्राम',
        'कार्बोहाइड्रेट': '54 ग्राम',
        'आहारीय फाइबर': '9 ग्राम',
        'वसा': '14 ग्राम',
      },
      portionDefinition: const PortionDefinition(
        unit: 'थाली (प्लेट्स)',
        defaultAmount: 2.0,
        stepIncrement: 1.0,
        minAmount: 1.0,
        maxAmount: 8.0,
      ),
      ingredients: const [
        IngredientItem(id: 'i1', name: 'अंकुरित मोठ (मटकी)', baseQuantity: 1.5, unit: 'कप'),
        IngredientItem(id: 'i2', name: 'ताजे पाव', baseQuantity: 4.0, unit: 'टुकड़े'),
        IngredientItem(id: 'i3', name: 'मिक्स्ड फरसाण', baseQuantity: 1.0, unit: 'कप'),
        IngredientItem(id: 'i4', name: 'बारीक कटे प्याज', baseQuantity: 2.0, unit: 'मध्यम'),
        IngredientItem(id: 'i5', name: 'पके टमाटर', baseQuantity: 2.0, unit: 'मध्यम'),
        IngredientItem(id: 'i6', name: 'भुना सूखा नारियल (खोपरा)', baseQuantity: 0.25, unit: 'कप'),
        IngredientItem(id: 'i7', name: 'मिसल / गोडा मसाला', baseQuantity: 2.0, unit: 'बड़ा चम्मच'),
        IngredientItem(id: 'i8', name: 'अदरक-लहसुन पेस्ट', baseQuantity: 1.0, unit: 'बड़ा चम्मच'),
        IngredientItem(id: 'i9', name: 'राई और कढ़ी पत्ता', baseQuantity: 1.0, unit: 'छोटा चम्मच'),
        IngredientItem(id: 'i10', name: 'नींबू के टुकड़े', baseQuantity: 2.0, unit: 'टुकड़े'),
      ],
      steps: const [
        RecipeStepItem(
          index: 0,
          heading: 'व्यंजन का परिचय',
          instructionText: 'कोल्हापुरी व पुणेरी मिसल पाव के चटपटे इतिहास और प्रोटीन की शक्ति को जानें।',
          audioNarrationText: 'प्रामाणिक मिसल पाव की तीखी और चटपटी दुनिया में आपका स्वागत है।',
        ),
        RecipeStepItem(
          index: 1,
          heading: 'प्लेटों की संख्या चुनें',
          instructionText: 'आज आप कितनी प्लेट मिसल पाव तैयार करना चाहते हैं, चुनें।',
          audioNarrationText: 'जितनी प्लेट बनानी हैं, संख्या चुनें।',
        ),
        RecipeStepItem(
          index: 2,
          heading: 'सामग्री चेकलिस्ट',
          instructionText: 'अंकुरित मटकी, ताजा पाव, फरसाण और मसालों को काउंटर पर सजाएं।',
          audioNarrationText: 'अंकुरित मटकी, फरसाण और मसाले इकट्ठा करें और चेकलिस्ट पर टिक लगाएं।',
        ),
        RecipeStepItem(
          index: 3,
          heading: 'मटकी उबालें',
          instructionText: 'अंकुरित मटकी को हल्दी और नमक के साथ 7-8 मिनट तक उबालें ताकि वह नरम हो जाए लेकिन घुले नहीं।',
          audioNarrationText: 'मटकी को हल्दी और नमक के साथ तब तक उबालें जब तक वह नरम न हो जाए।',
          todos: [
            'अंकुरित मटकी को साफ पानी से धो लें',
            'पैन में 2 कप पानी और 1/4 चम्मच हल्दी डालकर उबालें',
            '7-8 मिनट तक नरम होने तक पकाएं',
            'गैस बंद करें और मटकी को उबले पानी में ही रहने दें',
          ],
        ),
        RecipeStepItem(
          index: 4,
          heading: 'वाटण (मसाला पेस्ट) भूनें',
          instructionText: 'सूखे नारियल को सुनहरा भूनें और प्याज को भूरा भूनें। अदरक-लहसुन के साथ मिक्सी में बारीक पीस लें।',
          audioNarrationText: 'सूखा नारियल और प्याज भूनकर खुशबूदार वाटण पेस्ट तैयार करें।',
          todos: [
            'सूखे नारियल को धीमी आंच पर सुनहरा भूनें',
            'कटे प्याज को तेल में गहरा भूरा होने तक भूनें',
            'अदरक, लहसुन और 2 चम्मच पानी के साथ मिक्सी में पीसें',
          ],
        ),
        RecipeStepItem(
          index: 5,
          heading: 'तीखा कट (तरी) तैयार करें',
          instructionText: 'कड़ाही में तेल गरम करें, राई और कढ़ी पत्ता तड़काएं। वाटण और मिसल मसाला भूनकर मटकी का पानी डालें और तरी आने तक उबालें।',
          audioNarrationText: 'मसालों को तेल में भूनें और धीमी आंच पर उबालें जब तक लाल तरी ऊपर न तैरने लगे।',
          todos: [
            'कड़ाही में 2 बड़े चम्मच तेल गरम करें',
            'राई और कढ़ी पत्ता तड़काएं',
            'वाटण पेस्ट को 3-4 मिनट तक तेल छूटने तक भूनें',
            'मिसल मसाला, कश्मीरी लाल मिर्च और टमाटर मिलाएं',
            'मटकी का पानी और 2 कप सादा पानी डालें',
            '10 मिनट तक उबालें जब तक लाल तरी ऊपर न आ जाए',
          ],
        ),
        RecipeStepItem(
          index: 6,
          heading: 'प्लेटिंग और पाव सेकना',
          instructionText: 'कटोरे में उबली मटकी डालें, ऊपर से खौलता हुआ तीखा कट डालें, ढेर सारा फरसाण, प्याज और धनिया डालें। मक्खन में सिके पाव संग परोसें।',
          audioNarrationText: 'कटोरे में मटकी डालें, गर्म कट डालें, फरसाण और प्याज से सजाएं और मक्खन वाले पाव के साथ परोसें।',
          todos: [
            'कटोरे के तले में 1 करछुल उबली मटकी डालें',
            'ऊपर से 2 करछुल खौलता हुआ लाल कट (रस्सा) डालें',
            'कुरकुरे फरसाण की परत लगाएं',
            'बारीक प्याज और हरा धनिया छिड़कें',
            'तवे पर मक्खन लगाकर पाव सेकें और नींबू के साथ गरमागरम परोसें',
          ],
        ),
        RecipeStepItem(
          index: 7,
          heading: 'स्वाद और समीक्षा',
          instructionText: 'नींबू निचोड़ें, गर्म पाव कट में डुबोएं और चटपटे स्वाद का आनंद लें। अपनी प्रतिक्रिया दें।',
          audioNarrationText: 'शानदार मिसल पाव का आनंद लें! कृपया अपनी रेटिंग और तस्वीर साझा करें।',
        ),
      ],
      feedbackFormFields: const [
        DynamicFormFieldModel(
          id: 'dish_rating',
          title: 'मिसल पाव का स्वाद कैसा लगा?',
          type: FormFieldType.rating,
          isRequired: true,
          initialValue: 5,
        ),
        DynamicFormFieldModel(
          id: 'spice_level_choice',
          title: 'कट/रस्से का तीखापन कैसा था?',
          type: FormFieldType.singleChoice,
          options: ['प्रामाणिक तीखा और चटपटा', 'हल्का तीखा', 'बहुत ज्यादा तीखा!'],
          isRequired: true,
        ),
        DynamicFormFieldModel(
          id: 'texture_rating',
          title: 'क्या फरसाण कुरकुरा रहा?',
          type: FormFieldType.singleChoice,
          options: ['एकदम कुरकुरा', 'हल्का नरम', 'गीला'],
        ),
        DynamicFormFieldModel(
          id: 'notes',
          title: 'कोई व्यक्तिगत सुझाव?',
          type: FormFieldType.text,
          placeholder: 'उदा. नीचे पोहा डाला या अधिक नींबू...',
        ),
        DynamicFormFieldModel(
          id: 'misal_photo',
          title: 'तैयार मिसल पाव की तस्वीर अपलोड करें',
          type: FormFieldType.imageUpload,
        ),
      ],
    ),
    'dish_pizza': DishDetailModel(
      id: 'dish_pizza',
      name: 'नेपोलिटन मार्गेरिटा पिज़्ज़ा',
      imageUrl: 'https://images.unsplash.com/photo-1604382355076-af4b0eb60143?w=800',
      shareUrl: 'https://cukkie.com/recipe/dish_pizza',
      description: 'लकड़ी की भट्टी की शैली का कुरकुरा क्रस्ट, इटैलियन टमाटर सॉस, मोज़ेरेला चीज़, ताज़ी तुलसी की पत्तियां और ऑलिव ऑयल।',
      history: '1889 में नेपल्स में रानी मार्गेरिटा के सम्मान में बनाया गया यह पिज़्ज़ा इटैलियन झंडे के रंगों का प्रतिनिधित्व करता है।',
      nutritionalBreakdown: {
        'कैलोरी': '350 किलोकैलोरी',
        'प्रोटीन': '13 ग्राम',
        'कार्बोहाइड्रेट': '42 ग्राम',
        'आहारीय फाइबर': '3 ग्राम',
        'वसा': '12 ग्राम',
      },
      portionDefinition: const PortionDefinition(
        unit: 'पिज़्ज़ा',
        defaultAmount: 2.0,
        stepIncrement: 1.0,
        minAmount: 1.0,
        maxAmount: 6.0,
      ),
      ingredients: const [
        IngredientItem(id: 'i1', name: 'मैदा / ब्रेड आटा', baseQuantity: 2.5, unit: 'कप'),
        IngredientItem(id: 'i2', name: 'गुनगुना पानी', baseQuantity: 1.0, unit: 'कप'),
        IngredientItem(id: 'i3', name: 'एक्टिव ड्राई यीस्ट', baseQuantity: 1.0, unit: 'छोटा चम्मच'),
        IngredientItem(id: 'i4', name: 'कुचले हुए इटैलियन टमाटर', baseQuantity: 1.5, unit: 'कप'),
        IngredientItem(id: 'i5', name: 'ताजा मोज़ेरेला चीज़', baseQuantity: 200.0, unit: 'ग्राम'),
        IngredientItem(id: 'i6', name: 'ताजा बेसिल (तुलसी) के पत्ते', baseQuantity: 10.0, unit: 'पत्ते'),
        IngredientItem(id: 'i7', name: 'एक्स्ट्रा वर्जिन ऑलिव ऑयल', baseQuantity: 2.0, unit: 'बड़ा चम्मच'),
        IngredientItem(id: 'i8', name: 'समुद्री नमक', baseQuantity: 1.0, unit: 'छोटा चम्मच'),
      ],
      steps: const [
        RecipeStepItem(
          index: 0,
          heading: 'व्यंजन का परिचय',
          instructionText: 'नेपल्स के विश्व प्रसिद्ध मार्गेरिटा पिज़्ज़ा के प्रामाणिक इतिहास और सादगी को जानें।',
          audioNarrationText: 'नेपोलिटन पिज़्ज़ा बनाने की कला में आपका स्वागत है। आइए बनाएं प्रामाणिक पिज़्ज़ा।',
        ),
        RecipeStepItem(
          index: 1,
          heading: 'पिज़्ज़ा की संख्या चुनें',
          instructionText: 'आज आप कितने 10-इंच के पिज़्ज़ा बनाना चाहते हैं, चुनें।',
          audioNarrationText: 'पिज़्ज़ा की संख्या चुनें। सभी माप अपने आप बदल जाएंगे।',
        ),
        RecipeStepItem(
          index: 2,
          heading: 'सामग्री चेकलिस्ट',
          instructionText: 'मैदा, यीस्ट, टमाटर सॉस, मोज़ेरेला और बेसिल तैयार करें।',
          audioNarrationText: 'सामग्री काउंटर पर रखें और चेकलिस्ट में टिक लगाएं।',
        ),
        RecipeStepItem(
          index: 3,
          heading: 'आटा गूंथें और फूलने दें',
          instructionText: 'यीस्ट को गुनगुने पानी में घोलें, मैदा और नमक मिलाकर 8-10 मिनट तक गूंथें। गीले कपड़े से ढककर 1 घंटे तक दोगुना होने तक रखें।',
          audioNarrationText: 'आटे को चिकना और लचीला होने तक गूंथें और 1 घंटे तक फूलने दें।',
          todos: [
            'गुनगुने पानी में यीस्ट 5 मिनट घोलें',
            'मैदा और नमक में यीस्ट का पानी डालकर मिलाएं',
            '8-10 मिनट तक अच्छी तरह गूंथें',
            'गीले कपड़े से ढककर 60 मिनट तक फूलने दें',
          ],
        ),
        RecipeStepItem(
          index: 4,
          heading: 'क्रस्ट को फैलाएं',
          instructionText: 'उंगलियों से हवा को किनारों की ओर धकेलते हुए गोल 10-इंच का बेस फैलाएं। बीच से न फाड़ें।',
          audioNarrationText: 'किनारों पर हवा के बुलबुले छोड़ते हुए गोल पिज़्ज़ा बेस फैलाएं।',
          todos: [
            'काउंटर पर सूजी या आटा छिड़कें',
            'उंगलियों से दबाते हुए किनारे उभारे',
            'हल्के हाथ से फैलाकर 10 इंच का गोल बेस बनाएं',
          ],
        ),
        RecipeStepItem(
          index: 5,
          heading: 'टमाटर सॉस और चीज़ लगाएं',
          instructionText: 'टमाटर सॉस फैलाएं, मोज़ेरेला चीज़ के टुकड़े डालें और थोड़ा ऑलिव ऑयल छिड़कें।',
          audioNarrationText: 'टमाटर सॉस, मोज़ेरेला चीज़ और ऑलिव ऑयल की परत लगाएं।',
        ),
        RecipeStepItem(
          index: 6,
          heading: 'तेज आंच पर बेक करें',
          instructionText: 'ओवन के अधिकतम तापमान (250°C या अधिक) पर 6-8 मिनट बेक करें जब तक क्रस्ट सुनहरा और चीज़ बुलबुलेदार न हो जाए।',
          audioNarrationText: 'अधिकतम तापमान पर 6-8 मिनट तक क्रस्ट के फूलने तक बेक करें।',
          todos: [
            'ओवन को अधिकतम तापमान पर पहले से 30 मिनट गर्म करें',
            'पिज़्ज़ा को गर्म ट्रे या स्टोन पर रखें',
            '6-8 मिनट तक सुनहरा होने तक बेक करें',
          ],
        ),
        RecipeStepItem(
          index: 7,
          heading: 'स्वाद और समीक्षा',
          instructionText: 'ऊपर से ताजी तुलसी के पत्ते और ऑलिव ऑयल डालकर गरमागरम स्लाइस काटकर परोसें।',
          audioNarrationText: 'ताजा बेसिल पत्तों से सजाएं और अपनी समीक्षा दर्ज करें।',
        ),
      ],
      feedbackFormFields: const [
        DynamicFormFieldModel(
          id: 'dish_rating',
          title: 'पिज़्ज़ा कितना स्वादिष्ट बना?',
          type: FormFieldType.rating,
          isRequired: true,
          initialValue: 5,
        ),
        DynamicFormFieldModel(
          id: 'crust_texture',
          title: 'क्रस्ट की बनावट कैसी थी?',
          type: FormFieldType.singleChoice,
          options: ['कुरकुरा और हवादार', 'नरम और फूला हुआ', 'थोड़ा भारी'],
          isRequired: true,
        ),
        DynamicFormFieldModel(
          id: 'cheese_melt',
          title: 'चीज़ का पिघलना कैसा था?',
          type: FormFieldType.singleChoice,
          options: ['मलाईदार और खिंचाव वाला', 'थोड़ा तेलीय', 'और चीज़ चाहिए थी'],
        ),
        DynamicFormFieldModel(
          id: 'notes',
          title: 'बेकिंग अनुभव या सुझाव',
          type: FormFieldType.text,
          placeholder: 'उदा. चिली फ्लेक्स या गार्लिक ऑयल मिलाया...',
        ),
        DynamicFormFieldModel(
          id: 'pizza_photo',
          title: 'अपने पिज़्ज़ा की तस्वीर अपलोड करें',
          type: FormFieldType.imageUpload,
        ),
      ],
    ),
    'dish_arrabbiata': DishDetailModel(
      id: 'dish_arrabbiata',
      name: 'पेने ऑल-अराबियाता',
      imageUrl: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=800',
      shareUrl: 'https://cukkie.com/recipe/dish_arrabbiata',
      description: 'अल डेंटे पेने पास्ता, लहसुन, तीखी लाल मिर्च के गुच्छे और ऑलिव ऑयल के साथ बने चटपटे इटैलियन टमाटर सॉस में लिपटा हुआ।',
      history: '20वीं सदी के रोम में जन्मी \'अराबियाता\' का शाब्दिक अर्थ है \'क्रोधित\', जो इसके तीखे और लाल मिर्च के गर्म स्वाद को दर्शाता है।',
      nutritionalBreakdown: {
        'कैलोरी': '330 किलोकैलोरी',
        'प्रोटीन': '10 ग्राम',
        'कार्बोहाइड्रेट': '56 ग्राम',
        'आहारीय फाइबर': '4 ग्राम',
        'वसा': '7 ग्राम',
      },
      portionDefinition: const PortionDefinition(
        unit: 'भाग (सर्विंग्स)',
        defaultAmount: 2.0,
        stepIncrement: 1.0,
        minAmount: 1.0,
        maxAmount: 8.0,
      ),
      ingredients: const [
        IngredientItem(id: 'i1', name: 'पेने रिगाते पास्ता', baseQuantity: 250.0, unit: 'ग्राम'),
        IngredientItem(id: 'i2', name: 'छिले इटैलियन टमाटर', baseQuantity: 400.0, unit: 'ग्राम'),
        IngredientItem(id: 'i3', name: 'बारीक कटा लहसुन', baseQuantity: 4.0, unit: 'कलियां'),
        IngredientItem(id: 'i4', name: 'कुटी हुई लाल मिर्च (चिली फ्लेक्स)', baseQuantity: 1.5, unit: 'छोटा चम्मच'),
        IngredientItem(id: 'i5', name: 'एक्स्ट्रा वर्जिन ऑलिव ऑयल', baseQuantity: 3.0, unit: 'बड़ा चम्मच'),
        IngredientItem(id: 'i6', name: 'बारीक कटी पार्सले', baseQuantity: 0.25, unit: 'कप'),
        IngredientItem(id: 'i7', name: 'पास्ता पानी के लिए समुद्री नमक', baseQuantity: 1.0, unit: 'बड़ा चम्मच'),
      ],
      steps: const [
        RecipeStepItem(
          index: 0,
          heading: 'व्यंजन का परिचय',
          instructionText: 'रोम के इस तीखे और स्वादिष्ट पास्ता के इतिहास को समझें।',
          audioNarrationText: 'पेने ऑल-अराबियाता की चटपटी इटैलियन दुनिया में आपका स्वागत है।',
        ),
        RecipeStepItem(
          index: 1,
          heading: 'सर्विंग्स का चयन',
          instructionText: 'पास्ता की सर्विंग्स चुनें। सामग्री अपने आप स्केल होगी।',
          audioNarrationText: 'सर्विंग्स की संख्या चुनें।',
        ),
        RecipeStepItem(
          index: 2,
          heading: 'सामग्री चेकलिस्ट',
          instructionText: 'पेने पास्ता, लहसुन, मिर्च और ऑलिव ऑयल की तैयारी करें।',
          audioNarrationText: 'पास्ता और सामग्री निकालें और चेकलिस्ट पर टिक करें।',
        ),
        RecipeStepItem(
          index: 3,
          heading: 'पास्ता अल डेंटे उबालें',
          instructionText: 'नमक वाले पानी में पेने पास्ता 9-10 मिनट उबालें। छानने से पहले आधा कप स्टार्च वाला पानी अलग निकाल लें।',
          audioNarrationText: 'पास्ता को अल डेंटे उबालें और आधा कप पानी अलग बचाकर रखें।',
          todos: [
            '3 लीटर पानी में 1 चम्मच नमक डालकर तेज उबालें',
            'पेने पास्ता डालें और चिपकने से रोकने के लिए चलाएं',
            '9-10 मिनट तक थोड़ा कड़क (अल डेंटे) रहने तक पकाएं',
            'छानने से पहले 1/2 कप पास्ता पानी निकाल लें',
          ],
        ),
        RecipeStepItem(
          index: 4,
          heading: 'लहसुन और मिर्च भूनें',
          instructionText: 'धीमी आंच पर ऑलिव ऑयल में लहसुन और चिली फ्लेक्स को सुनहरा और खुशबूदार होने तक भूनें।',
          audioNarrationText: 'ऑलिव ऑयल में लहसुन और चिली फ्लेक्स को धीमी आंच पर भूनें।',
          todos: [
            'पैन में मध्यम आंच पर ऑलिव ऑयल गर्म करें',
            'लहसुन और चिली फ्लेक्स डालें',
            '90 सेकंड तक भूनें बिना जलाए',
          ],
        ),
        RecipeStepItem(
          index: 5,
          heading: 'टमाटर सॉस पकाएं',
          instructionText: 'टमाटर और नमक डालकर 10-12 मिनट तक तेल अलग होने तक धीमी आंच पर पकाएं।',
          audioNarrationText: 'टमाटर डालकर गाढ़ा और खुशबूदार होने तक पकाएं।',
        ),
        RecipeStepItem(
          index: 6,
          heading: 'पास्ता सॉस में टॉस करें',
          instructionText: 'उबला पास्ता सॉस में डालें, 3 चम्मच बचा हुआ पास्ता पानी डालें और 1 मिनट तक तेज आंच पर अच्छी तरह टॉस करें।',
          audioNarrationText: 'पास्ता को सॉस और पानी के साथ अच्छी तरह मिलाएं।',
          todos: [
            'उबला पास्ता सॉस पैन में डालें',
            'बचा हुआ 3 चम्मच पास्ता पानी डालें',
            '60 सेकंड तक तेज आंच पर अच्छी तरह टॉस करें',
            'पार्सले मिलाकर गैस बंद करें',
          ],
        ),
        RecipeStepItem(
          index: 7,
          heading: 'स्वाद और समीक्षा',
          instructionText: 'ऊपर से थोड़ा ऑलिव ऑयल और पार्सले छिड़ककर गरमागरम परोसें और प्रतिक्रिया दें!',
          audioNarrationText: 'गरमागरम पेने पास्ता का आनंद लें और अपनी समीक्षा दें!',
        ),
      ],
      feedbackFormFields: const [
        DynamicFormFieldModel(
          id: 'dish_rating',
          title: 'पेने अराबियाता का स्वाद कैसा लगा?',
          type: FormFieldType.rating,
          isRequired: true,
          initialValue: 5,
        ),
        DynamicFormFieldModel(
          id: 'spice_balance',
          title: 'मिर्च का तीखापन कैसा था?',
          type: FormFieldType.singleChoice,
          options: ['प्रामाणिक तीखा रोमन स्वाद', 'हल्का तीखा', 'बहुत ज्यादा तीखा!'],
          isRequired: true,
        ),
        DynamicFormFieldModel(
          id: 'pasta_doneness',
          title: 'पास्ता की बनावट कैसी थी?',
          type: FormFieldType.singleChoice,
          options: ['एकदम परफेक्ट अल डेंटे', 'थोड़ा नरम', 'ज्यादा कड़क'],
        ),
        DynamicFormFieldModel(
          id: 'notes',
          title: 'पाक सुझाव या अनुभव',
          type: FormFieldType.text,
          placeholder: 'उदा. पेकोरिनो चीज़ मिलाई...',
        ),
        DynamicFormFieldModel(
          id: 'pasta_photo',
          title: 'अपने पास्ता की तस्वीर अपलोड करें',
          type: FormFieldType.imageUpload,
        ),
      ],
    ),
  };

  // ---------- ARABIC RECIPES ----------
  static final Map<String, DishDetailModel> _arabicDishDetails = {
    'dish_paratha': DishDetailModel(
      id: 'dish_paratha',
      name: 'باراثا البطاطس والقرنبيط',
      imageUrl: 'https://images.unsplash.com/photo-1626074353765-517a681e40be?w=800',
      shareUrl: 'https://cukkie.com/recipe/dish_paratha',
      description: 'خبز هندي مسطح مقرمش محشو بالبطاطس المتبلة والقرنبيط، محمص على صاج ساخن مع السمن الأصيل.',
      history: 'نشأت الباراثا المحشوة في مزارع البنجاب كوجبة إفطار دسمة تمنح المزارعين الطاقة طوال موسم الحصاد.',
      nutritionalBreakdown: {
        'السعرات الحرارية': '290 سعرة',
        'البروتين': '7 غرام',
        'الكربوهيدرات': '48 غرام',
        'الألياف الغذائية': '6 غرام',
        'الدهون': '8 غرام',
      },
      portionDefinition: const PortionDefinition(
        unit: 'قطع',
        defaultAmount: 4.0,
        stepIncrement: 1.0,
        minAmount: 1.0,
        maxAmount: 12.0,
      ),
      ingredients: const [
        IngredientItem(id: 'i1', name: 'طحين القمح الكامل', baseQuantity: 2.0, unit: 'أكواب'),
        IngredientItem(id: 'i2', name: 'بطاطس مسلوقة', baseQuantity: 3.0, unit: 'حبات متوسطة'),
        IngredientItem(id: 'i3', name: 'قرنبيط مبشور', baseQuantity: 1.0, unit: 'كوب'),
        IngredientItem(id: 'i4', name: 'فلفل أخضر مفروم', baseQuantity: 2.0, unit: 'قرون'),
        IngredientItem(id: 'i5', name: 'بذور الكمون الملكي (أجوان)', baseQuantity: 0.5, unit: 'ملعقة صغيرة'),
        IngredientItem(id: 'i6', name: 'بودرة المانجو المجفف (أمشور)', baseQuantity: 1.0, unit: 'ملعقة صغيرة'),
        IngredientItem(id: 'i7', name: 'سمن أصيل أو زبدة', baseQuantity: 3.0, unit: 'ملاعق كبيرة'),
        IngredientItem(id: 'i8', name: 'كزبرة طازجة مفرومة', baseQuantity: 0.25, unit: 'كوب'),
      ],
      steps: const [
        RecipeStepItem(
          index: 0,
          heading: 'نظرة عامة على الطبق',
          instructionText: 'اكتشف التراث العريق والقيمة الغذائية لطبق باراثا البطاطس والقرنبيط التقليدي.',
          audioNarrationText: 'مرحباً بكم في كوكي. دعونا نبدأ برحلة طهي باراثا البطاطس والقرنبيط الشهية.',
        ),
        RecipeStepItem(
          index: 1,
          heading: 'تحديد عدد الحصص',
          instructionText: 'اختر عدد قطع الباراثا التي ترغب في إعدادها اليوم. ستُعدل مقادير المكونات تلقائياً.',
          audioNarrationText: 'حدد عدد القطع المطلوبة وستتم إعادة حساب الكميات فوراً.',
        ),
        RecipeStepItem(
          index: 2,
          heading: 'قائمة المكونات',
          instructionText: 'تأكد من تجهيز مكوناتك الطازجة وضع علامة على كل عنصر تم إعداده.',
          audioNarrationText: 'إليك قائمة المكونات. اجمعها على سطح التحضير وضع علامة إنجاز.',
        ),
        RecipeStepItem(
          index: 3,
          heading: 'إعداد العجينة',
          instructionText: 'اعجن طحين القمح مع رشة ملح وماء دافئ حتى تحصل على عجينة طرية ومرنة، ثم ادهنها بقليل من السمن واتركها ترتاح 15 دقيقة.',
          audioNarrationText: 'اعجن العجينة جيداً حتى تصبح طرية ومرنة، واتركها ترتاح لمدة خمس عشرة دقيقة.',
          todos: [
            'أضف طحين القمح ورشة الملح في وعاء العجن',
            'أضف الماء الفاتر تدريجياً أثناء العجن',
            'اعجن لمدة 5 دقائق حتى تصبح غير لاصقة',
            'ادهن بنصف ملعقة سمن وغطها لمدة 15 دقيقة',
          ],
        ),
        RecipeStepItem(
          index: 4,
          heading: 'خلط الحشوة المتبلة',
          instructionText: 'اهرس البطاطس جيداً في وعاء كبير، واخلط معها القرنبيط المبشور، الفلفل الأخضر، التوابل العطرية والكزبرة الطازجة.',
          audioNarrationText: 'اهرس البطاطس واخلطها مع القرنبيط والتوابل العطرية الشهية.',
          todos: [
            'اهرس البطاطس تماماً دون أي كتل',
            'أضف القرنبيط المبشور والفلفل المفروم',
            'أضف بذور الأجوان وبودرة المانجو والتوابل والملح',
            'اخلط الكزبرة الطازجة جيداً',
          ],
        ),
        RecipeStepItem(
          index: 5,
          heading: 'حشو وفرد العجين',
          instructionText: 'شكّل كرة عجين متوسطة، افرد الأطراف، ضع كرة من الحشوة في المنتصف، أطبق الأطراف بإحكام وافردها بلطف إلى دائرة متناسقة.',
          audioNarrationText: 'ضع الحشوة داخل العجين وافردها بضغط خفيف ومتساوٍ.',
        ),
        RecipeStepItem(
          index: 6,
          heading: 'التحميص على الصاج',
          instructionText: 'اطبخ الباراثا على صاج ساخن حتى تظهر بقع ذهبية على الجانبين، وادهن بسخاء بالسمن حتى تنتفخ وتصبح مقرمشة.',
          audioNarrationText: 'حمص الباراثا على صاج ساخن مع السمن حتى تصبح ذهبية ومقرمشة ولذيذة.',
          todos: [
            'ضع قرص الباراثا على الصاج الساخن',
            'اقلب بعد 45 ثانية عند ظهور فقاعات',
            'ادهن ملعقة سمن على السطح',
            'اقلب واضغط على الحواف حتى تصبح مقرمشة وذهبية',
          ],
        ),
        RecipeStepItem(
          index: 7,
          heading: 'التذوق والتقييم',
          instructionText: 'قدمها ساخنة مع الزبدة، اللبن الزبادي ومخلل المانجو الحار. قيّم تجربتك أدناه.',
          audioNarrationText: 'هنيئاً لك إتمام طبقك! تذوق الباراثا وشاركنا رأيك القيم.',
        ),
      ],
      feedbackFormFields: const [
        DynamicFormFieldModel(
          id: 'dish_rating',
          title: 'ما مدى لذة الباراثا التي أعددتها؟',
          type: FormFieldType.rating,
          isRequired: true,
          initialValue: 5,
        ),
        DynamicFormFieldModel(
          id: 'crispiness_choice',
          title: 'كيف كانت قرمشة العجينة؟',
          type: FormFieldType.singleChoice,
          options: ['مقرمشة ورائعة', 'طرية وهشة', 'بحاجة إلى تحميص إضافي'],
          isRequired: true,
        ),
        DynamicFormFieldModel(
          id: 'side_pairings',
          title: 'ماذا قدمت مع الباراثا؟',
          type: FormFieldType.multipleChoice,
          options: ['زبادي طازج', 'زبدة بلدية', 'مخلل مانجو', 'شاي كرك ساخن'],
        ),
        DynamicFormFieldModel(
          id: 'chef_notes',
          title: 'ملاحظات الشيف أو إضافات خاصة',
          type: FormFieldType.text,
          placeholder: 'مثال: أضفت رشة حلبة مجففة إلى الحشوة...',
        ),
        DynamicFormFieldModel(
          id: 'dish_photo',
          title: 'التقط صورة لطبقك النهائي',
          type: FormFieldType.imageUpload,
        ),
      ],
    ),
    'dish_halwa': DishDetailModel(
      id: 'dish_halwa',
      name: 'حلوى السميد (شيرا)',
      imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=800',
      shareUrl: 'https://cukkie.com/recipe/dish_halwa',
      description: 'حلوى السميد الغنية والمحمصة بالسمن الصافي حتى تكتسب لوناً عنبرياً، معطرة بالهيل الأخضر والزعفران والمكسرات المقرمشة.',
      history: 'تعتبر هذه الحلوى التقليدية رمزاً للاحتفال والضيافة الكريمة في البيوت الهندية منذ قرون.',
      nutritionalBreakdown: {
        'السعرات الحرارية': '310 سعرة',
        'البروتين': '5 غرام',
        'الكربوهيدرات': '52 غرام',
        'الدهون': '11 غرام',
      },
      portionDefinition: const PortionDefinition(
        unit: 'غرام',
        defaultAmount: 250.0,
        stepIncrement: 50.0,
        minAmount: 100.0,
        maxAmount: 1000.0,
      ),
      ingredients: const [
        IngredientItem(id: 'i1', name: 'سميد ناعم', baseQuantity: 100.0, unit: 'غرام'),
        IngredientItem(id: 'i2', name: 'سمن بلدي نقي', baseQuantity: 80.0, unit: 'غرام'),
        IngredientItem(id: 'i3', name: 'سكر', baseQuantity: 90.0, unit: 'غرام'),
        IngredientItem(id: 'i4', name: 'حليب كامل الدسم / ماء', baseQuantity: 300.0, unit: 'مل'),
        IngredientItem(id: 'i5', name: 'هيل مطحون', baseQuantity: 0.5, unit: 'ملعقة صغيرة'),
        IngredientItem(id: 'i6', name: 'خيوط الزعفران', baseQuantity: 8.0, unit: 'خيوط', isOptional: true),
        IngredientItem(id: 'i7', name: 'لوز وكاجو شرائح', baseQuantity: 20.0, unit: 'غرام'),
      ],
      steps: const [
        RecipeStepItem(
          index: 0,
          heading: 'نظرة عامة على الطبق',
          instructionText: 'اكتشف حلاوة التراث وعطر الهيل في حلوى السميد التقليدية بالسمن.',
          audioNarrationText: 'أهلاً بكم. استمتعوا برائحة الهيل والسمن الزكية لحلوى الشيرا الأصلية.',
        ),
        RecipeStepItem(
          index: 1,
          heading: 'تحديد الكمية',
          instructionText: 'اختر وزن الكمية المطلوب إعدادها بالغرام.',
          audioNarrationText: 'اختر الوزن الكلي الذي تود تحضيره.',
        ),
        RecipeStepItem(
          index: 2,
          heading: 'قائمة المكونات',
          instructionText: 'جهز السميد، السمن، السكر والحليب على الطاولة.',
          audioNarrationText: 'قس مقادير السميد والسمن والمطيبات وضع علامة إنجاز.',
        ),
        RecipeStepItem(
          index: 3,
          heading: 'تحميص المكسرات والسميد',
          instructionText: 'سخن السمن في مقلاة عميقة، حمر المكسرات وارفعها جانباً، ثم حمر السميد على نار هادئة حتى يصبح وردياً ذهبياً وتفوح رائحته العطرة.',
          audioNarrationText: 'حمص السميد بالسمن الساخن على نار هادئة حتى تعبق رائحته الزكية.',
          todos: [
            'سخن ملعقتين سمن وحمر الكاجو واللوز',
            'ارفع المكسرات جانباً للتزيين',
            'أضف السميد إلى السمن المتبقي وقلب باستمرار',
            'حمص لمدة 8-10 دقائق حتى يصبح ذهبياً فاتحاً',
          ],
        ),
        RecipeStepItem(
          index: 4,
          heading: 'إضافة الحليب بالزعفران',
          instructionText: 'اسكب الحليب الساخن المشبع بالزعفران تدريجياً فوق السميد مع الخفق المستمر لتجنب أي تكتلات. غطّ المقلاة واتركه ينضج لـ 3 دقائق.',
          audioNarrationText: 'اسكب الحليب الدافئ مع التقليب المستمر حتى تتشرب حبات السميد الرطوبة.',
          todos: [
            'اغلِ الحليب مع الزعفران في قدر جانبي',
            'اسكب الحليب الساخن ببطء مع التحريك بمضرب يدوي',
            'غط المقلاة 3 دقائق لتنتفخ حبات السميد على نار هادئة',
          ],
        ),
        RecipeStepItem(
          index: 5,
          heading: 'إضافة السكر والتزيين',
          instructionText: 'أضف السكر ومسحوق الهيل وقلب حتى يذوب السكر وتكتسب الحلوى لمعاناً براقاً، ثم زين بالمكسرات المحمصة.',
          audioNarrationText: 'أضف السكر والهيل المطحون وشاهد القوام اللامع والشهي.',
        ),
        RecipeStepItem(
          index: 6,
          heading: 'التذوق والتقييم',
          instructionText: 'استمتع بحلوى السميد الدافئة وقيم درجة الحلاوة والتوازن.',
          audioNarrationText: 'بالهناء والشفاء! شاركنا تقييمك وملاحظاتك.',
        ),
      ],
      feedbackFormFields: const [
        DynamicFormFieldModel(
          id: 'dish_rating',
          title: 'كيف كان طعم وقوام الحلوى؟',
          type: FormFieldType.rating,
          isRequired: true,
          initialValue: 5,
        ),
        DynamicFormFieldModel(
          id: 'sweetness_rating',
          title: 'هل كانت درجة الحلاوة مناسبة؟',
          type: FormFieldType.singleChoice,
          options: ['حلاوة متوازنة ومثالية', 'حلوة جداً', 'تحتاج لمزيد من السكر'],
          isRequired: true,
        ),
        DynamicFormFieldModel(
          id: 'feedback_notes',
          title: 'ملاحظات الشيف',
          type: FormFieldType.text,
          placeholder: 'ملاحظاتك حول التحميص أو القوام...',
        ),
        DynamicFormFieldModel(
          id: 'halwa_photo',
          title: 'ارفع صورة لحلوى السميد التي صنعتها',
          type: FormFieldType.imageUpload,
        ),
      ],
    ),
    'dish_pbm': DishDetailModel(
      id: 'dish_pbm',
      name: 'بانير زبدة ماسالا',
      imageUrl: 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=800',
      shareUrl: 'https://cukkie.com/recipe/dish_pbm',
      description: 'مكعبات جبن البانير الطازجة المطهوة ببطء في مرق طماطم وكاجو مخملي ناعم مع الحلبة المجففة والزبدة الفاخرة.',
      history: 'ابتُكر هذا المرق الفاخر في دلهي في خمسينيات القرن الماضي ليجسد التناغم المثالي بين الطماطم، الزبدة الطبيعية والحلبة.',
      nutritionalBreakdown: {
        'السعرات الحرارية': '380 سعرة',
        'البروتين': '14 غرام',
        'الكربوهيدرات': '22 غرام',
        'الدهون': '28 غرام',
      },
      portionDefinition: const PortionDefinition(
        unit: 'حصص',
        defaultAmount: 3.0,
        stepIncrement: 1.0,
        minAmount: 1.0,
        maxAmount: 8.0,
      ),
      ingredients: const [
        IngredientItem(id: 'i1', name: 'مكعبات جبن البانير الطازج', baseQuantity: 250.0, unit: 'غرام'),
        IngredientItem(id: 'i2', name: 'طماطم طازجة ناضجة', baseQuantity: 4.0, unit: 'حبات كبيرة'),
        IngredientItem(id: 'i3', name: 'حبات كاجو', baseQuantity: 15.0, unit: 'حبات'),
        IngredientItem(id: 'i4', name: 'زبدة طازجة', baseQuantity: 2.0, unit: 'ملاعق كبيرة'),
        IngredientItem(id: 'i5', name: 'كريمة طبخ كثيفة', baseQuantity: 3.0, unit: 'ملاعق كبيرة'),
        IngredientItem(id: 'i6', name: 'أوراق حلبة مجففة (كاسوري ميثي)', baseQuantity: 1.0, unit: 'ملعقة صغيرة'),
        IngredientItem(id: 'i7', name: 'معجون زنجبيل وثوم', baseQuantity: 1.0, unit: 'ملعقة كبيرة'),
      ],
      steps: const [
        RecipeStepItem(
          index: 0,
          heading: 'نظرة عامة على الطبق',
          instructionText: 'تعرف على التراث الملكي والقيمة الغذائية الفاخرة لطبق بانير زبدة ماسالا.',
          audioNarrationText: 'اكتشف القوام المخملي والنكهات الملكية لطبق بانير زبدة ماسالا الشهير.',
        ),
        RecipeStepItem(
          index: 1,
          heading: 'تحديد عدد الحصص',
          instructionText: 'حدد عدد الحصص التي ترغب في إعدادها.',
          audioNarrationText: 'اختر عدد الحصص المطلوبة وسيتم تعديل المكونات فوراً.',
        ),
        RecipeStepItem(
          index: 2,
          heading: 'قائمة المكونات',
          instructionText: 'جهز جبن البانير، الطماطم الناضجة، الكاجو المنقوع والزبدة.',
          audioNarrationText: 'رتب المكونات وضع علامة إنجاز لكل عنصر.',
        ),
        RecipeStepItem(
          index: 3,
          heading: 'تحضير صلصة الطماطم المخملية',
          instructionText: 'اغلِ الطماطم مع الكاجو المنقوع في قليل من الماء لمدة 10 دقائق حتى تنضج، ثم اخلطها حتى تصبح ناعمة جداً وصفيها بمصفاة دقيقة.',
          audioNarrationText: 'اغلِ الطماطم مع الكاجو واخلطها لتحصل على صلصة حريرية فائقة النعومة.',
          todos: [
            'قطع الطماطم وضعها مع الكاجو والماء في قدر',
            'اغلِ لمدة 10 دقائق حتى تنفصل القشور',
            'اتركها تبرد قليلاً واخلطها حتى تصبح حريرية تماماً',
            'صفِّ الصلصة بمصفاة ناعمة لقوام كريمي فاخر',
          ],
        ),
        RecipeStepItem(
          index: 4,
          heading: 'تسبيك الصلصة مع المطيبات',
          instructionText: 'سخن الزبدة في مقلاة، شوح معجون الزنجبيل والثوم مع الفلفل والكزبرة، ثم اسكب الصلصة المصفاة واتركها تتسبك حتى تطفو الزبدة.',
          audioNarrationText: 'اطبخ الصلصة مع الزبدة والمطيبات العطرية حتى تكتسب لوناً عميقاً ولمعاناً.',
        ),
        RecipeStepItem(
          index: 5,
          heading: 'إضافة البانير والكريمة',
          instructionText: 'أضف مكعبات البانير برفق واتركها تنضج لـ 3 دقائق، ثم رش الحلبة المجففة واختم بلمسة من الكريمة الكثيفة.',
          audioNarrationText: 'أضف مكعبات الجبن الطري واختم بالحلبة العطرية ولمسة من الكريمة الغنية.',
          todos: [
            'انقع البانير في ماء دافئ 5 دقائق لطراوة مثالية',
            'اسكب مكعبات البانير برفق في الصلصة',
            'افرك الحلبة المجففة بين كفيك وانثرها بالتساوي',
            'أضف الكريمة واطفئ النار فوراً',
          ],
        ),
        RecipeStepItem(
          index: 6,
          heading: 'التذوق والتقييم',
          instructionText: 'قدم الطبق مع خبز النان الساخن أو أرز الجيرا العطري، وشاركنا تقييمك!',
          audioNarrationText: 'قدم الطبق ساخناً مع خبز النان أو الأرز وشاركنا تقييمك الكريم.',
        ),
      ],
      feedbackFormFields: const [
        DynamicFormFieldModel(
          id: 'dish_rating',
          title: 'ما مدى غنى ولذة الماسالا؟',
          type: FormFieldType.rating,
          isRequired: true,
          initialValue: 5,
        ),
        DynamicFormFieldModel(
          id: 'richness_choice',
          title: 'كيف كان قوام المرق؟',
          type: FormFieldType.singleChoice,
          options: ['حريري ومثالي', 'كثيف قليلاً', 'خفيف جداً'],
          isRequired: true,
        ),
        DynamicFormFieldModel(
          id: 'pairing_options',
          title: 'مع ماذا قدمت الطبق؟',
          type: FormFieldType.multipleChoice,
          options: ['خبز نان بالزبدة', 'أرز جيرا بالكمون', 'خبز روتي تندوري', 'باراثا'],
        ),
        DynamicFormFieldModel(
          id: 'comments',
          title: 'ملاحظات التذوق',
          type: FormFieldType.text,
          placeholder: 'أخبرنا عن رأي عائلتك بالطبق...',
        ),
        DynamicFormFieldModel(
          id: 'curry_photo',
          title: 'ارفع صورة لطبق بانير زبدة ماسالا',
          type: FormFieldType.imageUpload,
        ),
      ],
    ),
    'dish_misal': DishDetailModel(
      id: 'dish_misal',
      name: 'ميسال باف الأصيل',
      imageUrl: 'https://images.unsplash.com/photo-1606491956689-2ea866880c84?w=800',
      shareUrl: 'https://cukkie.com/recipe/dish_misal',
      description: 'كاري ماهاراشترا حار ومتبل مصنوع من حبوب الموث المنبتة، يُسكب فوقه مرق أحمر ناري ويُزين بفرسان المقرمش والبصل مع خبز الباف الدافئ.',
      history: 'طبق شعبي أصيل يعود إلى مدن كولهابور وبوني ويعد أشهر وجبة إفطار غنية بالبروتين في ولاية ماهاراشترا.',
      nutritionalBreakdown: {
        'السعرات الحرارية': '420 سعرة',
        'البروتين': '16 غرام',
        'الكربوهيدرات': '54 غرام',
        'الألياف الغذائية': '9 غرام',
        'الدهون': '14 غرام',
      },
      portionDefinition: const PortionDefinition(
        unit: 'أطباق',
        defaultAmount: 2.0,
        stepIncrement: 1.0,
        minAmount: 1.0,
        maxAmount: 8.0,
      ),
      ingredients: const [
        IngredientItem(id: 'i1', name: 'حبوب موث منبتة (ماتكي)', baseQuantity: 1.5, unit: 'أكواب'),
        IngredientItem(id: 'i2', name: 'خبز باف طازج', baseQuantity: 4.0, unit: 'قطع'),
        IngredientItem(id: 'i3', name: 'فرسان هندي مقرمش مشكل', baseQuantity: 1.0, unit: 'كوب'),
        IngredientItem(id: 'i4', name: 'بصل أحمر مفروم ناعماً', baseQuantity: 2.0, unit: 'حبات متوسطة'),
        IngredientItem(id: 'i5', name: 'طماطم ناضجة', baseQuantity: 2.0, unit: 'حبات متوسطة'),
        IngredientItem(id: 'i6', name: 'جوز هند جاف محمص مبشور', baseQuantity: 0.25, unit: 'كوب'),
        IngredientItem(id: 'i7', name: 'بهارات ميسال / غودا ماسالا', baseQuantity: 2.0, unit: 'ملاعق كبيرة'),
        IngredientItem(id: 'i8', name: 'معجون زنجبيل وثوم', baseQuantity: 1.0, unit: 'ملعقة كبيرة'),
        IngredientItem(id: 'i9', name: 'بذور خردل وأوراق كاري', baseQuantity: 1.0, unit: 'ملعقة صغيرة'),
        IngredientItem(id: 'i10', name: 'شرائح ليمون طازج', baseQuantity: 2.0, unit: 'قطع'),
      ],
      steps: const [
        RecipeStepItem(
          index: 0,
          heading: 'نظرة عامة على الطبق',
          instructionText: 'استكشف التراث والنكهات الحارة المتفجرة لطبق الميسال باف الكولهابوري الأصيل.',
          audioNarrationText: 'مرحباً بكم في عالم ميسال باف الغني بالنكهات الحارة والتوابل الهندية.',
        ),
        RecipeStepItem(
          index: 1,
          heading: 'تحديد عدد الأطباق',
          instructionText: 'حدد عدد أطباق الميسال باف التي تود تحضيرها.',
          audioNarrationText: 'حدد عدد الأطباق وسيتكفل التطبيق بحساب المقادير.',
        ),
        RecipeStepItem(
          index: 2,
          heading: 'قائمة المكونات',
          instructionText: 'تأكد من وجود الماتكي المنبتة، خبز الباف، الفرسان المقرمش والتوابل.',
          audioNarrationText: 'اجمع الحبوب المنبتة والمقرمشات وضع علامة إنجاز.',
        ),
        RecipeStepItem(
          index: 3,
          heading: 'سلق الحبوب المنبتة',
          instructionText: 'اسلق حبوب الماتكي في ماء مع كركم ورشة ملح لمدة 7-8 دقائق حتى تنضج مع الحفاظ على قوامها.',
          audioNarrationText: 'اسلق الحبوب المنبتة حتى تنضج دون أن تفقد قوامها.',
          todos: [
            'اغسل الحبوب المنبتة جيداً بماء بارد',
            'ضعها في قدر مع كوبين ماء وربع ملعقة كركم',
            'اسلق لمدة 7-8 دقائق حتى تطرى',
            'احتفظ بماء السلق لاستخدامه في المرق',
          ],
        ),
        RecipeStepItem(
          index: 4,
          heading: 'تحضير معجون الفاتان التقليدي',
          instructionText: 'حمص جوز الهند المبشور حتى يصبح بنياً ذهبياً، وشوح شرائح البصل حتى تتكرمل، ثم اخلطها مع الثوم والزنجبيل إلى معجون ناعم.',
          audioNarrationText: 'حمص جوز الهند والبصل حتى يكتسبا لوناً بنياً كراميلياً غنياً واخلطهما جيداً.',
          todos: [
            'حمص جوز الهند على نار هادئة حتى يكتسب لوناً ذهبياً',
            'شوح البصل مع ملعقة زيت حتى يتكرمل بعمق',
            'اخلط المكونات بالخلاط مع زنجبيل وثوم وقليل من الماء',
          ],
        ),
        RecipeStepItem(
          index: 5,
          heading: 'تسبيك المرق الناري (تاري)',
          instructionText: 'سخن الزيت، فرقع بذور الخردل وأوراق الكاري، أضف معجون الفاتان والبهارات ثم اسكب ماء الحبوب واتركه يغلي حتى تطفو طبقة الزيت الحمراء الشهيرة.',
          audioNarrationText: 'شوح المعجون مع بهارات الميسال ودع المرق يغلي حتى تظهر طبقة الزيت الحمراء العطرية.',
          todos: [
            'سخن ملعقتين كبيرتين من الزيت في قدر عميق',
            'أضف بذور الخردل وأوراق الكاري',
            'شوح معجون الفاتان 3-4 دقائق',
            'أضف بهارات الميسال والشطة والطماطم',
            'اسكب ماء سلق الحبوب واتركه يغلي 10 دقائق لتطفو طبقة التاري الحمراء',
          ],
        ),
        RecipeStepItem(
          index: 6,
          heading: 'التجميع وتحميص الباف',
          instructionText: 'في وعاء عميق، ضع مغرفة من الحبوب المسلوقة، اسكب فوقها المرق الأحمر المغلي، غطها بالفرسان المقرمش والبصل المفروم وقدمها مع خبز الباف المحمص بالزبدة.',
          audioNarrationText: 'ضع الحبوب المسلوقة، اغمرها بالمرق الساخن، زين بالفرسان المقرمش وقدم مع خبز الباف المحمص.',
          todos: [
            'ضع مغرفة حبوب مسلوقة في قاع الوعاء',
            'اسكب مغرفتين من المرق الأحمر الحار فوقها',
            'أضف كمية وافرة من الفرسان المقرمش',
            'زين بالبصل المفروم والكزبرة',
            'حمص خبز الباف بالزبدة وقدم فوراً مع شرائح الليمون',
          ],
        ),
        RecipeStepItem(
          index: 7,
          heading: 'التذوق والتقييم',
          instructionText: 'اعصر الليمون الطازج، اغمس الخبز الدافئ في المرق واستمتع بالقرمشة والنكهة النارية المميزة!',
          audioNarrationText: 'استمتع بطبق ميسال باف الأسطوري وشاركنا تقييمك وصورك.',
        ),
      ],
      feedbackFormFields: const [
        DynamicFormFieldModel(
          id: 'dish_rating',
          title: 'ما مدى لذة ميسال باف؟',
          type: FormFieldType.rating,
          isRequired: true,
          initialValue: 5,
        ),
        DynamicFormFieldModel(
          id: 'spice_level_choice',
          title: 'كيف كان مستوى حرارة المرق؟',
          type: FormFieldType.singleChoice,
          options: ['حار أصيل وممتع', 'معتدل الحرارة', 'حار جداً!'],
          isRequired: true,
        ),
        DynamicFormFieldModel(
          id: 'texture_rating',
          title: 'هل حافظ الفرسان على قرمشته؟',
          type: FormFieldType.singleChoice,
          options: ['مقرمش ولذيذ', 'لين قليلاً', 'رطب'],
        ),
        DynamicFormFieldModel(
          id: 'notes',
          title: 'ملاحظات أو تعديلات خاصة',
          type: FormFieldType.text,
          placeholder: 'مثال: أضفت مزيداً من عصير الليمون...',
        ),
        DynamicFormFieldModel(
          id: 'misal_photo',
          title: 'ارفع صورة لطبق الميسال باف الشهي',
          type: FormFieldType.imageUpload,
        ),
      ],
    ),
    'dish_pizza': DishDetailModel(
      id: 'dish_pizza',
      name: 'بيتزا مارغريتا نابوليتان',
      imageUrl: 'https://images.unsplash.com/photo-1604382355076-af4b0eb60143?w=800',
      shareUrl: 'https://cukkie.com/recipe/dish_pizza',
      description: 'عجينة نابولية تقليدية هشة مخبوزة على الحطب، مغطاة بصلصة الطماطم الإيطالية، جبن الموزاريلا الطازج، ريحان عطري وزيت زيتون بكر ممتاز.',
      history: 'صُنعت في نابولي عام 1889 تكريماً لزيارة الملكة مارغريتا لتعكس ألوان العلم الإيطالي الثلاثية: الأحمر، الأبيض، والأخضر.',
      nutritionalBreakdown: {
        'السعرات الحرارية': '350 سعرة',
        'البروتين': '13 غرام',
        'الكربوهيدرات': '42 غرام',
        'الألياف الغذائية': '3 غرام',
        'الدهون': '12 غرام',
      },
      portionDefinition: const PortionDefinition(
        unit: 'بيتزا',
        defaultAmount: 2.0,
        stepIncrement: 1.0,
        minAmount: 1.0,
        maxAmount: 6.0,
      ),
      ingredients: const [
        IngredientItem(id: 'i1', name: 'طحين أبيض عالي البروتين (تيبو 00)', baseQuantity: 2.5, unit: 'أكواب'),
        IngredientItem(id: 'i2', name: 'ماء فاتر', baseQuantity: 1.0, unit: 'كوب'),
        IngredientItem(id: 'i3', name: 'خميرة فورية جافة', baseQuantity: 1.0, unit: 'ملعقة صغيرة'),
        IngredientItem(id: 'i4', name: 'طماطم إيطالية مهروسة', baseQuantity: 1.5, unit: 'أكواب'),
        IngredientItem(id: 'i5', name: 'جبن موزاريلا طازج مفتت', baseQuantity: 200.0, unit: 'غرام'),
        IngredientItem(id: 'i6', name: 'أوراق ريحان طازجة', baseQuantity: 10.0, unit: 'أوراق'),
        IngredientItem(id: 'i7', name: 'زيت زيتون بكر ممتاز', baseQuantity: 2.0, unit: 'ملاعق كبيرة'),
        IngredientItem(id: 'i8', name: 'ملح بحري ناعم', baseQuantity: 1.0, unit: 'ملعقة صغيرة'),
      ],
      steps: const [
        RecipeStepItem(
          index: 0,
          heading: 'نظرة عامة على الطبق',
          instructionText: 'استكشف التراث العريق والبساطة الساحرة لبيتزا مارغريتا النابولية الشهيرة.',
          audioNarrationText: 'مرحباً بكم في فن صناعة البيتزا النابولية التقليدية.',
        ),
        RecipeStepItem(
          index: 1,
          heading: 'تحديد عدد حبات البيتزا',
          instructionText: 'اختر عدد حبات البيتزا مقاس 10 بوصات التي ستخبزها اليوم.',
          audioNarrationText: 'حدد عدد حبات البيتزا المطلوبة.',
        ),
        RecipeStepItem(
          index: 2,
          heading: 'قائمة المكونات',
          instructionText: 'تأكد من تجهيز الطحين، الخميرة، صلصة الطماطم، جبن الموزاريلا والريحان الطازج.',
          audioNarrationText: 'جهز الطحين والجبن وأوراق الريحان العطرة على الطاولة.',
        ),
        RecipeStepItem(
          index: 3,
          heading: 'عجن وتخمير العجينة',
          instructionText: 'أذب الخميرة في ماء فاتر، اخلط مع الطحين والملح واعجن 8-10 دقائق حتى تصبح ناعمة ومطاطية. غطها بفوطة رطبة لمدة ساعة لتتضاعف.',
          audioNarrationText: 'اعجن العجينة جيداً حتى تصبح ناعمة ومطاطية ثم اتركها تختمر.',
          todos: [
            'أذب الخميرة في الماء الفاتر لخمس دقائق',
            'اخلط الطحين والملح واسكب ماء الخميرة',
            'اعجن بنشاط لمدة 8-10 دقائق حتى تصبح غير لاصقة',
            'شكل كرات وغطها بفوطة رطبة لمدة 60 دقيقة',
          ],
        ),
        RecipeStepItem(
          index: 4,
          heading: 'فرد العجينة وصنع الحواف',
          instructionText: 'اضغط بأطراف أصابعك من المنتصف نحو الخارج لدفع فقاعات الهواء نحو الإطار الخارجي (الكورنيشوني)، وافردها إلى قرص بقطر 10 بوصات.',
          audioNarrationText: 'ادفع فقاعات الهواء نحو الأطراف وافرد العجينة إلى قرص دائري كلاسيكي.',
          todos: [
            'رش سطح العمل بالسميد أو الطحين',
            'اضغط بالأصابع نحو الحواف لتشكيل إطار منتفخ',
            'افرد العجين بلطف إلى دائرة مقاس 10 بوصات',
          ],
        ),
        RecipeStepItem(
          index: 5,
          heading: 'إضافة الصلصة والموزاريلا',
          instructionText: 'وزع صلصة الطماطم بالتساوي مع ترك إطار 2 سم عند الحواف، انثر قطع الموزاريلا ورش قليلاً من زيت الزيتون.',
          audioNarrationText: 'وزع صلصة الطماطم وجبن الموزاريلا ورشة زيت الزيتون.',
        ),
        RecipeStepItem(
          index: 6,
          heading: 'الخبز على حرارة فائقة',
          instructionText: 'اخبز في أعلى درجة حرارة ممكنة للفرن (250° مئوية أو أكثر) على حجر ساخن حتى تنتفخ الحواف وتذوب الجبنة وتتحمر.',
          audioNarrationText: 'اخبز على أقصى حرارة حتى تنتفخ حواف البيتزا وتكتسب لوناً ذهبياً شهياً.',
          todos: [
            'سخن الفرن وحجر البيتزا مسبقاً لأقصى حرارة لمدة 30 دقيقة',
            'انقل البيتزا إلى الحجر الساخن',
            'اخبز لمدة 6-8 دقائق حتى تنضج الحواف وتظهر فقاعات الجبن',
          ],
        ),
        RecipeStepItem(
          index: 7,
          heading: 'التذوق والتقييم',
          instructionText: 'زين فوراً بأوراق الريحان الطازجة ورشة أخيرة من زيت الزيتون البكر، قطع واستمتع بها ساخنة!',
          audioNarrationText: 'زين بأوراق الريحان وزيت الزيتون وقيم وصفتك المميزة!',
        ),
      ],
      feedbackFormFields: const [
        DynamicFormFieldModel(
          id: 'dish_rating',
          title: 'ما مدى روعة بيتزا المارغريتا؟',
          type: FormFieldType.rating,
          isRequired: true,
          initialValue: 5,
        ),
        DynamicFormFieldModel(
          id: 'crust_texture',
          title: 'كيف كان قوام الأطراف والعجينة؟',
          type: FormFieldType.singleChoice,
          options: ['مقرمشة وخفيفة جداً', 'طرية وهشة', 'كثيفة قليلاً'],
          isRequired: true,
        ),
        DynamicFormFieldModel(
          id: 'cheese_melt',
          title: 'كيف كان ذوبان الجبنة؟',
          type: FormFieldType.singleChoice,
          options: ['كريمي ومطاطي ممتاز', 'زيتي قليلاً', 'تحتاج لمزيد من الجبن'],
        ),
        DynamicFormFieldModel(
          id: 'notes',
          title: 'ملاحظات الخبز',
          type: FormFieldType.text,
          placeholder: 'مثال: أضفت رشة فلفل أحمر أو زيت ثوم...',
        ),
        DynamicFormFieldModel(
          id: 'pizza_photo',
          title: 'ارفع صورة للبيتزا الشهية',
          type: FormFieldType.imageUpload,
        ),
      ],
    ),
    'dish_arrabbiata': DishDetailModel(
      id: 'dish_arrabbiata',
      name: 'بيني ألارابياتا الحارة',
      imageUrl: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=800',
      shareUrl: 'https://cukkie.com/recipe/dish_arrabbiata',
      description: 'معكرونة بيني مطهوة على الطريقة الإيطالية (أل دينتي) مغطاة بصلصة طماطم رومانية حارة مع الثوم المشوح ورقائق الفلفل وزيت الزيتون والبقدونس.',
      history: 'ولدت في روما في أوائل القرن العشرين، وسميت "ألارابياتا" (أي الغاضبة) في إشارة مرحة إلى احمرار الوجنتين وحرارة الفلفل المميزة.',
      nutritionalBreakdown: {
        'السعرات الحرارية': '330 سعرة',
        'البروتين': '10 غرام',
        'الكربوهيدرات': '56 غرام',
        'الألياف الغذائية': '4 غرام',
        'الدهون': '7 غرام',
      },
      portionDefinition: const PortionDefinition(
        unit: 'حصص',
        defaultAmount: 2.0,
        stepIncrement: 1.0,
        minAmount: 1.0,
        maxAmount: 8.0,
      ),
      ingredients: const [
        IngredientItem(id: 'i1', name: 'معكرونة بيني ريغاتي', baseQuantity: 250.0, unit: 'غرام'),
        IngredientItem(id: 'i2', name: 'طماطم إيطالية مقشرة ومهروسة', baseQuantity: 400.0, unit: 'غرام'),
        IngredientItem(id: 'i3', name: 'ثوم طازج شرائح رفيعة', baseQuantity: 4.0, unit: 'فصوص'),
        IngredientItem(id: 'i4', name: 'رقائق فلفل أحمر حار مجفف', baseQuantity: 1.5, unit: 'ملعقة صغيرة'),
        IngredientItem(id: 'i5', name: 'زيت زيتون بكر ممتاز', baseQuantity: 3.0, unit: 'ملاعق كبيرة'),
        IngredientItem(id: 'i6', name: 'بقدونس طازج مفروم', baseQuantity: 0.25, unit: 'كوب'),
        IngredientItem(id: 'i7', name: 'ملح بحري لسلق المعكرونة', baseQuantity: 1.0, unit: 'ملعقة كبيرة'),
      ],
      steps: const [
        RecipeStepItem(
          index: 0,
          heading: 'نظرة عامة على الطبق',
          instructionText: 'تعرف على أحد أشهر أطباق الباستا الرومانية المشهورة ببساطة مكوناتها وقوة نكهتها.',
          audioNarrationText: 'اكتشف كلاسيكية روما الحارة، بيني ألارابياتا. نكهة جريئة ولذيذة.',
        ),
        RecipeStepItem(
          index: 1,
          heading: 'تحديد عدد الحصص',
          instructionText: 'حدد عدد حصص الباستا التي تود طهيها.',
          audioNarrationText: 'اختر عدد الحصص المطلوبة.',
        ),
        RecipeStepItem(
          index: 2,
          heading: 'قائمة المكونات',
          instructionText: 'تأكد من جاهزية البيني، شرائح الثوم، رقائق الفلفل الحار وزيت الزيتون.',
          audioNarrationText: 'ضع معكرونة البيني والثوم وزيت الزيتون وضع علامة إنجاز.',
        ),
        RecipeStepItem(
          index: 3,
          heading: 'سلق الباستا (أل دينتي)',
          instructionText: 'اغلِ قدراً كبيراً من الماء مع الملح، اطبخ البيني حتى تصبح صلبة قليلاً عند العض. مهم جداً: احتفظ بنصف كوب من ماء السلق النشوي قبل التصفية.',
          audioNarrationText: 'اسلق الباستا حتى تصبح أل دينتي واحتفظ بنصف كوب من ماء السلق.',
          todos: [
            'اغلِ 3 لترات ماء مع ملعقة كبيرة ملح خشن',
            'أضف البيني وقلب لمنع الالتصاق',
            'اطبخ لمدة 9-10 دقائق حتى تصبح متماسكة',
            'احتفظ بنصف كوب من ماء السلق قبل تصفية الباستا',
          ],
        ),
        RecipeStepItem(
          index: 4,
          heading: 'تشويح الثوم والفلفل الحار',
          instructionText: 'سخن زيت الزيتون في مقلاة واسعة على نار متوسطة هادئة، أضف شرائح الثوم ورقائق الفلفل وقلب برفق لمدة دقيقتين حتى تفوح رائحة الثوم دون أن يحترق.',
          audioNarrationText: 'شوح الثوم والفلفل الحار في زيت الزيتون برفق.',
          todos: [
            'سخن زيت الزيتون على نار هادئة',
            'أضف شرائح الثوم ورقائق الفلفل الحار',
            'قلب لمدة 90 ثانية حتى تفوح الرائحة الزكية دون احتراق',
          ],
        ),
        RecipeStepItem(
          index: 5,
          heading: 'تسبيك الصلصة الحارة',
          instructionText: 'اسكب الطماطم الإيطالية المهروسة مع رشة ملح، واتركها تغلي بهدوء لمدة 10-12 دقيقة حتى تتكثف الصلصة.',
          audioNarrationText: 'أضف الطماطم ودع الصلصة تتسبك حتى تصبح كثيفة وغنية.',
        ),
        RecipeStepItem(
          index: 6,
          heading: 'تقليب الباستا مع الصلصة',
          instructionText: 'أضف البيني المصفاة إلى الصلصة مع 2-3 ملاعق من ماء السلق النشوي، وقلب بسرعة على نار قوية لمدة دقيقة حتى تغلف الصلصة المعكرونة بلمعان رائع.',
          audioNarrationText: 'قلب الباستا الساخنة مع الصلصة وماء السلق حتى تتغلف تماماً.',
          todos: [
            'أضف الباستا الساخنة إلى المقلاة',
            'أضف 3 ملاعق من ماء السلق النشوي المحفوظ',
            'قلب بنشاط لمدة دقيقة لتتجانس الصلصة وتصبح لامعة',
            'اطفئ النار واخلط البقدونس المفروم',
          ],
        ),
        RecipeStepItem(
          index: 7,
          heading: 'التذوق والتقييم',
          instructionText: 'قدمها فوراً مع رشة زيت زيتون إضافية وبقدونس، وتذوق نكهة روما الدافئة!',
          audioNarrationText: 'استمتع بطبق بيني ألارابياتا الحار وشاركنا رأيك الكريم!',
        ),
      ],
      feedbackFormFields: const [
        DynamicFormFieldModel(
          id: 'dish_rating',
          title: 'كيف كانت تجربتك مع بيني ألارابياتا؟',
          type: FormFieldType.rating,
          isRequired: true,
          initialValue: 5,
        ),
        DynamicFormFieldModel(
          id: 'spice_balance',
          title: 'كيف كان مستوى حرارة الفلفل؟',
          type: FormFieldType.singleChoice,
          options: ['حرارة رومانية أصيلة ومميزة', 'معتدلة ولطيفة', 'حارة جداً!'],
          isRequired: true,
        ),
        DynamicFormFieldModel(
          id: 'pasta_doneness',
          title: 'كيف كان نضج وقوام المعكرونة؟',
          type: FormFieldType.singleChoice,
          options: ['قوام أل دينتي مثالي', 'طرية قليلاً', 'صلبة أكثر من اللازم'],
        ),
        DynamicFormFieldModel(
          id: 'notes',
          title: 'ملاحظات الشيف',
          type: FormFieldType.text,
          placeholder: 'مثال: أضفت جبن بيكورينو رومان أو مزيداً من البقدونس...',
        ),
        DynamicFormFieldModel(
          id: 'pasta_photo',
          title: 'ارفع صورة لطبق الباستا اللامع',
          type: FormFieldType.imageUpload,
        ),
      ],
    ),
  };
}
