// for testing including all SSDTs with NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "Sniki", "_T440P", 0)
{
    #define NO_DEFINITIONBLOCK
    #include "SSDT-XOSI.dsl"
    #include "SSDT-DDGPU.dsl"
    #include "SSDT-BAT.dsl"
    #include "SSDT-DEHCI.dsl"
    #include "SSDT-USB.dsl"
    #include "SSDT-IMEI.dsl"
    #include "SSDT-KBD.dsl"
    #include "SSDT-PNLF.dsl"
    #include "SSDT-ALS0.dsl"
    #include "SSDT-ALC3232.dsl"
}
//EOF
