import ballerinax/ai.anthropic;

final anthropic:ModelProvider anthropicModelprovider = check new (ampAnthropicProviderAgentManagerKey, "claude-haiku-4-5", ampAnthropicProviderAgentManagerUrl + "/v1");
final PixelgustMcpToolkit pixelgustMcp = check new (pixelgustMcpUrl, auth = {tokenUrl: agentIdTokenUrl, clientId: agentIdClientId, clientSecret: agentIdClientSecret, scopes: agentIdScopes, optionalParams: {"resource": pixelgustMcpUrl}});
