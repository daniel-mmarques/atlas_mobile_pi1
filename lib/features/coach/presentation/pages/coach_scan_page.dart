import 'package:atlas_mobile_pi1/core/theme/app_colors.dart';
import 'package:atlas_mobile_pi1/core/theme/app_spacing.dart';
import 'package:atlas_mobile_pi1/features/coach/data/coach_repository.dart';
import 'package:atlas_mobile_pi1/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class CoachScanPage extends StatefulWidget {
  const CoachScanPage({super.key});

  @override
  State<CoachScanPage> createState() => _CoachScanPageState();
}

class _CoachScanPageState extends State<CoachScanPage> {
  bool _handling = false;
  String? _message;

  Future<void> _handleCode(String raw) async {
    if (_handling) return;
    setState(() {
      _handling = true;
      _message = null;
    });

    try {
      final token = _extractToken(raw);
      if (token == null) {
        setState(() => _message = 'QR inválido');
        return;
      }

      final uid = context.read<AuthService>().user?.uid;
      if (uid == null) {
        setState(() => _message = 'Não autenticado');
        return;
      }

      await context.read<CoachRepository>().acceptInvitation(
            token: token,
            acceptorId: uid,
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vínculo criado com sucesso')),
      );
      context.pop();
    } catch (e) {
      setState(() => _message = e.toString());
    } finally {
      if (mounted) setState(() => _handling = false);
    }
  }

  String? _extractToken(String raw) {
    final uri = Uri.tryParse(raw);
    if (uri != null && uri.queryParameters['token'] != null) {
      return uri.queryParameters['token'];
    }
    if (raw.trim().isNotEmpty && !raw.contains(' ')) {
      return raw.trim();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear convite'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (capture) {
                final value = capture.barcodes.firstOrNull?.rawValue;
                if (value != null) {
                  _handleCode(value);
                }
              },
            ),
          ),
          if (_message != null)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                _message!,
                style: const TextStyle(color: AppColors.error),
              ),
            ),
          if (_handling)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
