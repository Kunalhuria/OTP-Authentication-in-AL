page 50100 "Two Factor Authentication"
{
    PageType = StandardDialog;
    layout
    {
        area(content)
        {
            group("Enter the OTP you received..")
            {
                Caption = 'Enter the OTP you received..';
                field(InputOTP; InputOTP)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        InputOTP: Integer;

    //[Scope('Internal')]
    procedure GetEnteredOTP(): Integer
    begin
        EXIT(InputOTP);
    end;
}

