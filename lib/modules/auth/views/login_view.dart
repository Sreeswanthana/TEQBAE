import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/rebs_look.dart';
import '../../../app/widgets/brand_art.dart';
import '../../../app/widgets/screen_frame.dart';
import '../../../app/theme/theme_helper.dart';
import '../../../app/theme/type_scale.dart';
import '../../../core/constants/app_constants.dart';
import '../controllers/login_controller.dart';

const _navy = Color(0xFF0B2A6F);
const _blue = Color(0xFF1E5BD8);
const _leaf = Color(0xFF22A559);

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _ = ThemeHelper.mode;
      return Scaffold(
        backgroundColor: const Color(0xFF071E4A),
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 840;
            final keyboard = MediaQuery.viewInsetsOf(context).bottom > 0;
            if (wide) {
              return Row(
                children: const [
                  Expanded(child: _Hero(expand: true)),
                  Expanded(child: _FormSheet(overlap: false)),
                ],
              );
            }
            return Stack(
              fit: StackFit.expand,
              children: [
                const _LoginBackdrop(),
                SafeArea(
                  child: LayoutBuilder(
                    builder: (context, box) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(20, keyboard ? 8 : 12, 20, 24),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: box.maxHeight),
                          child: Column(
                            mainAxisAlignment: keyboard ? MainAxisAlignment.start : MainAxisAlignment.center,
                            children: [
                              if (!keyboard) const _LoginTopBranding(),
                              if (!keyboard) const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.center,
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 420),
                                  child: const _FormSheet(centeredCard: true),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      );
    });
  }
}

class _LoginBackdrop extends StatelessWidget {
  const _LoginBackdrop();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF071E4A), Color(0xFF0C3480), Color(0xFF1858C8)],
          stops: [0, 0.55, 1],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _HeroPatternPainter())),
          const Positioned(left: -80, top: -40, child: _Blob(size: 200, opacity: 0.06)),
          const Positioned(right: -60, bottom: 80, child: _Blob(size: 180, opacity: 0.05)),
        ],
      ),
    );
  }
}

class _LoginTopBranding extends StatelessWidget {
  const _LoginTopBranding();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _RebsLogo(),
        const SizedBox(height: 8),
        Text(
          'Employee workspace · Work smarter. Grow together.',
          textAlign: TextAlign.center,
          style: TypeScale.body(size: 12, weight: FontWeight.w500, color: const Color(0xFFDCEBFF), height: 1.3),
        ),
        const SizedBox(height: 12),
        const _HeroFeatureRow(),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({this.expand = false});
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF071E4A), Color(0xFF0C3480), Color(0xFF1858C8)],
          stops: [0, 0.55, 1],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(child: CustomPaint(painter: _HeroPatternPainter())),
          const Positioned(left: -80, top: -40, child: _Blob(size: 200, opacity: 0.06)),
          const Positioned(right: -60, bottom: 40, child: _Blob(size: 160, opacity: 0.05)),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 28),
              child: Column(
                children: [
                  const _RebsLogo(),
                  const SizedBox(height: 10),
                  Text(
                    'Employee workspace',
                    textAlign: TextAlign.center,
                    style: TypeScale.body(
                      size: 11,
                      weight: FontWeight.w700,
                      color: const Color(0xFF8EB8F5),
                      height: 1.2,
                    ).copyWith(letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Work smarter. Grow together.',
                    textAlign: TextAlign.center,
                    style: TypeScale.body(size: 14, weight: FontWeight.w500, color: const Color(0xFFDCEBFF), height: 1.2),
                  ),
                  const SizedBox(height: 16),
                  const _HeroFeatureRow(),
                  const Spacer(),
                  const _HeroShowcase(expand: true, artHeight: 168, showFooter: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroFeatureRow extends StatelessWidget {
  const _HeroFeatureRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: const [
        _HeroChip(icon: Icons.fingerprint_rounded, label: 'Attendance'),
        _HeroChip(icon: Icons.event_available_rounded, label: 'Leave'),
        _HeroChip(icon: Icons.verified_user_outlined, label: 'Secure'),
      ],
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFFB8D4FF)),
          const SizedBox(width: 5),
          Text(label, style: TypeScale.body(size: 10, weight: FontWeight.w700, color: Colors.white)),
        ],
      ),
    );
  }
}

class _HeroShowcase extends StatelessWidget {
  const _HeroShowcase({
    required this.expand,
    required this.artHeight,
    this.showFooter = true,
  });

  final bool expand;
  final double artHeight;
  final bool showFooter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: expand ? 420 : 360),
      padding: EdgeInsets.fromLTRB(12, showFooter ? 12 : 10, 12, showFooter ? 12 : 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white.withValues(alpha: 0.1),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              height: artHeight,
              color: Colors.white.withValues(alpha: 0.08),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _leaf.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'HRMS',
                        style: TypeScale.body(size: 9, weight: FontWeight.w800, color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Image.asset(
                      BrandArt.woman,
                      height: (artHeight - 12).clamp(56.0, 168.0),
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showFooter) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(child: BrandIcon(BrandArt.briefcase, size: 20)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Built for modern teams',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TypeScale.body(size: 12, weight: FontWeight.w800, color: Colors.white),
                      ),
                      Text(
                        'Check-in, leave and history in one place.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TypeScale.body(size: 10, weight: FontWeight.w500, color: const Color(0xFFC5DBFA)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _HeroPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1;
    const step = 28.0;
    for (var x = 0.0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RebsLogo extends StatelessWidget {
  const _RebsLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 44, height: 44, child: CustomPaint(painter: _LogoPainter())),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'REBS',
              style: TypeScale.display(26, weight: FontWeight.w800, color: Colors.white, tracking: 1, height: 1),
            ),
            Text(
              'HRMS',
              style: TypeScale.body(
                size: 15,
                weight: FontWeight.w700,
                color: const Color(0xFF9BBEF5),
                height: 1,
              ).copyWith(letterSpacing: 4),
            ),
          ],
        ),
      ],
    );
  }
}

class _FormSheet extends GetView<LoginController> {
  const _FormSheet({this.overlap = true, this.centeredCard = false});
  final bool overlap;
  final bool centeredCard;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _ = ThemeHelper.mode;
      final ink = RebsLook.light ? _navy : RebsLook.inkColor;
      final mute = RebsLook.light ? const Color(0xFF7B8BA3) : RebsLook.muteColor;
      final form = Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome back', style: TypeScale.display(26, weight: FontWeight.w800, color: ink, tracking: -0.6)),
              const SizedBox(height: 4),
              Text(
                'Sign in to check in, apply leave and more.',
                style: TypeScale.body(size: 13, weight: FontWeight.w400, color: mute),
              ),
              const SizedBox(height: 18),
              _Label('Employee ID or email', ink),
              TextField(
                controller: controller.usernameController,
                keyboardType: TextInputType.emailAddress,
                style: TypeScale.body(size: 15, weight: FontWeight.w600, color: ink),
                decoration: _field(hint: 'EMP001', icon: Icons.person_outline_rounded),
              ),
              const SizedBox(height: 14),
              _Label('Password', ink),
              Obx(() {
                final showPassword = controller.isPasswordVisible.value;
                return TextField(
                  key: ValueKey<bool>(showPassword),
                  controller: controller.passwordController,
                  obscureText: !showPassword,
                  enableSuggestions: false,
                  autocorrect: false,
                  onSubmitted: (_) => controller.login(),
                  style: TypeScale.body(size: 15, weight: FontWeight.w600, color: ink),
                  decoration: _field(hint: 'Enter your password', icon: Icons.lock_outline_rounded).copyWith(
                    suffixIcon: IconButton(
                      tooltip: showPassword ? 'Hide password' : 'Show password',
                      onPressed: controller.togglePasswordVisibility,
                      icon: Icon(
                        showPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: showPassword ? _blue : mute,
                        size: 22,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
              Obx(() {
                return Row(
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: Checkbox(
                        value: controller.rememberMe.value,
                        activeColor: _blue,
                        side: const BorderSide(color: Color(0xFFB7C6DC), width: 1.4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (v) => controller.rememberMe.value = v ?? true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => controller.rememberMe.value = !controller.rememberMe.value,
                      child: Text('Remember me', style: TypeScale.body(size: 13, weight: FontWeight.w500, color: ink)),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _forgotPassword,
                      child: Text('Forgot password?', style: TypeScale.body(size: 13, weight: FontWeight.w500, color: mute)),
                    ),
                  ],
                );
              }),
              Obx(() {
                if (controller.errorMessage.isEmpty) return const SizedBox(height: 14);
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: RebsLook.roseBg, borderRadius: BorderRadius.circular(14)),
                  child: Text(
                    controller.errorMessage.value,
                    style: TypeScale.body(size: 12, weight: FontWeight.w600, color: RebsLook.rose),
                  ),
                );
              }),
              Obx(() {
                final busy = controller.isLoading.value;
                return Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: Responsive.buttonHeight(context),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: const LinearGradient(colors: [Color(0xFF1A4FBE), Color(0xFF1E5BD8)]),
                          ),
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: busy ? null : controller.login,
                            child: busy
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Sign In', style: TypeScale.body(size: 16, weight: FontWeight.w700, color: Colors.white)),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.arrow_forward_rounded, size: 20),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Material(
                      color: RebsLook.card,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: Color(0xFFD5E2F5)),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: busy ? null : controller.login,
                          child: SizedBox(
                            width: 54,
                            height: Responsive.buttonHeight(context),
                          child: Icon(Icons.fingerprint_rounded, color: _blue, size: 28),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () {
                    controller.fillDemoCredentials();
                    Get.snackbar(
                      'HR admin',
                      'Demo sign-in filled: ${AppConstants.defaultTestUsername} / ${AppConstants.defaultTestPassword}',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: _navy,
                      colorText: Colors.white,
                      margin: const EdgeInsets.all(16),
                      duration: const Duration(seconds: 3),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_rounded, color: _leaf, size: 16),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Secure sign-in  ·  Need help? Contact HR admin',
                          style: TypeScale.body(size: 12, weight: FontWeight.w500, color: const Color(0xFF3D9B63)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      );

      if (centeredCard) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: RebsLook.card,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.28),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: form,
        );
      }

      return Container(
        decoration: BoxDecoration(
          color: RebsLook.card,
          borderRadius: overlap ? const BorderRadius.vertical(top: Radius.circular(28)) : null,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(child: form),
          ),
        ),
      );
    });
  }

  void _forgotPassword() {
    controller.fillDemoCredentials();
    Get.snackbar(
      'Forgot password',
      'Ask HR admin to reset it. Demo sign-in is ${AppConstants.defaultTestUsername} / ${AppConstants.defaultTestPassword}.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: _navy,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }

  InputDecoration _field({required String hint, required IconData icon}) {
    final fill = RebsLook.fieldFill;
    return InputDecoration(
      hintText: hint,
      hintStyle: TypeScale.body(size: 14, weight: FontWeight.w500, color: const Color(0xFF9AABC0)),
      prefixIcon: Icon(icon, color: const Color(0xFF8AA0BF), size: 22),
      filled: true,
      fillColor: fill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _blue, width: 1.4),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text, this.color);
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(text, style: TypeScale.body(size: 13, weight: FontWeight.w600, color: color)),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.opacity});
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  const _LogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 44, size.height / 44);
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(0, 0, 44, 44), const Radius.circular(13)),
      Paint()..color = Colors.white,
    );
    _fill(canvas, 'M14 33V11H24.5C29 11 32 13.6 32 17.5C32 20.6 30.2 22.8 27.4 23.6L33 33H27.6L22.6 24.4H18.6V33Z', _navy, 1);
    _fill(canvas, 'M18.6 15V20.6H24C26 20.6 27.4 19.5 27.4 17.8C27.4 16.1 26 15 24 15Z', Colors.white, 1);
    _fill(canvas, 'M26 28C29 29 31 31.5 31 34C28 33.6 26 31.5 26 28Z', _leaf, 1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void _fill(Canvas canvas, String d, Color color, double opacity) {
  canvas.drawPath(parseSvgPath(d), Paint()..color = color.withValues(alpha: opacity));
}

Path parseSvgPath(String d) {
  final path = Path();
  final tokens = RegExp(r'[MmLlHhVvCcQqZz]|-?\d*\.?\d+(?:e[-+]?\d+)?')
      .allMatches(d)
      .map((m) => m.group(0)!)
      .toList();
  var i = 0;
  var cmd = '';
  var cx = 0.0;
  var cy = 0.0;
  var sx = 0.0;
  var sy = 0.0;

  double read() => double.parse(tokens[i++]);

  while (i < tokens.length) {
    final token = tokens[i];
    if (RegExp(r'^[A-Za-z]$').hasMatch(token)) {
      cmd = token;
      i++;
    }
    switch (cmd) {
      case 'M':
        cx = read();
        cy = read();
        path.moveTo(cx, cy);
        sx = cx;
        sy = cy;
        cmd = 'L';
      case 'L':
        cx = read();
        cy = read();
        path.lineTo(cx, cy);
      case 'H':
        cx = read();
        path.lineTo(cx, cy);
      case 'V':
        cy = read();
        path.lineTo(cx, cy);
      case 'C':
        final x1 = read();
        final y1 = read();
        final x2 = read();
        final y2 = read();
        final x = read();
        final y = read();
        path.cubicTo(x1, y1, x2, y2, x, y);
        cx = x;
        cy = y;
      case 'Q':
        final x1 = read();
        final y1 = read();
        final x = read();
        final y = read();
        path.quadraticBezierTo(x1, y1, x, y);
        cx = x;
        cy = y;
      case 'Z':
      case 'z':
        path.close();
        cx = sx;
        cy = sy;
      default:
        if (i < tokens.length && !RegExp(r'^[A-Za-z]$').hasMatch(tokens[i])) i++;
    }
  }
  return path;
}
