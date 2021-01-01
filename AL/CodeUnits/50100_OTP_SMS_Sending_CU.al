codeunit 50100 "OTP SMS Sending_AL"
{
    // // OTP SMS Authetication_Kunal Huria
    // //Change Api and their secret Key ...(For Ref. We Use this Url & Create free account for Testing Purpose - https://nexmo.com/)

    trigger OnRun()
    begin
        HttpPostSMS_AL();
    end;

    var
        Status: Integer;
        OTP: Integer;

    procedure HttpPostSMS_AL(): Text
    var
        HttpClient: HttpClient;
        ResponseMessage: HttpResponseMessage;
        JsonObject: JsonObject;
        ResponseText: Text;
        HttpContent: HttpContent;
        Answer: Boolean;
    begin
        OnBeforeSomething;
        Status := 1;
        Answer := DIALOG.CONFIRM('Do you Want to receive OTP?', FALSE);
        if not HttpClient.Post('https://rest.nexmo.com/sms/json' + GetParams, HttpContent, ResponseMessage) then
            Error('The Call to the Web Service Failed');
        // Error message Definition (Description)_START>>.. 
        if not ResponseMessage.IsSuccessStatusCode then
            Error('The web service returned an error message:\\' +
                    'Status code: %1\' +
                    'Description: %2',
                    ResponseMessage.HttpStatusCode,
                    ResponseMessage.ReasonPhrase);
        ResponseMessage.Content.ReadAs(ResponseText);
        // Error message Definition (Description)_END<<..
        // Error Message_
        if not JsonObject.ReadFrom(ResponseText) then
            Message('Invalid response, expected an JSON object.');
        exit(ResponseText);
    end;

    local procedure GetRandom(): Text
    var
        RandomParam: Text;
    begin
        OTP := RANDOM(99999);
        RandomParam := 'Hi..This is Kunal Blog (OTP SMS Sending) from %1 is %2 ';
        RandomParam := STRSUBSTNO(RandomParam, COMPANYNAME, OTP);
        EXIT(RandomParam);
    end;

    local procedure GetParams(): Text
    var
        Params: Text;
    begin
        Params := '?api_key=c5f8f10e&api_secret=Z8JG3UOTFseo4Mb0&to=919034411477,&from=Kunal-NAV&text=%1'; // Change api, secret key and other info..
        Params := STRSUBSTNO(Params, GetRandom);
        EXIT(Params);
    end;

    //[Scope('Internal')]
    procedure OnBeforeSomething(): Boolean
    var
        TwoFactorAuth: Page "Two Factor Authentication";
        "Count": Integer;
    begin
        IF Status = 0 THEN
            REPEAT
                CLEAR(TwoFactorAuth);
                IF TwoFactorAuth.RUNMODAL <> ACTION::OK THEN
                    ERROR('Cancelled');
                IF TwoFactorAuth.GetEnteredOTP = OTP THEN BEGIN
                    EXIT(TRUE);
                END ELSE BEGIN
                    Count += 1;
                    MESSAGE('Wrong OTP');
                END;
            UNTIL Count = 3;
        ERROR('You have Entered Wrong OTP too many times');
    end;

    var
    // HttpStatusCode: DotNet HttpStatusCode;
    // ResponseHeaders: DotNet NameValueCollection;
}
// dotnet
// {
//     assembly("System")
//     {
//         Version = '4.0.0.0';
//         Culture = 'neutral';
//         PublicKeyToken = 'b77a5c561934e089';

//         type("System.Net.HttpStatusCode"; "HttpStatusCode")
//         {
//         }

//         type("System.Collections.Specialized.NameValueCollection"; "NameValueCollection")
//         {
//         }
//     }

// assembly("Newtonsoft.Json")
// {
//     Version = '6.0.0.0';
//     Culture = 'neutral';
//     PublicKeyToken = '30ad4fe6b2a6aeed';

//     type("Newtonsoft.Json.Linq.JObject"; "JObject")
//     {
//     }

//     type("Newtonsoft.Json.JsonConvert"; "JsonConvert")
//     {
//     }
// }
// }