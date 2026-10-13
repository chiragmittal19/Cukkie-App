import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/services/local/secure_prefs_service.dart';

/// Premium animated splash screen for Cukkie.
/// Provides a seamless transition from the OS native splash window with warm
/// culinary aesthetics, micro-animations, glowing emblem, and brand storytelling.
class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _pulseController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _badgesFade;
  late final Animation<Offset> _badgesSlide;
  late final Animation<double> _footerFade;

  Timer? _navTimer;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _logoFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.45, curve: Curves.easeIn),
    );

    _logoScale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
      ),
    );

    _titleFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.35, 0.75, curve: Curves.easeIn),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _badgesFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.55, 0.90, curve: Curves.easeIn),
    );

    _badgesSlide = Tween<Offset>(
      begin: const Offset(0, 0.30),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.55, 0.90, curve: Curves.easeOutCubic),
      ),
    );

    _footerFade = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.70, 1.0, curve: Curves.easeIn),
    );

    _entranceController.forward();

    // Automatically navigate after animation sequence (2.4 seconds so user can enjoy the vibe)
    _navTimer = Timer(const Duration(milliseconds: 2400), _navigateToNext);
  }

  void _navigateToNext() {
    if (!mounted || _navigated) return;
    _navigated = true;

    final isFirstLaunchDone = SecurePrefsService.instance.isFirstLaunchDone();
    final target = isFirstLaunchDone
        ? '/home'
        : '/language?isInitialOnboarding=true';

    context.go(target);
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _entranceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: _navigateToNext,
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.15,
              colors: isDark
                  ? const [
                      Color(0xFF261D19),
                      Color(0xFF1B130E),
                      Color(0xFF140D0A),
                    ]
                  : const [
                      Color(0xFFFFFDFB),
                      Color(0xFFFFF9F2),
                      Color(0xFFF7EDE3),
                    ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),

                // Center Emblem & Brand Section
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Glowing Animated App Logo
                      AnimatedBuilder(
                        animation: Listenable.merge([
                          _entranceController,
                          _pulseController,
                        ]),
                        builder: (context, child) {
                          final pulseValue = _pulseController.value;
                          final breatheScale = 1.0 + (pulseValue * 0.03);

                          return Transform.scale(
                            scale: _logoScale.value * breatheScale,
                            child: FadeTransition(
                              opacity: _logoFade,
                              child: Container(
                                width: 164,
                                height: 164,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFE65100).withValues(
                                        alpha: 0.32 + (pulseValue * 0.15),
                                      ),
                                      blurRadius: 42 + (pulseValue * 14),
                                      spreadRadius: 6 + (pulseValue * 4),
                                    ),
                                    BoxShadow(
                                      color: const Color(0xFFFFB300).withValues(
                                        alpha: 0.22 + (pulseValue * 0.08),
                                      ),
                                      blurRadius: 22,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/cukkie_icon_full.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 28),

                      // Brand Name Typography: Cukkie
                      SlideTransition(
                        position: _titleSlide,
                        child: FadeTransition(
                          opacity: _titleFade,
                          child: Column(
                            children: [
                              Text(
                                'Cukkie',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                  color: isDark
                                      ? const Color(0xFFFFF0E6)
                                      : const Color(0xFF2E1C14),
                                  shadows: [
                                    Shadow(
                                      color: const Color(0xFFE65100).withValues(
                                        alpha: isDark ? 0.45 : 0.15,
                                      ),
                                      blurRadius: 16,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'YOUR COOKING COMPANION',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2.8,
                                  color: isDark
                                      ? const Color(0xFFFFB380)
                                      : const Color(0xFFB54924),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Vibe Pills: Food • Recipes • Love
                      SlideTransition(
                        position: _badgesSlide,
                        child: FadeTransition(
                          opacity: _badgesFade,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF33241F).withValues(alpha: 0.8)
                                  : const Color(0xFFFFEDE0).withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF5A3B30)
                                    : const Color(0xFFFFD5BD),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFE65100).withValues(
                                    alpha: 0.08,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildVibeChip(
                                  label: 'Food',
                                  icon: '🍽️',
                                  isDark: isDark,
                                ),
                                _buildDot(isDark),
                                _buildVibeChip(
                                  label: 'Recipes',
                                  icon: '📖',
                                  isDark: isDark,
                                ),
                                _buildDot(isDark),
                                _buildVibeChip(
                                  label: 'Love',
                                  icon: '❤️',
                                  isDark: isDark,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 4),

                // Bottom Ambient Loading Line & Note
                FadeTransition(
                  opacity: _footerFade,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Subtle shimmer bar
                        SizedBox(
                          width: 48,
                          height: 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: const LinearProgressIndicator(
                              backgroundColor: Color(0x22E65100),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.saffronPrimary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Cooking up delicious ideas...',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                            color: isDark
                                ? const Color(0xFFA69389)
                                : const Color(0xFF8C7569),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVibeChip({
    required String label,
    required String icon,
    required bool isDark,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          icon,
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: isDark ? const Color(0xFFFFD5BD) : const Color(0xFF9E3615),
          ),
        ),
      ],
    );
  }

  Widget _buildDot(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        '•',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w900,
          color: isDark ? const Color(0xFF8A5A48) : const Color(0xFFE29E80),
        ),
      ),
    );
  }
}
