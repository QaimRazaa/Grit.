import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/sizes.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/device/responsive_size.dart';
import 'package:grit/utils/validators/app_validators.dart';
import 'package:grit/features/authentication/viewmodel/signin/signin_viewmodel.dart';
import 'package:grit/features/authentication/viewmodel/signup/obscure_password_provider.dart';
import 'package:grit/shared/widgets/textfield/custom_text_field.dart';
import 'package:grit/shared/widgets/button/elevated_button.dart';
import 'package:grit/features/authentication/view/signin/widgets/signin_widgets.dart';
import 'package:grit/utils/popups/snackbar.dart';

class SigninScreen extends ConsumerStatefulWidget {
  const SigninScreen({super.key});

  @override
  ConsumerState<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends ConsumerState<SigninScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(signinViewModelProvider.notifier).submit(
            onSuccess: (route) {
              if (mounted) context.go(route);
            },
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(signinViewModelProvider.select((s) => s.globalError), (previous, next) {
      if (next != null) {
        AppSnackBar.showError(context, next);
      }
    });

    final state = ref.watch(signinViewModelProvider);
    final obscurePassword = ref.watch(obscurePasswordProvider('signin'));

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
                    AppTexts.signinTitle,
                    style: AppTextStyles.font24Bold.copyWith(
                      fontSize: AppSizes.font(GritSizes.fontSize24),
                    ),
                  ),
                  SizedBox(height: AppSizes.height(GritSizes.gap6)),
                  Text(
                    AppTexts.signinSubtitle,
                    style: AppTextStyles.font14RegularMuted.copyWith(
                      fontSize: AppSizes.font(GritSizes.fontSize14),
                    ),
                  ),
                  SizedBox(height: AppSizes.height(GritSizes.gap24)),
                  CustomTextField(
                    hintText: AppTexts.emailPlaceholder,
                    labelText: AppTexts.emailLabel,
                    controller: _emailController,
                    focusNode: _emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    height: AppSizes.height(GritSizes.size52),
                    onChanged: (v) => ref.read(signinViewModelProvider.notifier).setEmail(v),
                    onSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocus),
                    validator: AppValidators.validateEmail,
                  ),
                  SizedBox(height: AppSizes.height(GritSizes.gap16)),
                  CustomTextField(
                    hintText: AppTexts.signinPasswordPlaceholder,
                    labelText: AppTexts.passwordLabel,
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    obscureText: obscurePassword,
                    textInputAction: TextInputAction.done,
                    height: AppSizes.height(GritSizes.size52),
                    onChanged: (v) => ref.read(signinViewModelProvider.notifier).setPassword(v),
                    onSubmitted: (_) {
                      if (state.isButtonActive) _handleSubmit();
                    },
                    validator: AppValidators.validatePasswordSignin,
                    suffixIcon: Icon(
                      obscurePassword
                          ? CupertinoIcons.eye
                          : CupertinoIcons.eye_slash,
                      color: obscurePassword ? AppColors.muted : AppColors.amber,
                      size: AppSizes.icon(GritSizes.size20),
                    ),
                    onSuffixTap: () {
                      ref.read(obscurePasswordProvider('signin').notifier).state =
                          !obscurePassword;
                    },
                  ),
                  SizedBox(height: AppSizes.height(GritSizes.gap8)),
                  const SigninForgotPasswordLink(),
                  SizedBox(height: AppSizes.height(GritSizes.gap24)),
                  CustomElevatedButton(
                    text: AppTexts.buttonLogin,
                    textColor: state.isButtonActive ? AppColors.background : AppColors.dim,
                    backgroundColor: state.isButtonActive ? AppColors.amber : AppColors.surface2,
                    onPressed: (state.isButtonActive && !state.isLoading)
                        ? _handleSubmit
                        : null,
                    width: double.infinity,
                    height: GritSizes.size52,
                    borderRadius: GritSizes.radius12,
                    fontSize: AppSizes.font(GritSizes.fontSize15),
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
                  SizedBox(height: AppSizes.height(GritSizes.gap16)),
                  const SigninSignupLink(),
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
