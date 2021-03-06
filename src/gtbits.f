C> @file
C
C> SUBPROGRAM:    GTBITS      COMPUTE NUMBER OF BITS AND ROUND FIELD.
C>   PRGMMR: IREDELL          ORG: W/NMC23    DATE: 92-10-31
C>
C> ABSTRACT: THE NUMBER OF BITS REQUIRED TO PACK A GIVEN FIELD
C>   AT A PARTICULAR DECIMAL SCALING IS COMPUTED USING THE FIELD RANGE.
C>   THE FIELD IS ROUNDED OFF TO THE DECIMAL SCALING FOR PACKING.
C>   THE MINIMUM AND MAXIMUM ROUNDED FIELD VALUES ARE ALSO RETURNED.
C>   GRIB BITMAP MASKING FOR VALID DATA IS OPTIONALLY USED.
C>
C> PROGRAM HISTORY LOG:
C>   92-10-31  IREDELL
C>
C> USAGE:    CALL GTBITS(IBM,IDS,LEN,MG,G,GMIN,GMAX,NBIT)
C>   INPUT ARGUMENT LIST:
C>     IBM      - INTEGER BITMAP FLAG (=0 FOR NO BITMAP)
C>     IDS      - INTEGER DECIMAL SCALING
C>                (E.G. IDS=3 TO ROUND FIELD TO NEAREST MILLI-VALUE)
C>     LEN      - INTEGER LENGTH OF THE FIELD AND BITMAP
C>     MG       - INTEGER (LEN) BITMAP IF IBM=1 (0 TO SKIP, 1 TO KEEP)
C>     G        - REAL (LEN) FIELD
C>
C>   OUTPUT ARGUMENT LIST:
C>     GROUND   - REAL (LEN) FIELD ROUNDED TO DECIMAL SCALING
C>                (SET TO ZERO WHERE BITMAP IS 0 IF IBM=1)
C>     GMIN     - REAL MINIMUM VALID ROUNDED FIELD VALUE
C>     GMAX     - REAL MAXIMUM VALID ROUNDED FIELD VALUE
C>     NBIT     - INTEGER NUMBER OF BITS TO PACK
C>
C> SUBPROGRAMS CALLED:
C>   ISRCHNE  - FIND FIRST VALUE IN AN ARRAY NOT EQUAL TO TARGET VALUE
C>
C> ATTRIBUTES:
C>   LANGUAGE: CRAY FORTRAN
C>
      SUBROUTINE GTBITS(IBM,IDS,LEN,MG,G,GROUND,GMIN,GMAX,NBIT)
      DIMENSION MG(LEN),G(LEN),GROUND(LEN)
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  ROUND FIELD AND DETERMINE EXTREMES WHERE BITMAP IS ON
      DS=10.**IDS
      IF(IBM.EQ.0) THEN
        GROUND(1)=NINT(G(1)*DS)/DS
        GMAX=GROUND(1)
        GMIN=GROUND(1)
        DO I=2,LEN
          GROUND(I)=NINT(G(I)*DS)/DS
          GMAX=MAX(GMAX,GROUND(I))
          GMIN=MIN(GMIN,GROUND(I))
        ENDDO
      ELSE
        I1=ISRCHNE(LEN,MG,1,0)
        IF(I1.GT.0.AND.I1.LE.LEN) THEN
          DO I=1,I1-1
            GROUND(I)=0.
          ENDDO
          GROUND(I1)=NINT(G(I1)*DS)/DS
          GMAX=GROUND(I1)
          GMIN=GROUND(I1)
          DO I=I1+1,LEN
            IF(MG(I).NE.0) THEN
              GROUND(I)=NINT(G(I)*DS)/DS
              GMAX=MAX(GMAX,GROUND(I))
              GMIN=MIN(GMIN,GROUND(I))
            ELSE
              GROUND(I)=0.
            ENDIF
          ENDDO
        ELSE
          DO I=1,LEN
            GROUND(I)=0.
          ENDDO
          GMAX=0.
          GMIN=0.
        ENDIF
      ENDIF
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  COMPUTE NUMBER OF BITS
      NBIT=LOG((GMAX-GMIN)*DS+0.9)/LOG(2.)+1.
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      RETURN
      END
