package com.nasuha.app

import io.flutter.embedding.android.FlutterFragmentActivity

// FlutterFragmentActivity (bukan FlutterActivity) dibutuhkan agar
// plugin local_auth (biometrik/PIN) bisa menampilkan dialog otentikasi.
class MainActivity : FlutterFragmentActivity()
