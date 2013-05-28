;Copyright (C) 2013 Bruno Golosio and Tom Schoonjans

;This program is free software: you can redistribute it and/or modify
;it under the terms of the GNU General Public License as published by
;the Free Software Foundation, either version 3 of the License, or
;(at your option) any later version.

;This program is distributed in the hope that it will be useful,
;but WITHOUT ANY WARRANTY; without even the implied warranty of
;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;GNU General Public License for more details.

;You should have received a copy of the GNU General Public License
;along with this program.  If not, see <http://www.gnu.org/licenses/>.
;

NLines = INTARR(95)
NLines[0] = 0

Line = PTRARR(95)
;Line[0] = !NULL

;find location of KL1_LINE in common block
loc = 0
WHILE (SCOPE_VARNAME(COMMON='xraylib', loc) NE 'KL1_LINE') DO loc++

PRINT,'KL1_LINE offset: ',loc,' confirm: ', SCOPE_VARNAME(COMMON='xraylib', loc)
offset = loc


FOR Z = 1, 94 DO BEGIN
	NLines_counter = 0
	NLines_names = []
	FOR xrf_line = KL1_LINE,L3Q1_LINE,-1 DO BEGIN
		IF (xrf_line EQ L1L2_LINE OR xrf_line EQ L1L3_LINE OR xrf_line EQ L2L3_LINE $
		OR xrf_line EQ KO_LINE OR xrf_line EQ KP_LINE) THEN CONTINUE
		IF (RadRate(Z, xrf_line) GT 0.0 AND LineEnergy(Z, xrf_line)) THEN BEGIN
			NLines_counter++
			NLines_names = [NLines_names, SCOPE_VARNAME(COMMON='xraylib', offset+(KL1_LINE-xrf_line))]
		ENDIF
	ENDFOR
	NLines[Z] = NLines_counter
	Line[Z] = PTR_NEW(NLines_names)
	PRINT, 'Z: ',Z, ' -> ',NLines[Z]
ENDFOR



OPENW, lun, 'xrmc_fluo_lines.h', /get_lun
PRINTF, lun, '/*'
PRINTF, lun, 'Copyright (C) 2013 Bruno Golosio and Tom Schoonjans'
PRINTF, lun, ''
PRINTF, lun, 'This program is free software: you can redistribute it and/or modify'
PRINTF, lun, 'it under the terms of the GNU General Public License as published by'
PRINTF, lun, 'the Free Software Foundation, either version 3 of the License, or'
PRINTF, lun, '(at your option) any later version.'
PRINTF, lun, ''
PRINTF, lun, 'This program is distributed in the hope that it will be useful,'
PRINTF, lun, 'but WITHOUT ANY WARRANTY; without even the implied warranty of'
PRINTF, lun, 'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the'
PRINTF, lun, 'GNU General Public License for more details.'
PRINTF, lun, ''
PRINTF, lun, 'You should have received a copy of the GNU General Public License'
PRINTF, lun, 'along with this program.  If not, see <http://www.gnu.org/licenses/>.'
PRINTF, lun, '*/'
PRINTF, lun, ''
PRINTF, lun, '/* This file is automatically generated by the IDL script xrmc_fluo_lines.pro */'
PRINTF, lun, '/* Modify at your own risk */'

PRINTF, lun, ''
PRINTF, lun, '#define MAXZ 94'
PRINTF, lun, '#define MAXNLINES ',MAX(NLines)

PRINTF, lun, 'int NLines[MAXZ + 1] = {'
PRINTF, lun, STRCOMPRESS(STRJOIN(STRING(NLines), ', '))
PRINTF, lun, '};'
PRINTF, lun, ''

PRINTF, lun, 'int Line[MAXZ + 1]['+STRCOMPRESS(STRING(MAX(NLines)),/REMOVE_ALL)+'] = {'
;PRINTF, lun, 'int *Line[] = {'
FOR Z = 0, 94 DO BEGIN
	IF (Line[Z] NE !NULL) THEN BEGIN
	IF (*Line[Z] NE !NULL) THEN BEGIN
	PRINTF , lun, '/* ',AtomicNumberToSymbol(Z), ' */ {', STRCOMPRESS(STRJOIN([*Line[Z], (MAX(NLines) NE NLines[Z] ? STRING(INTARR(MAX(NLines)-NLines[Z])) : !NULL)], ', ')), '},'
	ENDIF ELSE PRINTF, lun, '/* ',AtomicNumberToSymbol(Z), ' */ {', STRCOMPRESS(STRJOIN(STRING(INTARR(MAX(NLINES))),', '))  ,'},'
	ENDIF ELSE PRINTF, lun, '{', STRCOMPRESS(STRJOIN(STRING(INTARR(MAX(NLINES))),', '))  ,'},'
ENDFOR

PRINTF, lun, '};'

FREE_LUN,lun


END