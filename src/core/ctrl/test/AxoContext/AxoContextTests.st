USING AxUnit;
USING AXOpen.Core;
USING AXOpen.Rtm;

NAMESPACE AXOpen.Core.AxoContext_Tests

    {S7.extern=ReadWrite}
    CLASS TestContext EXTENDS AxoContext         
            METHOD PROTECTED OVERRIDE Main
                ;
            END_METHOD
    END_CLASS  
    

    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoContextUnitTests
        VAR PROTECTED
            _context : TestContext;
        END_VAR    

        VAR
            _contextClean : TestContext;
        END_VAR    
    
        {TestSetup}
        METHOD PUBLIC TestSetup
            _context := _contextClean;
        END_METHOD

        {TestTearDown}
        METHOD PUBLIC TestTearDown
            ;
        END_METHOD

        {FixtureSetup}
        METHOD PUBLIC FixtureSetup
            ;
        END_METHOD

        {FixtureTearDown}
        METHOD PUBLIC FixtureTearDown
            ;
        END_METHOD
        
        {Test}
        METHOD PUBLIC should_increment_counters_on_execute
            Assert.Equal(actual := ULINT#0, expected := _context.OpenCycleCount());
            Assert.Equal(actual := ULINT#0, expected := _context.ClosedCycleCount());
            _context.Run();
            Assert.Equal(actual := ULINT#1, expected := _context.OpenCycleCount());
            Assert.Equal(actual := ULINT#1, expected := _context.ClosedCycleCount());
        END_METHOD

         
        VAR
            _nullContext : _NULL_CONTEXT;
        END_VAR    
        {Test}
        METHOD PUBLIC null_contex_should_be_invalid            
            Assert.Equal(actual := _nullContext.IsValid(), expected := FALSE);            
        END_METHOD

        {Test}
        METHOD PUBLIC contex_should_be_valid            
            Assert.Equal(actual := _context.IsValid(), expected := TRUE);            
        END_METHOD

        {Test}
        METHOD PUBLIC should_increment_identity_counter
            VAR
                expected    : ULINT;
                actual      : ULINT;
            END_VAR    
            expected := _context.PeekIdentity() + ULINT#1;
            actual := _context.CreateIdentity();
            Assert.Equal(expected, actual);
        END_METHOD
               
    END_CLASS

    
END_NAMESPACE
