import 'package:flutter/material.dart';
import 'package:resumify_mobile/presentation/screens/auth_screen.dart';
import 'package:resumify_mobile/presentation/views/edit_password_view.dart';
import 'package:resumify_mobile/services/auth_service.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _Profile();
}

class _Profile extends State<ProfileView> {
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contactoController = TextEditingController();
  final TextEditingController contactoAdicionalController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  bool isEditable = false;

  @override
  void initState() {
    super.initState();
    nombresController.text = "Coliflor";
    apellidosController.text = "Paredes Purima";
    correoController.text = "Coliflor.Paredes@gmail.com";
    contactoController.text = "987654123";
    contactoAdicionalController.text = "953265412";
    contrasenaController.text = "********************";
  }

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
                  'Mi Perfil',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildProfileField(label: 'Nombres', controller: nombresController, isEditable: isEditable),
              _buildProfileField(label: 'Apellidos', controller: apellidosController, isEditable: isEditable),
              _buildProfileField(label: 'Correo', controller: correoController, isEditable: isEditable),
              _buildProfileField(label: 'N°Contacto', controller: contactoController, isEditable: isEditable),
              _buildProfileField(label: 'N°Contacto Adicional', controller: contactoAdicionalController, isEditable: isEditable),
              _buildProfileField(label: 'Contraseña', controller: contrasenaController, isPassword: true, isEditable: false),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isEditable =! isEditable;
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 40),
                  backgroundColor: const Color.fromRGBO(77, 148, 255, 100),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: Text(isEditable ? 'Guardar Cambios' : 'Editar Perfil'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditPasswordScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 40),
                  backgroundColor: const Color.fromRGBO(77, 148, 255, 100),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Editar Contraseña'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                  );
                  AuthService.logOut();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 40),
                  backgroundColor: const Color.fromRGBO(77, 148, 255, 100),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Cerrar Sesión'),
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
    nombresController.dispose();
    apellidosController.dispose();
    correoController.dispose();
    contactoController.dispose();
    contactoAdicionalController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }
}