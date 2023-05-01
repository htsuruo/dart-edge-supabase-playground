import 'package:supabase_functions/supabase_functions.dart';

void main() {
  SupabaseFunctions(fetch: (request) async {
    final response = await fetch(
      Resource.uri(Uri.parse('http://httpbin.org/ip')),
      method: 'GET',
      headers: Headers({'Content-Type': 'application/json'}),
    );
    if (response.ok) {
      final json = (await response.json()) as Map<String, dynamic>?;
      print(json);
      return Response.json(json);
    }
    return Response.error();
  });
}
