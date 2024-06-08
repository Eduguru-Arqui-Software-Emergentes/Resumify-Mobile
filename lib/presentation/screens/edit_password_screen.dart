import 'package:flutter/material.dart';
import 'package:resumify_mobile/presentation/screens/profile_screen.dart';

class EditPasswordScreen extends StatefulWidget {
  const EditPasswordScreen({super.key});

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreen();
}

class _EditPasswordScreen extends State<EditPasswordScreen> {
  final TextEditingController contrasenaController = TextEditingController();
  final TextEditingController nuevacontrasenaController1 = TextEditingController();
  final TextEditingController nuevacontrasenaController2 = TextEditingController();

  bool isEditable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Editar Contraseña',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildProfileField(
                  label: 'Contraseña Antigua',
                  controller: contrasenaController,
                  isPassword: true,
                  isEditable: true),
              _buildProfileField(
                  label: 'Contraseña Nueva',
                  controller: nuevacontrasenaController1,
                  isPassword: true,
                  isEditable: true),
              _buildProfileField(
                  label: 'Repetir Contraseña Nueva',
                  controller: nuevacontrasenaController2,
                  isPassword: true,
                  isEditable: true),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Profile()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 40),
                  backgroundColor: const Color.fromRGBO(77, 148, 255, 100),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Cancelar'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Profile()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 40),
                  backgroundColor: const Color.fromRGBO(77, 148, 255, 100),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Confirmar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(
      {required String label,
      required TextEditingController controller,
      bool isPassword = false,
      required bool isEditable}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          TextField(
            controller: controller,
            obscureText: isPassword,
            enabled: isEditable,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    contrasenaController.dispose();
    nuevacontrasenaController1.dispose();
    nuevacontrasenaController2.dispose();
    super.dispose();
  }
}
