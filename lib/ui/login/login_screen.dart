// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class LoginScreen extends ConsumerStatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   ConsumerState<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends ConsumerState<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _handleController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authNotifierProvider);

//     // Auto-navigate on success
//     if (authState.user != null && authState.handle != null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted) {
//           context.push('/user');
//         }
//       });
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(labelText: 'Email'),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: const InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             if (authState.isLoading) const CircularProgressIndicator(),
//             if (authState.error != null)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: Text(
//                   authState.error!,
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               ),
//             ElevatedButton(
//               onPressed: authState.isLoading
//                   ? null
//                   : () => ref
//                         .read(authNotifierProvider.notifier)
//                         .login(
//                           _emailController.text.trim(),
//                           _passwordController.text,
//                         ),
//               child: const Text('Login'),
//             ),
//             if (authState.user != null && authState.handle == null) ...[
//               const SizedBox(height: 20),
//               const Text('Create Profile'),
//               TextField(
//                 controller: _handleController,
//                 decoration: const InputDecoration(
//                   labelText: 'Username (e.g., @paulo)',
//                   prefixText: '@',
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: authState.isLoading
//                     ? null
//                     : () => ref
//                           .read(authNotifierProvider.notifier)
//                           .createHandle(_handleController.text.trim()),
//                 child: const Text('Create'),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _handleController.dispose();
//     super.dispose();
//   }
// }
