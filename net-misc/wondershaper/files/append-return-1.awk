{
    addOR=nextAddOR;nextAddOR=0
}
/tc.*add/{
    addOR=1
}
/\\$/{
    nextAddOR=addOR;addOR=0
}
{
    printf("%s",$0);
    if (addOR)
	print " || return 1"
    else
	printf "\n"
}