import 'dart:async';

import 'package:flutter_app/datamodel/collectednotes/credentials.dart';
import 'package:flutter_app/datamodel/collectednotes/note.dart';
import 'package:flutter_app/datamodel/collectednotes/site.dart';
import 'package:flutter_app/service/collectednotes/json_processor.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/datamodel/collectednotes/user.dart';
import 'package:sprintf/sprintf.dart';
import 'package:flutter_app/exceptions/unauthorized_exception.dart';

/// Possible results for the credentials checking call. */
enum CredentialsValidationResult {
  UNKNOWN,
  CONNECTIVITY_ERROR,
  WRONG_CREDENTIALS,
  SUCCESS
}

/// Service that encapsulates all communication with Collected Notes API. */
class CollectedNotesService {
  static const String URL_BASE = 'https://collectednotes.com/';
  static const String URL_ME =  URL_BASE + 'accounts/me';
  static const String URL_SITES =  URL_BASE + 'sites';
  static const String URL_NOTES =  URL_SITES + '%d/notes';


  /// Get the request headers for the credentials given. */
  static Map<String, String> getHeaders(Credentials credentials) {
    return {
      'Authorization': sprintf('%s %s', [credentials.email, credentials.key]),
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
  }

  /// Fetches the current user for the email/key combination. */
  static Future<User> fetchUser(Credentials credentials) async {
    final response =
        await http.get(URL_ME, headers: getHeaders(credentials));
    return JsonProcessor.process(response, (json) => User.fromJson(json), 'User');
  }

  // TODO: Add pagination
  /// Fetch all sites for the current user.
  static Future<List<Site>> fetchSites() async {
    Credentials credentials = await getCredentials();
    final response =
        await http.get(URL_SITES, headers: getHeaders(credentials));
    return JsonProcessor.process(response, ((json) { Iterable l = json.decode(response.body);
        List<Site> sites =
        List.from(l).map((element) => Site.fromJson(element)).toList();
    return sites;}), 'Sites');
  }

  static Future<List<Note>> fetchNotes(siteId) async {
    Credentials credentials = await getCredentials();
    final response =
      await http.get(sprintf(URL_NOTES, [siteId]),
          headers: getHeaders(credentials));
    return JsonProcessor.process(response, ((json) { Iterable l = json.decode(response.body);
    List<Note> notes =
    List.from(l).map((element) => Note.fromJson(element)).toList();
    return notes;}), 'Notes');
  }

  static Future<CredentialsValidationResult> validateCredentials(Credentials credentials) async {
    return fetchUser(credentials).then((user) {
      return (user.email == credentials.email)
          ? CredentialsValidationResult.SUCCESS
          : CredentialsValidationResult.WRONG_CREDENTIALS;
    }).catchError((e) {
      return (e is UnauthorizedException)
          ? CredentialsValidationResult.WRONG_CREDENTIALS
          : CredentialsValidationResult.CONNECTIVITY_ERROR;
    });
  }

  static Future<CredentialsValidationResult> validateStoredCredentials() async {
    return getCredentials()
        .then((creds) => validateCredentials(creds));
  }

  static Future<Credentials> getCredentials() {
    return SharedPreferences.getInstance().then((prefs) => Credentials(
        email: (prefs.getString('UserEmail') ?? ''),
        key: (prefs.getString('UserKey') ?? '')));
  }
}
