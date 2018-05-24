# This shell script automatically creates duplicates for each languages bi-directionally.
DATA="data"

for src in eng tgl bik ceb; do 
  for tgt in eng tgl bik ceb; do
  	if [ $src != $tgt ]
  	then
	  	cp ${DATA}/train.$src ${DATA}/train-$src$tgt.$src
	  	cp ${DATA}/train.$src ${DATA}/train-$tgt$src.$src

	  	cp ${DATA}/test.$src ${DATA}/test-$src$tgt.$src
	  	cp ${DATA}/test.$src ${DATA}/test-$tgt$src.$src

	  	cp ${DATA}/valid.$src ${DATA}/valid-$src$tgt.$src
	  	cp ${DATA}/valid.$src ${DATA}/valid-$tgt$src.$src
	fi
  done
done

read -p "Task Complete! Press enter to continue..."
