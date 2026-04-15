USING AXOpen.Core;

NAMESPACE AxoAlertExamples

    {S7.extern=ReadWrite}
    CLASS AxoAlertDocuExample EXTENDS AXOpen.Core.AxoObject
        //<AlertDeclaration>
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Process Alert#>"}
            _alert : AXOpen.Core.AxoAlert;
        END_VAR
        //</AlertDeclaration>

        //<AlertUsageVariables>
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Trigger alert#>"}
            _triggerAlert : BOOL;
            {#ix-set:AttributeName = "<#Alert was shown#>"}
            _alertWasShown : BOOL;
        END_VAR
        //</AlertUsageVariables>

        METHOD PUBLIC Execute
            //<AlertShowPattern>
            // AxoAlert shows a timed notification banner on the HMI.
            // Unlike AxoDialog, it does NOT wait for user response.
            // IsShown() returns TRUE once the alert has been displayed and dismissed.
            IF _triggerAlert THEN
                IF _alert.Show(THIS)
                    .WithTitle('<#Process Notification#>')
                    .WithType(eDialogType#Info)
                    .WithMessage('<#Cycle completed successfully.#>')
                    .WithTimeToBurn(UINT#5).IsShown() THEN
                    // Alert was displayed and timed out
                    _alertWasShown := TRUE;
                    _triggerAlert := FALSE;
                END_IF;
            END_IF;
            //</AlertShowPattern>
        END_METHOD

        METHOD AlertTypeExamples
        //<AlertTypes>
            // Info alert — general information
            IF _alert.Show(THIS)
                .WithTitle('<#Info#>')
                .WithType(eDialogType#Info)
                .WithMessage('<#Operation started.#>')
                .WithTimeToBurn(UINT#3).IsShown() THEN
                ;
            END_IF;

            // Success alert — operation completed
            IF _alert.Show(THIS)
                .WithTitle('<#Success#>')
                .WithType(eDialogType#Success)
                .WithMessage('<#Part inspection passed.#>')
                .WithTimeToBurn(UINT#5).IsShown() THEN
                ;
            END_IF;

            // Warning alert — attention needed
            IF _alert.Show(THIS)
                .WithTitle('<#Warning#>')
                .WithType(eDialogType#Warning)
                .WithMessage('<#Approaching maintenance interval.#>')
                .WithTimeToBurn(UINT#8).IsShown() THEN
                ;
            END_IF;

            // Danger alert — critical condition
            IF _alert.Show(THIS)
                .WithTitle('<#Danger#>')
                .WithType(eDialogType#Danger)
                .WithMessage('<#Emergency stop triggered.#>')
                .WithTimeToBurn(UINT#10).IsShown() THEN
                ;
            END_IF;
        //</AlertTypes>

        //<AlertRestore>
            // Restore clears the alert state, allowing it to be shown again
            _alert.Restore();
        //</AlertRestore>
        END_METHOD
    END_CLASS
END_NAMESPACE
