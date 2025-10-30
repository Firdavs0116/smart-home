import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home1/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:smart_home1/features/auth/presentation/bloc/auth_event.dart';
import 'package:smart_home1/features/auth/presentation/bloc/auth_state.dart';
import 'package:smart_home1/features/auth/presentation/screens/signin_page.dart';
import 'package:smart_home1/features/home/presentation/screens/home_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscure = true;
  bool _agreed = false;
  String? _emailError;
  double _pwdStrength = 0.0;

  @override
  void initState() {
    super.initState();
    _emailCtrl.addListener(_validateEmailRealtime);
    _passwordCtrl.addListener(_calcPwdStrength);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _validateEmailRealtime() {
    final text = _emailCtrl.text.trim();
    if (text.isEmpty) {
      setState(() => _emailError = null);
      return;
    }
    final emailValid = RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$")
        .hasMatch(text);
    setState(() => _emailError = emailValid ? null : 'To\'g\'ri email kiriting');
  }

  void _calcPwdStrength() {
    final pwd = _passwordCtrl.text;
    double score = 0;
    if (pwd.length >= 6) score += 0.25;
    if (pwd.length >= 8) score += 0.15;
    if (RegExp(r'[A-Z]').hasMatch(pwd)) score += 0.2;
    if (RegExp(r'[0-9]').hasMatch(pwd)) score += 0.2;
    if (RegExp(r'[!@#\$&*~^%(),.?":{}|<>]').hasMatch(pwd)) score += 0.2;
    if (score > 1) score = 1;
    setState(() => _pwdStrength = score);
  }

  String _pwdLabel(double s) {
    if (s < 0.3) return 'Juda zaif';
    if (s < 0.6) return 'O\'rta';
    if (s < 0.85) return 'Kuchli';
    return 'Juda kuchli';
  }

  void _signUp() {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Iltimos, shartlarga rozilik bering")),
      );
      return;
    }

    context.read<AuthBloc>().add(
          SignUpEvent(
            email: _emailCtrl.text.trim(),
            password: _passwordCtrl.text,
            name: _nameCtrl.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AuthAuthenticated) {
            // ✅ Muvaffaqiyatli ro'yxatdan o'tgandan keyin HomeScreen'ga o'tish
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Container(
                  width: 480,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 8)
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 4),
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Icon(
                            Icons.home_rounded,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Ro'yxatdan o'tish",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Aqlli uy tizimining ilk qadamlari.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 16),

                        // Name
                        TextFormField(
                          controller: _nameCtrl,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person_outline),
                            hintText: "Ism",
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? "Ismingizni kiriting"
                              : null,
                        ),
                        const SizedBox(height: 12),

                        // Email
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email_outlined),
                            hintText: "Email",
                            errorText: _emailError,
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return "Email kiriting";
                            if (_emailError != null) return _emailError;
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // Password
                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: _obscure,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline),
                            hintText: "Parol",
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () => setState(() => _obscure = !_obscure),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return "Parol kiriting";
                            if (v.length < 6) {
                              return "Parol kamida 6 ta belgidan iborat bo'lishi kerak";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),

                        // Password strength
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: _pwdStrength,
                                minHeight: 6,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _pwdStrength < 0.3
                                      ? Colors.red
                                      : _pwdStrength < 0.6
                                          ? Colors.orange
                                          : _pwdStrength < 0.85
                                              ? Colors.blue
                                              : Colors.green,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(_pwdLabel(_pwdStrength)),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Confirm password
                        TextFormField(
                          controller: _confirmCtrl,
                          obscureText: _obscure,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline),
                            hintText: "Parolni tasdiqlang",
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return "Parolni tasdiqlang";
                            if (v != _passwordCtrl.text) return "Parol mos kelmadi";
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // Terms
                        Row(
                          children: [
                            Checkbox(
                              value: _agreed,
                              onChanged: (val) => setState(() => _agreed = val ?? false),
                            ),
                            Expanded(
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(color: Colors.black87),
                                  children: [
                                    TextSpan(text: "Men "),
                                    TextSpan(
                                      text: "Xizmat shartlari",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    TextSpan(text: " va "),
                                    TextSpan(
                                      text: "Maxfiylik siyosati",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    TextSpan(text: " bilan roziman"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Sign up button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _signUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "Ro'yxatdan o'tish",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Allaqachon hisobingiz bormi? "),
                            GestureDetector(
                              onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignInPage(),
                                ),
                              ),
                              child: const Text(
                                "Kirish",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}