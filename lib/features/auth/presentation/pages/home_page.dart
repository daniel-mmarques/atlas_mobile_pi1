import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_radii.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/core/theme/responsive.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:atlas_mobile_pi1/ui/components/app_action_button.dart';
import 'package:atlas_mobile_pi1/ui/components/app_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final user = auth.appUser;
    final name =
        user?.name?.isNotEmpty == true ? user!.name! : 'atleta';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Atlas',
          style: TextStyle(
            fontSize: AppResponsive.font(context, base: 20, min: 18),
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: AppResponsive.pagePadding(context).copyWith(
                top: AppSpacing.lg,
                bottom: AppSpacing.xxl,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Olá, $name!',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontSize: AppResponsive.font(
                                    context,
                                    base: 20,
                                    min: 17,
                                    max: 22,
                                  ),
                                ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            user?.email ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.textSecondary(context),
                                  fontSize: AppResponsive.font(
                                    context,
                                    base: 14,
                                    min: 12,
                                  ),
                                ),
                          ),
                          if (user?.activityLevel != null) ...[
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Atividade: ${user!.activityLevel!.label}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontSize: AppResponsive.font(
                                      context,
                                      base: 13,
                                      min: 12,
                                    ),
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    AppActionButton(
                      label: 'Sair',
                      emphasized: true,
                      borderRadius: AppRadii.pill,
                      onTap: () => context.read<AuthService>().logout(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Bem-vindo ao Atlas.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textSecondary(context),
                        fontSize: AppResponsive.font(
                          context,
                          base: 13,
                          min: 12,
                        ),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
