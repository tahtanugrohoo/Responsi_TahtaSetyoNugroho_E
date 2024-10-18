class ApiUrl {
  static const String baseUrl = 'http://responsi.webwizards.my.id/api';
  static const String registrasi = baseUrl + '/registrasi';
  static const String login = baseUrl + '/login';
  static const String listKeuangan = baseUrl + '/keuangan/anggaran';
  static const String createKeuangan = baseUrl + '/keuangan/anggaran';
  static String updateKeuangan(int id) {
    return baseUrl + '/keuangan/anggaran/' + id.toString() + '/update';
  }

  static String showKeuangan(int id) {
    return baseUrl + '/keuangan/anggaran/' + id.toString();
  }

  static String deleteKeuangan(int id) {
    return baseUrl + '/keuangan/anggaran/' + id.toString() + '/delete' ;
  }
}
