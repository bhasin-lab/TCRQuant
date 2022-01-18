# TCRQuant


## Installation:

### Installing the GitHub Repository

```install
git clone 
```
### Installing MiXCR

```mixcr install
wget -c https://github.com/milaboratory/mixcr/releases/download/v3.0.13/mixcr-3.0.13.zip
unzip mixcr-3.0.13.zip
cd cd mixcr-3.0.13/
./mixcr
```
The path of executable file `./mixcr` can be added to the `.bashrc` file. Detailed installation steps can be followed from the [MiXCR installation manual](https://mixcr.readthedocs.io/en/develop/install.html).

## MiXCR 

MiXCR files can be put in the same directory. The typical input files are in the fastq.gz format. A sample code to run MiXCR on your samples is here

```mixcr run
echo "Starting Pre-processing.."

for file in $(ls *.fastq.gz | rev | cut -c 11- | rev | uniq)
do

	echo "Starting" ${file}
	echo "Species :" ${1}

	/opt/mixcr/mixcr-3.0.13 align -t 4 -s ${1} -r ${file}_align.log -OallowPartialAlignments=true -p rna-seq ${file}1.fastq.gz ${file}2.fastq.gz ${file}.vdjca > /dev/null
	cat ${file}_align.log
	/opt/mixcr/mixcr-3.0.13 assemblePartial ${file}.vdjca ${file}_contigs.vdjca > /dev/null
	/opt/mixcr/mixcr-3.0.13 assemble -t 4 ${file}_contigs.vdjca ${file}.clns > /dev/null
	/opt/mixcr/mixcr-3.0.13 exportClones ${file}.clns ${file}.txt > /dev/null

	echo ${file} "done"

done

echo "MixCR done"
```
More generally 

```
mixcr align -t 4 -s <Species name> -r <Log file name> -OallowPartialAlignments=true -p rna-seq <Forward Read fastq.gz> <Reverse Read fastq.gz> <file name>.vdjca
mixcr assemblePartial <file name>.vdjca <file name>_contigs.vdjca 
mixcr assemble -t 4 <file name>_contigs.vdjca <file name>.clns 
mixcr exportClones <file name>.clns <file name>.txt
```
### Processing files for TCRQuant

The `<file name>.txt` files can be grouped into two classes A and B. The files should be present in directories say `Afiles` and `Bfiles`.

## TCRQuant

The final step of the analysis is to run TCRQuant. The arguements for running the program are:

1. -pA or "--path_to_fileA", "Path to input meta file list Group A (required)
2. -pB or "--path_to_fileB", "Path to input meta file list Group B (required)
3. -d or "--cwd", "Working directory path"

```
Rscript ranalysis.R -d . -f no -pA /path/to/Afiles -pB /path/to/Afiles 
```
