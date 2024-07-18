import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:maids_task/core/network/network_layer.dart';

import 'networkService_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late NetworkService networkService;

  setUp(() {
    final client = MockClient();

    networkService =
        NetworkService(baseUrl: 'https://example.com', client: client);
  });

  group('NetworkService', () {
    const String endpoint = 'todos';
    final uri = Uri.parse('https://example.com/$endpoint');
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Accept-Language": "en",
    };

    test('getRequest returns data on success', () async {
      final client = MockClient();

      when(client.get(uri))
          .thenAnswer((_) async => http.Response('{"todos": []}', 200));

      final result = await networkService.getRequest(endpoint);

      expect(result, isA<Map<String, dynamic>>());
    });

    test('getRequest returns error on failure', () async {
      final client = MockClient();

      when(client.get(uri)).thenAnswer((_) async => http.Response(
          '{"success": "error","{error}:{"message":"Not Found"}"}', 404));

      final result = await networkService.getRequest(endpoint);

      expect(result, isA<Map<String, dynamic>>());
      expect(result['success'], 'error');
    });

    test('postRequest returns data on success', () async {
      final client = MockClient();

      final body = {'todo': 'Test Todo'};
      when(client.post(uri))
          .thenAnswer((_) async => http.Response('{"id": 1}', 201));

      final result = await networkService.postRequest(endpoint, body);

      expect(result, isA<Map<String, dynamic>>());
    });

    test('postRequest returns error on failure', () async {
      final client = MockClient();
      final body = {'todo': 'Test Todo'};
      when(client.post(uri))
          .thenAnswer((_) async => http.Response('Bad Request', 400));

      final result = await networkService.postRequest(endpoint, body);
      expect(result, isA<Map<String, dynamic>>());
      expect(result['success'], 'error');
    });

    test('putRequest returns data on success', () async {
      final client = MockClient();

      final body = {'todo': 'Updated Todo'};
      when(client.put(
        uri,
        body: jsonEncode(body),
        headers: headers,
      )).thenAnswer((_) async => http.Response('{"id": 1}', 200));

      final result = await networkService.putRequest(endpoint, body);

      expect(result, isA<Map<String, dynamic>>());
    });

    test('putRequest returns error on failure', () async {
      final client = MockClient();

      final body = {'todo': 'Updated Todo'};
      when(client.put(uri))
          .thenAnswer((_) async => http.Response('Bad Request', 400));

      final result = await networkService.putRequest(endpoint, body);

      expect(result, isA<Map<String, dynamic>>());
      expect(result['success'], 'error');
    });

    test('deleteRequest returns data on success', () async {
      final client = MockClient();

      when(client.delete(
        uri,
        headers: headers,
      )).thenAnswer((_) async => http.Response('{"success": true}', 200));

      final result = await networkService.deleteRequest(endpoint);

      expect(result, isA<Map<String, dynamic>>());
    });

    test('deleteRequest returns error on failure', () async {
      final client = MockClient();

      when(client.put(uri))
          .thenAnswer((_) async => http.Response('Bad Request', 400));

      final result = await networkService.deleteRequest(endpoint);

      expect(result, isA<Map<String, dynamic>>());
      expect(result['success'], 'error');
    });
  });
}
