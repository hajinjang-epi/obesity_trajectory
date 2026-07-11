/* Adapted from obesity_figures.sas (Figure 1: overall obesity prevalence
   trend and its p-trend test). FIG1_OBE holds the author's own
   age-standardized obesity-prevalence estimates by KNHANES wave (TERM),
   embedded inline in the original script -- shipped here unmodified.
   The PROC REG steps are the author's own "p-trend" checks (regressing
   the wave-level prevalence on TERM), copied verbatim. The upstream
   PROC SURVEYREG step that produces FIG1_OBE from the private KNHANES
   extract is omitted. */

DATA FIG1_OBE;
INPUT TERM MEN WOMEN;
CARDS;
1	24.61	25.93
2	31.07	27.41
3	34.07	27.12
4	35.14	25.2
5	35	26.15
6	37.16	24.26
7	40.7	24.8
;
RUN;

/*p-trend 보기*/
PROC REG DATA=FIG1_OBE;
MODEL MEN=TERM ;
RUN;
PROC REG DATA=FIG1_OBE;
MODEL WOMEN=TERM;
RUN;
