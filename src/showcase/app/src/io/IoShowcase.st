USING AXOpen.Core;

NAMESPACE AXOpen.Showcase.Io

    {S7.extern=ReadWrite}
    CLASS IoShowcase EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            _rootObject                     : AxoObject;
            axoIoComponent                  : AxoIoComponent_Showcase;
            axoHwDiag                       : AxoHwDiag_Showcase;
            axoRecordAccessTool             : AxoRecordAccessTool_Showcase;
            axoIOLinkET200SP_Balluff_IO     : AxoIOLinkET200SP_Balluff_IO_Showcase;
        END_VAR

        METHOD PUBLIC Execute
            _rootObject.Run(THIS);
            axoIoComponent.Run(_rootObject);
            axoHwDiag.Run(_rootObject);
            axoRecordAccessTool.Run(_rootObject);
            axoIOLinkET200SP_Balluff_IO.Run(_rootObject);
        END_METHOD
    END_CLASS

END_NAMESPACE
