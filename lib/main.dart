import 'package:flutter/material.dart';

void main() => runApp(const AtividadesApp());

class AtividadesApp extends StatelessWidget {
  const AtividadesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atividades Flutter',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1565C0),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
        ),
      ),
      home: const HomePage(),
      routes: {
        LayoutTutorialPage.route: (_) => const LayoutTutorialPage(),
        CookbookFormPage.route: (_) => const CookbookFormPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _HomeCard(
        title: 'Layout Tutorial',
        subtitle: 'Replicação do layout do guia oficial',
        icon: Icons.dashboard,
        onTap: () => Navigator.pushNamed(context, LayoutTutorialPage.route),
      ),
      _HomeCard(
        title: 'Cookbook • Form',
        subtitle: 'Validação + melhorias (senha, feedback, etc.)',
        icon: Icons.fact_check,
        onTap: () => Navigator.pushNamed(context, CookbookFormPage.route),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('09 • Atividades Flutter')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => cards[i],
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _HomeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

/* ===================== PARTE (a) – LAYOUT TUTORIAL ===================== */
// Baseado no tutorial oficial de layout (imagem, título, ação e texto)
class LayoutTutorialPage extends StatelessWidget {
  static const route = '/layout';

  const LayoutTutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Lago Oeschinen',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                SizedBox(height: 6),
                Text('Kandersteg, Suíça',
                    style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          const Icon(Icons.star, color: Colors.redAccent),
          const SizedBox(width: 6),
          const Text('41'),
        ],
      ),
    );

    Widget buttonSection = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _ActionButton(icon: Icons.call, label: 'LIGAR'),
          _ActionButton(icon: Icons.near_me, label: 'ROTA'),
          _ActionButton(icon: Icons.share, label: 'COMP.'),
        ],
      ),
    );

    Widget textSection = const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'O Lago Oeschinen é um destino alpino muito visitado, conhecido pela '
        'água azul e trilhas bem sinalizadas. Esta tela demonstra composição '
        'de layout com Row, Column, alinhamentos e espaçamentos de maneira '
        'idiomática no Flutter.',
        softWrap: true,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Layout Tutorial')),
      body: ListView(
        children: [
          // Troque a imagem por qualquer foto em assets/lake.jpg
          Image.asset('assets/lake.jpg', height: 240, fit: BoxFit.cover),
          titleSection,
          const Divider(height: 1),
          buttonSection,
          textSection,
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

/* ===================== PARTE (b) – COOKBOOK: FORM ===================== */
// Baseado no recipe "Build a form with validation", com melhorias
class CookbookFormPage extends StatefulWidget {
  static const route = '/cookbook-form';
  const CookbookFormPage({super.key});

  @override
  State<CookbookFormPage> createState() => _CookbookFormPageState();
}

class _CookbookFormPageState extends State<CookbookFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _autoValidate = true;
  bool _obscure = true;
  bool _simulateError = false;

  double get _strength {
    final p = _passCtrl.text;
    if (p.isEmpty) return 0;
    int score = 0;
    if (p.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(p)) score++;
    if (RegExp(r'[a-z]').hasMatch(p)) score++;
    if (RegExp(r'\d').hasMatch(p)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>_-]').hasMatch(p)) score++;
    return (score / 5).clamp(0, 1);
  }

  String? _nameValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Informe seu nome';
    if (v.trim().length < 3) return 'Mínimo de 3 caracteres';
    return null;
  }

  String? _emailValidator(String? v) {
    if (v == null || v.isEmpty) return 'Informe seu e-mail';
    final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v);
    return ok ? null : 'E-mail inválido';
    // Baseado no fluxo de validação do recipe oficial.
  }

  String? _passValidator(String? v) {
    if (v == null || v.isEmpty) return 'Crie uma senha';
    if (v.length < 8) return 'Use pelo menos 8 caracteres';
    if (_strength < 0.6) return 'Fortaleça a senha (letras, números e símbolos)';
    return null;
  }

  void _submit() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    if (_simulateError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha simulada no envio. Tente novamente.')),
      );
      return;
    }

    _formKey.currentState?.save();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tudo certo, ${_nameCtrl.text}! Dados enviados.'),
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Cookbook • Form com melhorias')),
      body: Form(
        key: _formKey,
        autovalidateMode: _autoValidate
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Nome completo'),
              validator: _nameValidator,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
              validator: _emailValidator,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passCtrl,
              decoration: InputDecoration(
                labelText: 'Senha',
                suffixIcon: IconButton(
                  tooltip: _obscure ? 'Mostrar' : 'Ocultar',
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                ),
              ),
              obscureText: _obscure,
              onChanged: (_) => setState(() {}),
              validator: _passValidator,
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Força da senha'),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(value: _strength, minHeight: 10),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Simular falha no envio'),
              value: _simulateError,
              onChanged: (v) => setState(() => _simulateError = v),
              secondary: const Icon(Icons.bug_report),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.send),
              label: const Text('Enviar'),
            ),
            const SizedBox(height: 24),
            Text(
              'Baseado no recipe oficial de validação de formulários, com melhorias '
              'de UX (validação reativa, força da senha, exibir/ocultar senha e '
              'feedback por SnackBar).',
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
