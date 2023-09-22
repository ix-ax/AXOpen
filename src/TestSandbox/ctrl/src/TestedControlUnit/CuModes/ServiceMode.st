NAMESPACE sandboxtest.StandardControlUnit
    USING AXOpen.Core;
    USING System.Strings;

    ///<summary>
    /// Provides logic for service/manual/maintenance mode.
    ///</summary>
    {#ix-set:AttributeName = "<#SERVICE#>"}
    CLASS PUBLIC ServiceMode
        EXTENDS AXOpen.Core.AxoTask
        ///<summary>
        /// Runs service mode logic. This method must be called cyclically.
        ///</summary>

        METHOD PUBLIC Run
            VAR_INPUT
                parent : IAxoObject;
            END_VAR
            VAR_IN_OUT
                components : Components;
            END_VAR
            THIS.Initialize(parent);
            IF THIS.Execute() THEN
                THIS.Handle(components);
            END_IF;
        END_METHOD

        METHOD PRIVATE Handle
            VAR_IN_OUT
                components : Components;
            END_VAR
            ;
            //HERE CALL LOGIC FOR MANUAL/SERICE OPERATIONS
            components.Cylinder_0.ActivateManualControl();
            components.Cylinder_1.ActivateManualControl();
            components.Cylinder_2.ActivateManualControl();
            components.Cylinder_3.ActivateManualControl();
            components.Cylinder_4.ActivateManualControl();
            components.Cylinder_5.ActivateManualControl();
            components.Cylinder_6.ActivateManualControl();
            components.Cylinder_7.ActivateManualControl();
            components.Cylinder_8.ActivateManualControl();
            components.Cylinder_9.ActivateManualControl();  

            components.Reader_0.ActivateManualControl();
            components.Reader_1.ActivateManualControl();
            
            components.Camera_0.ActivateManualControl();
            components.Camera_1.ActivateManualControl();

        END_METHOD
    END_CLASS

END_NAMESPACE
