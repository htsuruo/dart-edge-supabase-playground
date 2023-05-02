import 'dart:convert';

import 'package:supabase_functions/supabase_functions.dart';

void main() {
  // ref. https://supabase.com/docs/guides/functions/examples/openai
  SupabaseFunctions(fetch: (request) async {
    final req = (await request.json()) as Map<String, dynamic>?;
    print('req: $req');
    if (req == null) {
      return Response.error();
    }
    return fetch(
      Resource.uri(Uri.parse('https://api.openai.com/v1/completions')),
      method: 'POST',
      headers: Headers(
        {
          'Authorization': 'Bearer ${Deno.env.get('OPENAI_API_KEY')}',
          'OpenAI-Organization': '${Deno.env.get('ORGANIZATION_ID')}',
          'Content-Type': 'application/json'
        },
      ),
      // TODO(tsuruoka): replase Map<String,dynamic> to Type-Safe class.
      body: jsonEncode(<String, dynamic>{
        'model': 'text-davinci-003',
        'prompt': req['query'],
        'max_tokens': 256,
        'temperature': 0,
        'stream': false,
      }),
    );
  });

  // Get IP Address on Edge Runtime with `http` package
  // TODO(tsuruoka): cannot use `http` package on Edge Runtime following error.
  // Unsupported operation: Cannot create a client without dart:html or dart:io
  // http.runWithClient(() async {
  //   SupabaseFunctions(fetch: (request) async {
  //     final response = await http.get(
  //       Uri.parse('http://httpbin.org/ip'),
  //       headers: {'Content-Type': 'application/json'},
  //     );
  //     if (response.statusCode == 200) {
  //       final json = response.body as Map<String, dynamic>?;
  //       print(json);
  //       return Response.json(json);
  //     }
  //     return Response.error();
  //   });
  // }, () => EdgeHttpClient());

  // Get IP Address on Edge Runtime with `fetch` method
  //
  // SupabaseFunctions(fetch: (request) async {
  //   final response = await fetch(
  //     Resource.uri(Uri.parse('http://httpbin.org/ip')),
  //     method: 'GET',
  //     headers: Headers({'Content-Type': 'application/json'}),
  //   );
  //   if (response.ok) {
  //     final json = (await response.json()) as Map<String, dynamic>?;
  //     print(json);
  //     return Response.json(json);
  //   }
  //   return Response.error();
  // });
}
