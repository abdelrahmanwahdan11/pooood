import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/glass_container.dart';
import '../../data/repositories/watch_store_repo.dart';
import 'auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = Get.find<WatchStoreRepository>();
    final hero = repo.fetchWatches(page: 0, limit: 1).then((value) => value.first);
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 680;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('welcome_back'.tr, style: theme.textTheme.headlineSmall),
                      const Spacer(),
                      TextButton(
                        onPressed: controller.loginAsGuest,
                        child: Text('continue_guest'.tr),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: isWide
                        ? Row(
                            children: [
                              Expanded(
                                child: FutureBuilder(
                                  future: hero,
                                  builder: (context, snapshot) {
                                    return _AuthHeroCard(itemTitle: snapshot.data?.name ?? '');
                                  },
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(child: _buildForm(theme)),
                            ],
                          )
                        : SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                FutureBuilder(
                                  future: hero,
                                  builder: (context, snapshot) => _AuthHeroCard(
                                    itemTitle: snapshot.data?.name ?? '',
                                    compact: true,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                _buildForm(theme),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildForm(ThemeData theme) {
    return Obx(
      () => AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        child: switch (controller.stage.value) {
          AuthStage.login => _LoginForm(theme: theme, controller: controller),
          AuthStage.register => _RegisterForm(theme: theme, controller: controller),
          AuthStage.verify => _VerifyForm(theme: theme, controller: controller),
        },
      ),
    );
  }
}

class _AuthHeroCard extends StatelessWidget {
  const _AuthHeroCard({required this.itemTitle, this.compact = false});

  final String itemTitle;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassContainer(
      borderRadius: 32,
      padding: const EdgeInsets.all(24),
      gradient: LinearGradient(
        colors: [
          const Color(0xFF141A37).withOpacity(0.95),
          const Color(0xFF1E2B60).withOpacity(0.65),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('smart_entry_title'.tr, style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white)),
          const SizedBox(height: 12),
          Text(
            'smart_entry_desc'.tr,
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
          ),
          const Spacer(),
          Container(
            height: compact ? 160 : 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: Colors.white.withOpacity(0.18),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.watch_rounded, size: compact ? 88 : 120, color: Colors.white.withOpacity(0.9)),
                const SizedBox(height: 12),
                Text(
                  itemTitle.isEmpty ? 'ultra_watch'.tr : itemTitle,
                  style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeroTag(label: 'biometric_ready'.tr, icon: Icons.fingerprint_rounded),
              _HeroTag(label: 'otp_protected'.tr, icon: Icons.verified_user_rounded),
              _HeroTag(label: 'secure_checkout'.tr, icon: Icons.lock_rounded),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroTag extends StatelessWidget {
  const _HeroTag({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppTheme.accentPrimary),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({required this.theme, required this.controller});

  final ThemeData theme;
  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 28,
      padding: const EdgeInsets.all(24),
      child: Form(
        key: controller.loginFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('login_title'.tr, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text('login_subtitle'.tr, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),
            TextFormField(
              controller: controller.loginEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'email'.tr,
                prefixIcon: const Icon(Icons.mail_outline_rounded),
              ),
              validator: controller.validateEmail,
              onFieldSubmitted: (_) => controller.login(),
            ),
            const SizedBox(height: 16),
            Obx(
              () => TextFormField(
                controller: controller.loginPasswordController,
                obscureText: controller.obscurePassword.value,
                decoration: InputDecoration(
                  labelText: 'password'.tr,
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(controller.obscurePassword.value
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded),
                    onPressed: controller.obscurePassword.toggle,
                  ),
                ),
                validator: controller.validatePassword,
                onFieldSubmitted: (_) => controller.login(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Obx(
                  () => Checkbox(
                    value: controller.rememberMe.value,
                    onChanged: (_) => controller.rememberMe.toggle(),
                  ),
                ),
                Text('remember_me'.tr),
                const Spacer(),
                TextButton(
                  onPressed: () => controller.goToStage(AuthStage.register),
                  child: Text('create_account'.tr),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                child: controller.authError.value == null
                    ? const SizedBox.shrink()
                    : Text(
                        controller.authError.value!,
                        key: ValueKey(controller.authError.value),
                        style: theme.textTheme.bodyMedium?.copyWith(color: AppTheme.accentSuccess),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => FilledButton(
                onPressed: controller.isLoading.value ? null : controller.login,
                child: controller.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text('login_button'.tr),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: controller.loginAsGuest,
              child: Text('continue_guest'.tr),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.2, end: 0);
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm({required this.theme, required this.controller});

  final ThemeData theme;
  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 28,
      padding: const EdgeInsets.all(24),
      child: Form(
        key: controller.registerFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('register_title'.tr, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text('register_subtitle'.tr, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),
            TextFormField(
              controller: controller.registerNameController,
              decoration: InputDecoration(
                labelText: 'name'.tr,
                prefixIcon: const Icon(Icons.person_outline_rounded),
              ),
              validator: controller.validateName,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.registerEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'email'.tr,
                prefixIcon: const Icon(Icons.mail_outline_rounded),
              ),
              validator: controller.validateEmail,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.registerPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'password'.tr,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
              ),
              validator: controller.validatePassword,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.registerConfirmController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'confirm_password'.tr,
                prefixIcon: const Icon(Icons.lock_person_rounded),
              ),
              validator: controller.validatePassword,
            ),
            const SizedBox(height: 12),
            Obx(
              () => SwitchListTile.adaptive(
                value: controller.acceptTerms.value,
                onChanged: (value) => controller.acceptTerms.value = value,
                title: Text('accept_terms_title'.tr),
                subtitle: Text('accept_terms_desc'.tr),
              ),
            ),
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                child: controller.authError.value == null
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          controller.authError.value!,
                          style: theme.textTheme.bodyMedium?.copyWith(color: AppTheme.accentSuccess),
                        ),
                      ),
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () => controller.goToStage(AuthStage.login),
                  child: Text('back_to_login'.tr),
                ),
                const Spacer(),
                Obx(
                  () => FilledButton(
                    onPressed: controller.isLoading.value ? null : controller.register,
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text('continue'.tr),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.2, end: 0);
  }
}

class _VerifyForm extends StatelessWidget {
  const _VerifyForm({required this.theme, required this.controller});

  final ThemeData theme;
  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 28,
      padding: const EdgeInsets.all(24),
      child: Form(
        key: controller.otpFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('verify_title'.tr, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text('verify_subtitle'.tr, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),
            TextFormField(
              controller: controller.otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: 'otp_label'.tr,
                prefixIcon: const Icon(Icons.verified_rounded),
              ),
              validator: controller.validateOtp,
            ),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                'otp_timer'.trParams({'seconds': controller.countdown.value.toString()}),
                style: theme.textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Row(
                children: [
                  TextButton(
                    onPressed: controller.canResendCode.value ? controller.resendCode : null,
                    child: Text('resend_code'.tr),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: controller.verify,
                    child: Text('finish'.tr),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.2, end: 0);
  }
}
