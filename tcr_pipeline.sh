#!/bin/bash

cd ${2}

#pwd

#echo ${3}


if [ ! ${3} == "no" ]
then
	#re='^[0-9]+$'
	if [ ${3} == "yes" ]
	then
		echo ${3}
		#subsample
		for i in `ls *.fastq.gz`; do echo $(zcat ${i} | wc -l)/4|bc; done > count.txt
		count=$(sort -r count.txt | tail -1)
		echo ${count}
	else
		count=$((${3} + 0))
		echo ${count}
	fi
	gzip -d *.fastq.gz
	for file in $(ls *.fastq | rev | cut -c 8- | rev | uniq)
	do
		paste ${file}1.fastq ${file}2.fastq | awk '{ printf("%s",$0); n++;
		if(n%4==0) { printf("\n");} else { printf("\t");} }' |
		awk -v k=${count} 'BEGIN{srand(systime() + PROCINFO["pid"]);}{s=x++<k?x-1:int(rand()*x);if(s<k)R[s]=$0}END{for(i in R)print R[i]}' |
		awk -F"\t" '{print $1"\n"$3"\n"$5"\n"$7 > "'${file}'_sub_1.fastq"; print $2"\n"$4"\n"$6"\n"$8 > "'${file}'_sub_2.fastq"}'
		rm ${file}1.fastq ${file}2.fastq
	done
	gzip *.fastq
fi

echo "Starting Pre-processing.."

for file in $(ls *.fastq.gz | rev | cut -c 11- | rev | uniq)
do

	echo "Starting" ${file}
	echo "Species :" ${1}

	/home/hskhalsa/Desktop/tcr_pipeline_new/mixcr align -t 4 -s ${1} -r ${file}_align.log -OallowPartialAlignments=true -p rna-seq ${file}1.fastq.gz ${file}2.fastq.gz ${file}.vdjca > /dev/null
	cat ${file}_align.log
	/home/hskhalsa/Desktop/tcr_pipeline_new/mixcr assemblePartial ${file}.vdjca ${file}_contigs.vdjca > /dev/null
	/home/hskhalsa/Desktop/tcr_pipeline_new/mixcr assemble -t 4 ${file}_contigs.vdjca ${file}.clns > /dev/null
	/home/hskhalsa/Desktop/tcr_pipeline_new/mixcr exportClones ${file}.clns ${file}.txt > /dev/null

	echo ${file} "done"

done

echo "MixCR done"

echo "All data has been pre-processed and clonotype count files generated..."


# Post process
Rscript /home/hskhalsa/Desktop/tcr_pipeline_new/ranalysis.R ${1}