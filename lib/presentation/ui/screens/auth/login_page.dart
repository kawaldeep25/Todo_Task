import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/core/constants/app_consts.dart';
import 'package:todo_list/core/enums/status.dart';
import 'package:todo_list/core/theme/app_assets.dart';
import 'package:todo_list/domain/viewmodel/auth_provider.dart';
import 'package:todo_list/presentation/ui/screens/auth/register_page.dart';
import 'package:todo_list/presentation/ui/screens/home_page.dart';
import 'package:todo_list/presentation/ui/widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const ROUTE_NAME = 'LoginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                  AppConsts.loginBody,
                  style: TextStyle(fontSize: 28),
                ),
                const SizedBox(
                  height: 45,
                ),
                // email -----------------------------------
                TextFormField(
                  controller: _emailController,
                  //style: Theme.of(context).textTheme.bodyText1,
                  validator: (value) =>
                      value!.isEmpty ? AppConsts.loginTxtErrorEmail : null,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email
                          //color: Theme.of(context).iconTheme.color,
                          ),
                      labelText: AppConsts.loginTxtEmail,
                      border: OutlineInputBorder()),
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
                authProvider.status == Status.Authenticating
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : CustomButton(
                        text: AppConsts.loginBtnSignIn,
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            FocusScope.of(context)
                                .unfocus(); //to hide the keyboard - if any

                            bool status =
                                await authProvider.signInWithEmailAndPassword(
                                    _emailController.text,
                                    _passwordController.text);

                            if (!status) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                //_scaffoldKey.currentState!.showSnackBar(SnackBar(
                                content: Text(AppConsts.loginTxtErrorSignIn),
                              ));
                            } else {
                              Navigator.of(context)
                                  .pushReplacementNamed(HomePage.ROUTE_NAME);
                            }
                          }
                        }),
                const SizedBox(
                  height: 35,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  //--- Google button-------------------------
                  authProvider.status == Status.Authenticating
                      ? const Center(
                          child: null,
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            maximumSize: const Size(220, 100),
                            backgroundColor: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                            padding: EdgeInsets.zero,
                          ),
                          clipBehavior: Clip.none,
                          child:
                              Image.asset(AppAssets.google, fit: BoxFit.fill),
                          onPressed: () async {
                            bool status =
                                await authProvider.signInWithGoogle(context);
                            if (!status) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                //_scaffoldKey.currentState!.showSnackBar(SnackBar(
                                content:
                                    Text(AppConsts.loginTxtErrorGoogleSignIn),
                              ));
                            } else {
                              if (mounted) {
                                Navigator.of(context)
                                    .pushReplacementNamed(HomePage.ROUTE_NAME);
                              } else {
                                Navigator.pop;
                              }
                            }
                          }),
                ]),
                const SizedBox(
                  height: 40,
                ),
                authProvider.status == Status.Authenticating
                    ? const Center(
                        child: null,
                      )
                    : const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Center(
                            child: Text(
                          AppConsts.loginTxtDontHaveAccount,
                          //style: Theme.of(context).textTheme.button,
                        )),
                      ),
                const SizedBox(
                  height: 10,
                ),
                authProvider.status == Status.Authenticating
                    ? const Center(
                        child: null,
                      )
                    : TextButton(
                        child: const Text(AppConsts.loginBtnLinkCreateAccount),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 55),
                            elevation: 2),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(RegisterPage.ROUTE_NAME);
                        },
                      ),
                Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    authProvider.status == Status.Authenticating
                        ? const Center(
                            child: null,
                          )
                        : const SizedBox(
                            height: 70,
                          ),
                  ],
                )),
              ],
            ),
          ),
        ));
  }
}
