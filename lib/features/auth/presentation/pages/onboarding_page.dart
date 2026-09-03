import 'dart:async';

import 'package:atlas_mobile_pi1/core/l10n/l10n_ext.dart';
import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/responsive.dart';
import 'package:atlas_mobile_pi1/features/auth/presentation/pages/sign_in_page.dart';
import 'package:atlas_mobile_pi1/ui/components/slide_to_start_action.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  Timer? _timer;
  bool getStartedFinished = false;

  @override
  void initState() {
    super.initState();
    getStartedFinished = false;
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_controller.hasClients) {
        _currentPage = (_currentPage + 1) % 3;
        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    getStartedFinished = false;
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (getStartedFinished) {
      return const SignInPage();
    }

    final l10n = context.l10n;
    final short = AppResponsive.isShort(context);
    final iconSize = AppResponsive.font(context, base: 64, min: 44, max: 72);

    return Scaffold(
      backgroundColor: AppColors.surface(context),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: [
                  _baseSlide(
                    icon: Icons.fitness_center,
                    title: l10n.onboardingTitle1,
                    subtitle: l10n.onboardingSubtitle1,
                    iconSize: iconSize,
                  ),
                  _baseSlide(
                    icon: Icons.show_chart,
                    title: l10n.onboardingTitle2,
                    subtitle: l10n.onboardingSubtitle2,
                    iconSize: iconSize,
                  ),
                  _baseSlide(
                    icon: Icons.local_fire_department,
                    title: l10n.onboardingTitle3,
                    subtitle: l10n.onboardingSubtitle3,
                    iconSize: iconSize,
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary(context),
                borderRadius: AppRadii.authPanel,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  short ? 16 : 24,
                  16,
                  20 + MediaQuery.paddingOf(context).bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.authWelcomeSlide,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppResponsive.font(
                          context,
                          base: 20,
                          min: 16,
                          max: 22,
                        ),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary(context),
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: short ? 12 : 16),
                    SlideToStartAction(
                      text: l10n.authGetStarted,
                      borderRadius: 100,
                      height: short ? 58 : 66,
                      onSubmit: () {
                        setState(() {
                          getStartedFinished = true;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _baseSlide({
    required IconData icon,
    required String title,
    required String subtitle,
    required double iconSize,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.isCompact(context) ? 20 : 32,
                vertical: 16,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: iconSize, color: AppColors.accentOf(context)),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textPrimary(context),
                      fontSize: AppResponsive.font(
                        context,
                        base: 26,
                        min: 20,
                        max: 28,
                      ),
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: AppResponsive.font(
                        context,
                        base: 16,
                        min: 13,
                        max: 17,
                      ),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
