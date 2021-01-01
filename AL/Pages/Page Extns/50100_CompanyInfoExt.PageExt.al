pageextension 50100 "Company Information Extension" extends "Company Information"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addlast(Processing)
        {
            action("Send OTP")
            {
                ApplicationArea = All;

                trigger OnAction()
                Var
                    OTPSMSSending_CU: Codeunit "OTP SMS Sending_AL";
                begin
                    OTPSMSSending_CU.Run();
                end;
            }
        }
    }

    var
        myInt: Integer;
}