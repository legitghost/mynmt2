#Vars
DATA="data"

# Build Vocab
echo "Building vocab for training..."
onmt-build-vocab --size 50000 --save_vocab ${DATA}/src-vocab.txt ${DATA}/train-multi.src.tok
onmt-build-vocab --size 50000 --save_vocab ${DATA}/tgt-vocab.txt ${DATA}/train-multi.tgt.tok

# Train
onmt-main train --config config/myconfig.yml --model config/models/mymodel.yml 

# Halt
read -p "Task Complete! Press enter to continue..."