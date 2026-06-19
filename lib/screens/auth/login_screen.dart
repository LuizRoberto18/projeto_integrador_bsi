import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = Get.find<AuthController>();
  bool _isRegister = false;

  // Login fields
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  // Register fields
  final _nameCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  String _disability = '';
  bool _acceptTerms = false;
  bool _showPass = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args?['mode'] == 'register') _isRegister = true;
  }

  Future<void> _login() async {
    final ok = await _auth.login(_emailCtrl.text.trim(), _passCtrl.text);
    if (ok) Get.offAllNamed(AppRoutes.home);
  }

  Future<void> _register() async {
    if (_passCtrl.text != _confirmPassCtrl.text) {
      _auth.errorMessage.value = 'As senhas não coincidem.';
      return;
    }
    if (!_acceptTerms) {
      _auth.errorMessage.value = 'Aceite os Termos de Uso.';
      return;
    }
    final ok = await _auth.register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
      disability: _disability.isEmpty ? null : _disability,
    );
    if (ok) Get.offAllNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                // Logo
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(16)),
                  child: const Center(child: Text('♿', style: TextStyle(fontSize: 28))),
                ),
                const SizedBox(height: 12),
                const Text('INCLUI+', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w800, fontSize: 24, color: AppTheme.primary)),
                const SizedBox(height: 4),
                const Text('Onde você pode ir. Onde você pertence.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                const SizedBox(height: 32),

                Obx(() => Column(
                  children: [
                    if (!_isRegister) ..._loginFields() else ..._registerFields(),
                    if (_auth.errorMessage.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: AppTheme.error.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                        child: Row(children: [
                          const Icon(Icons.error_outline, color: AppTheme.error, size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text(_auth.errorMessage.value, style: const TextStyle(color: AppTheme.error, fontSize: 13))),
                        ]),
                      ),
                    ],
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _auth.isLoading.value ? null : (_isRegister ? _register : _login),
                      child: _auth.isLoading.value
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(_isRegister ? 'Criar minha conta' : 'Entrar'),
                    ),
                    if (!_isRegister) ...[
                      const SizedBox(height: 12),
                      const Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('ou')), Expanded(child: Divider())]),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final ok = await _auth.loginWithGoogle();
                          if (ok) Get.offAllNamed(AppRoutes.home);
                        },
                        icon: const Text('G', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                        label: const Text('Entrar com Google'),
                      ),
                    ],
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => setState(() { _isRegister = !_isRegister; _auth.errorMessage.value = ''; }),
                      child: Text(
                        _isRegister ? 'Já tem conta? Entrar' : 'Não tem conta? Cadastre-se',
                        style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _loginFields() => [
    TextField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Seu e-mail')),
    const SizedBox(height: 12),
    TextField(
      controller: _passCtrl, obscureText: !_showPass,
      decoration: InputDecoration(
        labelText: 'Sua senha',
        suffixIcon: IconButton(icon: Icon(_showPass ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _showPass = !_showPass)),
      ),
    ),
  ];

  List<Widget> _registerFields() => [
    TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Nome completo')),
    const SizedBox(height: 12),
    TextField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Seu e-mail')),
    const SizedBox(height: 12),
    TextField(
      controller: _passCtrl, obscureText: !_showPass,
      decoration: InputDecoration(
        labelText: 'Sua senha',
        suffixIcon: IconButton(icon: Icon(_showPass ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _showPass = !_showPass)),
      ),
    ),
    const SizedBox(height: 12),
    TextField(controller: _confirmPassCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Confirmar senha')),
    const SizedBox(height: 12),
    DropdownButtonFormField<String>(
      value: _disability.isEmpty ? null : _disability,
      decoration: const InputDecoration(labelText: 'Você tem alguma deficiência? (opcional)'),
      items: const [
        DropdownMenuItem(value: 'Física', child: Text('Física')),
        DropdownMenuItem(value: 'Visual', child: Text('Visual')),
        DropdownMenuItem(value: 'Auditiva', child: Text('Auditiva')),
        DropdownMenuItem(value: 'Intelectual', child: Text('Intelectual')),
        DropdownMenuItem(value: 'Prefiro não dizer', child: Text('Prefiro não dizer')),
      ],
      onChanged: (v) => setState(() => _disability = v ?? ''),
    ),
    const SizedBox(height: 12),
    Row(children: [
      Checkbox(value: _acceptTerms, onChanged: (v) => setState(() => _acceptTerms = v ?? false)),
      const Expanded(child: Text('Aceito os Termos de Uso e Política de Privacidade', style: TextStyle(fontSize: 13))),
    ]),
  ];
}