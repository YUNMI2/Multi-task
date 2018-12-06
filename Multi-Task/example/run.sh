#!/bin/bash 
#absolute path point to NNSegmentation directory
workspace=`pwd`
tooldir=/data/yzhu/Experiment/WS-Domain-Adaptation/Add-News/CodeDebug/Multi-Task/
corpus=multi-task
outputdir=$corpus.sample

mkdir -p $outputdir
rm $outputdir/* -rf

function extract
{
    #extracting your features here
    echo "[self implementation]"
}

function runLSTM
{
    cmd=$1
    option=$2

    mkdir $workspace/$outputdir/$cmd.$corpus -p
    echo $workspace/ws-corpus/news-corpus/sparse/msr.train.sparse.corpus.feats
    ln -s $workspace/ws-corpus/news-corpus/sparse/msr.train.sparse.feats $workspace/$outputdir/$cmd.$corpus/msr.train.feats 
    ln -s $workspace/ws-corpus/news-corpus/sparse/msr.dev.sparse.feats $workspace/$outputdir/$cmd.$corpus/msr.dev.feats 
    ln -s $workspace/ws-corpus/news-corpus/sparse/msr.test.sparse.feats $workspace/$outputdir/$cmd.$corpus/msr.test.feats 
    
    ln -s $workspace/ws-corpus/news-corpus/sparse/pku.train.sparse.feats $workspace/$outputdir/$cmd.$corpus/pku.train.feats 
    ln -s $workspace/ws-corpus/news-corpus/sparse/pku.dev.sparse.feats $workspace/$outputdir/$cmd.$corpus/pku.dev.feats 
    ln -s $workspace/ws-corpus/news-corpus/sparse/pku.test.sparse.feats $workspace/$outputdir/$cmd.$corpus/pku.test.feats 
    
    ln -s $workspace/ws-corpus/news-corpus/sparse/ctb5.train.sparse.feats $workspace/$outputdir/$cmd.$corpus/ctb5.train.feats 
    ln -s $workspace/ws-corpus/news-corpus/sparse/ctb5.dev.sparse.feats $workspace/$outputdir/$cmd.$corpus/ctb5.dev.feats 
    ln -s $workspace/ws-corpus/news-corpus/sparse/ctb5.test.sparse.feats $workspace/$outputdir/$cmd.$corpus/ctb5.test.feats 
    
    echo $tooldir/$cmd 
	echo $workspace/$outputdir/$cmd/
	cp $tooldir/$cmd $workspace/$outputdir/$cmd.$corpus/
    	train_file=$workspace/$outputdir/$cmd.$corpus/ctb5.train.feats,$workspace/$outputdir/$cmd.$corpus/msr.train.feats,$workspace/$outputdir/$cmd.$corpus/pku.train.feats
        train_corpus=10000,10000,10000
        train_tags=ctb5,msr,pku
        test_tags=ctb5,msr,pku
    	dev_file=$workspace/$outputdir/$cmd.$corpus/ctb5.dev.feats,$workspace/$outputdir/$cmd.$corpus/msr.dev.feats,$workspace/$outputdir/$cmd.$corpus/pku.dev.feats
    	test_file=$workspace/$outputdir/$cmd.$corpus/ctb5.test.feats,$workspace/$outputdir/$cmd.$corpus/msr.test.feats,$workspace/$outputdir/$cmd.$corpus/pku.test.feats
    #character bigram embedding and character trigram embedding should use a comma to separate 
    echo $train_file

     nohup $workspace/$outputdir/$cmd.$corpus/$cmd -l \
        -train $train_file \
        -trainSize $train_corpus \
        -trainTags $train_tags \
        -testTags $test_tags \
        -dev $dev_file \
        -test $test_file \
        -option $option \
        -model $workspace/$outputdir/$cmd/$cmd.model \
    >$workspace/$outputdir/$cmd.log 2>&1 &
}

echo "Step 1: Extracting Features..."
extract $corpus 
echo "Step 2: Running LSTMCRFMLLabeler..."
cmds="LSTMCRFMLLabeler"
runLSTM LSTMCRFMLLabeler ./options/option.lstm
#runLSTM SparseLSTMCRFMMLabeler ./options/option.sparse+lstm
echo "Successfully run!"
