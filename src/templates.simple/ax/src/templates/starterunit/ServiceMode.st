
NAMESPACE axosimple.StarterUnitTemplate
    USING axosimple;
    USING AXOpen.Data;
    USING AXOpen.Core;
    USING System.Strings;

    ///<summary>
    /// Provides logic for service/manual/maintenance mode.
    ///</summary>
    {#ix-set:AttributeName = "<#SERVICE#>"}
    {S7.extern=ReadWrite}
    CLASS PUBLIC ServiceMode
        EXTENDS AXOpen.Core.AxoTask IMPLEMENTS IModeContainer
        ///<summary>
        /// Runs service mode logic. This method must be called cyclically.
        ///</summary>

        METHOD PUBLIC Run
            VAR_INPUT
                parent : IAxoObject;
            END_VAR
            VAR_IN_OUT
                components : axosimple.StarterUnitTemplate.Components;
            END_VAR
            THIS.Initialize(parent);
            IF THIS.Execute() THEN
                THIS.Handle(components);
            END_IF;
        END_METHOD

        METHOD PRIVATE Handle
            VAR_IN_OUT
                components : axosimple.StarterUnitTemplate.Components;
            END_VAR
            ;
            // HERE CALL LOGIC FOR MANUAL/SERICE OPERATIONS
            components.HorizontalCylinder.ActivateManualControl();
            components.VerticalCylinder.ActivateManualControl();
            components.GripperCylinder.ActivateManualControl();
        END_METHOD
    END_CLASS
END_NAMESPACE    
