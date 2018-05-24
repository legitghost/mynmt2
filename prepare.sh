#Vars
DATA="data"
TOK="tokenizer/tokenize.exe"
BPE="subword-nmt/learn_bpe.py"
MOSES="moses"

# Raw Tokenize for BPE
echo "Tokenizing training data for BPE"
for f in ${DATA}/train-??????.??? ; do
 	echo "--- tokenize $f for BPE"
	$TOK < $f > $f.rawtok
done

# Training BPE Model
echo "Training BPE model..."
rm ${DATA}/philippines.bpe32000
cat ${DATA}/train*.rawtok | python $BPE -s 32000 > ${DATA}/philippines.bpe32000
echo "BPE model generated."

# Tokenization with BPE Model (including train, test, and valid files)
echo "Tokenizing training, testing and validation data using the produced BPE model..."
for f in ${DATA}/*-??????.??? ; do 
	echo "--- tokenizing using BPE model $f"
	$TOK --case_feature --joiner_annotate --bpe_model ${DATA}/philippines.bpe32000 < $f > $f.tok
done

# Add language token
echo "Adding language token..."
for set in train valid test ; do rm ${DATA}/$set-multi.???.tok ; done
  for src in eng tgl bik ceb; do
    for tgt in eng tgl bik ceb; do
      [ ! $src = $tgt ] && perl -i.bak -pe "s//__opt_src_${src} __opt_tgt_${tgt} /" ${DATA}/*-$src$tgt.$src.tok
      for set in train valid test ; do
        [ ! $src = $tgt ] && cat ${DATA}/$set-$src$tgt.$src.tok >> ${DATA}/$set-multi.src.tok
        [ ! $src = $tgt ] && cat ${DATA}/$set-$src$tgt.$tgt.tok >> ${DATA}/$set-multi.tgt.tok
      done
    done
  done
  paste ${DATA}/valid-multi.src.tok ${DATA}/valid-multi.tgt.tok | shuf > ${DATA}/valid-multi.srctgt.tok
  head -2000 ${DATA}/valid-multi.srctgt.tok | cut -f1 > ${DATA}/valid-multi2000.src.tok
  head -2000 ${DATA}/valid-multi.srctgt.tok | cut -f2 > ${DATA}/valid-multi2000.tgt.tok
fi

# Halt
read -p "Task Complete! Press enter to continue..."