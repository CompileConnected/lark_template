{{#api_openapi}}import 'package:openapi_generator_annotations/openapi_generator_annotations.dart';

@Openapi(
  additionalProperties: {{#openapi_dio}}DioProperties(pubName: '{{project_name.snakeCase()}}', pubAuthor: '{{org_name}}'){{/openapi_dio}}{{^openapi_dio}}AdditionalProperties(pubName: '{{project_name.snakeCase()}}', pubAuthor: '{{org_name}}'){{/openapi_dio}},
  inputSpec: {{#openapi_spec_url}}RemoteSpec(path: '{{openapi_spec_url}}'){{/openapi_spec_url}}{{^openapi_spec_url}}InputSpec(path: 'openapi/spec.json'){{/openapi_spec_url}},
  generatorName: Generator.{{#openapi_dart}}dart{{/openapi_dart}}{{#openapi_dio}}dartDio{{/openapi_dio}}{{#openapi_dio_alt}}dartOpenapiMaven{{/openapi_dio_alt}},
  runSourceGenOnOutput: {{#openapi_dio}}true{{/openapi_dio}}{{^openapi_dio}}false{{/openapi_dio}},
  outputDirectory: 'lib/src/api',
)
class OpenApiConfig {}
{{/api_openapi}}
