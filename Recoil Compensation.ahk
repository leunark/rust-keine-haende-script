#NoEnv
SendMode Input

; GLOBALS
global RPM := 0
global mysensitivity := 0.3 ; works only with sensitivity 0.3
global myzoom := 1 ; works only with standard scope
global weapon := 2

~End::ExitApp
~Numpad0::weapon := 0
~Numpad1::weapon := 1
~Numpad2::weapon := 2
~Numpad3::weapon := 3

/*
----------------------------------------------------------------------------
WEAPON LIST: 
AK: 450RPM, 30Ammo -> 1 ; TEST RESULTS: 30 Runs in 4000MS 
MP5: 600RPM, 30Ammo -> 2 ; TEST RESULTS: 30 Runs in 3000MS 
----------------------------------------------------------------------------
SENSITIVITY TESTS:
When Sensitivity in game is 0.3 then moving 200px moves in game 80px
-> Stretch Factor 2.5
----------------------------------------------------------------------------
*/

LCtrl & ~LButton::

; AK
if(weapon == 1)
{
	RPM := 450
	moveWeapon(0,-1900,30)
}

; MP5
if(weapon == 2)
{
	RPM := 600
	moveWeapon(70,-80,2)
	moveWeapon(198,-245,3)
	moveWeapon(85,-70,2)
	moveWeapon(-340,-120,5)
	moveWeapon(200,-50,5)
	moveWeapon(-50,-40,5)
	moveWeapon(-210,-20,5)
	moveWeapon(0,0,3)
}

if(weapon == 3)
{
	shots := 12
	RPM := 450
	moveBy(488,360,1000)
}

; this function moves the cursor instantly by its relative position 
mouseXY(x,y)
{
	DllCall("mouse_event",int,1,int,x,int,-y,uint,0,uint,0)
}

; this function moves the weapon by "x" and "y" smoothly within the next "runs" runs
moveWeapon(x,y,runs)
{
	time := 60000*runs/RPM
	moveBy(x,y,time)
}

; this function moves the cursor by "x" and "y" smoothly in "time" milliseconds
moveBy(x,y,time)
{	
	sleeptime := 15.6
	counter := 0
	sleepcounter := floor(time/sleeptime)
	xpart := x/sleepcounter
	ypart := y/sleepcounter
	
	xfehler := xpart - floor(xpart)
	yfehler := ypart - floor(ypart)
	
	xfehlercollector := 0
	yfehlercollector := 0
	
	xfehlercollectorfloored := 0
	yfehlercollectorfloored := 0
	
	while(counter < sleepcounter)
	{
		If GetKeyState("LButton", "LCtrl") 
		{
			Sleep, sleeptime
			xfehlercollectorfloored := floor(xfehlercollector)
			yfehlercollectorfloored := floor(yfehlercollector)
			mouseXY(xpart+xfehlercollectorfloored,ypart+yfehlercollectorfloored)
			xfehlercollector := xfehlercollector - xfehlercollectorfloored + xfehler
			yfehlercollector := yfehlercollector - yfehlercollectorfloored + yfehler
			counter += 1
		}
		else
		break
	}
}

; this function calculates the time it needs to shoot X bullets regarding the RPM of the weapon
timeToShootBullets(RPM,runs)
{
	return 60*1000*runs/RPM
}