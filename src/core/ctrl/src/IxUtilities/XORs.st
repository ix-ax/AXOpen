// USING System.BitAccess;

NAMESPACE ix.framework.core
    FUNCTION ixXor : BYTE
        VAR_INPUT 
            In1 : BYTE;
            In2 : BYTE;
        END_VAR
        VAR_TEMP
            retval : BYTE;
            i : USINT;
        END_VAR
        retval := BYTE#0;

        // TODO check the performance of both principles
        // FOR i := USINT#0 TO USINT#7 DO
        //     SetBit(retval,i,GetBit(In1,i) XOR GetBit(In2,i));
        // END_FOR;

        retval.%X0 := In1.%X0  XOR In2.%X0 ;
        retval.%X1 := In1.%X1  XOR In2.%X1 ;
        retval.%X2 := In1.%X2  XOR In2.%X2 ;
        retval.%X3 := In1.%X3  XOR In2.%X3 ;
        retval.%X4 := In1.%X4  XOR In2.%X4 ;
        retval.%X5 := In1.%X5  XOR In2.%X5 ;
        retval.%X6 := In1.%X6  XOR In2.%X6 ;
        retval.%X7 := In1.%X7  XOR In2.%X7 ;

        ixXor := retval;
    END_FUNCTION

    FUNCTION ixXor : WORD
        VAR_INPUT 
            In1 : WORD;
            In2 : WORD;
        END_VAR
        VAR_TEMP
            retval : WORD;
            i : USINT;
        END_VAR
        retval := WORD#0;

        // TODO check the performance of both principles
        // FOR i := USINT#0 TO USINT#15 DO
        //     SetBit(retval,i,GetBit(In1,i) XOR GetBit(In2,i));
        // END_FOR;

        retval.%X0  := In1.%X0   XOR In2.%X0  ;
        retval.%X1  := In1.%X1   XOR In2.%X1  ;
        retval.%X2  := In1.%X2   XOR In2.%X2  ;
        retval.%X3  := In1.%X3   XOR In2.%X3  ;
        retval.%X4  := In1.%X4   XOR In2.%X4  ;
        retval.%X5  := In1.%X5   XOR In2.%X5  ;
        retval.%X6  := In1.%X6   XOR In2.%X6  ;
        retval.%X7  := In1.%X7   XOR In2.%X7  ;
        retval.%X8  := In1.%X8   XOR In2.%X8  ;
        retval.%X9  := In1.%X9   XOR In2.%X9  ;
        retval.%X10 := In1.%X10  XOR In2.%X10 ;
        retval.%X11 := In1.%X11  XOR In2.%X11 ;
        retval.%X12 := In1.%X12  XOR In2.%X12 ;
        retval.%X13 := In1.%X13  XOR In2.%X13 ;
        retval.%X14 := In1.%X14  XOR In2.%X14 ;
        retval.%X15 := In1.%X15  XOR In2.%X15 ;

        ixXor := retval;
    END_FUNCTION    

    FUNCTION ixXor : DWORD
        VAR_INPUT 
            In1 : DWORD;
            In2 : DWORD;
        END_VAR
        VAR_TEMP
            retval : DWORD;
            i : USINT;
        END_VAR
        retval := DWORD#0;

        // TODO check the performance of both principles
        // FOR i := USINT#0 TO USINT#31 DO
        //     SetBit(retval,i,GetBit(In1,i) XOR GetBit(In2,i));
        // END_FOR;

        retval.%X0  := In1.%X0   XOR In2.%X0  ;
        retval.%X1  := In1.%X1   XOR In2.%X1  ;
        retval.%X2  := In1.%X2   XOR In2.%X2  ;
        retval.%X3  := In1.%X3   XOR In2.%X3  ;
        retval.%X4  := In1.%X4   XOR In2.%X4  ;
        retval.%X5  := In1.%X5   XOR In2.%X5  ;
        retval.%X6  := In1.%X6   XOR In2.%X6  ;
        retval.%X7  := In1.%X7   XOR In2.%X7  ;
        retval.%X8  := In1.%X8   XOR In2.%X8  ;
        retval.%X9  := In1.%X9   XOR In2.%X9  ;
        retval.%X10 := In1.%X10  XOR In2.%X10 ;
        retval.%X11 := In1.%X11  XOR In2.%X11 ;
        retval.%X12 := In1.%X12  XOR In2.%X12 ;
        retval.%X13 := In1.%X13  XOR In2.%X13 ;
        retval.%X14 := In1.%X14  XOR In2.%X14 ;
        retval.%X15 := In1.%X15  XOR In2.%X15 ;
        retval.%X16 := In1.%X16  XOR In2.%X16 ;
        retval.%X17 := In1.%X17  XOR In2.%X17 ;
        retval.%X18 := In1.%X18  XOR In2.%X18 ;
        retval.%X19 := In1.%X19  XOR In2.%X19 ;
        retval.%X20 := In1.%X20  XOR In2.%X20 ;
        retval.%X21 := In1.%X21  XOR In2.%X21 ;
        retval.%X22 := In1.%X22  XOR In2.%X22 ;
        retval.%X23 := In1.%X23  XOR In2.%X23 ;
        retval.%X24 := In1.%X24  XOR In2.%X24 ;
        retval.%X25 := In1.%X25  XOR In2.%X25 ;
        retval.%X26 := In1.%X26  XOR In2.%X26 ;
        retval.%X27 := In1.%X27  XOR In2.%X27 ;
        retval.%X28 := In1.%X28  XOR In2.%X28 ;
        retval.%X29 := In1.%X29  XOR In2.%X29 ;
        retval.%X30 := In1.%X30  XOR In2.%X30 ;
        retval.%X31 := In1.%X31  XOR In2.%X31 ;
        ixXor := retval;
    END_FUNCTION 

    FUNCTION ixXor : LWORD
        VAR_INPUT 
            In1 : LWORD;
            In2 : LWORD;
        END_VAR
        VAR_TEMP
            retval : LWORD;
            i : USINT;
        END_VAR
        retval := LWORD#0;

        // TODO check the performance of both principles
        // FOR i := USINT#0 TO USINT#63 DO
        //     SetBit(retval,i,GetBit(In1,i) XOR GetBit(In2,i));
        // END_FOR;

        retval.%X0  := In1.%X0   XOR In2.%X0  ;
        retval.%X1  := In1.%X1   XOR In2.%X1  ;
        retval.%X2  := In1.%X2   XOR In2.%X2  ;
        retval.%X3  := In1.%X3   XOR In2.%X3  ;
        retval.%X4  := In1.%X4   XOR In2.%X4  ;
        retval.%X5  := In1.%X5   XOR In2.%X5  ;
        retval.%X6  := In1.%X6   XOR In2.%X6  ;
        retval.%X7  := In1.%X7   XOR In2.%X7  ;
        retval.%X8  := In1.%X8   XOR In2.%X8  ;
        retval.%X9  := In1.%X9   XOR In2.%X9  ;
        retval.%X10 := In1.%X10  XOR In2.%X10 ;
        retval.%X11 := In1.%X11  XOR In2.%X11 ;
        retval.%X12 := In1.%X12  XOR In2.%X12 ;
        retval.%X13 := In1.%X13  XOR In2.%X13 ;
        retval.%X14 := In1.%X14  XOR In2.%X14 ;
        retval.%X15 := In1.%X15  XOR In2.%X15 ;
        retval.%X16 := In1.%X16  XOR In2.%X16 ;
        retval.%X17 := In1.%X17  XOR In2.%X17 ;
        retval.%X18 := In1.%X18  XOR In2.%X18 ;
        retval.%X19 := In1.%X19  XOR In2.%X19 ;
        retval.%X20 := In1.%X20  XOR In2.%X20 ;
        retval.%X21 := In1.%X21  XOR In2.%X21 ;
        retval.%X22 := In1.%X22  XOR In2.%X22 ;
        retval.%X23 := In1.%X23  XOR In2.%X23 ;
        retval.%X24 := In1.%X24  XOR In2.%X24 ;
        retval.%X25 := In1.%X25  XOR In2.%X25 ;
        retval.%X26 := In1.%X26  XOR In2.%X26 ;
        retval.%X27 := In1.%X27  XOR In2.%X27 ;
        retval.%X28 := In1.%X28  XOR In2.%X28 ;
        retval.%X29 := In1.%X29  XOR In2.%X29 ;
        retval.%X30 := In1.%X30  XOR In2.%X30 ;
        retval.%X31 := In1.%X31  XOR In2.%X31 ;
        retval.%X32 := In1.%X32  XOR In2.%X32 ;
        retval.%X33 := In1.%X33  XOR In2.%X33 ;
        retval.%X34 := In1.%X34  XOR In2.%X34 ;
        retval.%X35 := In1.%X35  XOR In2.%X35 ;
        retval.%X36 := In1.%X36  XOR In2.%X36 ;
        retval.%X37 := In1.%X37  XOR In2.%X37 ;
        retval.%X38 := In1.%X38  XOR In2.%X38 ;
        retval.%X39 := In1.%X39  XOR In2.%X39 ;
        retval.%X40 := In1.%X40  XOR In2.%X40 ;
        retval.%X41 := In1.%X41  XOR In2.%X41 ;
        retval.%X42 := In1.%X42  XOR In2.%X42 ;
        retval.%X43 := In1.%X43  XOR In2.%X43 ;
        retval.%X44 := In1.%X44  XOR In2.%X44 ;
        retval.%X45 := In1.%X45  XOR In2.%X45 ;
        retval.%X46 := In1.%X46  XOR In2.%X46 ;
        retval.%X47 := In1.%X47  XOR In2.%X47 ;
        retval.%X48 := In1.%X48  XOR In2.%X48 ;
        retval.%X49 := In1.%X49  XOR In2.%X49 ;
        retval.%X50 := In1.%X50  XOR In2.%X50 ;
        retval.%X51 := In1.%X51  XOR In2.%X51 ;
        retval.%X52 := In1.%X52  XOR In2.%X52 ;
        retval.%X53 := In1.%X53  XOR In2.%X53 ;
        retval.%X54 := In1.%X54  XOR In2.%X54 ;
        retval.%X55 := In1.%X55  XOR In2.%X55 ;
        retval.%X56 := In1.%X56  XOR In2.%X56 ;
        retval.%X57 := In1.%X57  XOR In2.%X57 ;
        retval.%X58 := In1.%X58  XOR In2.%X58 ;
        retval.%X59 := In1.%X59  XOR In2.%X59 ;
        retval.%X60 := In1.%X60  XOR In2.%X60 ;
        retval.%X61 := In1.%X61  XOR In2.%X61 ;
        retval.%X62 := In1.%X62  XOR In2.%X62 ;
        retval.%X63 := In1.%X63  XOR In2.%X63 ;
        ixXor := retval;
    END_FUNCTION 
END_NAMESPACE