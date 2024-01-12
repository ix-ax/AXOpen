NAMESPACE AXOpen.Io
    TYPE ReplacementState  : UINT (
        OK              :=	UINT#0, //	The correct element exists.
        Substitute      :=	UINT#1, //	The element was replaced by a compatible element.
        Incompatible    :=	UINT#2, //	The element was replaced by an incompatible element (is reachable, but not ready for operation).
        Missing         :=	UINT#3 //	The element does not exist.
            );
    END_TYPE
END_NAMESPACE

