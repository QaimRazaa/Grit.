import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grit/core/routes/app_routes.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/sizes.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/device/responsive_size.dart';
import 'package:grit/utils/validators/app_validators.dart';
import 'package:grit/features/authentication/viewmodel/signup/signup_viewmodel.dart';
import 'package:grit/features/authentication/viewmodel/signup/obscure_password_provider.dart';
import 'package:grit/shared/widgets/textfield/custom_text_field.dart';
import 'package:grit/shared/widgets/button/elevated_button.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(signupViewModelProvider.notifier).submit(
        onSuccess: () {
          if (mounted) context.go(AppRoutes.goalFormStep1);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signupViewModelProvider);
    final obscurePassword = ref.watch(obscurePasswordProvider('signup'));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.width(GritSizes.gap20),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSizes.height(20)),
                  Text(
                    AppTexts.signupTitle,
                    style: AppTextStyles.font24Bold.copyWith(
                      fontSize: AppSizes.font(24.0),
                    ),
                  ),
                  SizedBox(height: AppSizes.height(GritSizes.gap6)),
                  Text(
                    AppTexts.signupSubtitle,
                    style: AppTextStyles.font14Regular.copyWith(
                      fontSize: AppSizes.font(14.0),
                      color: AppColors.muted,
                    ),
                  ),
                  SizedBox(height: AppSizes.height(GritSizes.gap24)),
                  CustomTextField(
                    hintText: AppTexts.namePlaceholder,
                    labelText: AppTexts.nameLabel,
                    controller: _nameController,
                    focusNode: _nameFocus,
                    textInputAction: TextInputAction.next,
                    height: AppSizes.height(GritSizes.size52),
                    onChanged: (v) => ref.read(signupViewModelProvider.notifier).setName(v),
                    onSubmitted: (_) => FocusScope.of(context).requestFocus(_emailFocus),
                    validator: AppValidators.validateName,
                  ),
                  SizedBox(height: AppSizes.height(GritSizes.gap16)),
                  CustomTextField(
                    hintText: AppTexts.emailPlaceholder,
                    labelText: AppTexts.emailLabel,
                    controller: _emailController,
                    focusNode: _emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    height: AppSizes.height(GritSizes.size52),
                    onChanged: (v) => ref.read(signupViewModelProvider.notifier).setEmail(v),
                    onSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocus),
                    validator: AppValidators.validateEmail,
                  ),
                  SizedBox(height: AppSizes.height(GritSizes.gap16)),
                  CustomTextField(
                    hintText: AppTexts.passwordPlaceholder,
                    labelText: AppTexts.passwordLabel,
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    obscureText: obscurePassword,
                    textInputAction: TextInputAction.done,
                    height: AppSizes.height(GritSizes.size52),
                    onChanged: (v) => ref.read(signupViewModelProvider.notifier).setPassword(v),
                    onSubmitted: (_) {
                      if (state.isButtonActive) {
                        _handleSubmit();
                      }
                    },
                    validator: AppValidators.validatePassword,
                    suffixIcon: Icon(
                      obscurePassword
                          ? CupertinoIcons.eye
                          : CupertinoIcons.eye_slash,
                      color: obscurePassword ? AppColors.muted : AppColors.amber,
                      size: AppSizes.icon(GritSizes.size20),
                    ),
                    onSuffixTap: () {
                      ref.read(obscurePasswordProvider('signup').notifier).state =
                          !obscurePassword;
                    },
                  ),
                  SizedBox(height: AppSizes.height(GritSizes.gap24)),
                  CustomElevatedButton(
                    text: AppTexts.buttonCreateAccount,
                    textColor: state.isButtonActive ? AppColors.background : AppColors.dim,
                    backgroundColor: state.isButtonActive ? AppColors.amber : AppColors.surface2,
                    onPressed: (state.isButtonActive && !state.isLoading)
                        ? _handleSubmit
                        : null,
                    width: double.infinity,
                    height: GritSizes.size52,
                    borderRadius: GritSizes.radius12,
                    fontSize: AppSizes.font(15.0),
                    icon: state.isLoading
                        ? SizedBox(
                            height: AppSizes.height(20.0),
                            width: AppSizes.width(20.0),
                            child: const CircularProgressIndicator(
                              color: AppColors.white,
                              strokeWidth: 2.0,
                            ),
                          )
                        : null,
                  ),
                  if (state.globalError != null)
                    Padding(
                      padding: EdgeInsets.only(top: AppSizes.height(8.0)),
                      child: Center(
                        child: Text(
                          state.globalError!,
                          style: AppTextStyles.font12RegularRed.copyWith(
                            fontSize: AppSizes.font(12.0),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  SizedBox(height: AppSizes.height(16.0)),
                  Center(
                    child: GestureDetector(
                      onTap: () => context.go(AppRoutes.signin),
                      child: RichText(
                        text: TextSpan(
                          text: '${AppTexts.loginPromptText} ',
                          style: AppTextStyles.font13RegularAmber.copyWith(
                            color: AppColors.muted,
                            fontSize: AppSizes.font(13.0),
                          ),
                          children: [
                            TextSpan(
                              text: AppTexts.loginLinkText,
                              style: AppTextStyles.font13RegularAmber.copyWith(
                                color: AppColors.amber,
                                fontSize: AppSizes.font(13.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSizes.height(40)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
