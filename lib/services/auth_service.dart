import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // signIn ด้วย Email/Password
  Future<AuthResponse> signIn(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // signUp เก็บแค่ Email/Password
  Future<AuthResponse> signUp(String email, String password) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  // อัปเดตชื่อ (เอาไว้ใช้หน้า Setting หลังจาก Login แล้ว)
  Future<void> updateProfileName(String name) async {
    final userId = _supabase.auth.currentUser!.id;
    await _supabase
        .from('profiles')
        .update({'name': name}) // มีฟิลด์อื่นที่แก้ไขได้อีก เช่น avatar_url, bio, etc.
        .eq('id', userId);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
  User? get currentUser => _supabase.auth.currentUser;
}