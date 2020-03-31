/*Student name: Ammar Saad*/
/* EPI5143 quiz 6 submission*/

/*Creating permanent repositories*/
libname fixed 'C:\Users\ammar\Desktop\EPI5143\classfile'; run;
libname quizsix 'C:\Users\ammar\Desktop\EPI5143\EPI5143 work\programs'; run;

/* Creating a dataset of encounters that only took place in 2003*/
data quizsix.nencounter;
set fixed.nencounter;
if year(datepart(EncStartDtm))=2003;
run;

/*Sorting the dataset by our unit of analysis (patient)*/
proc sort data=quizsix.nencounter;
by EncPatWID;
run;

/*Flat-filing the dataset and creating variables that count encounters*/
data quizsix.finalcount;
set quizsix.nencounter;
by EncPatWID;
if first.EncPatWID=1 then do;
	inpatient=0; /*variable that takes a value of 1 if there was an inpatient encounter and 0 otherwise*/
	er=0; /*variable that takes a value of 1 if there was an emergency room encounter and 0 otherwise*/ 
	encount=0; /*variable that takes a value of 1 if there was an inpatient or emerg encoutner and 0 otherwise*/
	count=0; /*variable that takes the value of the number of encounters*/
	end;
if EncVisitTypeCd='INPT' then do; /*if the patient had an inpatient encounter*/
	inpatient=1; 
	end;
if EncVisitTypeCd='EMERG' then do; /*if the patient had an emergency room encounter*/
	er=1;
	end;
if EncVisitTypeCd in: ('INPT' 'EMERG') then do; /*if the patient had an inpatient or ER encounter*/
	encount=1;
	count=count+1;
	end;
if last.EncPatWID then output;
retain inpatient er encount count; /*keeping the variables were are interested in */
run;

/* creating tables of frequencies for our variables of interest*/
proc freq data=quizsix.finalcount;
tables inpatient er encount count;
options formchar="|----|+|---+=|-/\<>*"; /*print-friendly frequency tables*/
run;

/*Answers*/
/* a) 1074 patients had at least one inpatient encounter in 2003*/
/* b) 1978 patient had at least one emergency room encounter in 2003*/
/* c) 2891 patients had at least one encounter (inpatient or emergency room) in 2003*/
/* d) Please see table below:

                                                        Cumulative    Cumulative
                      count    Frequency     Percent     Frequency      Percent
                      ----------------------------------------------------------
                          1        2556       88.41          2556        88.41
                          2         270        9.34          2826        97.75
                          3          45        1.56          2871        99.31
                          4          14        0.48          2885        99.79
                          5           3        0.10          2888        99.90
                          6           1        0.03          2889        99.93
                          7           1        0.03          2890        99.97
                         12           1        0.03          2891       100.00
*/

/*End of quiz*/
