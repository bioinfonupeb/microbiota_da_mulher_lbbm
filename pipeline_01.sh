# Define paths
ROOT_DIR_PATH="/home/lauro/nupeb/renata_thayne_jennefer/menopausa_lbbm";
METADIR="${ROOT_DIR_PATH}/metadata";
METAFILE="${METADIR}/metadata.tsv";
FASTQ_DIR_PATH="${ROOT_DIR_PATH}/fastq_files";
FASTQC_DIR_PATH="${ROOT_DIR_PATH}/fastqc_files";
FILTERED_DIR_PATH="${ROOT_DIR_PATH}/filtered_fastqc_files";
FILTERED_GOOD_DIR_PATH="${FILTERED_DIR_PATH}/good";
FILTERED_BAD_DIR_PATH="${FILTERED_DIR_PATH}/bad";
FILTERED_GD_DIR_PATH="${FILTERED_DIR_PATH}/graph_data";
MANIFESTFILE="${ROOT_DIR_PATH}/manifest";
SEQSQZA="${ROOT_DIR_PATH}/seqs-demux.qza";
SEQSQZV="${ROOT_DIR_PATH}/seqs-demux.qzv";
GREENGENES="${ROOT_DIR_PATH}/gg-13-8-99-classifier.qza";
GREENGENESOTUS="${ROOT_DIR_PATH}/gg_13_8_otus";
SILVA="${ROOT_DIR_PATH}/silva-132-99-nb-classifier.qza";
DADADIR="${ROOT_DIR_PATH}/dada_dmx_se";
DADATABLEQZA="${DADADIR}/dada_table.qza";
DADATABLEQZV="${DADADIR}/dada_table.qzv";
DADAREPSEQSQZA="${DADADIR}/dada_rep_seqs.qza";
DADAREPSEQSQZV="${DADADIR}/dada_rep_seqs.qzv";
TAXONDIR="${ROOT_DIR_PATH}/taxonomy";
TAXONQZA="${TAXONDIR}/taxonomy_dada_rep_seqs.qza";
TAXONQZV="${TAXONDIR}/taxonomy_dada_rep_seqs.qzv";
PHYLOTREEDIR="${ROOT_DIR_PATH}/phylotree";
MAFFTDADAREPSEQSQZA="${PHYLOTREEDIR}/mafft_dada_rep_seqs.qza";
MASKMAFFTDADAREPSEQSQZA="${PHYLOTREEDIR}/mask_mafft_dada_rep_seqs.qza";
UNROOTMLTREEMASKEDQZA="${PHYLOTREEDIR}/unroot_ml_tree_masked.qza";
ROOTMLTREEQZA="${PHYLOTREEDIR}/root_ml_tree.qza";
COREMETRICSDIR="${ROOT_DIR_PATH}/core_metrics_results";
CLOSEDREFDIR="${ROOT_DIR_PATH}/closed_ref";



# Define variables
QIIME=qiime2-2020.11;	# Conda qiime enviroment



# # --------------------------------------------------------------------------------------
# # --- Pipe 00.1.1 : Obtain Greengenes 13_8 99% OTUs full-length sequences classifier ---
# # --------------------------------------------------------------------------------------
# if test -f "${GREENGENES}"; then
#     echo "File already exists: ${GREENGENES}";
# else
# 	echo "File don't exists: ${GREENGENES}";
# 	wget -O "${GREENGENES}" "https://data.qiime2.org/2021.4/common/gg-13-8-99-nb-classifier.qza";
# fi

# # --------------------------------------------------------------------------------------
# # --- Pipe 00.1.2 : Obtain Greengenes 13_8 99% OTUs full-length sequences classifier ---
# # --------------------------------------------------------------------------------------
# if [ -d "${GREENGENESOTUS}" ]; then
#     echo "Folder already exists: ${GREENGENESOTUS}";
# else
# 	echo "Folder don't exists: ${GREENGENESOTUS}";
# 	wget "ftp://greengenes.microbio.me/greengenes_release/gg_13_5/gg_13_8_otus.tar.gz" # download DB
# 	tar -xvzf "gg_13_5_otus.tar.gz" -C "${ROOT_DIR_PATH}" # uncompress DB
# 	rm "gg_13_8_otus.tar.gz";
# fi


# # ---------------------------------------------------------------------
# # --- Pipe 00.1.3 : Obtain Silva 132 99% OTUs full-length sequences ---
# # ---------------------------------------------------------------------
# if test -f "${SILVA}"; then
#     echo "File already exists: ${SILVA}";
# else
# 	echo "File don't exists: ${SILVA}";
# 	wget -O "${SILVA}" "https://data.qiime2.org/2021.4/common/silva-138-99-nb-classifier.qza";
# fi

# # # ----------------------------------------
# # # --- Pipe 00.2 : Create metadata file ---
# # # ----------------------------------------
# mkdir -p $METADIR;
# if test -f "${METAFILE}"; then
#     echo "File already exists: ${METAFILE}";
# else
# 	echo "File don't exists: ${METAFILE}";
# 	>${METAFILE};
# 	echo "#SampleID	BarcodeSequence	LinkerPrimerSequence	Description" >> ${METAFILE};
# 	echo "#q2:types	categorical	categorical	categorical" >> ${METAFILE};
# 	FILEEXT=".extendedFrags.fastq";
# 	for file in $(ls $FASTQ_DIR_PATH/*fastq); do
# 		SAMPLEID="${file:${#FASTQ_DIR_PATH}+1:-${#FILEEXT}}";
# 		echo -e "${SAMPLEID}\t\t\tfeces-without_reposition" >> ${METAFILE};
# 	done;
# fi


# # -----------------------------------------------------------
# # --- Pipe 01 : Create quality analysis files with fastqc ---
# # -----------------------------------------------------------
# # Create new folder if it not exists
# mkdir -p $FASTQC_DIR_PATH;

# # Execute fasqc over all fastq files
# for file in $(ls $FASTQ_DIR_PATH/*fastq); do
# 	fastqc $file -o $FASTQC_DIR_PATH;
# done;



# # ------------------------------------------------
# # --- Pipe 02 : filter by quality with prinseq ---
# # ------------------------------------------------
# # Define prinseq parametes
# # Output format: 1 (fasta only), 2 (fasta and qual), 3 (fastq), 4 (fastq and input fasta), and 5 (fastq, fasta and qual)
# OUTFMT=4;
# # phred threshold value
# QUALSCORE=20;

# # Create new folder if it not exists
# mkdir -p $FILTERED_DIR_PATH;
# mkdir -p $FILTERED_GOOD_DIR_PATH;
# mkdir -p $FILTERED_BAD_DIR_PATH;
# mkdir -p $FILTERED_GD_DIR_PATH;

# # Execute prinseq over all fastq files
# for file in $(ls $FASTQ_DIR_PATH/*fastq); do
# 	FNAME=${file:${#FASTQ_DIR_PATH}:(-5)};
# 	echo "> (PIPE02) Filter with PRINSEQ: ${FNAME:1:-1}";
# 	GOOD_PATH=${FILTERED_GOOD_DIR_PATH}${FNAME}good;
# 	BAD_PATH=${FILTERED_BAD_DIR_PATH}${FNAME}bad;
# 	GD_PATH=${FILTERED_GD_DIR_PATH}${FNAME}gd;
# 	prinseq-lite -fastq $file -out_format $OUTFMT -trim_qual_right $QUALSCORE -out_good $GOOD_PATH -out_bad $BAD_PATH -graph_data $GD_PATH;
# done;



# # ----------------------------------------
# # --- Pipe 03.1 : Create manifest file ---
# # ----------------------------------------
# # Create "fastq manifest" file
# EXTGOOD=".extendedFrags.good.fastq";
# >${MANIFESTFILE};
# # Write header to manifest file
# echo "sample-id,absolute-filepath,direction" >> ${MANIFESTFILE};
# # Write each sample line to manisfest
# for file in $(ls ${FILTERED_GOOD_DIR_PATH}/*fastq); do
# 	SAMPLEID=${file:${#FILTERED_GOOD_DIR_PATH}+1:-${#EXTGOOD}};
# 	NEWLINE="${SAMPLEID},${file},forward";
# 	echo $NEWLINE >> ${MANIFESTFILE};
# done;



# # -------------------------------------------------------
# # --- Pipe 03.2 : Import fastq files to a single .qza ---
# # -------------------------------------------------------
# conda activate $QIIME;
# qiime tools import \
#   --type 'SampleData[SequencesWithQuality]' \
#   --input-path ${MANIFESTFILE} \
#   --output-path $SEQSQZA \
#   --input-format SingleEndFastqManifestPhred33;
# # Convert to .qzv
# qiime demux summarize --i-data ${SEQSQZA} --o-visualization ${SEQSQZV};
# conda deactivate;



# # ---------------------------------------------------------------
# # --- Pipe 04 : (DADA2) Divisive Amplicon Denoising Algorithm --- 
# # filter reads (based on length and Q scores) as well as chimeras
# # ; joins paired-end reads;
# # denoises and dereplicates sequences
# # ---------------------------------------------------------------
# # mkdir -p $DADADIR;
# conda activate $QIIME;
# qiime dada2 denoise-single \
# 	--i-demultiplexed-seqs ${SEQSQZA} \
# 	--p-trunc-len 0 \
# 	--p-n-reads-learn 1000000 \
# 	--p-n-threads 6 \
# 	--o-representative-sequences ${DADAREPSEQSQZA} \
# 	--o-table ${DADATABLEQZA} \
# 	--output-dir ${DADADIR} \
# 	--verbose
# qiime feature-table summarize \
# 	--i-table ${DADATABLEQZA} \
# 	--o-visualization ${DADATABLEQZV} \
# 	--m-sample-metadata-file ${METAFILE}
# qiime feature-table tabulate-seqs \
# 	--i-data ${DADAREPSEQSQZA} \
# 	--o-visualization ${DADAREPSEQSQZV}
# conda deactivate;


# # --------------------------------------
# # --- Pipe 05 : Taxonomic assignment ---
# # Classify the ASVs representative 
# # sequences using the Naive Bayes
# # classifier
# # --------------------------------------
# mkdir -p ${TAXONDIR};
# conda activate $QIIME;
# qiime feature-classifier classify-sklearn \
# 	--i-classifier ${SILVA} \
# 	--i-reads ${DADAREPSEQSQZA} \
# 	--o-classification ${TAXONQZA} \
# 	--p-n-jobs -2
# qiime metadata tabulate \
# 	--m-input-file ${TAXONQZA} \
# 	--o-visualization ${TAXONQZV}
# conda deactivate;


# # -------------------------------------
# # --- Pipe 06.1 : Phylogenetic tree ---
# # Multiple Sequence Alignment (MSA) 
# # with MAFFT
# # -------------------------------------
# mkdir -p ${PHYLOTREEDIR};
# conda activate $QIIME;
# qiime alignment mafft \
# 	--i-sequences ${DADAREPSEQSQZA} \
# 	--o-alignment ${MAFFTDADAREPSEQSQZA}
# conda deactivate;

# # -------------------------------------
# # --- Pipe 06.2 : Phylogenetic tree ---
# # Eliminate the highly variable 
# # positions, to avoid overestimate 
# # distances
# # -------------------------------------
# conda activate $QIIME;
# qiime alignment mask \
# 	--i-alignment ${MAFFTDADAREPSEQSQZA} \
# 	--o-masked-alignment ${MASKMAFFTDADAREPSEQSQZA}
# conda deactivate;

# # -------------------------------------
# # --- Pipe 06.3 : Phylogenetic tree ---
# # Build the ML tree with FastTree
# # -------------------------------------
# conda activate $QIIME;
# qiime phylogeny fasttree \
# 	--i-alignment ${MASKMAFFTDADAREPSEQSQZA} \
# 	--o-tree ${UNROOTMLTREEMASKEDQZA}
# conda deactivate;


# # -------------------------------------
# # --- Pipe 06.4 : Phylogenetic tree ---
# # Root the unrooted tree based on 
# # midpoint rooting method
# # -------------------------------------
# conda activate $QIIME;
# qiime phylogeny midpoint-root \
# 	--i-tree ${UNROOTMLTREEMASKEDQZA} \
# 	--o-rooted-tree ${ROOTMLTREEQZA}
# conda deactivate;


# # --------------------------------------------------------
# # --- Pipe 07.1 : Taxonomic Analisys - Barplot profile ---
# # --------------------------------------------------------
# conda activate $QIIME;
# BARPLOTQZV="${TAXONDIR}/taxa-bar-plots.qzv";
# qiime taxa barplot \
# 	--i-table ${DADATABLEQZA} \
# 	--i-taxonomy ${TAXONQZA} \
# 	--m-metadata-file ${METAFILE} \
# 	--o-visualization ${BARPLOTQZV}
# conda deactivate;


# # ----------------------------------------------------------------
# # --- Pipe 07.2 : Taxonomic Analisys - Core diversity analysis ---
# # ----------------------------------------------------------------
# RAREFACTIONFREQ=55700
# conda activate $QIIME;
# rm -fR ${COREMETRICSDIR};
# qiime diversity core-metrics-phylogenetic \
# 	--i-phylogeny ${ROOTMLTREEQZA} \
# 	--i-table ${DADATABLEQZA} \
# 	--p-sampling-depth ${RAREFACTIONFREQ} \
# 	--m-metadata-file ${METAFILE} \
# 	--output-dir ${COREMETRICSDIR}

# qiime diversity alpha-rarefaction \
# 	--i-table ${DADATABLEQZA} \
# 	--i-phylogeny ${ROOTMLTREEQZA} \
# 	--p-max-depth ${RAREFACTIONFREQ} \
# 	--m-metadata-file ${METAFILE} \
# 	--o-visualization "${COREMETRICSDIR}/alpha_rarefaction.qzv"
# conda deactivate;


# ------------------------------------------
# --- Pipe 08 :  Closed Reference Method ---
# ------------------------------------------
mkdir -p "${CLOSEDREFDIR}";
conda activate $QIIME;

JPE="${CLOSEDREFDIR}/dmx-jpe.qza"
JPEFILTER="${CLOSEDREFDIR}/dmx-jpe-filter.qza";
JPEFILTERSTATS="${CLOSEDREFDIR}/dmx-jpe-filter-stats.qza";
DRPLTABLE="${CLOSEDREFDIR}/drpl-tbl.qza";
DRPLSEQSQZA="${CLOSEDREFDIR}/drpl-seqs.qza";
OTUS97="${CLOSEDREFDIR}/97_otus-GG.qza";
OTUS97REFTAX="${CLOSEDREFDIR}/97_otu-ref-taxonomy-GG.qza";
TBLCR97="${CLOSEDREFDIR}/tbl-cr-97.qza";
REPSEQCR97="${CLOSEDREFDIR}/rep-seqs-cr-97.qza";
UMATCHCR97="${CLOSEDREFDIR}/unmatched-cr-97.qza";

# # Join paired-end reads - Only for demux-paired-end
# qiime vsearch join-pairs \
# 	--i-demultiplexed-seqs "${SEQSQZA}" \
# 	--p-allowmergestagger \
# 	--o-joined-sequences "${JPE}"

# # Filter based on Q scores
# qiime quality-filter q-score \
# 	--i-demux "${SEQSQZA}" \
# 	--o-filtered-sequences "${JPEFILTER}" \
# 	--o-filter-stats "${JPEFILTERSTATS}"

# Dereplicating sequences
qiime vsearch dereplicate-sequences \
	--i-sequences "${JPEFILTER}" \
	--o-dereplicated-table "${DRPLTABLE}" \
	--o-dereplicated-sequences "${DRPLSEQSQZA}"

# # Closed-reference clustering
# qiime tools import \
# 	--type 'FeatureData[Sequence]' \
# 	--input-path "${GREENGENESOTUS}/rep_set/97_otus.fasta" \
# 	--output-path "${OTUS97}"

# qiime tools import \
# 	--type 'FeatureData[Taxonomy]' \
# 	--source-format HeaderlessTSVTaxonomyFormat \
# 	--input-path "${GREENGENESOTUS}/taxonomy/97_otu_taxonomy.txt" \
# 	--output-path "${OTUS97REFTAX}"

# #  OTU clustering at 97%
# qiime vsearch cluster-features-closed-reference \
# 	--i-table "${DRPLTABLE}" \
# 	--i-sequences "${DRPLSEQSQZA}" \
# 	--i-reference-sequences "${OTUS97}" \
# 	--p-perc-identity 0.97 \
# 	--o-clustered-table "${TBLCR97}" \
# 	--o-clustered-sequences "${REPSEQCR97}" \
# 	--o-unmatched-sequences "${UMATCHCR97}"
# # Export the OTU table
# qiime tools export "${TBLCR97}" \
# 	--output-dir "${CLOSEDREFDIR}"
conda deactivate;