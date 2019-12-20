import ballerina/config;
import ballerina/http;
import ballerina/log;
import wso2/ftp;
import ballerina/io;

const string remoteLocation = "/home/ftp-user/in/account.json";

ftp:ClientEndpointConfig ftpConfig = {
    protocol: ftp:FTP,
    host: config:getAsString("ftp.host"),
    port: config:getAsInt("ftp.port"),
    secureSocket: {
        basicAuth: {
            username: config:getAsString("ftp.username"),
            password: config:getAsString("ftp.password")
        }
    }
};
ftp:Client ftp = new (ftpConfig);

@http:ServiceConfig {
    basePath: "company"
}

service company on new http:Listener(9090) {

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/addJsonFile"
    }

    resource function addJsonFile(http:Caller caller, http:Request request) returns error? {
        http:Response response = new ();
        json jsonPayload = check request.getJsonPayload();
        var ftpResult = ftp->put(remoteLocation, jsonPayload);

        if (ftpResult is error) {
            log:printError("Error", ftpResult);
            response.setJsonPayload({Message: "Error occurred uploading file to FTP.", Resason: ftpResult.reason()});
        } else {
            response.setJsonPayload({Message: "Employee records uploaded successfully."});
        }
        var httpResult = caller->respond(response);
    }

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/readFile/{fileName}"
    }
        resource function readFile(http:Caller caller, http:Request request, string fileName) returns error? {
        http:Response response = new ();
        var ftpResult = ftp->get("/home/ftp-user/in/" + fileName);
        if (ftpResult is io:ReadableByteChannel) {
            io:ReadableCharacterChannel? characters = new io:ReadableCharacterChannel(ftpResult, "utf-8");
            if (characters is io:ReadableCharacterChannel) {
                var output = characters.read(1000);
                if (output is json | xml | string | byte) {
                    response.setPayload(<@untained>(output));
                } else {
                    response.setJsonPayload(<@untained>({
                        Message: "Error occured in retrieving content",
                        Reason: output.reason()
                    }));
                    log:printError("Error occured in retrieving content", output);
                }
                var closeResult = characters.close();
                if (closeResult is error) {
                    log:printError("Error occurred while closing the channel", closeResult);
                }
            }
        } else {
            response.setJsonPayload({Message: "Error occured in retrieving content", Reason: ftpResult.reason()});
        }
        var httpResult = caller->respond(response);

    }
}
