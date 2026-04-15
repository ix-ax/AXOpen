NAMESPACE AXOpen.Showcase.Pneumatics

    {S7.extern=ReadWrite}
    CLASS PneumaticsShowcase EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject : AXOpen.Core.AxoObject;
            axoCylinder : AxoCylinder_Example;
        END_VAR

        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            axoCylinder.Run(_rootObject);
        END_METHOD
    END_CLASS

END_NAMESPACE
