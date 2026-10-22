import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/config/app_constants.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../domain/entities/user_entity.dart';
import '../controllers/auth_controller.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _studentIdController = TextEditingController();
  String _selectedDepartment = AppConstants.departments.first;
  UserRole _selectedRole = UserRole.student;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  void _onRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(authControllerProvider.notifier).register(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            studentId: _studentIdController.text.trim(),
            department: _selectedDepartment,
            role: _selectedRole,
          );

      final authState = ref.read(authControllerProvider);
      if (authState.hasValue && authState.value != null) {
        if (mounted) {
          if (_selectedRole == UserRole.faculty) {
            context.go('/teacher-dashboard');
          } else {
            context.go('/student-dashboard');
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SegmentedButton<UserRole>(
                  segments: const [
                    ButtonSegment(
                      value: UserRole.student,
                      label: Text('Student'),
                      icon: Icon(Icons.person_outline),
                    ),
                    ButtonSegment(
                      value: UserRole.faculty,
                      label: Text('Faculty'),
                      icon: Icon(Icons.admin_panel_settings_outlined),
                    ),
                  ],
                  selected: {_selectedRole},
                  onSelectionChanged: (Set<UserRole> newSelection) {
                    setState(() {
                      _selectedRole = newSelection.first;
                    });
                  },
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Full Name',
                  hint: 'Dr. / John Doe',
                  controller: _nameController,
                  validator: (val) => Validators.validateRequired(val, 'Full Name'),
                  prefixIcon: const Icon(Icons.badge_outlined),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'University Email',
                  hint: 'email@university.edu',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: _selectedRole == UserRole.student ? 'Student ID' : 'Faculty ID',
                  hint: 'e.g. CSE-2023-045',
                  controller: _studentIdController,
                  validator: (val) => Validators.validateRequired(val, 'ID'),
                  prefixIcon: const Icon(Icons.confirmation_number_outlined),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedDepartment,
                  decoration: InputDecoration(
                    labelText: 'Department',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                  ),
                  items: AppConstants.departments.map((dept) {
                    return DropdownMenuItem(
                      value: dept,
                      child: Text(dept, overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedDepartment = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Password',
                  hint: 'At least 6 characters',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: Validators.validatePassword,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Register Account',
                  isLoading: authState.isLoading,
                  onPressed: _onRegister,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
