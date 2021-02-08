pageextension 11710 "G/L Account Balance Lines CZL" extends "G/L Account Balance Lines"
{
    layout
    {
        addafter(DebitAmount)
        {
            field("Debit Amount (VAT Date) CZL"; GLAcc."Debit Amount (VAT Date) CZL")
            {
                Caption = 'Debit Amount (VAT Date)';
                ApplicationArea = Basic, Suite;
                AutoFormatType = 1;
                BlankNumbers = BlankZero;
                DrillDown = true;
                Editable = false;
                ToolTip = 'Specifies the debit in the account balance during the time period in the Date Filter field posted by VAT date';
                trigger OnDrillDown()
                begin
                    BalanceDrillDown();
                end;
            }
        }
        addafter(CreditAmount)
        {
            field("Credit Amount (VAT Date) CZL"; GLAcc."Credit Amount (VAT Date) CZL")
            {
                Caption = 'Credit Amount (VAT Date)';
                ApplicationArea = Basic, Suite;
                AutoFormatType = 1;
                BlankNumbers = BlankZero;
                DrillDown = true;
                Editable = false;
                ToolTip = 'Specifies the credit in the account balance during the time period in the Date Filter field posted by VAT date';
                trigger OnDrillDown()
                begin
                    BalanceDrillDown();
                end;
            }
        }
        addafter(NetChange)
        {
            field("Net Change (VAT Date) CZL"; GLAcc."Net Change (VAT Date) CZL")
            {
                Caption = 'Net Change (VAT Date)';
                ApplicationArea = Basic, Suite;
                AutoFormatType = 1;
                BlankNumbers = BlankZero;
                DrillDown = true;
                Editable = false;
                ToolTip = 'Specifies the net change in the account balance during the time period in the Date Filter field posted by VAT date.';
                Visible = false;
                trigger OnDrillDown()
                begin
                    BalanceDrillDown();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if DebitCreditTotals then
            GLAcc.CalcFields("Debit Amount (VAT Date) CZL", "Credit Amount (VAT Date) CZL", "Net Change (VAT Date) CZL")
        else begin
            GLAcc.CalcFields("Net Change (VAT Date) CZL");
            if GLAcc."Net Change (VAT Date) CZL" > 0 then begin
                GLAcc."Debit Amount (VAT Date) CZL" := GLAcc."Net Change (VAT Date) CZL";
                GLAcc."Credit Amount (VAT Date) CZL" := 0
            end else begin
                GLAcc."Debit Amount (VAT Date) CZL" := 0;
                GLAcc."Credit Amount (VAT Date) CZL" := -GLAcc."Net Change (VAT Date) CZL"
            end;
        end;
    end;

    local procedure BalanceDrillDown()
    var
        GLEntry: Record "G/L Entry";
    begin
        GLEntry.SetCurrentKey("G/L Account No.", "Posting Date");
        GLEntry.SetRange("G/L Account No.", GLAcc."No.");
        if GLAcc.Totaling <> '' then
            GLEntry.SetFilter("G/L Account No.", GLAcc.Totaling);
        GLEntry.SetFilter("VAT Date CZL", GLAcc.GetFilter("Date Filter"));
        GLEntry.SetFilter("Global Dimension 1 Code", GLAcc.GetFilter("Global Dimension 1 Filter"));
        GLEntry.SetFilter("Global Dimension 2 Code", GLAcc.GetFilter("Global Dimension 2 Filter"));
        GLEntry.SetFilter("Business Unit Code", GLAcc.GetFilter("Business Unit Filter"));
        Page.Run(0, GLEntry);
    end;
}
