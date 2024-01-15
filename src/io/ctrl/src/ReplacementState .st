NAMESPACE AXOpen.Io
    TYPE ReplacementState  : UINT (
        Unknown         :=	UINT#255, 
        OK              :=	UINT#0, //	The correct element exists.
        Substitute      :=	UINT#1, //	The element was replaced by a compatible element.
        Incompatible    :=	UINT#2, //	The element was replaced by an incompatible element (is reachable, but not ready for operation).
        Missing         :=	UINT#3 //	The element does not exist.
            ) := Unknown;
    END_TYPE
END_NAMESPACE

