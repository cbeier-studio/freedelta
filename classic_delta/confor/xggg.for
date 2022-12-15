      PROGRAM    CONFOR                                                     XSSS
 
C* REVISED 17-SEP-93.
C* CONVERTS DELTA FORMAT TO OTHER FORMATS.
C    (DELTA = DESCRIPTION LANGUAGE FOR TAXONOMY.)
 
      CHARACTER PIDP*230
      PARAMETER (PIDP = '|CONFOR version 2.25f Win32-gfortran||'//
     *'M.J. Dallwitz, T.A. Paine and E.J. Zurcher||'//
     *'CSIRO Division of Entomology, '//
     *'GPO Box 1700, Canberra, ACT 2601, Australia|'//
     *'Phone +61 2 6246 4075. '//
     *'Fax +61 2 6246 4000. Email delta@ento.csiro.au||%')

      PARAMETER (LENW=2000000)
 
C     COMMON FORCES ALIGNMENT WITH SEGMENT BOUNDARY.
      COMMON W(LENW)
      DIMENSION IW(LENW)
      EQUIVALENCE (W,IW)
 
      COMMON /PIDXXX/ PID
        CHARACTER*230 PID
      COMMON /WDIRXX/ LENWRK,IWRKDRV,WRKDIR
        CHARACTER*80 WRKDIR
 
      PID = PIDP
      LW = LENW
 
      LENWRK = 0
 
      CALL CONFR (W, IW, LW)
 
      END
      SUBROUTINE MEM (W, LW, IWST)                                          XSSS
 
C  REVISED 12-DEC-90.
C  DUMMY ROUTINE TO MATCH MS-DOS MEMORY ALLOCATION CALL.
 
      IWST = 1
 
      RETURN
      END
      SUBROUTINE CPYINP (IPOINT, IBUF, N, IOUT, LOUT, JOUT)                 XSSS
 
C  REVISED 16-NOV-92.
C  COPIES A BUFFER AND 'TRANSLATES' ANY CONTROL CHARACTERS PRESENT.
 
C  IPOINT RECEIVES AND RETURNS A POINTER INTO THE BUFFER.
C  IBUF RECEIVES THE BUFFER.
C  N RECEIVES THE NUMBER OF CHARACTERS IN THE BUFFER
C  IOUT RECEIVES THE OUTPUT BUFFER.
C  LOUT RECEIVES THE THE LENGTH OF THE OUTPUT BUFFER.
C  JOUT RETURNS THE NUMBER OF CHARACTERS OUTPUT.
 
      COMMON /SYMXXX/ KPOINT,KDASH,KSTAR,KVERT,KEQUAL,KCOMMA,KSEMIC,
     * KCOLON,KSTOP,KSOL,KLPAR,KRPAR,KDOLLA,KQUEST,KEXCL,KAT,KLBRACE,
     * KRBRACE
 
      DIMENSION IBUF(N),IOUT(LOUT)
 
      I = 1
      JOUT = 0
      DO WHILE (I.LE.N)
        IF (IBUF(I).LT.32)  THEN
          IF (JOUT+2.GT.LOUT)  GOTO 10
          IOUT(JOUT+1) = KPOINT
          IOUT(JOUT+2) = IBUF(I)+64
          JOUT = JOUT + 2
          IF (IPOINT.GT.I)  IPOINT = IPOINT + 1
        ELSE
          JOUT = JOUT + 1
          IOUT(JOUT) = IBUF(I)
        ENDIF
        I = I + 1
      END DO
 
   10 RETURN
      END
      LOGICAL FUNCTION BITTST (N, IA, NBITS)                                XSSS

C  REVISED 6-DEC-88.
C  TESTS A BIT IN AN ARRAY.

C  N RECEIVES THE BIT NUMBER (NUMBER OF LEAST SIGNIFICANT BIT = 1).
C  IA RECEIVES THE ARRAY.
C  NBITS RECEIVES THE NUMBER OF BITS USED PER WORD.

      DIMENSION IA(1000)

      IW = (N-1)/NBITS
      I = N - IW*NBITS
      BITTST = BTEST(IA(IW+1),I-1)

      RETURN
      END
      SUBROUTINE CLRBIT (N, IA, NBITS)                                      XSSS

C  REVISED 6-DEC-88.
C  CLEARS A BIT IN AN ARRAY.

C  N RECEIVES THE BIT NUMBER (NUMBER OF LEAST SIGNIFICANT BIT = 1).
C  IA RECEIVES THE ARRAY.
C  NBITS RECEIVES THE NUMBER OF BITS USED PER WORD.

      DIMENSION IA(1000)

      IW = (N-1)/NBITS
      I = N - IW*NBITS
      IA(IW+1) = IBCLR(IA(IW+1),I-1)

      RETURN
      END


      SUBROUTINE DELDIR (DIR, L)                                            XWWW
 
C  REVISED 08-SEP-95.
C  FINDS VALUE OF DELTA ENVIRONMENT VARIABLE.
 
      COMMON /BLKXXX/ KBLANK
      COMMON /DELXXX/ KDPLUS,KDSTAR,KDNUM,KDSOL,KDLBRA,KDRBRA,
     * KDCOM,KDRANG,KDAMP,KDCOLN,KDSTOP,KDINF,KDLPAR,KDRPAR,KDBSLSH
 
      CHARACTER ARG*256
      CHARACTER*(*) DIR
 
C     ASSUMING THE PROGRAM IS RUNNING FROM THE DELTA DIRECTORY!
C     GET FULL PATHNAME OF RUNNING PROGRAM.
      CALL GETARG(0, ARG)
      
C     FIND START OF NAME.
      DO I = LNBLNK(ARG), 1, -1
         IF (ARG(I:I).EQ.CHAR(KDCOLN) .OR.
     *        ARG(I:I).EQ.CHAR(KDBSLSH) .OR.
     *        arg(I:I).eq.'/') GOTO 50
      ENDDO
 50   DIR = ARG(1:I)
      L = I
      
      IF (L.EQ.0) THEN
         L = GETCWD(DIR)
         IF (L.EQ.0) THEN
            L = LNBLNK(DIR) + 1
            DIR(L:L) = '/';
         ELSE
            L = 0
         ENDIF
         
      ENDIF

      RETURN
      END

c      SUBROUTINE DELDIR (DIR, L)                                            XSSS
c 
C  REVISED 20-JUN-90.
C  FINDS VALUE OF DELTA ENVIRONMENT VARIABLE.
 
c      COMMON /LUNXXX/ LUNE,LUNL,LUNO,LUNP,LUNS1,LUNBO,LUNBI,LUNI,LUNDA,
c     * LUNS2,LUNS3,LUNS4,LUNS5,LUNS6,LUNS7
c 
c      CHARACTER*(*) DIR
c
c      CALL GETENV ('DELTA', DIR)
c      IF (DIR .EQ. ' ') DIR  = '/usr/local/delta'
c
c      L = LNBLNK(DIR)
c      IF (DIR(L:L) .NE. '/') THEN
c        L = L + 1
c        DIR(L:L) = '/'
c      ENDIF 
c
c      RETURN
c      END
      SUBROUTINE EXNAME (FSPEC, FNAME)                                      XSSS

C* REVISED 13/7/87.
C* EXTRACTS FILE NAME AND TYPE FROM FILE SPECIFICATION.

C  ALSO, IF THE SPECIFICATION DOES NOT CONTAIN A FILE TYPE, AND THE
C    DEFAULT FILE TYPE (AS INSERTED BY THE COMPILER) IS NOT NULL, A NULL
C    TYPE (I.E. A DOT) IS EXPLICITLY INSERTED IN THE SPECIFICATION.

C  FSPEC RECEIVES AND RETURNS A FILE SPECIFICATION.
C    IN THIS VERSION, THE RETURNED FILE SPECIFICATION IS UNALTERED.
C  FNAME RETURNS THE FILE NAME AND TYPE (EXTENSION), I.E. THE FILE
C    SPECIFICATION LESS ANY DISC NAME AND DIRECTORY NAME (PATH).

      CHARACTER*(*) FSPEC, FNAME

C     FIND END OF SPECIFICATION.
      LFS = LEN(FSPEC)
      DO 10 I = 1, LFS
        IF (FSPEC(I:I).EQ.' ') GOTO 20
   10 CONTINUE
   20 IES = I - 1
      IEN = IES

C     FIND START OF NAME.
      DO 30 I = IES, 1, -1
        IF (FSPEC(I:I).EQ.':' .OR. FSPEC(I:I).EQ.'\') GOTO 40
   30 CONTINUE
   40 IBN = I + 1

C     STORE NAME.
   80 IF (FSPEC(IEN:IEN).EQ.'.') IEN = IEN - 1
      FNAME = ' '
      IF (IBN.LE.IEN) FNAME = FSPEC(IBN:IEN)

      RETURN
      END
      SUBROUTINE GTIME (TIM, DAT)                                           XSSS

C* REVISED 15-JAN-90.
C* GETS THE TIME AND DATE.
C UNDER SUNOS, REQUIRES LINKING WITH V77 LIBRARY FOR CORRECT BEHAVIOUR

      CHARACTER*10 TIM,DAT
      character*10 atim, adat
      character*25 test

      test = ctime(time8())
c      print *, test
      
c      CALL Date_and_Time(aDAT, aTIM)
c      TIM = atim(1:2) // ':' // atim(3:4) // ':' // atim(5:6)
c      DAT = adat(7:8) // '-' // adat(5:6) // '-' // adat(1:4)
      tim = test(12:19)
      dat = test(9:10) // '-' // test(5:7) // '-' // test(23:24)
C      CALL TIME (TIM)
C      TIM(9:10) = ' '
C      CALL DATE (DAT)
C      DAT(10:10) = ' '

      RETURN
      END
      SUBROUTINE INITF (LUNE, LUNI, LUNTI, LUNTO, LUNUSE, NUN)              XSSS

C* REVISED 8-OCT-92.
C* INITIALIZES SYSTEM-DEPENDENT INPUT/OUTPUT.

C  LUNE RETURNS THE ERROR LOGICAL UNIT.
C  LUNI RETURNS THE INITIAL INPUT LOGICAL UNIT.
C  LUNTI RETURNS THE TERMINAL INPUT LOGICAL UNIT.
C  LUNTO RETURNS THE TERMINAL OUTPUT LOGICAL UNIT.
C  LUNUSE RETURNS FLAGS INDICATING UNAVAILABLE LOGICAL UNITS (SEE
C    BELOW).
C  NUN RECEIVES THE DIMENSION OF LUNUSE.

C  THIS SUBR. MUST:
C  (1) SET LUNUSE(LUN) TO 0 FOR ANY LOGICAL UNITS WHOSE USE
C      IS RESTRICTED BY THE OPERATING SYSTEM.
C  (2) IF TERMINAL INPUT/OUTPUT IS REQUIRED, SET LUNTI AND LUNTO
C      TO THE REQUIRED VALUES, AND OPEN THESE UNITS IF NECESSARY.
C  (3) OPEN A UNIT FOR INITIAL OUTPUT OF ERROR MESSAGES, AND SET
C      LUNE TO THE NUMBER OF THIS UNIT.
C  (4) OPEN A UNIT FOR INITIAL INPUT OF DIRECTIVES, AND SET
C      LUNI TO THE NUMBER OF THIS UNIT.

      DIMENSION LUNUSE(NUN)
      CHARACTER FNAME*60,MESS*80
      LOGICAL*4 E

C-    SET LUNUSE(LUN) TO 0 FOR ANY UNUSABLE LOGICAL UNITS.
      LUNUSE(5) = 0
      LUNUSE(6) = 0
      CONTINUE

C-    OPEN TERMINAL INPUT AND OUTPUT UNITS.
      LUNTI = 5
      LUNTO = 6

C-    SET ERROR UNIT.
C     NOTE. ACTUAL I/O IS DONE ON UNIT 0. THE VARIABLES ARE SET TO 1 TO
C     AVOID ARRAY-BOUNDS ERRORS (MS-FORTRAN DOES NOT ALLOW SUBSCRIPT 0).
      LUNE = LUNTO

C-    OPEN MAIN DIRECTIVES FILE.
      LUNI = 2

C     GET THE COMMAND LINE.
      IF (IARGC().GT.0) THEN
        CALL GETARG(1, FNAME) 

      ELSE
C     ASK FOR THE FILE NAME IF IT WAS NOT IN THE COMMAND LINE.
        WRITE (0, 10)
   10   FORMAT('ENTER THE NAME OF THE DIRECTIVES FILE: ',$)
        READ (5, 20) FNAME
   20   FORMAT (A)
      ENDIF

C     CHECK FOR EXISTENCE OF THE FILE, AND OPEN IT.
      INQUIRE (FILE=FNAME, EXIST=E)
      IF (.NOT.E) GOTO 210
      OPEN (UNIT=LUNI, FILE=FNAME, STATUS='OLD', ERR=220)
C-
  100 RETURN

C-    FATAL ERRORS.
  200 IERRNO = 123
      GOTO 294

  210 IERRNO = 121
      GOTO 290

  220 IERRNO = 122

  290 DO 292 I = 60, 2, -1
       IF (FNAME(I:I).NE.' ') GOTO 294
  292 CONTINUE

  294 CALL PMESSC (IERRNO, IDUM, 1, FNAME(1:I), I, 1, MESS, LMESS)
      WRITE (0, *) MESS(1:LMESS-1)
 
  300 CALL PSTOP (1)
      END
      SUBROUTINE PROGRS (ITYPE, N, NSEQ, NTOT, TNAME, L)                    XWWW
 
C* REVISED 08-JUN-99.
C* WRITES A PROGRESS DISPLAY IN THE TOP-RIGHT CORNER OF THE SCREEN.

C  ITYPE RECEIVES 1 IF THE OUTPUT IS FOR ITEMS
C                 2 IF THE OUTPUT IS FOR CHARACTERS
C                 3 IF THE OUTPUT IS FOR MATRIX TRANSPOSITION IN INTTI.
C  N RECEIVES THE ITEM OR CHARACTER NUMBER.
C  NSEQ RECEIVES THE SEQUENCE NUMBER.
C  NTOT RECEIVES THE MAXIMUM NUMBER OF CHARACTERS OR ITEMS.
C  TNAME RECEIVES THE TAXON NAME IF ITYPE = 1
C  L RECEIVES THE LENGTH OF ITEXT.

      COMMON /OUTXXX/ LFLAG
 
      CHARACTER CC*1,TXT*45
      INTEGER TEMP(60),TNAME(L)

      P = (NSEQ * 100.)/NTOT
 
C     DETERMINE CARRIAGE-CONTROL CHARACTER REQUIRED.
c      IF (NSEQ.EQ.1)  THEN
        CC = CHAR(13)
c      ELSE
c        IF (LFLAG.NE.0)  THEN
c          CC = ' '
c        ELSE
          CC = CHAR(13)
c        ENDIF
c      ENDIF
      LFLAG = 0
      IF (NSEQ.NE.NTOT) LFLAG = 1
 
C     LIMIT ON NAME LENGTH. NOTE: VARIABLE TXT NEEDS TO HAVE THIS SIZE.
      NAMELIM = 45
      LTEMP = 60
      IF (ITYPE.EQ.1)  THEN
        TXT = ' '
        I = 0
        JSG = 2
   10   IF (JSG.GT.TNAME(1))  GO TO 20
          IF (JSG.GT.2)  THEN
            I = I + 1
            IF (I.GT.NAMELIM)  GOTO 20
            TXT(I:I) = ' '
          ENDIF
          IB = JSG + 2
          L = TNAME(JSG) - 2
C         Handle any Unicode characters first.
C         Use a temporary array to store changed name.
          NCOPY = MIN(L, LTEMP)
          CALL COPIA (TNAME(IB), TEMP, NCOPY)
          CALL PROCRTF (TEMP, NCOPY, L1, -1)
          DO J = 1, L1
            IF (IGNOR(TEMP(J)).EQ.0)  THEN
              I = I + 1
              IF (I.GT.NAMELIM)  GOTO 20
              TXT(I:I) = CHAR(TEMP(J))
            ENDIF
          ENDDO
          JSG = JSG + TNAME(JSG)
          GO TO 10
      ENDIF
 
   20 IF (ITYPE.EQ.1)  THEN
        IF (NSEQ.EQ.NTOT)  THEN
          WRITE (*,30) CC,TXT,N,NINT(P)
   30     FORMAT (A, A,' Item ',I6,'  Done ',I3,'%')
        ELSE
          WRITE (*,35) CC,TXT,N,NINT(P)
   35     FORMAT (A, A,' Item ',I6,'  Done ',I3,'%',$)
        ENDIF
      ELSEIF (ITYPE.EQ.2)  THEN
        IF (NSEQ.EQ.NTOT)  THEN
          WRITE (*,40) CC,N,NINT(P)
   40     FORMAT (A, ' Character ',I6,'  Done ',I3,'%')
        ELSE
          WRITE (*,45) CC,N,NINT(P)
   45     FORMAT (A, ' Character ',I6,'  Done ',I3,'%',$)
        ENDIF
      ELSEIF (ITYPE.EQ.3)  THEN
        IF (NSEQ.EQ.NTOT)  THEN
          WRITE (*,50) CC,N,NINT(P)
   50     FORMAT (A,
     *    'Transposing Matrix      Character ',I6,'  Done ',I3,'%')
        ELSE
          WRITE (*,51) CC,N,NINT(P)
   51     FORMAT (A,
     *    'Transposing Matrix      Character ',I6,'  Done ',I3,'%',$)
        ENDIF
      ENDIF

      RETURN
      END
c      SUBROUTINE PROGRS (ITYPE, N, NTOT, TNAME, L)                          XSSS
 
C* REVISED 3-MAR-92.
C* DUMMY ROUTINE TO MATCH DOS AND OS/2 VERSIONS.

c      RETURN
c      END
      SUBROUTINE PSTOP (ISTAT)                                              XSSS
 
C  REVISED 9-OCT-92.
C  STOPS A PROGRAM.
 
      CALL EXIT(ISTAT)
      END
      SUBROUTINE RREC (IBUF, MIREC, LUN, LREC)                             XSSS

C* REVISED 10-JUN-93.
C* READS A RECORD.

C  IBUF RETURNS THE RECORD, 1 SYMBOL PER ELEMENT.
C  MIREC RECEIVES THE MAXIMUM RECORD LENGTH.
C  LUN RECEIVES THE LOGICAL UNIT.
C  LREC RETURNS THE ACTUAL LENGTH OF THE RECORD READ, OR -1 IF
C    THERE ARE NO MORE RECORDS IN THE FILE.
C  FNAME RECEIVES THE FILE NAME.
C  LFNAME RECEIVES THE LENGTH OF THE FILE NAME.
C  LUNREC RECEIVES THE RECORD NUMBER.

      DIMENSION IBUF(MIREC),IVAL(3)
C     LENGTH MUST BE MIREC.                                                   =/
      CHARACTER*120 BUF

      PARAMETER (ITAB=9, IBLANK = 32, ICR=13)
      
      READ (LUN, 20, END=50) BUF
   20 FORMAT (A)
      LREC = LEN_TRIM(BUF)
 	  
      IF (LREC.LE.0) GO TO 100

 30   DO 40 I = 1, MIREC
        IBUF(I) = ICHAR(BUF(I:I))
C       CONVERT TAB CHARACTER TO A SINGLE BLANK.
        IF (IBUF(I).EQ.ITAB)  IBUF(I) = IBLANK
        IF (IBUF(I).EQ.ICR)  IBUF(I) = IBLANK
C        IF (K.LT.32)  THEN
C          CALL BMESS
C          IVAL(1) = K
C          IVAL(2) = LUNREC + 1
C          IVAL(3) = I
C          CALL MESSC (124, IVAL, 3, 0, 0, FNAME(1:LFNAME), LFNAME, 1)
C          IBUF(I) = ICHAR(' ')
C          CALL ECOUNT
C        ELSE
C          IBUF(I) = K
C        ENDIF
   40 CONTINUE

      GO TO 100

   50 LREC = -1

  100 RETURN
      END
      SUBROUTINE SETBIT (N, IA, NBITS)                                      XSSS

C* REVISED 6-DEC-88.
C* SETS A BIT IN AN ARRAY.

C  N.B. IN THE STANDARD VERSION, THE BIT MUST INITIALLY BE CLEAR, AND
C    THE SIGN BIT CANNOT BE USED.

C  N RECEIVES THE BIT NUMBER (NUMBER OF LEAST SIGNIFICANT BIT = 1).
C  IA RECEIVES THE ARRAY.
C  NBITS RECEIVES THE NUMBER OF BITS USED PER WORD.

      DIMENSION IA(1000)

      IW = (N-1)/NBITS
      I = N - IW*NBITS
      IA(IW+1) = IBSET(IA(IW+1),I-1)

      RETURN
      END

      SUBROUTINE SYSID (ID)                                                 XSSS
 
C  REVISED 26-APR-91.
C  RETURNS A STRING IDENTIFYING THE TYPE OF SYSTEM.
 
      CHARACTER*(*) ID
 
      ID = 'OS/2'
      RETURN
      END
      SUBROUTINE UOPEN (LUN, LUNUSE, FNAME, LREC, IERR)                     XSSS

C* REVISED 22-SEP-92.
C* BEGINS A FILE.

C  LUN RECEIVES THE LOGICAL UNIT NUMBER.
C  LUNUSE RECEIVES THE COMPATIBILITY OF LUN.
C  FNAME RECEIVES THE FILE NAME.
C  LREC RECEIVES THE LENGTH OF DIRECT-ACCESS RECORDS IN WORDS.
C  IERR RETURNS 1 IF ERROR, 0 OTHERWISE.

      CHARACTER*(*) FNAME
      LOGICAL CHKDIRY

      IERR = 0

C     Check if the directory named in an output file exists.
      IF (LUNUSE.LE.4.OR.LUNUSE.EQ.9)  THEN
        L = LSTRB(FNAME)
        DO I = L, 1, -1
          IF (FNAME(I:I).EQ.'\'.OR.FNAME(I:I).EQ.'/')  THEN
            IF (CHKDIRY(FNAME(1:I), I)) GOTO 10
            CALL MESSC (164, IDUM, 1, 1, 0, FNAME(1:I-1), I-1, 1)
            GOTO 100
          ENDIF
        ENDDO
      ENDIF
   10 CONTINUE

      IF (LUNUSE.LE.2.OR.LUNUSE.EQ.4) THEN
        OPEN (UNIT=LUN, FILE=FNAME, STATUS='UNKNOWN', ERR=100)
      ELSEIF (LUNUSE.EQ.3) THEN
        OPEN (UNIT=LUN, FILE=FNAME, STATUS='UNKNOWN', ERR=100,
     *  FORM='FORMATTED')
      ELSEIF (LUNUSE.EQ.5 .OR. LUNUSE.EQ.10) THEN
C       SCRATCH.
        OPEN (UNIT=LUN, FILE=FNAME, STATUS='UNKNOWN', ERR=100)
      ELSEIF (LUNUSE.EQ.7) THEN
        OPEN (UNIT=LUN, FILE=FNAME, STATUS='OLD', ERR=100,
     *  FORM='UNFORMATTED')
      ELSEIF (LUNUSE.EQ.8) THEN
        OPEN (UNIT=LUN, FILE=FNAME, STATUS='OLD', ERR=100)
      ELSEIF (LUNUSE.EQ.9) THEN
C       RECL IS IN LONGWORDS.
C	UNDER SUNOS, THE -xl FLAG DETERMINES WHETHER SIZE IS BYTES OR
C	LONGWORDS. HENCE THE -xl FLAG MUST BE USED HERE.
        OPEN (UNIT=LUN, FILE=FNAME, STATUS='UNKNOWN', ERR=100,
     *  FORM='UNFORMATTED', ACCESS='DIRECT', RECL=LREC*4)
      ELSEIF (LUNUSE.EQ.11. OR. LUNUSE.EQ.12 .OR. LUNUSE.EQ.13 .OR.
     *        LUNUSE.EQ.14 .OR. LUNUSE.EQ.15) THEN
C       SCRATCH.
        OPEN (UNIT=LUN, FILE=FNAME, STATUS='UNKNOWN', ERR=100,
     *  FORM='UNFORMATTED', ACCESS='DIRECT', RECL=LREC*4)
      ENDIF

      RETURN

  100 IERR = 1

      RETURN
      END
C      INTEGER FUNCTION UPCASE(ICHR)                                         XSSS
C
C* REVISED 14/2/92
C* CONVERTS INTEGER "CHARACTER" TO UPPERCASE
C
C      IF (ICHR.GE.97.AND.ICHR.LE.122) THEN
C        UPCASE = ICHR - 32
C      ELSE
C        UPCASE = ICHR
C      ENDIF
C
C      RETURN
C      END
      SUBROUTINE WREC (IREC, LREC, LUN)                                     XSSS

C* REVISED 13/7/87.
C* WRITES A RECORD.

C  IREC RECEIVES THE RECORD, 1 SYMBOL PER ELEMENT.
C  LREC RECEIVES THE RECORD LENGTH.
C  LUN RECEIVES THE LOGICAL UNIT.

      COMMON /LUNXXX/ LUNE,LUNL,LUNO,LUNP,LUNS1,LUNBO,LUNBI,LUNI,LUNDA,
     * LUNS2,LUNS3,LUNS4,LUNS5,LUNS6,LUNS7
      COMMON /LUTXXX/ LUNTI,LUNTO
      COMMON /OUTXXX/ LFLAG

      DIMENSION IREC(LREC)
      CHARACTER*132 B

      L = MIN(LREC,132)
      DO 10 I = 1, L
        B(I:I) = CHAR(IREC(I))
   10 CONTINUE

      if (lun.eq.lunto .and. lflag .ne. 0) then
         write(0, 30) char(13)
         lflag = 0
      endif
      WRITE (LUN, 30) B(1:L)
 
   30 FORMAT (A)

      RETURN
      END
      SUBROUTINE WRECB (IREC, LREC, LUN)                                    XSSS

C* REVISED 23-OCT-95.
C* WRITES A BINARY RECORD.

C  IREC RECEIVES THE RECORD, 1 SYMBOL PER ELEMENT.
C  LREC RECEIVES THE RECORD LENGTH.
C  LUN RECEIVES THE LOGICAL UNIT.

      COMMON /BINXXX/ IENDRC,LENDRC,INSBLK
      COMMON /BLKXXX/ KBLANK
      COMMON /LUTXXX/ LUNTI,LUNTO
      COMMON /OUTXXX/ LFLAG

      DIMENSION IREC(LREC)
      !EXTERNAL FPUTC
C      CHARACTER*134 B
      PARAMETER (ICR=13, LF=10)

      L = MIN(LREC,132)
      IB = 0
 
      if (lun.eq.lunto .and. lflag .ne. 0) then
         call fputc(lun, char(icr))
         call fputc(lun, char(lf))
         lflag = 0
      endif

C     IF LAST BUFFER WAS NOT TERMINATED, INSERT BLANK BETWEEN OUTPUT BUFFERS
C     AND REMOVE LEADING BLANKS IN CURRENT BUFFER.
      IF (LENDRC.EQ.0)  THEN
        IF (INSBLK.EQ.1)  THEN
	  CALL FPUTC(LUN, CHAR(KBLANK))
C          IB = 1
C         B(IB:IB) = CHAR(KBLANK)
        ENDIF
        DO I = 1, L
          IF (IREC(I).NE.KBLANK)  GOTO 5
        ENDDO
      ELSE
        I = 1
      ENDIF
  
 5    if (iendrc.ne.0) then
         do k = l, i, -1
            if (irec(k).ne.kblank) goto 15
         enddo
 15      l = k
      endif

      DO 10 K = I, L
        CALL FPUTC(LUN, CHAR(IREC(K)))
c        IB = IB + 1
C       B(IB:IB) = CHAR(IREC(K))
   10 CONTINUE

      IF (IENDRC.NE.0)  THEN
C       REMOVE TRAILING BLANKS.
c        DO K = IB, 1, -1
c          IF (B(K:K).NE.' ')  GOTO 15
c        ENDDO
c   15   IB = K
C       INSERT RECORD TERMINATOR - {LF}.
c        IB = IB + 1
         call fputc(lun, char(icr))
        CALL FPUTC(LUN, CHAR(LF))
C       B(IB:IB) = CHAR(LF)
      ENDIF
 
C      WRITE (LUN) B(1:IB)

      LENDRC = IENDRC
 
      RETURN
      END
      SUBROUTINE WRECS (REC, LREC, LUN)                                     XSSS

C* REVISED 22-SEP-92.
C* WRITES A STRING RECORD.

C  IREC RECEIVES THE RECORD, 1 SYMBOL PER ELEMENT.
C  LREC RECEIVES THE RECORD LENGTH.
C  LUN RECEIVES THE LOGICAL UNIT.

      COMMON /LUTXXX/ LUNTI,LUNTO

      CHARACTER REC*(*)

      L = MIN(LREC,132)

      WRITE (LUN, 30) REC(1:L)
   30 FORMAT (A)

      RETURN
      END
