USING AxUnit;
USING AXOpen.Elements;
USING AXOpen.Core;
USING AXOpen.Rtc;
USING AXOpen.Logging;
USING AXOpen.Components.Elements;

NAMESPACE AXOpen.Elements.Tests
   
    {TestFixture}
    {S7.extern=ReadWrite}
    CLASS AxoLockDoorWithSensorTests 
        VAR 
            context : TestContext;
            _testDoorLock : AxoDoorLockWithSensor;
            _isLockOpen : BOOL;
            _isSensorOpen : BOOL;
            _isLocked : BOOL;
            _lockOutput : BOOL;
            _lockResult : BOOL;
            _unlockResult : BOOL;
            _isClosedResult : BOOL;
        END_VAR   

        {Test}
        METHOD PUBLIC Test_Run_WithValidParent
            context.Open();
            _isLockOpen := FALSE;
            _isSensorOpen := FALSE;
            _isLocked := TRUE;
            
            _testDoorLock.Run(context.SignalParent, _isLockOpen, _isSensorOpen, _isLocked, _lockOutput);
            
            // Assert that inputs are processed correctly
            AxUnit.Assert.Equal(FALSE, _testDoorLock.IsLockOpen.IsTrue());
            AxUnit.Assert.Equal(FALSE, _testDoorLock.IsSensorOpen.IsTrue());
            AxUnit.Assert.Equal(TRUE, _testDoorLock._IsLocked);
            
            context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC Test_Run_NullParent_DoesNotRun
            _isLockOpen := FALSE;
            _isSensorOpen := FALSE;
            _isLocked := TRUE;
            
            _testDoorLock.Run(NULL, _isLockOpen, _isSensorOpen, _isLocked, _lockOutput);
            
            // Component should not process anything when parent is null
        END_METHOD

        {Test}
        METHOD PUBLIC Test_Lock_DoorClosedAndLocked_ReturnsTrue
            context.Open();
            _isLockOpen := FALSE;
            _isSensorOpen := FALSE;
            _isLocked := TRUE;
            
            _testDoorLock.Run(context.SignalParent, _isLockOpen, _isSensorOpen, _isLocked, _lockOutput);
            
            _lockResult := _testDoorLock.Lock();
            
            AxUnit.Assert.Equal(TRUE, _lockResult);
            
            context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC Test_Lock_DoorOpenOrUnlocked_ReturnsFalse
            context.Open();
            _isLockOpen := TRUE; // Door is open
            _isSensorOpen := FALSE;
            _isLocked := FALSE; // Not locked
            
            _testDoorLock.Run(context.SignalParent, _isLockOpen, _isSensorOpen, _isLocked, _lockOutput);
            
            _lockResult := _testDoorLock.Lock();
            
            AxUnit.Assert.Equal(FALSE, _lockResult);
            
            context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC Test_UnLock_LockedDoor_ReturnsTrue
            context.Open();
            _isLockOpen := FALSE;
            _isSensorOpen := FALSE;
            _isLocked := FALSE; // Not locked
            
            _testDoorLock.Run(context.SignalParent, _isLockOpen, _isSensorOpen, _isLocked, _lockOutput);
            
            _unlockResult := _testDoorLock.UnLock();
            
            AxUnit.Assert.Equal(TRUE, _unlockResult);
            
            context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC Test_UnLock_AlreadyLocked_ReturnsFalse
            context.Open();
            _isLockOpen := FALSE;
            _isSensorOpen := FALSE;
            _isLocked := TRUE; // Already locked
            
            _testDoorLock.Run(context.SignalParent, _isLockOpen, _isSensorOpen, _isLocked, _lockOutput);
            
            _unlockResult := _testDoorLock.UnLock();
            
            AxUnit.Assert.Equal(FALSE, _unlockResult);
            
            context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC Test_IsClosed_BothSensorsClosed_ReturnsTrue
            context.Open();
            _isLockOpen := FALSE;
            _isSensorOpen := FALSE;
            _isLocked := TRUE;
            
            _testDoorLock.Run(context.SignalParent, _isLockOpen, _isSensorOpen, _isLocked, _lockOutput);
            
            _isClosedResult := _testDoorLock.IsClosed();
            
            AxUnit.Assert.Equal(TRUE, _isClosedResult);
            
            context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC Test_IsClosed_AnySensorOpen_ReturnsFalse
            context.Open();
            _isLockOpen := TRUE; // Lock sensor is open
            _isSensorOpen := FALSE;
            _isLocked := TRUE;
            
            _testDoorLock.Run(context.SignalParent, _isLockOpen, _isSensorOpen, _isLocked, _lockOutput);
            
            _isClosedResult := _testDoorLock.IsClosed();
            
            AxUnit.Assert.Equal(FALSE, _isClosedResult);
            
            context.Close();
        END_METHOD

        {Test}
        METHOD PUBLIC Test_Restore_CallsRestoreOnChildren
            context.Open();
            _testDoorLock.Restore();
            context.Close();
        END_METHOD
    END_CLASS
END_NAMESPACE