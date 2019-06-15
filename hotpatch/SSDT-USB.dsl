// USB Port Injector for Lenovo ThinkPad T440P.
// Disabled FingerPrint Reader as it's not supported.
// Disabled ESEL to avoid USB Problems.
// Fix Auto Start after Shut Down when a USB Device is plugged in.

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 2, "T440P", "_USB", 0)
{
#endif
    Device(UIAC)
    {
        Name(_HID, "UIA00000")

        Name(RMCF, Package()
        {
            "8086_8c31", Package()
            {
                "port-count", Buffer() { 21, 0, 0, 0 },
                "ports", Package()
                {
                    "HS01", Package() // USB3 Port (2.0 Device)
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    "HS02", Package() // USB3 Port (2.0 Device)
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HS03", Package() // USB2 Port
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    "HS06", Package() // USB2 Port
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 6, 0, 0, 0 },
                    },
                    //"HS07", Package() // FingerPrint Reader
                    //{
                        //"UsbConnector", 255,
                        //"port", Buffer() { 7, 0, 0, 0 },
                    //},
                    "HS11", Package() // Bluetooth
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 11, 0, 0, 0 },
                    },
                    "HS12", Package() // Integrated Camera
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 12, 0, 0, 0 },
                    },
                    "SSP1", Package() // USB3 Port
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 16, 0, 0, 0 },
                    },
                    "SSP2", Package() // USB3 Port
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 17, 0, 0, 0 },
                    },
                },
            },
        })
    }
    External(_SB.PCI0.XHC, DeviceObj)
    External(ZPTS, MethodObj)
    External(_SB.PCI0.XHC.PMEE, FieldUnitObj)
    // Disable ESEL to avoid USB Problems
    Method(_SB.PCI0.XHC.ESEL)
    {
        // do nothing
    }
    // In DSDT, native _PTS is renamed to ZPTS
    // As a result, calls to this method land here.
    Method(_PTS, 1)
    {
        ZPTS(Arg0)
        If (5 == Arg0)
        {
            // fix "auto start after shutdown if a USB Device is Plugged In"
            \_SB.PCI0.XHC.PMEE = 0
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
