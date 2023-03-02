PROGRAM MyProgram
    VAR_EXTERNAL
        MainContext : MyContext;
        ixcoreSequencers : core.SequencerExample;
        I_am_alive : ULINT;
        ixcoreTasks : core.Tasks;
        myComponentExamples : core.ComponentExamples;
    END_VAR    
    I_am_alive := I_am_alive + ULINT#1;
    MainContext.Run();
    ixcoreTasks.Run();
    ixcoreSequencers.Run();
    myComponentExamples.Run();

END_PROGRAM

USING ix.framework.core;

CLASS PUBLIC Cylinder EXTENDS ix.framework.core.IxObject
    VAR PUBLIC
        _home : REF_TO BOOL;
        _work : REF_TO BOOL;

        _moveHome : REF_TO BOOL;
        _moveWork : REF_TO BOOL;
    END_VAR 

    VAR PUBLIC
        {#ix-set:AttributeName = "Move Home"}
        _moveHomeCommand : IxTask;
        {#ix-set:AttributeName = "Move Work"}
        _moveWorkCommand : IxTask;
    END_VAR    
    
    METHOD PUBLIC MoveHome : IIxTaskState       
        MoveHome :=_moveHomeCommand.Invoke();
    END_METHOD    

    METHOD PUBLIC MoveWork : IIxTaskState       
        MoveWork :=_moveWorkCommand.Invoke();
    END_METHOD    

    METHOD PUBLIC Initialize        
        VAR_INPUT
            parent : IIxContext;
            home : REF_TO BOOL;
            work : REF_TO BOOL;
            moveHome : REF_TO BOOL;
            moveWork : REF_TO BOOL;
        END_VAR    
        
        SUPER.Initialize(parent);
        _moveHomeCommand.Initialize(THIS);

        _home := home;
        _work := work;
        _moveHome := moveHome;
        _moveWork := moveWork;

        IF(_moveHomeCommand.Execute()) THEN
            _moveHome^ := TRUE;
            _moveWork^ := FALSE;
            _moveHomeCommand.DoneWhen(_home^);    
        END_IF;    
        
        IF(_moveWorkCommand.Execute()) THEN
            _moveHome^ := FALSE;
            _moveWork^ := TRUE;
            _moveWorkCommand.DoneWhen(_work^);    
        END_IF;    

    END_METHOD        
END_CLASS    


CLASS MyContext EXTENDS ix.framework.core.IxContext
    VAR PUBLIC 
        _counter : INT; 
        _cylinder1 : Cylinder;   
        _homeSensor : BOOL;
        _workSensor : BOOL;
        _moveHomeSignal : BOOL;
        _moveWorkSignal : BOOL;
    END_VAR    
    
    VAR PUBLIC 
        _progress : INT; 
    END_VAR

    METHOD PROTECTED OVERRIDE Main 
        _cylinder1.Initialize(THIS, REF(_homeSensor), REF(_workSensor), REF(_moveHomeSignal), REF(_moveWorkSignal));

        CASE _progress OF
            0:
                IF(_cylinder1.MoveWork().IsDone()) THEN 
                    _progress := 1; 
                END_IF;
            1:    
                IF(_cylinder1.MoveHome().IsDone()) THEN 
                    _progress := 2; 
                END_IF;            
        END_CASE;

        _counter := _counter + 1;
    END_METHOD
END_CLASS    

