class ApiKeys {
  // OpenAI API key from CodeMagic environment variable
  static const String openAiKey = String.fromEnvironment('OPENAI_API_KEY', 
    defaultValue: 'sk-your-actual-openai-api-key-here');
}
