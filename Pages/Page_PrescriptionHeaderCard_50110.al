page 50110 "Prescription Header Card"
{
    PageType = Document;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Prescription Header";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Prescription No"; Rec."Prescription No")
                {

                }
                field("Consultation No"; Rec."Consultation No")
                {

                }
                field("Patient No"; Rec."Patient No")
                {

                }
                field("Patient Name"; Rec."Patient Name")
                {

                }
                field("Doctor No"; Rec."Doctor No")
                {

                }
                field("Doctor Name"; Rec."Doctor Name")
                {

                }
                field("Prescription Date"; Rec."Prescription Date")
                {

                }
                field(Status; Rec.Status)
                {

                }
                field(Notes; Rec.Notes)
                {
                    MultiLine = true;
                }
            }

            part(PrescriptionLines; "Prescription Subform")
            {
                ApplicationArea = All;

                SubPageLink = "Prescription No" = field("Prescription No");
            }

        }
    }

    actions
    {
        area(Processing)
        {

            action(CompletePrescription)
            {
                ApplicationArea = All;
                Caption = 'Complete Prescription';
                Image = Completed;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;


                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Completed;
                    Rec.Modify();
                    Message('Prescription completed successfully.');
                end;
            }



            action(PrintPrescription)
            {
                ApplicationArea = All;
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;


                trigger OnAction()
                begin
                    Report.RunModal(50130, true, true, Rec);
                end;
            }

            action(PostToPharmacy)
            {
                caption = 'Post To Pharmacy';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = Post;

                trigger OnAction()
                var
                    PharmacyMgt: Codeunit "Pharmacy Management";
                    pharmacyHeader: Record "Pharmacy Header";
                    PrescriptionHeader: Record "Prescription Header";
                begin
                    PharmacyHeader.Reset();
                    PharmacyHeader.SetRange("Prescripion No", PrescriptionHeader."Prescription No");
                    // if PharmacyHeader.FindFirst() then
                    //     Error('This prescription has already been posted to Pharmacy.');
                    PharmacyMgt.CreatePharmacy(Rec);

                end;


            }
            action(Release)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Released;
                    Rec.Modify(true);

                    Message('Prescription Released.');
                end;
            }
            action(Reopen)
            {
                Caption = 'Reopen';
                Image = ReOpen;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Open;
                    Rec.Modify(true);

                    Message('Prescription Reopened.');
                end;
            }



        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        NoSeriesMgt: Codeunit "No. Series";
    begin
        if Rec."Prescription No" = '' then
            Rec."Prescription No" := NoSeriesMgt.GetNextNo('PRES');

        if Rec."Prescription Date" = 0D then
            Rec."Prescription Date" := Today;
    end;

    var
        myInt: Integer;
}