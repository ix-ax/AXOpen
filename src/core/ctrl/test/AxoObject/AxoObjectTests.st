USING AXOpen.Core;
USING AxUnit;

NAMESPACE AXOpen.Core.AxoObject_Tests

    CLASS TestObjContext EXTENDS AxoContext         
        METHOD PROTECTED OVERRIDE Main
            ;
        END_METHOD
    END_CLASS  

    CLASS TestObject EXTENDS AxoObject         
         
    END_CLASS  

    {TestFixture}
    CLASS IxObjectUnitTests EXTENDS AxoObject
        VAR PRIVATE
            _context : TestObjContext;
         END_VAR  
         METHOD PUBLIC OVERRIDE GetContext : IAxoContext
           GetContext := _context;
         END_METHOD  

        VAR PROTECTED
            _assign_identity_on_init : TestObject;
            _not_assign_identity_repeated_init : TestObject;
            _uninitialized_object : TestObject;
            _initialize_object_with_context : TestObject;
        END_VAR    

        {Test}
        METHOD PUBLIC should_assign_identity_upon_initialization_call
            VAR
                sut : REF_TO TestObject;
                expectedIdentity : ULINT;
            END_VAR  

            // Arrange
            sut := REF(_assign_identity_on_init);
            expectedIdentity := THIS.GetContext().CreateIdentity() + ULINT#1;

            // Act/Assert           
            sut^.Initialize(THIS);
            Assert.Equal(expectedIdentity, sut^.GetIdentity());
        END_METHOD

        {Test}
        METHOD PUBLIC should_not_change_identity_on_repeated_call_of_initialization
            VAR
                sut : REF_TO TestObject;
                expectedIdentity : ULINT;
            END_VAR    
            
            // Arrange
            sut := REF(_not_assign_identity_repeated_init);
            expectedIdentity := THIS.GetContext().CreateIdentity() + ULINT#1;
            
            // Act/Assert
            sut^.Initialize(THIS);
            Assert.Equal(sut^.GetIdentity(), expectedIdentity);
            sut^.Initialize(THIS);
            Assert.Equal(sut^.GetIdentity(), expectedIdentity);
        END_METHOD

        {Test}
        METHOD PUBLIC should_not_crush_uninitialized_object
            VAR
                sut : REF_TO TestObject;
                expectedIdentity : ULINT;
            END_VAR    
            ;
            // Arrange
            sut := REF(_uninitialized_object);
            expectedIdentity := ULINT#0;
            
            // Act/Assert
            
            sut^.GetContext();
            
            Assert.Equal(sut^.GetContext().CreateIdentity(), expectedIdentity);
            Assert.Equal(sut^.GetIdentity(), expectedIdentity);
           
        END_METHOD

        {Test}
        METHOD PUBLIC should_initialize_object_with_context_as_parent
            VAR
                sut : REF_TO TestObject;
                expectedIdentity : ULINT;
            END_VAR    
            ;
            // Arrange
            sut := REF(_initialize_object_with_context);
            expectedIdentity := _context.PeekIdentity() + ULINT#1;
            
            // Act/Assert
            sut^.Initialize(_context);
            sut^.GetContext();
                        
            Assert.Equal(sut^.GetIdentity(), expectedIdentity);
           
        END_METHOD
    END_CLASS

END_NAMESPACE
