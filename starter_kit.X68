        org $1000


*-------------------------------------------------------
*Validation values to be used, modify as needed
*Add additional validation values as required
*-------------------------------------------------------
exit        EQU 0      used to exit assembly program

str  EQU $8900       strength
int  EQU $9000       intelect 
agil EQU $9100       agilaty
charm EQU $9200       charm
luck EQU $9300       for a saving roll 
credits EQU $9400     money
hp   EQU $9500      health
day EQU $9600        DAY                    
good EQU $9700       good person
BAD EQU $9800        bad person
oneDone EQU $9900     mission one check
twoDone EQU $10000     mission two check


*Start of Game
start:
    move.b  #100,$4000 put score/health in memory location $4000
    lea     $4000,A3   assign address A3 to that memory location
            

    move.b #0,str
    move.b #0,int
    move.b #0,agil
    move.b #0,charm
    move.b #0,luck
    move.l #0,credits
    move.b #100,hp
    move.b #0,day
    move.b #0,good
    move.b #0,bad
    move.b #0,oneDone
    move.b #0,twoDone




    bsr     welcome    branch to the welcome subroutine
    bsr     game       branch to the game subroutine
*Game loop
    org     $3000      the rest of the program is to be located from 3000 onwards

*-------------------------------------------------------
*-------------------Game Subroutine---------------------
*-------------------------------------------------------
game:
    bsr     gameloop   branch to gameloop subroutine
    rts                return from game: subroutine
          
end:
    simhalt

*-------------------------------------------------------
*-------------------Welcome Subroutine------------------
*-------------------------------------------------------
welcome:
    lea     welcome_msg,A1  assign message to address register A1
    bsr display
    bsr     firstChoice
    bsr     endl            branch to endl subroutine
    rts                     return from welcome: subroutine
    
    
*-------------------------------------------------------
*---------players first choice--------------------------
*------------------------------------------------------- 
firstChoice:
    
    bsr     endl            branch to endl subroutine
    
    lea intro_msg,A1  assign message to address register A1
    bsr display
    bsr input 
    
    cmp #1,D1 
    BEQ shipStart
    cmp #2,D1
    BEQ smokeStart
 
   
   
    
  



*-------------------------------------------------------
*---------------------THE SHIP ENTERENCE----------------
*------------------------------------------------------- 
shipStart:
    lea shipStart_msg,A1
    bsr display
    bsr input
    
    cmp #1,D1 
    BEQ shipDoor
    cmp #2,D1
    BEQ shipHull
    
    
*-------------------------------------------------------
*---------------------THE SHIP Door---------------------
*------------------------------------------------------- 
shipDoor:  
  bsr endl
  lea shipDoor_msg,A1
  bsr display
  add.b #1,str
  bsr shipRoom


*-------------------------------------------------------
*---------------------THE SHIP HULL---------------------
*------------------------------------------------------- 
shipHull: 
   bsr endl
  lea shipHull_msg,A1
  bsr display
  bsr input
  
  add.b #1,int 
 
  cmp #1,D1
  beq hullDoor 
  cmp #2,D1
  beq hullHole
 
*-------------------------------------------------------
*---------------------THE SHIP Dead---------------------
*------------------------------------------------------- 
hullDoor:
  bsr endl
  lea hullDoor_msg,A1
  bsr display
  bsr dead
  
*-------------------------------------------------------
*---------------------THE SHIP HOlE---------------------
*------------------------------------------------------- 
hullHole:
  bsr endl
  lea hullHole_msg,A1
  bsr display
  bsr shipRoom 
  
*-------------------------------------------------------
*---------------------THE SHIP ROOM---------------------
*------------------------------------------------------- 
shipRoom: 
  bsr endl
  lea shipRoom_msg,a1
  bsr display
  bsr input
  
  cmp #1,D1
  beq shipSleep
  cmp #2,d1
  beq leaveingShip
 
*-------------------------------------------------------
*---------------------THE SHIP SLEEP--------------------
*------------------------------------------------------- 
 shipSleep:
   bsr endl
   lea shipSleep_msg,A1
   bsr display
   add.b #1,charm
   add.b #1,luck 
   add.b #1,day
   add.b #50,credits
   bsr forestDay
   
*-------------------------------------------------------
*------------------LEAVEING THE SHIP--------------------
*-------------------------------------------------------    
leaveingShip:
   bsr endl
   lea leaveShip_msg,a1
   bsr display
   bsr decorate
   bsr input
   bsr nightDanger
*-------------------------------------------------------
*------------------- NIGHT DANGER-----------------------
*------------------------------------------------------- 
nightDanger 
   bsr endl
   lea nightDanger_msg,A1
   bsr display
   sub.b #10,hp
   add.b #2,day
   bsr decorate
   bsr forestDay
   
 
  
*-------------------------------------------------------
*----------------THE SMOKE START------------------------
*-------------------------------------------------------
smokeStart:
    bsr endl
    lea smokeStart_msg,A1
    bsr display
    add #100,credits
    bsr input
    cmp #1,D1
    beq searchCrashSite
    cmp #2,d1
    beq forestTrail
*-------------------------------------------------------
*------------SEARCH CRASHSITE---------------------------
*-------------------------------------------------------
searchCrashSite:
  bsr endl
  lea searchCrash_msg,a1
  add.b #50,credits
  add.b #10,hp
  bsr display 
  bsr decorate
  bsr forestTrail 

*-------------------------------------------------------
*------------------FOREST TRAIL-------------------------
*-------------------------------------------------------
forestTrail:
  bsr endl
  lea forestTrail_msg,A1
  bsr display
  bsr input
  cmp #1,d1
  beq forestCamp1
  cmp #2,d1
  beq forestSunset
  
*-------------------------------------------------------
*-----------------FOREST SUNSET-------------------------
*-------------------------------------------------------
forestSunset:
 bsr endl
 lea forestSunset_msg,A1
 bsr display
 bsr input
 cmp #1,D1
 beq forestCamp2
 cmp #2,D1
 beq nightDanger

*-------------------------------------------------------
*-----------------FOREST CAMP 1-------------------------
*-------------------------------------------------------
forestCamp1:
 bsr endl
 lea forestCamp1_msg,A1
 add.b #1,charm
 add.b #1,day
 bsr display
 bsr decorate
 bsr forestDay

*-------------------------------------------------------
*-----------------FOREST CAMP 2-------------------------
*-------------------------------------------------------
forestCamp2:
 bsr endl
 lea forestCamp2_msg,A1
 add.b #1,int
 add.b #1,day
 bsr display
 bsr decorate
 bsr forestDay
*-------------------------------------------------------
*------------------Forest IN THE DAY--------------------
*-------------------------------------------------------
forestDay:
 bsr endl
 lea forestDay_msg,A1
 bsr display
 bsr input
 cmp #1,D1
 beq lowRoad
 cmp #2,D1
 beq highRoad

*-------------------------------------------------------
*------------------HighRoad-----------------------------
*-------------------------------------------------------
highRoad:
    bsr endl
    lea highRoad_msg,A1
    bsr display 
    bsr input
    cmp #1,d1
    beq hRoadRun
    cmp #2,d1
    beq hRoadstr
    cmp #3,d1
    beq hRoadPay
    cmp #4,d1
    beq hRoadJump
       

*-------------------------------------------------------
*------------------High Road RUN------------------------
*-------------------------------------------------------
hRoadRun:
 bsr endl 
 lea hRoadRun_msg,A1
 bsr display
 sub.b #30,hp
 bsr outSideTown 
*-------------------------------------------------------
*------------------High Road JUMP------------------------
*-------------------------------------------------------
hRoadJump:
  move.b luck,d4
  cmp #1,d4
  bge hRoadJumpLuckPass
  blt hRoadJumpLuckFail
 
*-------------------------------------------------------
*------------------High Road jump luck PASS-------------
*-------------------------------------------------------
hRoadJumpLuckPass:
  bsr endl
  lea hRoadJumpLuckPass_msg,a1
  bsr display
  sub.b #1,luck
  add.b #1,day
  bsr path

*-------------------------------------------------------
*------------------High Road jump luck FAIL-------------
*-------------------------------------------------------
hRoadJumpLuckFail:
  bsr endl
  lea hRoadJumpLuckFail_msg,a1
  bsr display
  bsr dead



*-------------------------------------------------------
*------------------High Road  str-----------------------
*-------------------------------------------------------
hRoadstr:
 bsr endl
 move.b str,d4
 cmp #1,d4
 bge hRoadstrPass
 blt hRoadstrFail

*-------------------------------------------------------
*------------------High Road  str pass------------------
*-------------------------------------------------------
hRoadstrPass:
 bsr endl
 lea hRoadstrPass_msg,a1
 bsr display
 bsr outSideTown
 
*-------------------------------------------------------
*------------------High Road  str fail------------------
*-------------------------------------------------------
hRoadstrFail:
 bsr endl
 lea hRoadStrFail_msg,A1
 bsr display
 bsr dead

*-------------------------------------------------------
*------------------High Road  pay-----------------------
*-------------------------------------------------------
hRoadPay:
 bsr endl
 lea hRoadpay_msg,A1
 sub.b #50,credits
 bsr display
 bsr dead
 


*-------------------------------------------------------
*------------------LOW Road-----------------------------
*-------------------------------------------------------
lowRoad:
    bsr endl
    lea lowRoad_msg,A1
    bsr display 
    bsr path
    
*-------------------------------------------------------
*------------------PATH---------------------------------
*-------------------------------------------------------    
path:
   bsr endl
   lea path_msg,a1
   bsr display
   bsr input
   cmp #1,d1
   beq throughRidge
   cmp #2,d1
   beq aroundRidge
   
*-------------------------------------------------------
*------------------Through RIDGE------------------------
*-------------------------------------------------------
throughRidge:
  bsr endl
  lea throughRidge_msg,a1
  sub.b #20,hp
  add.b #1,agil
  bsr display
  bsr outSideTown
  
*-------------------------------------------------------
*------------------AROUND RIDGE-------------------------
*-------------------------------------------------------
aroundRidge:
  bsr endl
  lea aroundRidge_msg,a1
  bsr display
  bsr input 
  
  cmp #1,d1
  beq aRidgeStr
  cmp #2,d1
  beq aRidgeInt
  
*-------------------------------------------------------
*------------------A ROUND STR--------------------------
*-------------------------------------------------------
aRidgeStr:
  bsr endl
  move.b str,d4
  cmp #1,d4
  bge aRidgeStrPass
  blt aRidgeStrFail
  
*-------------------------------------------------------
*------------------A ROUND STR PASS---------------------
*-------------------------------------------------------
aRidgeStrPass:
  bsr endl
  lea aRidgeStrPass_msg,A1
  bsr display
  bsr outSideTown
  
*-------------------------------------------------------
*------------------A ROUND STR FAIL---------------------
*-------------------------------------------------------
aRidgeStrFail:
  bsr endl
  lea aRidgeStrFail_msg,A1
  sub.b #20,hp
  bsr display
  bsr outSideTown
*-------------------------------------------------------
*------------------A ROUND INT--------------------------
*-------------------------------------------------------
aRidgeInt:
  bsr endl
  move.b int,d4
  cmp #1,d4
  bgt aRidgeIntPass
  blt aRidgeIntFail
  
*-------------------------------------------------------
*------------------A ROUND INT PASS---------------------
*-------------------------------------------------------
aRidgeIntPass:
  bsr endl
  lea aRidgeIntPass_msg,A1
  bsr display
  bsr outSideTown
  
*-------------------------------------------------------
*------------------A ROUND INT FAIL---------------------
*-------------------------------------------------------
aRidgeIntFail:
  bsr endl
  lea aRidgeIntFail_msg,a1
  bsr display
  bsr dead
  
*-------------------------------------------------------
*------------------ OUTSIDE TOWN------------------------
*-------------------------------------------------------
outSideTown:
  bsr endl
  lea outSideTown_msg,a1
  bsr display
  bsr input
  cmp #1,d1
  beq townGate
  cmp #2,d1
  beq otSearch

*-------------------------------------------------------
*------------------ SEARCH OUTSIDE----------------------
*-------------------------------------------------------
otSearch:
 BSR endl
 lea otSearch_msg,a1
 add.b #50,credits
 bsr display 
 bsr townGate

*-------------------------------------------------------
*------------------ TOWN GATE---------------------------
*-------------------------------------------------------
townGate:
 bsr endl
 lea townGate_msg,a1
 bsr display
 bsr input
 cmp #1,d1
 beq gatePay
 cmp #2,d1
 beq gateLuck
 cmp #3,d1
 beq gateCharm
 cmp #4,d1
 beq gateNoWayIn

*-------------------------------------------------------
*------------------ LEAVE THE GATE----------------------
*-------------------------------------------------------
gateNoWayIn:
  bsr endl
  lea gateNoWayIn_msg,a1
  bsr display 
  bsr dead
  
*-------------------------------------------------------
*------------------ GATE LUCK---------------------------
*-------------------------------------------------------
gateLuck:
  move.b luck,d4
  cmp #1,d4
  bge gateLuckPass
  blt gateLuckFail
  
*-------------------------------------------------------
*------------------ GATE LUCK PASS----------------------
*-------------------------------------------------------
gateLuckPass:
  bsr endl
  lea gateLuckPass_msg,a1
  sub.b #1,luck
  bsr display
  bsr townInside
  
*-------------------------------------------------------
*------------------ GATE LUCK FAIL----------------------
*-------------------------------------------------------
gateLuckFail:
  bsr endl
  lea gateLuckFail_msg,a1
  bsr display
  bsr dead

*-------------------------------------------------------
*------------------ GATE CHARM--------------------------
*-------------------------------------------------------
gateCharm:
  move.b charm,d4
  cmp #1,d4
  bge gateCharmPass
  blt gateCharmFail
  
*-------------------------------------------------------
*------------------ GATE CHARM PASS---------------------
*-------------------------------------------------------
gateCharmPass:
  bsr endl
  lea gateCharmPass_msg,a1
  bsr display
  bsr townInside
  
*-------------------------------------------------------
*------------------ GATE CHARM FAIL---------------------
*-------------------------------------------------------
gateCharmFail:
  bsr endl
  lea gateCharmFail_msg,a1
  bsr display
  bsr townGate
  
*-------------------------------------------------------
*------------------ GATE  PAY---------------------------
*-------------------------------------------------------
gatePay:
  bsr endl
  move.b credits,d4
  cmp #50,d4
  bge gatePayPass
  blt gatePayFail

*-------------------------------------------------------
*------------------ GATE PAY FAIL-----------------------
*-------------------------------------------------------
gatePayFail:
  bsr endl
  lea gatePayFail_msg,a1
  bsr display
  bsr townGate
  
*-------------------------------------------------------
*------------------ GATE PASS---------------------------
*------------------------------------------------------- 
gatePayPass:
  bsr endl
  lea gatePayPass_msg,a1
  sub.b #50,credits
  bsr display
  bsr townInside

*-------------------------------------------------------
*------------------ INSIDE TOWN-------------------------
*-------------------------------------------------------
townInside:
  bsr endl
  lea townInside_msg,a1
  bsr display
  bsr centerOfTown
  
*-------------------------------------------------------
*------------------ CENTER OF TOWN----------------------
*-------------------------------------------------------
centerOfTown:
  bsr endl
  lea centerOfTown_msg,a1
  bsr display
  bsr input 
  cmp #1,d1 
  beq shop
  cmp #2,d1
  beq missionBoard
  
*-------------------------------------------------------
*------------------ SHOP--------------------------------
*-------------------------------------------------------
shop:
  bsr endl
  lea shop_msg,a1
  bsr display
  bsr input
  cmp #1,d1
  beq buyHp
  cmp #2,d1
  beq buyWayHome
  cmp #3,d1
  beq centerOfTown
  

*-------------------------------------------------------
*------------------ BUY HP------------------------------
*-------------------------------------------------------
buyHp:
 move.b credits,d4
 cmp #10,d4
 bge buyHpPass
 blt buyHpFail

*-------------------------------------------------------
*------------------ BUY HP PASS-------------------------
*-------------------------------------------------------
buyHpPass:
  bsr endl
  lea buyHpPass_msg,a1
  sub.b #10,credits
  add.b #20,hp
  bsr display
  bsr shop
  
*-------------------------------------------------------
*------------------ BUY HP FAIL-------------------------
*-------------------------------------------------------
buyHpFail:
 bsr endl
 lea buyHpFail_msg,a1
 bsr display
 bsr shop
 
*-------------------------------------------------------
*------------------ BUY FREE----------------------------
*-------------------------------------------------------
buyWayHome:
  move.l credits,d4
  cmp #800,d4
  bge buyWayHomePass
  blt buyWayHomeFail
  
*-------------------------------------------------------
*------------------ BUY FREE PASS-----------------------
*-------------------------------------------------------
buyWayHomePass
  bsr endl
  lea buyWayHomePass_msg,a1
  sub.l #800,credits
  bsr display
  bsr ending
  
*-------------------------------------------------------
*------------------ BUY FREE FAIL ----------------------
*-------------------------------------------------------
buyWayHomeFail:
 bsr endl
 lea buyWayHomeFail_msg,a1
 bsr display
 bsr shop
 
*-------------------------------------------------------
*------------------ ENDING------------------------------
*-------------------------------------------------------
ending:
  bsr endl
  lea endOfGame_msg,a1
  bsr display
  lea youWin_msg,a1
  bsr display
  bsr end

*-------------------------------------------------------
*------------------ MISSION BOARD-----------------------
*-------------------------------------------------------
missionBoard:
  bsr endl
  lea missionBoard_msg,a1
  bsr display
  bsr input
  cmp #1,d1
  beq missionOne
  cmp #2,d1
  beq missionTwo
  cmp #3,d1
  beq missionThree
  cmp #4,d1
  beq centerOfTown
*-------------------------------------------------------
*------------------ MISSION redo------------------------
*-------------------------------------------------------
missionRedo:
  bsr endl
  lea missionRedo_msg,a1
  bsr display
  bsr missionBoard

*-------------------------------------------------------
*------------------ MISSION 1---------------------------
*-------------------------------------------------------
missionOne:
 bsr endl
 move.b oneDone,d4
 cmp #1,d4
 beq missionRedo
 lea missionOne_msg,a1
 bsr display
 bsr input
 cmp #1,d1
 beq oneSneak
 cmp #2,d1
 beq oneBreak
 
*-------------------------------------------------------
*------------------ 1 SNEAK IN--------------------------
*-------------------------------------------------------
oneSneak:
  bsr endl
  lea OneSneak_msg,a1
  add.b #50,credits
  add.b #1,good
  bsr display
  bsr oneStairs

*-------------------------------------------------------
*------------------ 1 BREAK IN--------------------------
*-------------------------------------------------------
oneBreak:
  bsr endl
  lea oneBreak_msg,a1
  add.b #1,bad
  bsr display
  bsr oneStairs
 
*-------------------------------------------------------
*------------------ 1 STAIRS----------------------------
*-------------------------------------------------------
oneStairs
  bsr endl
  lea oneStairs_msg,a1
  bsr display
  bsr input
  cmp #1,d1
  beq oneRush
  cmp #2,d1
  beq oneSurprise

*-------------------------------------------------------
*------------------ 1 RUSH------------------------------
*-------------------------------------------------------
oneRush
  bsr endl
  lea oneRush_msg,a1
  add.b #1,bad
  bsr display
  bsr oneEnd
  
*-------------------------------------------------------
*------------------ 1 SURPRISE--------------------------
*-------------------------------------------------------
oneSurprise:
  bsr endl
  lea oneSurprise_msg,a1
  add.b #1,good
  bsr display
  bsr oneEnd
  
*-------------------------------------------------------
*------------------ 1 end------------------------------
*------------------------------------------------------- 
oneEnd
  bsr endl
  lea missionOneDone_msg,a1
  add.l #500,credits
  add.b #1,day
  add.b #1,oneDone
  bsr display
  bsr centerOfTown
*-------------------------------------------------------
*------------------ MISSION 2---------------------------
*-------------------------------------------------------
missionTwo:
 bsr endl
 move.b twoDone,d4
 cmp #1,d4
 beq missionRedo
 
 lea missionTwo_msg,a1
 bsr display
 bsr input 
 cmp #1,d1
 beq tunnelOne
 cmp #2,d1
 beq tunnelTwo
 cmp #3,d1
 beq tunnelThree

*-------------------------------------------------------
*------------------ 2 tunnel 1--------------------------
*------------------------------------------------------- 
tunnelOne:
  bsr endl
  lea tunnelOne_msg,a1
  sub.b #20,hp
  bsr display
  bsr TwoOpening
 

*-------------------------------------------------------
*------------------ 2 tunnel 2--------------------------
*-------------------------------------------------------
tunnelTwo:
  bsr endl
  lea tunnelTwo_msg,a1
  add.b #50,credits
  bsr display 
  bsr TwoOpening
  

*-------------------------------------------------------
*------------------ 2 tunnel 3--------------------------
*-------------------------------------------------------
tunnelThree:
  move.b luck,d4
  cmp #1,d4
  bgt tthreeLuckPass
  blt tthreeLuckFail

*-------------------------------------------------------
*------------------ 2 tunnel 3 luck pass----------------
*-------------------------------------------------------
tthreeLuckPass:
  bsr endl
  lea tthreeLuckPass_msg,a1
  add.l #200,credits
  bsr display
  bsr twoOpening

*-------------------------------------------------------
*------------------ 2 tunnel 3 luck fail----------------
*-------------------------------------------------------
tthreeLuckFail:
  bsr endl
  lea tthreeLuckFail_msg,a1
  bsr display
  bsr dead

*-------------------------------------------------------
*------------------ 2 opening---------------------------
*------------------------------------------------------- 
TwoOpening
  bsr endl
  lea twoOpening_msg,a1
  bsr display
  bsr input
  cmp #1,d1
  beq twoStay
  cmp #2,d1
  beq twoLeave

*-------------------------------------------------------
*------------------ 2 Stay------------------------------
*------------------------------------------------------- 
twoStay:
  bsr endl
  lea twoStay_msg,a1
  add.b #50,credits
  add.b #1,good
  bsr display
  bsr missionTwoDone

*-------------------------------------------------------
*------------------ 2 Go--------------------------------
*------------------------------------------------------- 
twoLeave:
 bsr endl
 lea twoLeave_msg,a1
 add.b #1,bad
 sub.b #10,hp
 bsr display
 bsr missionTwoDone

*-------------------------------------------------------
*------------------ 2 Done------------------------------
*------------------------------------------------------- 
missionTwoDone:
  bsr endl
  lea missionTwoDone_msg,a1
  add.l #200,credits
  add.b #1,day
  add.b #1,twoDone
  bsr display
  bsr missionBoard
  
*-------------------------------------------------------
*------------------ MISSION 3---------------------------
*-------------------------------------------------------
missionThree:
 bsr endl
 lea missionThree_msg,a1
 bsr display
 bsr input 
 cmp #1,d1
 beq workHard
 cmp #2,d1
 beq slackOff

*-------------------------------------------------------
*------------------ 3 hard work-------------------------
*-------------------------------------------------------
workHard:
  bsr endl
  lea workHard_msg,a1
  add.b #1,good
  bsr display
  bsr missionThreeDone
  
*-------------------------------------------------------
*------------------ 3 slack off-------------------------
*-------------------------------------------------------
slackOff:
  bsr endl
  lea slackOff_msg,a1
  add.b #1,bad
  bsr display
  bsr missionThreeDone
  
*-------------------------------------------------------
*------------------ 3 done------------------------------
*------------------------------------------------------- 
missionThreeDone:
  bsr endl
  lea missionThreeDone_msg,a1
  add.l #100,credits
  add.b #1,day
  sub.b #10,hp
  bsr display
  bsr centerOfTown
*-------------------------------------------------------
*---------Gameplay Input Values Subroutine--------------
*-------------------------------------------------------    
input:
 bsr decorate
  lea aSpace_msg,a1
  bsr display
 
    move.b  #4,D0
    trap    #15
 bsr decorate
    rts

*-------------------------------------------------------
*----------------Gameloop (main loop)-------------------
*------------------------------------------------------- 
gameloop:
   

    bsr     clear_screen    clears the screen
    rts                     return from gameloop: subroutine


*-------------------------------------------------------
*-----------------display text--------------------------
*-------------------------------------------------------   
display:

  move.b #14,D0
  trap   #15

   rts
*-------------------------------------------------------
*--------------------------Loop-------------------------
*-------------------------------------------------------
loop:
    move.b  #5, D3 loop counter D3=5
next:

	sub     #1,D3   decrement loop counter
    bne     next    repeat until D0=0

*-------------------------------------------------------
*------------------Screen Decoration--------------------
*-------------------------------------------------------
decorate:
    move.b  #60, D3

 
out:
    
	sub     #1,D3   decrement loop counter
    bne     out	    repeat until D0=0
   
    rts
    
clear_screen: 

    move.b  #11,D0      clear screen
    move.w  #$ff00,D1
    trap    #15
    rts
hpCheck:

 move.b hp,d3
 cmp #0,d3
 ble zeroHp
 clr.l d3
 rts

zeroHp:
  lea aSpace_msg,a1
  bsr display
 lea zeroHp_msg,a1
 bsr display
   lea aSpace_msg,a1
  bsr display
 bsr dead

stats:
   lea aSpace_msg,a1
  bsr display
   lea days_msg,a1
   move.b day,d0
   move.b #3,d0
   trap #15
   bsr display
  move.b bad,d4
  move.b good,d5
  cmp d4,d5
  beq neutral
  bgt goodperson
  blt badperson
  
neutral:
 lea neutral_msg,a1
 bsr display
 rts
badperson:
 lea badperson_msg,a1
 bsr display
 rts
goodPerson:
 lea goodPerson_msg,a1
 bsr display
 rts
 
 
 
*-------------------------------------------------------
*------------------------Replay-------------------------
*-------------------------------------------------------

endl:
    bsr hpCheck
    movem.l D0/A1,-(A7)
    move    #14,D0
    lea     crlf,A1
    trap    #15
    movem.l (A7)+,D0/A1
   
    rts
dead:
  
  bsr decorate
    lea aSpace_msg,a1
  bsr display
  lea  gameover_msg,A1
  bsr display
    lea aSpace_msg,a1
  bsr display
  bsr stats
  bsr input 
  cmp #1,d1 
  beq start 
  cmp #2,d1
  beq end
    
*-------------------------------------------------------
*-------------------Data Delarations--------------------
*-------------------------------------------------------

crlf:           dc.b    $0D,$0A,0
aSpace_msg      dc.b    $0D,$0A,0

welcome_msg:    dc.b    '************************************************************'
                dc.b    $0D,$0A
                dc.b '  _______ ______  ______ ______   _______ _______ _______ _______ _______ ______   ',$0D,$0A
                dc.b '(_______(______)/ _____/ _____) (_______(_______(_______(_______(_______(______)  ',$0D,$0A
                dc.b ' _  _  _ ______( (____( (____    _____   _____   _____   _____   _         _      ',$0D,$0A
                dc.b '| ||_|| |  __  |\____ \\____ \  |  ___) |  ___) |  ___) |  ___) | |       | | ',$0D,$0A
                dc.b '| |   | | |  | |_____) _____) ) | |_____| |     | |     | |_____| |_____  | |  ',$0D,$0A
                dc.b '|_|   |_|_|  |_(______(______/  |_______|_|     |_|     |_______)\______) |_| ',$0D,$0A
                dc.b '   _                 _               | |                   _                       ',$0D,$0A
                dc.b ' _| |_ _____ _   _ _| |_    _____  __| |_   _ _____ ____ _| |_ _   _  ____ _____   ',$0D,$0A 
                dc.b '(_   _| ___ ( \ / (_   _)  (____ |/ _  | | | | ___ |  _ (_   _| | | |/ ___| ___ |  ',$0D,$0A
                dc.b '  | |_| ____|) X (  | |_   / ___ ( (_| |\ V /| ____| | | || |_| |_| | |   | ____| ',$0D,$0A    
                dc.b '   \__|_____(_/ \_)  \__)  \_____|\____| \_/ |_____|_| |_| \__|____/|_|   |_____)',$0D,$0A
                dc.b    $0D,$0A
                dc.b    '************************************************************'
                dc.b    $0D,$0A,0
                
intro_msg       dc.b    ' As you wake up you see nothing  but darkness then you soon realise that your',$0D,$0A
                dc.b    ' eyes are closed.Coming to your senses you force your eyes open and look around.',$0D,$0A
                dc.b    ' On the ground beside you is a name tag half burnt by flamess you can make out  ',$0D,$0A
                dc.b    ' the name Tex .Trying to figure out where you are your mind is blank you cant ',$0D,$0A
                dc.b    ' remember anything not even your name you decide the only choice is to steal ',$0D,$0A
                dc.b    ' this persons name.Lets hope they dont mind,looking around all you see is dieing',$0D,$0A
                dc.b    ' flames and a crashed ship to your right as you look closer you notice a hole ',$0D,$0A
                dc.b    ' in its side the flames around the ship seem to have died down enough to try ',$0D,$0A
                dc.b    ' go into it you also notice a smoke trail in the distance which might lead to',$0D,$0A
                dc.b    ' people or something else alive.The sun begins to set you must make a choice.',$0D,$0A
                dc.b    $0D,$0A
                dc.b    ' The ship(1) or the smoke trail(2)',$0D,$0A,0
      
shipStart_msg   dc.b    ' you find yourself  drawn to the shelter of the ship in the dieing light. ',$0D,$0A
                dc.b    ' You approach the ship with caution.You see two paths you can try force  ',$0D,$0A
                dc.b    ' your way through the door or you can try climb up the ship and enter ',$0D,$0A
                dc.b    ' through the ripped hull.' ,$0D,$0A
                dc.b     $0D,$0A
                dc.b    ' Through the door(1) or through the hull(2)',$0D,$0A,0
                
shipDoor_msg    dc.b    ' You decide that the best course of action is to try the door ',$0D,$0A
                dc.b    ' you smash and run at the door with all your force in an attempt to ',$0D,$0A
                dc.b    ' open it you succeed in hurting yourself and not opening the door.   ',$0D,$0A
                dc.b    ' Regreting the choice that brought you to this point in your life you  ',$0D,$0A
                dc.b    ' punch the side of the door hiting the open button(str + 1) .. the door opens.',$0D,$0A,0
               
                
                
shipHull_msg    dc.b    ' You decide that climbing the ship would be easyier than forceing the ',$0D,$0A
                dc.b    ' door open you look around for something to help you climb the ship with. ',$0D,$0A
                dc.b    ' You grab a stick and try to poll vault up.The stick snaps under ',$0D,$0A
                dc.b    ' your weight but it does give you a idea to use the sharp sticks ',$0D,$0A
                dc.b    ' to climb with.(int + 1) After an hour you reach the enternce ',$0D,$0A
                dc.b    ' there are wires hanging down from the celing you see a door way ',$0D,$0A
                dc.b    ' behind the wires and a hole down to a room. ',$0D,$0A
                dc.b     $0D,$0A
                dc.b    ' Through the door(1) or through the hole(2)',$0D,$0A,0
                                                  
hullDoor_msg    dc.b    ' The wonders of whats behind door number one makes you jump at the ',$0D,$0A
                dc.b    ' idea of opening it.You take one step forward, Realising ',$0D,$0A
                dc.b    ' your tiredness and that you were most likely just in a crash you  ',$0D,$0A
                dc.b    ' stumble and fall towards the door the wires hanging down wrap',$0D,$0A
                dc.b    ' around your neck and arm.In you struggle to break free you fall down ',$0D,$0A
                dc.b    ' the hole your weight causing  you arm to break and neck to snap ',$0D,$0A
                dc.b    ' and you die without much pain maybe running around in the dark after',$0D,$0A
                dc.b    ' a crash wasnt the best idea. ',$0D,$0A,0
                
hullHole_msg    dc.b    ' As you think about the option you feel that going down is the best course',$0D,$0A                
                dc.b    ' of action.Grabing hold of the side of the hole you lower yourself down into',$0D,$0A 
                dc.b    ' a room.',$0D,$0A,0
                
shipRoom_msg    dc.b    ' The room you just entered is destroyed there are wires hanging from the ',$0D,$0A
                dc.b    ' celing the walls are smashed in it looks like a horde of angry  birds have',$0D,$0A
                dc.b    ' flown at the windows leaving tiny cracks and holes in them.As you look through',$0D,$0A 
                dc.b    ' this broken windows the sun begins to set you can either stay here for the ',$0D,$0A 
                dc.b    ' night or you can go on your way. ',$0D,$0A 
                dc.b    $0D,$0A
                dc.b    ' Will you stay(1) or will you go(2)  ',$0D,$0A,0
                                 
shipSleep_msg   dc.b    ' Its getting way to late for you to travel safely through whatever is out ',$0D,$0A
                dc.b    ' there so you decide that the best course of action is to bunker down ',$0D,$0A
                dc.b    ' and sleep for the night and get some well deserved rest after all you ',$0D,$0A
                dc.b    ' been through alot (day +1).',$0D,$0A
                dc.b    $0D,$0A
                dc.b    ' You wake up in the morning feeling refreshed its odd how you got a ',$0D,$0A
                dc.b    ' good sleep on a metal floor but lets not think about that.You look in',$0D,$0A
                dc.b    ' the broken window and to your surprise you look ok (charm +1 ).You noticed',$0D,$0A
                dc.b    ' as you look around the room in the day 50 credits(+50 credits).',$0D,$0A
                dc.b    $0D,$0A
                dc.b    ' Deciding you should go on your way you gather you money and force the ',$0D,$0A
                dc.b    ' door open, You step into the light and take the first step on your journey ',$0D,$0A
                dc.b    ' to find out where you are and what is going on. You head towards the forest ',$0D,$0A
                dc.b    ' which is now light up by the sun you avoid a cave which you could have walked',$0D,$0A
                dc.b    ' into if it was darker. ',$0D,$0A,0

leaveShip_msg   dc.b    ' Decideing that you wasted enough time you force you way out of the ',$0D,$0A
                dc.b    ' ship.You press on into the darkness heading towards where you last remember ',$0D,$0A
                dc.b    ' the smoke trail being.',$0D,$0A,0
                
nightDanger_msg dc.b    ' You walk for what feels like forever you finaly hit what seems ',$0D,$0A
                dc.b    ' like a tree you stumble throught the trees in the darkness bumping into trees',$0D,$0A
                dc.b    ' and what seems like rocks but why knows its really dark.As you walk into the ',$0D,$0A
                dc.b    ' unknown you walk into a cave and walk straight into a wall knocking yourself ',$0D,$0A
                dc.b    ' out who knew walking around in the dark wasnt a good idea (-10hp) you wake up',$0D,$0A
                dc.b    ' in the day and press on(+1 day).',$0D,$0A,0
                
forestCamp1_msg dc.b    ' Thinking about your options setting up camp and takeing a well deserved',$0D,$0A
                dc.b    ' rest is you best idea you set up a crude shelter that will protect you ',$0D,$0A
                dc.b    ' the elements except fire which would burn down your wood and leaf tent',$0D,$0A
                dc.b    ' takeing this into account you fall asleep anyways.',$0D,$0A
                dc.b     $0D,$0A
                dc.b    ' You wake up in the morning with a inteact tent and body and find yourself ',$0D,$0A
                dc.b    ' refreshed and well rested you know what they say if you feel good you look ',$0D,$0A
                dc.b    ' good(charm + 1) you contine you on your way towards te smoke trail.',$0D,$0A,0
                

smokeStart_msg  dc.b    ' Wanting to find out where you are  you decide to head towards the smoke trail.',$0D,$0A
                dc.b    ' You take a quick look around the crash site (+100 credits) you then venture  ',$0D,$0A
                dc.b    ' forth towards the forest as you walk you notice a large opening with some parts',$0D,$0A
                dc.b    ' of the ship and some broken containers',$0D,$0A
                dc.b     $0D,$0A
                dc.b    ' Do you want to search the crash site(1) or do you want to continue on (2)',$0D,$0A,0
                
searchCrash_msg dc.b    ' You decide that you need supplies and the crash site might be the best place to.',$0D,$0A
                dc.b    ' look.You look around the crash site serching boxes and in wrecked parts of the ',$0D,$0A 
                dc.b    ' ship under a pile of what can best be describe as old clothes and turf you',$0D,$0A            
                dc.b    ' find 50 credits (credits + 50) in a container you find a hello kitty plaster  ',$0D,$0A 
                dc.b    ' whats that doing here(+10 hp) after finding your loot you continue on your way.',$0D,$0A,0

forestTrail_msg dc.b    ' You walk into a large clearing ahead of you is a trail that leads towards  ',$0D,$0A                 
                dc.b    ' the smoke, As you begin to walk towards the trail you realise how tired ',$0D,$0A
                dc.b    ' you and how sore your body is ,you could set up camp while its still light or ',$0D,$0A
                dc.b    ' you could press on towards the smoke trail.',$0D,$0A
                dc.b     $0D,$0A
                dc.b    ' Will you camp(1) or press on(2)',$0D,$0A,0
                
forestSunset_msg dc.b   ' You press on towards the smoke trail through the forest.Trees surround you ',$0D,$0A               
                 dc.b   ' blocking the sky but the trail leads on.The sun begins to set on your adventure',$0D,$0A
                 dc.b   ' thinking about the dangers of walking around at night you think about your ',$0D,$0A
                 dc.b   ' options you could set up a camp now and avoid possible danger or you could ',$0D,$0A
                 dc.b   ' press on towards the trail.',$0D,$0A 
                 dc.b   $0D,$0A
                 dc.b   'Do you want to call it quits for the day(1) or trudge on(2)',$0D,$0A,0
              
forestCamp2_msg dc.b    ' Staying up in the darkness is not the best idea especially without your ',$0D,$0A             
                dc.b    ' night light so you decide to set up a crude camp site for the night(int+1)You',$0D,$0A 
                dc.b    ' wake up on the trail and press on towards the smoke. ',$0D,$0A,0
                
forestDay_msg   dc.b    ' As you walk in the blistering sun the trees protecting you some what',$0D,$0A
                dc.b    ' you come to a fork in the road one heading upwards and one heading ',$0D,$0A
                dc.b    ' straight on.Do you decide that the path straight is the best or will you',$0D,$0A
                dc.b    ' take the high road',$0D,$0A
                dc.b     $0D,$0A                
                dc.b    ' Will you take the road less traveled(1) or the high road(2)',$0D,$0A,0
                
highRoad_msg    dc.b    ' Heading up the path your legs begin to strengthen and you fell better',$0D,$0A
                dc.b    ' about all this walking.As you reach the top of the hill you come across',$0D,$0A
                dc.b    ' a verren it snarls at you takeing a fighting stance what will you do. ',$0D,$0A
                dc.b    $0D,$0A
                dc.b    ' You could run(1) or maybe fight it head on(2) you could try barter(3)',$0D,$0A
                dc.b    ' or maybe take a risk and try jump to the lower path(4) ',$0D,$0A,0
                
                

hRoadRun_msg    dc.b    ' Looking at the beast you rather not start a fight with it you turn around',$0D,$0A               
                dc.b    ' to flee in your scramble for safety you trip over a well placed tree root ',$0D,$0A              
                dc.b    ' what are the chances of that.As you lay there the verren clamps down ',$0D,$0A 
                dc.b    ' on your leg.You trying to play dead the verren throws you about however untill ',$0D,$0A 
                dc.b    ' you kick it in the face.As the verren is blinded by your attack you flee.',$0D,$0A
                dc.b    ' Your arm is cut (-30 hp) and you continue on you way',$0D,$0A,0
                 

hRoadJumpLuckPass_msg dc.b  ' Not wanting to fight the beast you take a leap of faith to the lower path.',$0D,$0A
                      dc.b  ' With all your might you leap off the edge as you fall you hit tree branches ',$0D,$0A
                      dc.b  ' and vines.The shere luck of jumping where you did slows your decent ',$0D,$0A
                      dc.b  ' but not enough.Even tho you were so lucky you hit a squirrel on the way  ',$0D,$0A
                      dc.b  ' down this annoyed squirrel followes you for a day makeing it harder to ',$0D,$0A
                      dc.b  ' find the right path (+1 day )you eventually find your way back and lose ',$0D,$0A
                      dc.b  ' the furry fiend. ',$0D,$0A,0
                      
hRoadJumpLuckFail_msg dc.b  ' Not wanting to fight the beast you take a leap down  ',$0D,$0A
                      dc.b  ' towards the lower path hitting every branch on the way down.You knock  ',$0D,$0A
                      dc.b  ' youself out you wake in a daze and wonder into the same verren from before',$0D,$0A
                      dc.b  ' there is no escaping this time tho.',$0D,$0A,0
hRoadStrPass_msg dc.b   ' You charge the beast hitting it square in the nose it looks at you confused',$0D,$0A
                dc.b    ' and slightly conserned at the fact you just punched a animal in the face but',$0D,$0A
                dc.b    ' but who knows.The verren pulls it self together and realiseing it cant fight',$0D,$0A
                dc.b    ' a person who doesnt care about danger it runs away.',$0D,$0A,0
                
hRoadStrFail_msg dc.b   ' You charge the beast hitting it square in the face ,Your fist just bounces',$0D,$0A            
                dc.b    ' off of the verrens thick skull.The verren turns to you and goes straight for ',$0D,$0A
                dc.b    ' your face tearing it apart you slowly die.I guess he won this face off',$0D,$0A,0
                
hRoadPay_msg    dc.b    ' Trying to barter with the animal you throw fifty credits at it the verren looks ',$0D,$0A
                dc.b    ' confused to say the least.It looks at the credits then back to you one final',$0D,$0A
                dc.b    ' time before picking you.It charges at you and goes straight for your chest ',$0D,$0A
                dc.b    ' knocking you to the ground the verren proceeds with biteing you and tearing ',$0D,$0A
                dc.b    ' your limbs apart .Why did you think a animal cared about the value of credits',$0D,$0A,0     
                
lowRoad_msg     dc.b    ' Takeing the road less traveled you start to wonder where this adventure might ',$0D,$0A               
                dc.b    ' take you as you say this you bump your foot off a rock (-10hp) well thats ',$0D,$0A 
                dc.b    ' unlucky.',$0D,$0A,0


path_msg        dc.b    ' You come aross a path.The path splits in two one through a ridge and one ',$0D,$0A
                dc.b    ' around.The path through the ridge looks safe enough but do you want to ',$0D,$0A
                dc.b    ' risk it or do you you want to take the safer route around the ridge.',$0D,$0A
                dc.b    $0D,$0A
                dc.b    ' Through the ridge(1)or around the ridge(2)',$0D,$0A,0

throughRidge_msg dc.b   ' Decideing to go through the ridge you start to walk.Half way through  ',$0D,$0A
                 dc.b   ' the you hear a rumble looking up you notice a shifty looking ',$0D,$0A
                 dc.b   ' verren knocking into boulders on top of the ridge ,thinking about how ',$0D,$0A
                 dc.b   ' road runner acted in these situations you start to sprint(agil +1) ',$0D,$0A
                 dc.b   ' As you reach the end of the ridge one of the bolders hits your arm  ',$0D,$0A
                 dc.b   ' scrtching it badly (-20hp)You escape the ridge and press on towards the smoke ',$0D,$0A
                 dc.b   ' which leads you to a town.',$0D,$0A,0

aroundRidge_msg dc.b    ' Not wanting to take any risks you head around the ridge.You walk for an hour  ',$0D,$0A
                dc.b    ' before comeing to a narrow path blocked by boulders.You could try push',$0D,$0A
                dc.b    ' the boulders or maybe you could try remove the boulders. ',$0D,$0A
                dc.b    $0D,$0A
                dc.b    ' Push the boulder(1) or remove the boulders(2)',$0D,$0A,0
            
aRidgeStrPass_msg dc.b  ' Chooseing to push the boulder you run at the rock giveing one huge push. ',$0D,$0A
                dc.b    ' Disloging the bottom bolder all of the other bolders fall to the ground giveing',$0D,$0A
                dc.b    ' you a easy path to go through.You follow the path untill you reach a town. ',$0D,$0A,0
                
aRidgeStrFail_msg dc.b  ' Chooseing to push the boulders you ran at them and with one big push... you ',$0D,$0A
                  dc.b  ' fail to move the boulder.You keep running at the boulders untill they ',$0D,$0A
                  dc.b  ' finally budge the boulders all fall away leaving you with a clear path to' ,$0D,$0A
                  dc.b  ' cross. you look at your shoulder and it is torn to shreads(-20 hp)',$0D,$0A
                  dc.b  ' This cleared path leads you to a town.',$0D,$0A,0


aRidgeIntPass_msg dc.b  ' Thinking about the problem you try to remove one of the stones in hopes',$0D,$0A
                  dc.b  ' of causeing the other boulders to fall.After thinking about it you remove a ',$0D,$0A
                  dc.b  ' a single stone and the entire pile falls down clearing the path which leads',$0D,$0A
                  dc.b  ' you to a town.',$0D,$0A,0
                  
aRidgeIntFail_msg  dc.b ' Thinking about the problem you try to remove one of the stones in hopes',$0D,$0A
                   dc.b ' of causeing the other boulders to fall.After thinking about it you remove a ',$0D,$0A
                   dc.b ' single stone all the boulders fall to the ground one hits you square in the head',$0D,$0A
                   dc.b ' knocking you out,other boulders fall around you incaseing you.At least you dont',$0D,$0A
                   dc.b ' need to be buried now. ',$0D,$0A,0


outSideTown_msg   dc.b  ' Standing just outside the town you see a gate ahead.You can either go to the ',$0D,$0A
                  dc.b  ' gate or search the surrounding area.',$0D,$0A 
                  dc.b  $0D,$0A
                  dc.b  ' Go to the gate(1) or search the area(2)',$0D,$0A,0                                                



otSearch_msg     dc.b   ' Decideing to search the outside of the town you walk around.You find an ',$0D,$0A
                 dc.b   ' abandoned house in this big blue house you find a talking bear.How strange ',$0D,$0A
                 dc.b   ' it gives you 50 credits (+50 credits) and you continue on your way to the',$0D,$0A
                 dc.b   ' town gate.',$0D,$0A,0
                 
townGate_msg     dc.b   ' Standing at the town gate you see a guard who doesnt look to nice you could',$0D,$0A
                 dc.b    $0D,$0A
                 dc.b   ' Try and and pay the guard to let you in(1) or try your luck at sneaking in(2)',$0D,$0A
                 dc.b   ' or maybe you could talk your way in(3)orleave and live a life in the woods(4)',$0D,$0A,0
                 

gatePayPass_msg  dc.b   ' You walk up to the guard and start tot talk to him he refuses you entry untill',$0D,$0A
                 dc.b   ' you bring up a few credits(-50 credits) obviously the guards here dont get paid much',$0D,$0A
                 dc.b   ' get paid much',$0D,$0A,0
                 
gatePayFail_msg  dc.b   ' You walk up to the guard and chat for a bit he refuses you entry untill you ',$0D,$0A
                 dc.b   ' try to bribe him with no credits,He laughs at you before you walk away.',$0D,$0A,0

gateNoWayIn_msg  dc.b   ' Decideing that there is no way your getting into the town you build a small ',$0D,$0A
                 dc.b   ' hut in the wood.Over time this hut becomes your home you grow older here',$0D,$0A
                 dc.b   ' starting a farm and befrending a squirrel and a verren.You come to the end',$0D,$0A
                 dc.b   ' of your days and die happily with your animal friends.',$0D,$0A,0

gateLuckFail_msg dc.b   ' Trying your luck you try jump the fence but instead you run right into it ',$0D,$0A
                 dc.b   ' You would have been ok but the fence was electric well you got quite a shock.',$0D,$0A,0
                 
gateLuckPass_msg dc.b   ' Trying you luck you wait for the guard to turn around sneaking in behind him ',$0D,$0A
                 dc.b   ' you make it inside.',$0D,$0A,0

gateCharmPass_msg dc.b  ' You walk up to the guard with a air of confidence it shows because the guard',$0D,$0A
                  dc.b  ' just lets you right in, i guess haveing confidence in yourself does pay off.',$0D,$0A,0
                  
gateCharmFail_msg dc.b  ' You Walk up to the guard with a air of confidence sadily the guard just ',$0D,$0A
                  dc.b  ' looks at you and turns you away.',$0D,$0A,0

townInside_msg   dc.b   ' Inside the town you see shops and people walking about ',$0D,$0A
                 dc.b   ' you hear a rumor about buying passage out of this world.',$0D,$0A,0
                 
                 dc.b   ' You can go to the shop(1) or to the Mission Board(2)',$0D,$0A,0


centerOfTown_msg dc.b   ' The center of town is large and crowded with people',$0D,$0A
                 dc.b   $0D,$0A
                 dc.b   ' You can go to the shop(1) or to the Mission Board(2)',$0D,$0A,0

shop_msg         dc.b   ' You enter the shop and look at the shop keeper ',$0D,$0A
                 dc.b   ' He tells you he sells MediGells(10 credits = 10hp) ',$0D,$0A
                 dc.b   ' he also tells you he sells passage off this place for 800 credits',$0D,$0A
                 dc.b   $0D,$0A
                 dc.b   ' Buy Hp(1) or Passage off this place(2) or leave(3)',$0D,$0A,0

buyHpFail_msg    dc.b   ' You try to buy MediGell but you dont have enough money.',$0D,$0A,0
buyHpPass_msg    dc.b   ' You buy a MediGell.',$0D,$0A,0


buyWayHomeFail_msg dc.b ' You try to buy your way out but you dont have enough credits',$0D,$0A,0
buyWayHomePass_msg dc.b ' You walk up to the shop keeper and give him 800 credits he',$0D,$0A
                   dc.b ' he shows you out back where there is a space ship waiting with 10 other people ',$0D,$0A
                   dc.b ' you enter the ship and in no time you are on the citadel. ',$0D,$0A,0
                   

endOfGame_msg    dc.b   ' The citadel guards track down the ship and tells you how it was shot down ',$0D,$0A
                 dc.b   ' by enemy geth in the area you are lucky to be alive however they cant tell you',$0D,$0A
                 dc.b   ' who you were .I guess you will just have to go on another adventure.',$0D,$0A,0
                   
youWin_msg      dc.b    '01111001 01101111 01110101  01110111 01101001 01101110  ',$0D,$0A,0

missionBoard_msg dc.b   ' You walk up to the mission board to check whats ther is.There is one mission to',$0D,$0A
                 dc.b   ' clear out some bandits from a farm nearby. The second mission is to go find ',$0D,$0A
                 dc.b   ' a missing space hamster the third mission is two work for a day at a  ',$0D,$0A
                 dc.b    $0D,$0A
                 dc.b   'Mission 1(1) Mission 2(2) Mission 3(3) or leave(4)',$0D,$0A,0

missionOne_msg   dc.b   ' You decide to clear out the bandits from the near by farm. you head to the farm ',$0D,$0A
                 dc.b   ' on the outskirts of town.You can enter the farm two ways by sneaking in or ',$0D,$0A
                 dc.b   ' breaking down the door.',$0D,$0A
                 dc.b   $0D,$0A
                 dc.b   ' Sneak in (1) or break the door (2)',$0D,$0A,0

oneSneak_msg     dc.b   ' Sneaking in through the back you see a bandit.You hit him in the head knocking',$0D,$0A    
                 dc.b   ' him out you search his body(+50 credits). ',$0D,$0A,0
                 
oneBreak_msg     dc.b   ' Breaking down the door you take out the bandit behind it but destory the door',$0D,$0A               
                 dc.b   ' in the process and hurting yourself(-20hp)',$0D,$0A,0

oneStairs_msg    dc.b   ' You come to a set of stairs you notice a bandit on top of the stairs you can ',$0D,$0A 
                 dc.b   ' either rush the bandit or take him by surprise. ',$0D,$0A
                 dc.b   $0D,$0A
                 dc.b   ' Rush(1) or take him by surprise(2) ',$0D,$0A,0
                 
oneRush_msg      dc.b   ' You charge at the bandit grabing him.You drag him to the ground hiting him in ',$0D,$0A                
                 dc.b   ' multiple time ,He lays there not moveing.',$0D,$0A,0
                 
oneSurprise_msg  dc.b   ' Sneaking up the stair you step on a nail not being able to scream you bear it ',$0D,$0A 
                 dc.b   ' doing more damage to yourself (-50hp)you grab the bandit by his head hitting ',$0D,$0A 
                 dc.b   ' it against a wall knocking  him clean out. ',$0D,$0A,0
                 
missionOneDone_msg dc.b ' Looking throughout the rest of the farm you find no one else you alert the ',$0D,$0A
                   dc.b ' Guards,They come and arrest the two bandits.You claim your reward(+500 credits).',$0D,$0A
                   

missionTwo_msg   dc.b   ' You decide to help look for this missing hamster you go around town searching',$0D,$0A
                 dc.b   ' one clue brings you to the sewers as you arive there you see three tunnels',$0D,$0A
                 dc.b   ' which one do you choose.',$0D,$0A
                 dc.b    $0D,$0A
                 dc.b   ' Tunnel 1(1) Tuneel 2(2) or Tunnel 3(3)',$0D,$0A,0
                 
tunnelOne_msg    dc.b   ' You pick the first tunnel heading down the narrow path you get stuck.In your ',$0D,$0A                 
                 dc.b   ' attempt to free youself you get hurt (-20hp).who knew space hamsters were a',$0D,$0A
                 dc.b   ' dangerous game.',$0D,$0A,0

tunnelTwo_msg    dc.b   ' Heading down the second path you come across 50 credits(+50 credits) ',$0D,$0A
                 dc.b   ' some people just throw money down the toilet these days. ',$0D,$0A,0
                 
tunnelThree_msg  dc.b   ' You wonder down tunnel three as you reach the end you come across mutated',$0D,$0A
                 dc.b   ' turtles',$0D,$0A,0
tthreeLuckPass_msg   dc.b   ' the turtle turns to you and runs off you decide to follow it.It leads you to',$0D,$0A                 
                 dc.b   ' a stash of credits (+200 credits) ',$0D,$0A,0
                 
tThreeLuckFail_msg   dc.b   ' The turtle turns toyou and runs off you decide to follow it.It turns to you ',$0D,$0A
                 dc.b   ' it seems angry that you followed it.It jumps at you and fights you to the death',$0D,$0A                 
                 dc.b   ' you lose, who knew there were ninja turtles down here.',$0D,$0A,0
                 
twoOpening_msg       dc.b   ' You come to a opening in the tunnel you can either go to the surface or ',$0D,$0A                 
                 dc.b   ' stay in the tunnels. ',$0D,$0A
                 dc.b   $0D,$0A
                 dc.b   ' Stay(1) or go(2)',$0D,$0A,0
                 
twoStay_msg      dc.b   ' Staying in the tunnels you looks around finding 50 credits (+50 credits ) you look',$0D,$0A
                 dc.b   ' once more.',$0D,$0A,0

twoLeave_msg     dc.b   ' Decideing to leave the search for the hamster you try leave the way you came.You',$0D,$0A
                 dc.b   ' hit you foot off a steal beam in the darkness(-10hp) you look around once more',$0D,$0A,0                 
                 
missionTwoDone_msg dc.b ' To your surprise there is a hamster just sitting there looking at you ',$0D,$0A
                 dc.b   ' you grab the hamster and leave the sewer.You go and claim your ',$0D,$0A 
                 dc.b   ' reward (+200 credits)',$0D,$0A,0

missionThree_msg dc.b   ' You decide to work for a day. ',$0D,$0A
                 dc.b   $0D,$0A
                 dc.b   ' Work hard (1) or slack off(2)',$0D,$0A,0
workHard_msg     dc.b   ' You spend a day working hard earning your money.',$0D,$0A,0
slackOff_msg     dc.b   ' You slack off doing as little work as you can.' ,$0D,$0A,0
                 
missionThreeDone_msg dc.b ' You made it two the end of the day (+100 credits) (-10hp).',$0D,$0A,0

missionRedo_msg  dc.b ' You canot replay a mission.whats done is done. ',$0D,$0A,0
      
                
gameOver_msg    dc.b    ' OOOoooo no you did a death... ',$0D,$0A
                dc.b    '   _ (_)(_)(_)       _(_)_     (_) _     _ (_)(_)(_)(_)(_)(_)   ',$0D,$0A 
                dc.b    '  (_)              _(_) (_)_   (_)(_)   (_)(_)(_)               ',$0D,$0A 
                dc.b    ' (_)    _  _  _  _(_)     (_)_ (_) (_)_(_) (_)(_) _  _          ',$0D,$0A 
                dc.b    ' (_)   (_)(_)(_)(_) _  _  _ (_)(_)   (_)   (_)(_)(_)(_)         ',$0D,$0A 
                dc.b    ' (_)         (_)(_)(_)(_)(_)(_)(_)         (_)(_)               ',$0D,$0A 
                dc.b    '    (_)(_)(_)(_)(_)         (_)(_)         (_)(_)(_)(_)(_)(_)   ',$0D,$0A 
                dc.b     $0D,$0A               
                dc.b    '  _(_)(_)(_)(_)_ (_)         (_)(_)(_)(_)(_)(_)(_)(_)(_)(_) _   ',$0D,$0A
                dc.b    ' (_)          (_)(_)_       _(_)(_) _  _       (_) _  _  _ (_) ',$0D,$0A
                dc.b    ' (_)          (_)  (_)     (_)  (_)(_)(_)      (_)(_)(_)(_)     ',$0D,$0A
                dc.b    ' (_)_  _  _  _(_)    (_)_(_)    (_) _  _  _  _ (_)      (_) _    ',$0D,$0A
                dc.b    '   (_)(_)(_)(_)        (_)      (_)(_)(_)(_)(_)(_)         (_)  ',$0D,$0A
                dc.b    ' will you try again (1) or end it here (2)',$0D,$0A,0
                
zeroHp_msg      dc.b    'You should pay attention to your wounds (hp =0)',$0D,$0A,0

neutral_msg   dc.b ' You were neutral',$0D,$0A,0
goodPerson_msg dc.b ' You were a good person',$0D,$0A,0
badPerson_msg  dc.b ' You were a bad person',$0D,$0A,0
days_msg       dc.b  ' Days went by to reach this point.',$0D,$0A,0 



    end start
                








































*~Font name~Courier~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
