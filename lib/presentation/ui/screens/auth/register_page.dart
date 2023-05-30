import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/core/constants/app_consts.dart';
import 'package:todo_list/core/enums/status.dart';
import 'package:todo_list/domain/models/user_model.dart';
import 'package:todo_list/domain/viewmodel/auth_provider.dart';
import 'package:todo_list/presentation/ui/screens/auth/login_page.dart';
import 'package:todo_list/presentation/ui/screens/home_page.dart';
import 'package:todo_list/presentation/ui/widgets/custom_button.dart';

// register_screen
// TODO: show error when email is badly formatted

class RegisterPage extends StatefulWidget {
  static const ROUTE_NAME = 'RegisterPage';
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: _buildForm(context),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildForm(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  AppConsts.loginHeader,
                  style: TextStyle(fontSize: 28),
                ),
                const SizedBox(
                  height: 35,
                ),
                const Text(
                  AppConsts.registerBody,
                  style: TextStyle(fontSize: 28),
                ),
                const SizedBox(
                  height: 55,
                ),
                TextFormField(
                  controller: _emailController,
                  //style: Theme.of(context).textTheme.bodyText1,
                  validator: (value) =>
                      value!.isEmpty ? AppConsts.loginTxtErrorEmail : null,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      labelText: AppConsts.loginTxtEmail,
                      border: const OutlineInputBorder()),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: TextFormField(
                    obscureText: true,
                    maxLength: 12,
                    controller: _passwordController,
                    //style: Theme.of(context).textTheme.bodyText1,
                    validator: (value) => value!.length < 6
                        ? AppConsts.loginTxtErrorPassword
                        : null,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        labelText: AppConsts.loginTxtPassword,
                        border: const OutlineInputBorder()),
                  ),
                ),
                authProvider.status == Status.Registering
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : CustomButton(
                        text: AppConsts.loginBtnSignUp,
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            FocusScope.of(context)
                                .unfocus(); //to hide the keyboard - if any

                            UserModel userModel =
                                await authProvider.registerWithEmailAndPassword(
                                    _emailController.text,
                                    _passwordController.text);

                            if (userModel.email != null) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  HomePage.ROUTE_NAME,
                                  (Route<dynamic> route) => false);
                            }
                          }
                        }),
                authProvider.status == Status.Registering
                    ? const Center(
                        child: null,
                      )
                    : const Padding(
                        padding: EdgeInsets.only(top: 48),
                        child: Center(
                            child: Text(
                          AppConsts.loginTxtHaveAccount,
                          //style: Theme.of(context).textTheme.button,
                        )),
                      ),
                const SizedBox(
                  height: 10,
                ),
                authProvider.status == Status.Registering
                    ? const Center(
                        child: null,
                      )
                    : TextButton(
                        child: const Text(AppConsts.loginBtnLinkSignIn),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 55),
                            elevation: 2),
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(LoginPage.ROUTE_NAME);
                        },
                      ),
              ],
            ),
          ),
        ));
  }
}
