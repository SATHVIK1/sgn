import 'package:appwrite/appwrite.dart';

class ApiClient {
  // Create a singleton instance
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() => _instance;

  ApiClient._internal();

  // Client getter
  static Client get _client {
    Client client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1') // or your Appwrite endpoint
        .setProject('SGNetflix') // your project ID
        .setSelfSigned();
    return client;
  }

  // Static service instances
  static Account get account => Account(_client);
  static Databases get database => Databases(_client);
  static Storage get storage => Storage(_client);
}
