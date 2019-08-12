// Battery Status hotpatch for Lenovo ThinkPad T440P
// SMCD device (FAN0) to read Fan RPM/Speed

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock ("", "SSDT", 2, "T440P", "_BAT", 0)
{
#endif
    External(_SB.PCI0.LPC.EC, DeviceObj)
    External(BATM, MutexObj)
    External(HIID, FieldUnitObj)
    
    Scope (_SB.PCI0.LPC.EC)
    {
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
        // Arg0 - offset in bytes from zero-based EC
        {
            OperationRegion(ERAM, EmbeddedControl, Arg0, 1)
            Field(ERAM, ByteAcc, NoLock, Preserve) { BYTE, 8 }
            Return(BYTE)
        }
        
        Method (RECB, 2, Serialized)
        // Arg0 - offset in bytes from zero-based EC
        // Arg1 - size of buffer in bits
        {
            ShiftRight(Arg1, 3, Arg1)
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
        
        OperationRegion (ECR1, EmbeddedControl, 0x00, 0x0100)
        Field (ECR1, ByteAcc, NoLock, Preserve)
        {
            //Offset (0x36),
            //WAC0, 8,WAC1, 8,
            Offset (0x84),
            SPD0, 8,SPD1, 8,
        }
        Field (ECR1, ByteAcc, NoLock, Preserve)
        {
            Offset (0xA0),
            BRC0, 8,BRC1, 8,
            BFC0, 8,BFC1, 8,
            BAC0, 8,BAC1, 8,
            BVO0, 8,BVO1, 8,
        }
        Field (ECR1, ByteAcc, NoLock, Preserve)
        {
            Offset (0xA0),
            BBM0, 8,BBM1, 8,
        }
        Field (ECR1, ByteAcc, NoLock, Preserve)
        {
            Offset (0xA0),
            BDC0, 8,BDC1, 8,
            BDV0, 8,BDV1, 8,
            BSN0, 8,BSN1, 8,
        }
        Field (ECR1, ByteAcc, NoLock, Preserve)
        {
            Offset (0xA0),
            BCH0, 8,BCH1, 8,BCH2, 8,BCH3, 8,
        }
        
        Method (GBIF, 3, NotSerialized)
        {
            Acquire (BATM, 0xFFFF)
            If (Arg2)
            {
                Or (Arg0, 0x01, HIID)
                Store (B1B2(BBM0,BBM1), Local7)
                ShiftRight (Local7, 0x0F, Local7)
                XOr (Local7, 0x01, Index (Arg1, 0x00))
                Store (Arg0, HIID)
                If (Local7)
                {
                    Multiply (B1B2 (BFC0, BFC1), 0x0A, Local1)
                }
                Else
                {
                    Store (B1B2 (BFC0, BFC1), Local1)
                }
                
                Store (Local1, Index (Arg1, 0x02))
                Or (Arg0, 0x02, HIID)
                If (Local7)
                {
                    Multiply (B1B2 (BDC0, BDC1), 0x0A, Local0)
                }
                Else
                {
                    Store (B1B2 (BDC0, BDC1), Local0)
                }
                
                Store (Local0, Index (Arg1, 0x01))
                Divide (Local1, 0x14, Local2, Index (Arg1, 0x05))
                If (Local7)
                {
                    Store (0xC8, Index (Arg1, 0x06))
                }
                ElseIf (B1B2 (BDV0, BDV1))
                {
                    Divide (0x00030D40,B1B2(BDV0, BDV1), Local2, Index (Arg1, 0x06))
                }
                Else
                {
                    Store (0x00, Index (Arg1, 0x06))
                }
                
                Store (B1B2 (BDV0, BDV1), Index (Arg1, 0x04))
                Store (B1B2 (BSN0, BSN1), Local0)
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
                Store (B1B4(BCH0,BCH1,BCH2,BCH3), BTYP)
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
            
            If (And (Arg1, 0x07)){}
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
                Store (B1B2 (BVO0, BVO1), Local3)
                If (Arg2)
                {
                    Multiply (B1B2 (BRC0, BRC1), 0x0A, Local2)
                }
                Else
                {
                    Store (B1B2 (BRC0, BRC1), Local2)
                }
                
                Store (B1B2 (BAC0, BAC1), Local1)
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
        
        Device (SMCD)
        {
            Name (_HID, "MON0000")
            Method (FAN0, 0, NotSerialized)
            {
                Store (B1B2 (\_SB.PCI0.LPC.EC.SPD0, \_SB.PCI0.LPC.EC.SPD1), Local0)
                Return (Local0)
            }
        }
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
