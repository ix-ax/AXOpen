
NAMESPACE axosimple.UnitTemplate
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
        EXTENDS AXOpen.Core.AxoTask
        IMPLEMENTS IModeContainer
        ///<summary>
        /// Runs service mode logic. This method must be called cyclically.
        ///</summary>

        METHOD PUBLIC Run
            VAR_INPUT
                parent : AXOpen.Core.IAxoObject;
            END_VAR
            VAR_IN_OUT
                components : axosimple.UnitTemplate.Components;
            END_VAR
            THIS.Initialize(parent);
            IF THIS.Execute() THEN
                THIS.Handle(components);
            END_IF;
        END_METHOD

        METHOD PRIVATE Handle
            VAR_IN_OUT
                components : axosimple.UnitTemplate.Components;
            END_VAR
            ;
            // HERE CALL LOGIC FOR MANUAL/SERICE OPERATIONS
           
            components.DI_1.ActivateManualControl();
            components.DI_2.ActivateManualControl();
            // components.DI_3.ActivateManualControl();
            // components.DI_4.ActivateManualControl();

            components.DO_1.ActivateManualControl();
            components.DO_2.ActivateManualControl();
            // components.DO_3.ActivateManualControl();
            // components.DO_4.ActivateManualControl();


            components.AI_1.ActivateManualControl();
            components.AI_2.ActivateManualControl();
            // components.AI_3.ActivateManualControl();
            // components.AI_4.ActivateManualControl();

            components.AO_1.ActivateManualControl();
            components.AO_2.ActivateManualControl();
            // components.AO_3.ActivateManualControl();
            // components.AO_4.ActivateManualControl();

            components.Cylinder_1.ActivateManualControl();
            components.Cylinder_2.ActivateManualControl();
            // components.Cylinder_3.ActivateManualControl();
            // components.Cylinder_4.ActivateManualControl();
                        
            components.Reader_1.ActivateManualControl();
            components.Reader_2.ActivateManualControl();
            
            components.Camera_1.ActivateManualControl();
            components.Camera_2.ActivateManualControl();

            components.Drive_R1.ActivateManualControl();
            components.Drive_R2.ActivateManualControl();
        
            components.Drive_F1.ActivateManualControl();
            components.Drive_F2.ActivateManualControl();
        

        END_METHOD
    END_CLASS
END_NAMESPACE    
