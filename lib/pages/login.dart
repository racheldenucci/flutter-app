import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/main_page.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  //funcao de login
  static Future<User?> login({required String email, required String password, required BuildContext context}) async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch(e){
      if(e.code == 'user-not-found'){
        print('Este e-mail não está cadastrado');
      }
    }

    return user;
  }
  
  @override
  Widget build(BuildContext context) {

    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estante Virtual',
            style: TextStyle(
              color: Colors.amber[600],
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Fazer Login',
            style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 40.0,
          ),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'E-mail',
              prefixIcon: Icon(
                Icons.mail,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(
            height: 26.0,
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Senha',
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: Colors.orange[400],
              padding: EdgeInsets.symmetric(vertical: 14.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              onPressed: () async{
                User? user = await login(email: _emailController.text, password: _passwordController.text, context: context);
                print(user);
                if(user != null){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> MainPage()));
                }
              },
              child: Text(
                'Entrar',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
            //TODO: ADD ERRO DE LOGIN
          ),
        ],
      ),
    );
  }
}
