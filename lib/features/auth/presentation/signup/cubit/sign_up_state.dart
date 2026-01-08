import 'package:durbar_physics/common/enums/enums.dart';
import 'package:equatable/equatable.dart';

class SignUpState extends Equatable {
  final String name;
  final String nameStatus;

  final String email;
  final String emailStatus;

  final String password;
  final String passwordStatus;

  final String phone;
  final String phoneStatus;

  final String gender;

  final String age;
  final String ageStatus;

  final String statusMessage;
  final ApiDataStatus signupStatus; // idle, loading, success, error

  final String retypedPassword;
  final String retypedPasswordStatus;

  const SignUpState({
    this.name = '',
    this.nameStatus = '',
    this.email = '',
    this.emailStatus = '',
    this.password = '',
    this.passwordStatus = '',
    this.phone = '',
    this.phoneStatus = '',
    this.gender = 'male',
    this.age = '',
    this.ageStatus = '',
    this.statusMessage = '',
    this.signupStatus = ApiDataStatus.initial,
    this.retypedPassword = '',
    this.retypedPasswordStatus = '',
  });

  SignUpState copyWith({
    String? name,
    String? nameStatus,
    String? email,
    String? emailStatus,
    String? password,
    String? passwordStatus,
    String? phone,
    String? phoneStatus,
    String? gender,
    String? age,
    String? ageStatus,
    String? statusMessage,
    ApiDataStatus? signupStatus,
    String? retypedPassword,
    String? retypedPasswordStatus,
  }) {
    return SignUpState(
      name: name ?? this.name,
      nameStatus: nameStatus ?? this.nameStatus,
      email: email ?? this.email,
      emailStatus: emailStatus ?? this.emailStatus,
      password: password ?? this.password,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      phone: phone ?? this.phone,
      phoneStatus: phoneStatus ?? this.phoneStatus,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      ageStatus: ageStatus ?? this.ageStatus,
      statusMessage: statusMessage ?? this.statusMessage,
      signupStatus: signupStatus ?? this.signupStatus,
      retypedPassword: retypedPassword ?? this.retypedPassword,
      retypedPasswordStatus: retypedPasswordStatus ?? this.retypedPasswordStatus,
    );
  }

  @override
  List<Object?> get props => [
    name,
    nameStatus,
    email,
    emailStatus,
    password,
    passwordStatus,
    phone,
    phoneStatus,
    gender,
    age,
    ageStatus,
    statusMessage,
    signupStatus,
    retypedPassword,
    retypedPasswordStatus,
  ];
}
