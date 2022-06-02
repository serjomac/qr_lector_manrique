import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:qr_scaner_manrique/pages/login/controller/login_controller.dart';
import 'package:qr_scaner_manrique/shared/widgets/custom_input.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<LoginController>(
        init: LoginController(),
        builder: (_) {
          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  SafeArea(
                    child: Container(height: 35.0),
                  ),
                  Container(
                    width: size.width * 0.95,
                    padding: const EdgeInsets.only(
                        top: 90.0, bottom: 90.0, left: 10, right: 10),
                    // decoration: BoxDecoration(
                    //     // color: const Color(0xFFEBE5E5),
                    //     borderRadius: BorderRadius.circular(20.0),
                    //     boxShadow: const <BoxShadow>[
                    //       BoxShadow(
                    //         color: Colors.black26,
                    //         blurRadius: 3.0,
                    //       )
                    //     ]),
                    child: Form(
                      key: _.formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                              margin: const EdgeInsets.only(bottom: 50),
                              child: GetBuilder<LoginController>(
                                id: 'lblLogin',
                                builder: (_) => const Image(image: AssetImage('assets/images/logo.png'), width: 180, height: 180,)
                              )),
                          Container(
                            child: CustomInput(
                              autocorect: false,
                              hintText: 'Escriba su usuario',
                              icono: Icons.person ,
                              isOscured: false,
                              keyBoardType: TextInputType.emailAddress,
                              onChange: (value) {
                                _.email = value;
                              },
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Debe ingresar un correo';
                                } else if (value.length < 3) {
                                  return 'Debe ingresar minimo 3 caracteres';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            margin: const EdgeInsets.only(bottom: 10.0),
                          ),
                          Container(
                            child: GetBuilder<LoginController>(
                              id: 'pass-field',
                              builder: (context) {
                                return CustomInput(
                                  autocorect: false,
                                  hintText: '*********',
                                  icono: !_.isVisiblePass ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                  onTapIcon: () {
                                    _.isVisiblePass = !_.isVisiblePass;
                                  },
                                  isOscured: !_.isVisiblePass,
                                  keyBoardType: TextInputType.text,
                                  onChange: (String value) {
                                    _.password = value;
                                  },
                                  validator: (String value) {},
                                );
                              }
                            ),
                            margin: const EdgeInsets.only(bottom: 25.0),
                          ),
                          _buttonForgetPassword,
                          _buttonLogin(
                            () async {
                              if (_.formKey.currentState!.validate()) {
                                _.formKey.currentState!.save();
                                log('Boton login press');
                                log(_.email + '---' + _.password);
                                _.login(_.email, _.password);
                              } else {
                                log('Formulario invalido');
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  final _buttonForgetPassword = Container(
    child: InkWell(
      child: const Text(
        '¿Olvidó tu contraseña?',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold),
      ),
      onTap: () {
        log('Vamos a recuprar la clave');
      },
    ),
    margin: const EdgeInsets.only(bottom: 25.0),
  );

  Widget _buttonLogin(VoidCallback loginAction) {
    final button = GetBuilder<LoginController>(
      builder: (_) {
        return Obx(() {
          return Container(
              width: 298.0,
              height: 50.0,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() {
                      if (_.presentSpinner.value) {
                        return SpinKitChasingDots(
                          size: 18,
                          itemBuilder: (context, int index) {
                            return Container(
                              decoration:
                                  const BoxDecoration(color: Color(0xFFEBE5E5)),
                            );
                          },
                        );
                      } else {
                        return const Center();
                      }
                    }),
                    Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: const Text('Iniciar sesión',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                            )))
                  ],
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: _.presentSpinner.value
                      ? const Color(0xFF888888)
                      : const Color(0xFFED1B30)));
        });
      },
    );
    return GetBuilder<LoginController>(
        builder: (_) => Obx(() {
              return InkWell(
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: button,
                  onTap: _.presentSpinner.value ? null : loginAction);
            }));
  }
}
