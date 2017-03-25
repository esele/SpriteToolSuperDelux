;----------------------------------------------------;
; Cluster Rain - by Ladida			     ;
; Can be whatever you want, just change the graphics ;
; Edit of Roy's original Spike Hell sprite	     ;
;----------------------------------------------------;

!RainTile = $22	;Tile # of the rain.

!RainSize = $02	;Size of rain tile. 16x16 by default

!RainProp = $36 ;Tile property of the rain.


SpeedTableYRain:
db $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05 ; Speed table, per sprite. Amount of pixels to move down each frame. 00 = still, 80-FF = rise, 01-7F = sink.

SpeedTableXRain:
db $FF,$FE,$FF,$FE,$FF,$FE,$FF,$FE,$FF,$FE,$FF,$FE,$FF,$FE,$FF,$FE,$FF,$FE,$FF,$FE ; Speed table, per sprite. Amount of pixels to move down each frame. 00 = still, 80-FF = rise, 01-7F = sink.

OAMStuffRain:
db $40,$44,$48,$4C,$50,$54,$58,$5C,$60,$64,$68,$6C,$80,$84,$88,$8C,$B0,$B4,$B8,$BC ; These are all in $02xx


IncrementByOneRain:
LDA $1E02,y                     ; \ Increment Y position of sprite.
INC A                           ;  |
STA $1E02,y                     ;  |
SEC                             ;  | Check Y position relative to screen border Y position.
SBC $1C                         ;  | If equal to #$F0...
CMP #$F0                        ;  |
BNE ReturnAndSuchRain           ;  |
LDA #$01                        ;  | Appear.
STA $1E2A,y                     ; /

ReturnAndSuchRain:
RTS

Main:				;The code always starts at this label in all sprites.
LDA $1E2A,y                     ; \ If meant to appear, skip sprite intro code.
BEQ IncrementByOneRain		; /

LDA $9D				; \ Don't move if sprites are supposed to be frozen.
BNE ImmobileRain		; /
LDA $1E02,y                     ; \
CLC				;  |
ADC SpeedTableYRain,y               ;  | Movement.
STA $1E02,y                     ; /

LDA $1E16,y
CLC
ADC SpeedTableXRain,y
STA $1E16,y

ImmobileRain:                       ; OAM routine starts here.
LDX.w OAMStuffRain,y 		; Get OAM index.
LDA $1E02,y			; \ Copy Y position relative to screen Y to OAM Y.
SEC                             ;  |
SBC $1C				;  |
STA $0201,x			; /
LDA $1E16,y			; \ Copy X position relative to screen X to OAM X.
SEC				;  |
SBC $1A				;  |
STA $0200,x			; /
LDA #!RainTile			; \ Tile
STA $0202,x                     ; /
LDA #!RainProp
STA $0203,x
PHX
TXA
LSR
LSR
TAX
LDA #!RainSize
STA $0420,x
PLX
LDA $18BF
ORA $1493
BEQ ReturnToTheChocolateRainWhatever            ; Change BEQ to BRA if you don't want it to disappear at generator 2, sprite D2.
LDA $0201,x
CMP #$F0                                    	; As soon as the sprite is off-screen...
BCC ReturnToTheChocolateRainWhatever
LDA #$00					; Kill it.
STA $1892,y					;

ReturnToTheChocolateRainWhatever:
RTS