import ballerina/ai;
import ballerina/mcp;

final ai:Wso2ModelProvider weatherModel = check ai:getDefaultModelProvider();

final ai:Agent weatherAgent = check new (
    systemPrompt = {
        role: string `Weather Assistant`,
        instructions: string `You are a helpful weather assistant.
Use the tools available to you to fetch current weather, forecasts, or other weather related data when asked.
If no weather tools are available, let the user know that weather data access has not been configured yet.
Answer clearly and concisely, including relevant details such as location, temperature, and conditions when available.`
    }, model = anthropicModelprovider, tools = [pixelgustMcp]
);

final ai:InMemoryShortTermMemoryStore aiInmemoryshorttermmemorystore = check new ();
final ai:ShortTermMemory aiShorttermmemory = check new (aiInmemoryshorttermmemorystore);

isolated class PixelgustMcpToolkit {
    *ai:McpBaseToolKit;
    private final mcp:StreamableHttpClient mcpClient;
    private final readonly & ai:ToolConfig[] tools;

    public isolated function init(string serverUrl, mcp:Implementation info = {name: "MCP", version: "1.0.0"},
            *mcp:StreamableHttpClientTransportConfig config) returns ai:Error? {
        do {
            self.mcpClient = check new mcp:StreamableHttpClient(serverUrl, config);
            self.tools = check ai:getPermittedMcpToolConfigs(self.mcpClient, info, self.callTool).cloneReadOnly();
        } on fail error e {
            return error ai:Error("Failed to initialize MCP toolkit", e);
        }
    }

    public isolated function getTools() returns ai:ToolConfig[] => self.tools;

    @ai:AgentTool
    public isolated function callTool(mcp:CallToolParams params) returns mcp:CallToolResult|error {
        return self.mcpClient->callTool(params);
    }
}

