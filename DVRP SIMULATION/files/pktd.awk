BEGIN {
dcount = 0;
rcount = 0;
}
{
event = $1;
time=$2;
if(event == "d")
{
dcount++;
#printf("%f %d",time,dcount);
}
if(event == "r")
{
rcount++;
}
printf("%f %d \n",time,dcount);
}
END {
#printf("The no.of packets dropped  : %d\n ",dcount);
#printf("The no.of packets recieved : %d\n ",rcount);
#printf("%d %d",dcount,rcount);

}

