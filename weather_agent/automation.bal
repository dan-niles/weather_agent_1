import ballerina/ai;
import ballerina/http;

listener ai:Listener weatherAgentListener = new (listenOn = check http:getDefaultListener());

service /weather\-agent on weatherAgentListener {
    resource function post chat(@http:Payload ai:ChatReqMessage request) returns ai:ChatRespMessage|error {
        string stringResult = check weatherAgent.run(request.message, request.sessionId);
        return {message: stringResult};
    }
}
