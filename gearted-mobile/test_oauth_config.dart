import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/oauth_config.dart';

/// A utility class to test OAuth configuration at runtime
/// Run this file to verify OAuth credentials are properly loaded
class OAuthDebugTool extends StatelessWidget {
  const OAuthDebugTool({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OAuth Debug'),
      ),
      body: FutureBuilder(
        future: _loadEnv(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading configuration: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildConfigHeader(),
                const SizedBox(height: 24),
                _buildGoogleConfig(),
                const SizedBox(height: 16),
                _buildFacebookConfig(),
                const SizedBox(height: 32),
                _buildTestButtons(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildConfigHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'OAuth Configuration Status',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'This tool helps verify the OAuth configuration is properly loaded.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleConfig() {
    final isConfigured = OAuthConfig.isGoogleConfigured;
    final clientId = OAuthConfig.googleWebClientId;

    return _buildConfigItem(
      title: 'Google OAuth',
      isConfigured: isConfigured,
      configValue: clientId,
      configName: 'GOOGLE_WEB_CLIENT_ID',
    );
  }

  Widget _buildFacebookConfig() {
    final isConfigured = OAuthConfig.isFacebookConfigured;
    final appId = OAuthConfig.facebookAppId;

    return _buildConfigItem(
      title: 'Facebook OAuth',
      isConfigured: isConfigured,
      configValue: appId,
      configName: 'FACEBOOK_APP_ID',
    );
  }

  Widget _buildConfigItem({
    required String title,
    required bool isConfigured,
    required String configValue,
    required String configName,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Icon(
                  isConfigured ? Icons.check_circle : Icons.error,
                  color: isConfigured ? Colors.green : Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '$configName:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isConfigured
                  ? _maskCredential(configValue)
                  : 'Not configured or using placeholder value',
              style: TextStyle(
                color: isConfigured ? Colors.black87 : Colors.red,
                fontFamily: 'monospace',
              ),
            ),
            if (!isConfigured) ...[
              const SizedBox(height: 8),
              const Text(
                'Please update your .env file with valid credentials',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTestButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            // Log configuration to console for debugging
            OAuthConfig.printConfig();
          },
          child: const Text('Print Config to Console'),
        ),
        const SizedBox(height: 16),
        const Text(
          'Note: This tool only verifies if credentials are set in the .env file. '
          'It does not validate if the credentials are correct or working.',
          style: TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _maskCredential(String credential) {
    if (credential.isEmpty) return 'missing';
    if (credential.length <= 8) return '****';
    return '${credential.substring(0, 4)}...${credential.substring(credential.length - 4)}';
  }

  Future<void> _loadEnv() async {
    await dotenv.load(fileName: ".env");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(
    MaterialApp(
      title: 'OAuth Debug',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const OAuthDebugTool(),
    ),
  );
}
