// Will also add the missing IMEI device.

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "T440P", "_IMEI", 0)
{
#endif
    External(_SB.PCI0.IGPU, DeviceObj)
    // Note: If your ACPI set (DSDT+SSDTs) already defines IMEI (or HECI),
    // remove this Device definition, swap for External below
    Device(_SB.PCI0.IMEI) { Name(_ADR, 0x00160000) }

#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
