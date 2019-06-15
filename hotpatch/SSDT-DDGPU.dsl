// For disabling the discrete GPU (Nvidia)

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "T440P", "_DDGPU", 0)
{
#endif
    
    External(_SB.PCI0.PEG.VID.GPOF, MethodObj)
    Device(RMD1)
    {
        Name(_HID, "RMD10000")
        Method(_INI)
        {
            // disable discrete graphics (Nvidia/Radeon) if it is present
            If (CondRefOf(\_SB.PCI0.PEG.VID.GPOF))
            {
                \_SB.PCI0.PEG.VID.GPOF (Zero)
            }
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
