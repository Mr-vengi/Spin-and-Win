import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_mark.dart';
import '../widgets/wavy_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _password = TextEditingController();
  bool _obscurePassword = true;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    final accepted = context.read<AppState>().login(_name.text, _password.text);
    if (!accepted) {
      setState(
        () => _error = 'That name does not match this device’s saved profile.',
      );
      return;
    }
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return _AuthBackdrop(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 28, 22, 34),
        child: Column(
          children: [
            const SizedBox(height: 15),
            const _AuthWheelHero(),
            const SizedBox(height: 18),
            const BrandMark(),
            const SizedBox(height: 25),
            WavyCard(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 21),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Login',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1.2,
                          ),
                    ),
                  ),
                  const Center(child: Text('Sign in to continue.')),
                  const SizedBox(height: 21),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _label('NAME'),
                        TextFormField(
                          controller: _name,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            hintText: 'Your name',
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? 'Enter your name'
                              : null,
                        ),
                        const SizedBox(height: 15),
                        _label('PASSWORD'),
                        TextFormField(
                          controller: _password,
                          obscureText: _obscurePassword,
                          onFieldSubmitted: (_) => _login(),
                          decoration: InputDecoration(
                            hintText: 'Your password',
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Enter your password'
                              : null,
                        ),
                      ],
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],
                  const SizedBox(height: 20),
                  _DarkButton(label: 'Log in', onPressed: _login),
                ],
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
              child: const Text('Forgot password?'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/signup'),
              child: const Text('New here?  Create an account'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Local demo account · Your profile stays on this device',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.greenDeep, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _referral = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _referral.dispose();
    super.dispose();
  }

  void _signup() {
    if (!_formKey.currentState!.validate()) return;
    final created = context.read<AppState>().signUp(
      name: _name.text,
      email: _email.text,
      password: _password.text,
      referralCode: _referral.text,
    );
    if (created) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _AuthBackdrop(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 25, 22, 34),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: BrandMark(compact: true),
            ),
            const SizedBox(height: 27),
            WavyCard(
              padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Join Bagul',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text('A little spin. A real gift.'),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _labeledField('NAME', _name, hint: 'Your name'),
                        _labeledField(
                          'EMAIL',
                          _email,
                          hint: 'you@example.com',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || !value.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        _label('PASSWORD'),
                        TextFormField(
                          controller: _password,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'At least 6 characters',
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          validator: (value) =>
                              value == null || value.length < 6
                              ? 'Use at least 6 characters'
                              : null,
                        ),
                        _labeledField(
                          'REFERRAL CODE (OPTIONAL)',
                          _referral,
                          hint: 'Have a friend’s code?',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 21),
                  _DarkButton(label: 'Create account', onPressed: _signup),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('Already have an account?  Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AuthBackdrop(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(23, 38, 23, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
            const SizedBox(height: 26),
            const BrandMark(),
            const SizedBox(height: 42),
            Text(
              'FORGOT\nPASSWORD?',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Username or email'),
            ),
            const SizedBox(height: 28),
            Align(
              alignment: Alignment.center,
              child: _DarkButton(
                label: 'SEND',
                onPressed: () {
                  if (!_email.text.contains('@')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Enter a valid email address'),
                      ),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Password reset is not available in this local demo.',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthBackdrop extends StatelessWidget {
  const _AuthBackdrop({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFC15A), AppColors.orange, AppColors.orangeDeep],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(child: child),
      ),
    );
  }
}

class _AuthWheelHero extends StatelessWidget {
  const _AuthWheelHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 154,
      height: 154,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.cream.withValues(alpha: 0.4),
        border: Border.all(color: AppColors.gold, width: 2),
      ),
      child: const DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.green,
        ),
        child: Icon(Icons.casino, color: AppColors.gold, size: 89),
      ),
    );
  }
}

class _DarkButton extends StatelessWidget {
  const _DarkButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

Widget _label(String value) => Padding(
  padding: const EdgeInsets.only(bottom: 7),
  child: Align(
    alignment: Alignment.centerLeft,
    child: Text(
      value,
      style: const TextStyle(
        fontSize: 11,
        letterSpacing: 1.6,
        fontWeight: FontWeight.w700,
        color: AppColors.greenDeep,
      ),
    ),
  ),
);

Widget _labeledField(
  String label,
  TextEditingController controller, {
  required String hint,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Column(
      children: [
        _label(label),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: hint),
          validator:
              validator ??
              (value) => value == null || value.trim().isEmpty
                  ? 'This field is required'
                  : null,
        ),
      ],
    ),
  );
}
