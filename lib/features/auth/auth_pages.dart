import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_state.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, this.signUp = false});
  final bool signUp;
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController(),
      phone = TextEditingController(),
      password = TextEditingController(),
      confirm = TextEditingController();
  bool obscured = true;
  @override
  void dispose() {
    for (final c in [email, phone, password, confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> submit() async {
    if (!form.currentState!.validate()) return;
    if (widget.signUp) {
      go(context, '/otp');
    } else {
      await AppScope.of(context).signIn(true);
      if (mounted) home(context);
    }
  }

  @override
  Widget build(BuildContext context) => Screen(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 35, bottom: 24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AuthTab(
                  'Sign in',
                  selected: !widget.signUp,
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/signin'),
                ),
                _AuthTab(
                  'Sign up',
                  selected: widget.signUp,
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/signup'),
                ),
              ],
            ),
            if (!widget.signUp) ...[
              const SizedBox(height: 32),
              const FoodImage('signin', height: 200),
              const SizedBox(height: 32),
            ] else
              const SizedBox(height: 40),
            SoftCard(
              child: Form(
                key: form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 0, 24),
                      child: Text(
                        widget.signUp ? 'Fill in this form' : 'Hi, Friend!',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    if (widget.signUp) ...[
                      TextFormField(
                        key: const ValueKey('phone'),
                        controller: phone,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Phone number',
                          prefixIcon: Icon(
                            Icons.phone_in_talk_outlined,
                            size: 20,
                          ),
                          prefixText: '+84  ',
                        ),
                        validator: (v) =>
                            (v ?? '').replaceAll(RegExp(r'\D'), '').length < 7
                            ? 'Enter a valid phone number'
                            : null,
                      ),
                      const SizedBox(height: 16),
                    ],
                    TextFormField(
                      key: const ValueKey('email'),
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: widget.signUp ? 'Email' : 'Email or phone',
                        prefixIcon: const Icon(
                          Icons.mail_outline_rounded,
                          size: 20,
                        ),
                      ),
                      validator: (v) =>
                          RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                                  .hasMatch(v ?? '') ||
                              (!widget.signUp &&
                                  RegExp(r'^\+?[0-9]{7,15}$').hasMatch(v ?? ''))
                          ? null
                          : 'Enter a valid email or phone',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const ValueKey('password'),
                      controller: password,
                      obscureText: obscured,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          tooltip: 'Show password',
                          onPressed: () => setState(() => obscured = !obscured),
                          icon: Icon(
                            obscured
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 19,
                          ),
                        ),
                      ),
                      validator: (v) => (v ?? '').length >= 6
                          ? null
                          : 'Use at least 6 characters',
                    ),
                    if (widget.signUp) ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const ValueKey('confirm'),
                        controller: confirm,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Confirm password',
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                            size: 20,
                          ),
                        ),
                        validator: (v) => v == password.text
                            ? null
                            : 'Passwords do not match',
                      ),
                    ],
                    const SizedBox(height: 30),
                    PrimaryButton(
                      widget.signUp ? 'Sign up' : 'Sign in',
                      onPressed: submit,
                    ),
                    if (!widget.signUp)
                      Center(
                        child: TextButton(
                          onPressed: () => go(context, '/forgot'),
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'Local demo · no real account required',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(fontSize: 11),
            ),
            TextButton(
              onPressed: () => go(context, '/language'),
              child: const Text(
                'Choose the language',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _AuthTab extends StatelessWidget {
  const _AuthTab(this.label, {required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onTap,
    style: TextButton.styleFrom(
      foregroundColor: selected
          ? Colors.white
          : Theme.of(context).textTheme.bodySmall?.color,
      backgroundColor: selected ? orange : Colors.transparent,
      minimumSize: const Size(98, 42),
    ),
    child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
  );
}

class RecoveryPage extends StatefulWidget {
  const RecoveryPage({super.key, this.otp = false});
  final bool otp;
  @override
  State<RecoveryPage> createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage> {
  final controller = TextEditingController();
  String? error;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (widget.otp) {
      if (controller.text != '1490') {
        setState(() => error = 'Use the demo code 1490');
        return;
      }
      await AppScope.of(context).signIn(true);
      if (mounted) home(context);
    } else if (controller.text.replaceAll(RegExp(r'\D'), '').length < 7) {
      setState(() => error = 'Enter a valid phone number');
    } else {
      go(context, '/otp');
    }
  }

  @override
  Widget build(BuildContext context) => Screen(
    back: true,
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(
            widget.otp ? 'OTP' : 'Forgot password',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 18),
          Text(
            widget.otp
                ? 'Please enter the 4 digit code sent\nto your phone number'
                : 'Please enter your phone number.\nWe will send an OTP code to you.',
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 90),
          TextField(
            key: ValueKey(widget.otp ? 'otp' : 'recovery-phone'),
            controller: controller,
            keyboardType: widget.otp
                ? TextInputType.number
                : TextInputType.phone,
            maxLength: widget.otp ? 4 : 15,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyle(
              fontSize: widget.otp ? 28 : 16,
              letterSpacing: widget.otp ? 24 : 0,
            ),
            decoration: InputDecoration(
              hintText: widget.otp ? '− − − −' : 'Phone number',
              errorText: error,
              counterText: '',
              prefixIcon: widget.otp ? null : const Icon(Icons.phone_outlined),
              prefixText: widget.otp ? null : '+84  ',
            ),
          ),
          const SizedBox(height: 28),
          if (widget.otp)
            Text(
              'Demo code: 1490',
              style: Theme.of(context).textTheme.bodySmall,
            )
          else
            TextButton(
              onPressed: () => go(context, '/signin'),
              child: const Text(
                'Try others',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          const SizedBox(height: 36),
          PrimaryButton(widget.otp ? 'Send' : 'Confirm', onPressed: submit),
        ],
      ),
    ),
  );
}

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Screen(
      back: true,
      child: ListView(
        children: [
          const SizedBox(height: 12),
          Text(
            'Choose the language',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 42),
          for (final entry in const {
            'English': 'EN',
            'Vietnamese': 'VI',
            'Korean': 'KO',
            'Chinese': 'ZH',
          }.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SoftCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                onTap: () => state.setLanguage(entry.key),
                child: SizedBox(
                  height: 46,
                  child: Row(
                    children: [
                      Container(
                        width: 25,
                        height: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: orange.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          entry.value,
                          style: const TextStyle(
                            color: orange,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(entry.key)),
                      Icon(
                        state.language == entry.key
                            ? Icons.check_circle_rounded
                            : Icons.circle,
                        color: state.language == entry.key
                            ? orange
                            : Theme.of(context).dividerColor,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              'Preference saved on this device',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            'Continue',
            onPressed: () =>
                state.signedIn ? home(context) : go(context, '/signin'),
          ),
        ],
      ),
    );
  }
}
