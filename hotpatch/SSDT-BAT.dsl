// Battery Status Hotpatch for Lenovo ThinkPad T440P.
// Add SMCD device for FAN RPM/Speed reading.
// Fix LED Blink after wake from sleep.

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 2, "T440P", "_BAT", 0)
{
#endif

    External(_SB.PCI0.LPC.EC, DeviceObj)
    External(BATM, MutexObj)
    External(HIID, FieldUnitObj)
    External(WAKI, DeviceObj)
    External(SPS, FieldUnitObj)
    External(_SB.PCI0.LPC.EC.HCMU, FieldUnitObj)
    External(_SB.PCI0.LPC.EC.EVNT, MethodObj)
    External(_SB.PCI0.LPC.EC.HKEY.MHKE, MethodObj)
    External(_SB.PCI0.LPC.EC.FNST, MethodObj)
    External(UCMS, MethodObj)
    External(LIDB, FieldUnitObj)
    External(_SB.PCI0.IGPU.VRSI, MethodObj)
    External(_SB.PCI0.LPC.EC.HFNI, MethodObj)
    External(FNID, FieldUnitObj)
    External(NVSS, MethodObj)
    External(_SB.PCI0.LPC.EC.AC._PSR, MethodObj)
    External(PWRS, FieldUnitObj)
    External(OSC4, FieldUnitObj)
    External(PNTF, MethodObj)
    External(ACST, FieldUnitObj)
    External(_SB.PCI0.LPC.EC.ATMC, MethodObj)
    External(SCRM, FieldUnitObj)
    External(_SB.PCI0.LPC.EC.HFSP, FieldUnitObj)
    External(MTAU, FieldUnitObj)
    External(_SB.PCI0.LPC.EC.PIBS, FieldUnitObj)
    External(_SB.PCI0.LPC.EC.PLSL, FieldUnitObj)
    External(_SB.PCI0.LPC.EC.PLTU, FieldUnitObj)
    External(PL1L, FieldUnitObj)
    External(_SB.PCI0.LPC.EC.PLLS, FieldUnitObj)
    External(PL1M, FieldUnitObj)
    External(_SB.PCI0.LPC.EC.PLMS, FieldUnitObj)
    External(IOEN, FieldUnitObj)
    External(IOST, FieldUnitObj)
    External(ISWK, FieldUnitObj)
    External(_SB.PCI0.LPC.EC.HKEY.DHKC, MethodObj)
    External(_SB.PCI0.LPC.EC.HKEY.MHKQ, MethodObj)
    External(VIGD, FieldUnitObj)
    External(_SB.PCI0.IGPU.GLIS, MethodObj)
    External(_SB.LID._LID, MethodObj)
    External(WVIS, FieldUnitObj)
    External(VBTD, MethodObj)
    External(VCMS, MethodObj)
    External(AWON, MethodObj)
    External(CMPR, FieldUnitObj)
    External(_SB.SLPB, DeviceObj)
    External(USBR, FieldUnitObj)
    External(_SB.PCI0.XHC.XRST, FieldUnitObj)
    External(XHC, FieldUnitObj)
    External(_SB.PCI0.XHC.PR3, FieldUnitObj)
    External(_SB.PCI0.XHC.PR3M, FieldUnitObj)
    External(_SB.PCI0.XHC.PR2, FieldUnitObj)
    External(_SB.PCI0.XHC.PR2M, FieldUnitObj)
    External(ISCT, FieldUnitObj)
    External(_SB.PCI0.IGPU.TCHE, MethodObj)
    External(_SB.IAOE.GAOS, MethodObj)
    External(_SB.IAOE.GSWR, MethodObj)
    External(_SB.PCI0.IGPU.STAT, FieldUnitObj)
    External(_SB.PCI0.LPC.EC.SKEM, FieldUnitObj)
    External(_SB.PCI0.LPC.EC.HSPA, FieldUnitObj)
    External(NBCF, FieldUnitObj)
    External(_SB.PCI0.LPC.EC.BRNS, MethodObj)
    External(VBRC, MethodObj)
    External(BRLV, FieldUnitObj)
    External(_SB.PCI0.EXP6.PDS, FieldUnitObj)
    External(_SB.PCI0.EXP6.PDSF, FieldUnitObj)
    External(_SB.PCI0.LPC.EC.BATW, MethodObj)
    External(_SB.PCI0.LPC.EC.BWAK, MethodObj)
    External(_SB.PCI0.LPC.EC.HKEY.WGWK, MethodObj)
    External(_TZ.THM0, ThermalZoneObj)
    External(VSLD, MethodObj)
    External(RRBF, FieldUnitObj)
    External(CSUM, MethodObj)
    External(CHKC, FieldUnitObj)
    External(CHKE, FieldUnitObj)
    
    Method (B1B2, 2, NotSerialized) { Return (Or (Arg0, ShiftLeft (Arg1, 8))) }
    
    Method (B1B4, 4, NotSerialized)
    {

        Store(Arg3, Local0)
        Or(Arg2, ShiftLeft(Local0, 8), Local0)
        Or(Arg1, ShiftLeft(Local0, 8), Local0)
        Or(Arg0, ShiftLeft(Local0, 8), Local0)
        Return(Local0)
    }
    Method (RE1B, 1, NotSerialized)
        {
            OperationRegion(ERAM, EmbeddedControl, Arg0, 1)
            Field(ERAM, ByteAcc, NoLock, Preserve) { BYTE, 8 }
            Return(BYTE)
        }
        Method (RECB, 2, Serialized)
        // Arg0 - offset in bytes from zero-based EC
        // Arg1 - size of buffer in bits
        {
            ShiftRight(Add(Arg1,7), 3, Arg1)
            Name(TEMP, Buffer(Arg1) { })
            Add(Arg0, Arg1, Arg1)
            Store(0, Local0)
            While (LLess(Arg0, Arg1))
            {
                Store(RE1B(Arg0), Index(TEMP, Local0))
                Increment(Arg0)
                Increment(Local0)
            }
            Return(TEMP)
        }
        
        Method (WE1B, 2, NotSerialized)
        {
            OperationRegion(ERAM, EmbeddedControl, Arg0, 1)
            Field(ERAM, ByteAcc, NoLock, Preserve) { BYTE, 8 }
            Store(Arg1, BYTE)
        }
        
        Method (WECB, 3, Serialized)
        // Arg0 - offset in bytes from zero-based EC
        // Arg1 - size of buffer in bits
        // Arg2 - value to write
        {
            ShiftRight(Add(Arg1,7), 3, Arg1)
            Name(TEMP, Buffer(Arg1) { })
            Store(Arg2, TEMP)
            Add(Arg0, Arg1, Arg1)
            Store(0, Local0)
            While (LLess(Arg0, Arg1))
            {
                WE1B(Arg0, DerefOf(Index(TEMP, Local0)))
                Increment(Arg0)
                Increment(Local0)
            }
        }

    Scope (_SB.PCI0.LPC.EC)
    {
        OperationRegion (ECR1, EmbeddedControl, 0x00, 0x0100)
        Field (ECR1, ByteAcc, NoLock, Preserve)
        {
            Offset(0x36),
            HWC0, 8,HWC1, 8,
            //Offset (0x4C)
            //HTMH, 8, (0x4C)
            //HTML, 8, (0x4D)
            Offset (0x4E),
            HWK0, 8,HWK1, 8,
            //Others in order.
            Offset (0x84),
            HFN1, 8,HFN2, 8,
        }
        Field (ECR1, ByteAcc, NoLock, Preserve)
        {
            Offset(0xA0),
            BR00, 8,BR01, 8,
            BF00, 8,BF01, 8,
            //SBAE, 16, (A4/A5)
            //SBRS, 16, (A6/A7)
            Offset(0xA8),
            BA00, 8,BA01, 8,
            BV00, 8,BV01, 8,
        }
        Field (ECR1, ByteAcc, NoLock, Preserve)
        {
            Offset(0xA0),
            BB00, 8,BB01, 8,
        }
        Field (ECR1, ByteAcc, NoLock, Preserve)
        {
            Offset(0xA0),
            BD00, 8,BD01, 8,
            SB00, 8,SB01, 8,
            //SBOM, 16, (A4/A5)
            //SBSI, 16, (A6/A7)
            //SBDT, 16, (A8/A9)
            Offset(0xAA),
            BS00, 8,BS01, 8,
        }
        Field (ECR1, ByteAcc, NoLock, Preserve)
        {
            Offset(0xA0),
            //SBCH, 32,
            SH00,8,SH01,8,SH02,8,SH03,8,
        }
        
        Method (GBIF, 3, NotSerialized)
        {
            Acquire (BATM, 0xFFFF)
            If (Arg2)
            {
                Or (Arg0, 0x01, HIID)
                Store (B1B2(BB00,BB01), Local7)
                ShiftRight (Local7, 0x0F, Local7)
                XOr (Local7, 0x01, Index (Arg1, 0x00))
                Store (Arg0, HIID)
                If (Local7)
                {
                    Multiply (B1B2(BF00,BF01), 0x0A, Local1)
                }
                Else
                {
                    Store (B1B2(BF00,BF01), Local1)
                }

                Store (Local1, Index (Arg1, 0x02))
                Or (Arg0, 0x02, HIID)
                If (Local7)
                {
                    Multiply (B1B2(BD00,BD01), 0x0A, Local0)
                }
                Else
                {
                    Store (B1B2(BD00,BD01), Local0)
                }

                Store (Local0, Index (Arg1, 0x01))
                Divide (Local1, 0x14, Local2, Index (Arg1, 0x05))
                If (Local7)
                {
                    Store (0xC8, Index (Arg1, 0x06))
                }
                ElseIf (B1B2(SB00,SB01))
                {
                    Divide (0x00030D40, B1B2(SB00,SB01), Local2, Index (Arg1, 0x06))
                }
                Else
                {
                    Store (0x00, Index (Arg1, 0x06))
                }

                Store (B1B2(SB00,SB01), Index (Arg1, 0x04))
                Store (B1B2(BS00,BS01), Local0)
                Name (SERN, Buffer (0x06)
                {
                    "     "
                })
                Store (0x04, Local2)
                While (Local0)
                {
                    Divide (Local0, 0x0A, Local1, Local0)
                    Add (Local1, 0x30, Index (SERN, Local2))
                    Decrement (Local2)
                }

                Store (SERN, Index (Arg1, 0x0A))
                Or (Arg0, 0x06, HIID)
                Store (RECB(0xA0,128), Index (Arg1, 0x09))
                Or (Arg0, 0x04, HIID)
                Name (BTYP, Buffer (0x05)
                {
                    0x00, 0x00, 0x00, 0x00, 0x00
                })
                Store (B1B4(SH00,SH01,SH02,SH03), BTYP)
                Store (BTYP, Index (Arg1, 0x0B))
                Or (Arg0, 0x05, HIID)
                Store (RECB(0xA0,128), Index (Arg1, 0x0C))
            }
            Else
            {
                Store (0xFFFFFFFF, Index (Arg1, 0x01))
                Store (0x00, Index (Arg1, 0x05))
                Store (0x00, Index (Arg1, 0x06))
                Store (0xFFFFFFFF, Index (Arg1, 0x02))
            }

            Release (BATM)
            Return (Arg1)
        }

        Method (GBST, 4, NotSerialized)
        {
            Acquire (BATM, 0xFFFF)
            If (And (Arg1, 0x20))
            {
                Store (0x02, Local0)
            }
            ElseIf (And (Arg1, 0x40))
            {
                Store (0x01, Local0)
            }
            Else
            {
                Store (0x00, Local0)
            }

            If (And (Arg1, 0x07)) {}
            Else
            {
                Or (Local0, 0x04, Local0)
            }

            If (LEqual (And (Arg1, 0x07), 0x07))
            {
                Store (0x04, Local0)
                Store (0x00, Local1)
                Store (0x00, Local2)
                Store (0x00, Local3)
            }
            Else
            {
                Store (Arg0, HIID)
                Store (B1B2(BV00,BV01), Local3)
                If (Arg2)
                {
                    Multiply (B1B2(BR00,BR01), 0x0A, Local2)
                }
                Else
                {
                    Store (B1B2(BR00,BR01), Local2)
                }

                Store (B1B2(BA00,BA01), Local1)
                If (LGreaterEqual (Local1, 0x8000))
                {
                    If (And (Local0, 0x01))
                    {
                        Subtract (0x00010000, Local1, Local1)
                    }
                    Else
                    {
                        Store (0x00, Local1)
                    }
                }
                ElseIf (LNot (And (Local0, 0x02)))
                {
                    Store (0x00, Local1)
                }

                If (Arg2)
                {
                    Multiply (Local3, Local1, Local1)
                    Divide (Local1, 0x03E8, Local7, Local1)
                }
            }

            Store (Local0, Index (Arg3, 0x00))
            Store (Local1, Index (Arg3, 0x01))
            Store (Local2, Index (Arg3, 0x02))
            Store (Local3, Index (Arg3, 0x03))
            Release (BATM)
            Return (Arg3)
        }
        
        Method (_WAK, 1, NotSerialized)  // _WAK: Wake
        {
            If (LOr (LEqual (Arg0, 0x00), LGreaterEqual (Arg0, 0x05)))
            {
                Return (WAKI)
            }

            Store (0x00, \SPS)
            Store (0x00, \_SB.PCI0.LPC.EC.HCMU)
            \_SB.PCI0.LPC.EC.EVNT (0x01)
            \_SB.PCI0.LPC.EC.HKEY.MHKE (0x01)
            \_SB.PCI0.LPC.EC.FNST ()
            \UCMS (0x0D)
            Store (0x00, \LIDB)
            \_SB.PCI0.IGPU.VRSI ()
            If (LEqual (Arg0, 0x01))
            {
                Store (\_SB.PCI0.LPC.EC.HFNI, \FNID)
            }

            If (LEqual (Arg0, 0x03))
            {
                \NVSS (0x00)
                External(\_SI._SST, MethodObj)
                \_SI._SST(1) // fixes power LED blinking after wake
                Store (\_SB.PCI0.LPC.EC.AC._PSR (), \PWRS)
                If (\OSC4)
                {
                    \PNTF (0x81)
                }

                If (LNotEqual (\ACST, \_SB.PCI0.LPC.EC.AC._PSR ()))
                {
                    \_SB.PCI0.LPC.EC.ATMC ()
                }

                If (\SCRM)
                {
                    Store (0x07, \_SB.PCI0.LPC.EC.HFSP)
                    If (\MTAU)
                    {
                        Store (0x03E8, Local2)
                        While (LAnd (\_SB.PCI0.LPC.EC.PIBS, Local2))
                    {
                        Sleep (0x01)
                        Decrement (Local2)
                    }

                    If (Local2)
                    {
                        Store (0x01, \_SB.PCI0.LPC.EC.PLSL)
                        Store (\MTAU, \_SB.PCI0.LPC.EC.PLTU)
                        Store (\PL1L, \_SB.PCI0.LPC.EC.PLLS)
                        Store (\PL1M, \_SB.PCI0.LPC.EC.PLMS)
                    }
                }
            }

            Store (0x00, \IOEN)
            Store (0x00, \IOST)
            If (LEqual (\ISWK, 0x01))
            {
                If (\_SB.PCI0.LPC.EC.HKEY.DHKC)
                {
                    \_SB.PCI0.LPC.EC.HKEY.MHKQ (0x6070)
                }
            }

            If (\VIGD)
            {
                \_SB.PCI0.IGPU.GLIS (\_SB.LID._LID ())
                If (\WVIS)
                {
                    \VBTD ()
                }
            }
            ElseIf (\WVIS)
            {
                \_SB.PCI0.IGPU.GLIS (\_SB.LID._LID ())
                \VBTD ()
            }

            \VCMS (0x01, \_SB.LID._LID ())
            \AWON (0x00)
            If (\CMPR)
            {
                Notify (\_SB.SLPB, 0x02)
                Store (0x00, \CMPR)
            }

            If (LOr (\USBR, \_SB.PCI0.XHC.XRST))
            {
                If (LOr (LEqual (\XHC, 0x02), LEqual (\XHC, 0x03)))
                {
                    Store (0x00, Local0)
                    And (\_SB.PCI0.XHC.PR3, 0xFFFFFFC0, Local0)
                    Or (Local0, \_SB.PCI0.XHC.PR3M, \_SB.PCI0.XHC.PR3)
                    Store (0x00, Local0)
                    And (\_SB.PCI0.XHC.PR2, 0xFFFF8000, Local0)
                    Or (Local0, \_SB.PCI0.XHC.PR2M, \_SB.PCI0.XHC.PR2)
                }
            }

            If (LNotEqual (\ISCT, 0x00))
            {
                If (\VIGD)
                {
                    If (And (\_SB.PCI0.IGPU.TCHE, 0x0100))
                    {
                        If (And (\_SB.IAOE.GAOS (), 0x01))
                        {
                            If (And (\_SB.IAOE.GSWR (), 0x02))
                            {
                                Store (Or (And (\_SB.PCI0.IGPU.STAT, Not (0x03)), 0x01), \_SB.PCI0.IGPU.STAT)
                                Store (0x01, \_SB.PCI0.LPC.EC.SKEM)
                            }
                        }
                    }
                }
            }
        }

        If (LEqual (Arg0, 0x04))
        {
            \NVSS (0x00)
            Store (0x00, \_SB.PCI0.LPC.EC.HSPA)
            Store (\_SB.PCI0.LPC.EC.AC._PSR (), \PWRS)
            If (\OSC4)
            {
                \PNTF (0x81)
            }

            \_SB.PCI0.LPC.EC.ATMC ()
            If (\SCRM)
            {
                Store (0x07, \_SB.PCI0.LPC.EC.HFSP)
                If (\MTAU)
                {
                    Store (0x03E8, Local2)
                    While (LAnd (\_SB.PCI0.LPC.EC.PIBS, Local2))
                    {
                        Sleep (0x01)
                        Decrement (Local2)
                    }

                    If (Local2)
                    {
                        Store (0x01, \_SB.PCI0.LPC.EC.PLSL)
                        Store (\MTAU, \_SB.PCI0.LPC.EC.PLTU)
                        Store (\PL1L, \_SB.PCI0.LPC.EC.PLLS)
                        Store (\PL1M, \_SB.PCI0.LPC.EC.PLMS)
                    }
                }
            }

            If (LNot (\NBCF))
            {
                If (\VIGD)
                {
                    \_SB.PCI0.LPC.EC.BRNS ()
                }
                Else
                {
                    \VBRC (\BRLV)
                }
            }

            Store (0x00, \IOEN)
            Store (0x00, \IOST)
            If (LEqual (\ISWK, 0x02))
            {
                If (\_SB.PCI0.LPC.EC.HKEY.DHKC)
                {
                    \_SB.PCI0.LPC.EC.HKEY.MHKQ (0x6080)
                }
            }

            If (\_SB.PCI0.XHC.XRST)
            {
                If (LOr (LEqual (\XHC, 0x02), LEqual (\XHC, 0x03)))
                {
                    Store (0x00, Local0)
                    And (\_SB.PCI0.XHC.PR3, 0xFFFFFFC0, Local0)
                    Or (Local0, \_SB.PCI0.XHC.PR3M, \_SB.PCI0.XHC.PR3)
                    Store (0x00, Local0)
                    And (\_SB.PCI0.XHC.PR2, 0xFFFF8000, Local0)
                    Or (Local0, \_SB.PCI0.XHC.PR2M, \_SB.PCI0.XHC.PR2)
                }
            }
        }

        If (XOr (\_SB.PCI0.EXP6.PDS, \_SB.PCI0.EXP6.PDSF))
        {
            Store (\_SB.PCI0.EXP6.PDS, \_SB.PCI0.EXP6.PDSF)
            Notify (\_SB.PCI0.EXP6, 0x00)
        }

        \_SB.PCI0.LPC.EC.BATW (Arg0)
        \_SB.PCI0.LPC.EC.BWAK (Arg0)
        \_SB.PCI0.LPC.EC.HKEY.WGWK (Arg0)
        Notify (\_TZ.THM0, 0x80)
        \VSLD (\_SB.LID._LID ())
        If (\VIGD)
        {
            \_SB.PCI0.IGPU.GLIS (\_SB.LID._LID ())
        }
        ElseIf (\WVIS)
        {
            \_SB.PCI0.IGPU.GLIS (\_SB.LID._LID ())
        }

        If (LLess (Arg0, 0x04))
        {
            If (LOr (And (\RRBF, 0x02), And (B1B2(\_SB.PCI0.LPC.EC.HWC0,\_SB.PCI0.LPC.EC.HWC1), 0x02)))
            {
                ShiftLeft (Arg0, 0x08, Local0)
                Store (Or (0x2013, Local0), Local0)
                \_SB.PCI0.LPC.EC.HKEY.MHKQ (Local0)
            }
        }

        If (LEqual (Arg0, 0x04))
        {
            Store (0x00, Local0)
            Store (\CSUM (0x00), Local1)
            If (LNotEqual (Local1, \CHKC))
            {
                Store (0x01, Local0)
                Store (Local1, \CHKC)
            }

            Store (\CSUM (0x01), Local1)
            If (LNotEqual (Local1, \CHKE))
            {
                Store (0x01, Local0)
                Store (Local1, \CHKE)
            }

            If (Local0)
            {
                Notify (\_SB, 0x00)
            }
        }

        Store (Zero, \RRBF)
        Return (WAKI)
    }
    
    Device (SMCD)
    {
        Name (_HID, "MON0000")
        Method (FAN0, 0, NotSerialized)
        {
            Store (B1B2 (\_SB.PCI0.LPC.EC.HFN1, \_SB.PCI0.LPC.EC.HFN2), Local0)
            Return (Local0)
        }
    }
    
    Scope(_GPE)
    {
        Method (_L1D, 0, NotSerialized)
        {
            Store (B1B2(\_SB.PCI0.LPC.EC.HWC0,\_SB.PCI0.LPC.EC.HWC1), Local0)
            Store (Local0, \RRBF)
            Sleep (0x0A)
            If (And (Local0, 0x02)) {}
            If (And (Local0, 0x04))
            {
                Notify (\_SB.LID, 0x02)
            }

            If (And (Local0, 0x08))
            {
                Notify (\_SB.SLPB, 0x02)
            }

            If (And (Local0, 0x10))
            {
                Notify (\_SB.SLPB, 0x02)
            }

            If (And (Local0, 0x40)) {}
            If (And (Local0, 0x80))
            {
                Notify (\_SB.SLPB, 0x02)
            }
        }
    }
  }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF