// NAMESPACE AXOpen.Core
//     FUNCTION IsNullContext : BOOL
//         VAR_INPUT
//             Context : IAxoContext;
//         END_VAR
//         IF Context = NULL THEN
//             IsNullContext := TRUE;
//         ELSIF Context.CreateIdentity() = ULINT#0 THEN
//             IsNullContext := TRUE;
//         ELSE
//             IsNullContext := FALSE;
//         END_IF;
//     END_FUNCTION
// END_NAMESPACE
