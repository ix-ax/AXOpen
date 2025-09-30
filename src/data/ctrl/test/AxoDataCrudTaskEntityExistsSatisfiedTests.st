USING AXOpen.Core;
USING AXOpen.Data;
USING AxUnit;

NAMESPACE AXOpen.Data
    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoDataCrudTaskEntityExistsSatisfiedTests
        VAR
            _state : AxoDataCrudTaskEntityExistsSatisfied;
        END_VAR

        {Test}
        METHOD PUBLIC Satisfy_sets_status_and_exist_flag
            VAR
                existsAfterFirstRead : BOOL;
                existsAfterSecondRead : BOOL;
            END_VAR

            _state.Satisfy(eAxoTaskState#Done, TRUE);
            existsAfterFirstRead := _state.Exist();
            existsAfterSecondRead := _state.Exist();

            AxUnit.Assert.Equal(eAxoTaskState#Done, _state.Status);
            AxUnit.Assert.Equal(TRUE, existsAfterFirstRead);
            AxUnit.Assert.Equal(FALSE, existsAfterSecondRead);
        END_METHOD

        {Test}
        METHOD PUBLIC Satisfy_with_false_clears_exist_flag
            VAR
                existsAfterRead : BOOL;
            END_VAR

            _state.Satisfy(eAxoTaskState#Busy, FALSE);
            existsAfterRead := _state.Exist();

            AxUnit.Assert.Equal(eAxoTaskState#Busy, _state.Status);
            AxUnit.Assert.Equal(FALSE, existsAfterRead);
            AxUnit.Assert.Equal(FALSE, _state.Exist());
        END_METHOD
    END_CLASS
END_NAMESPACE
