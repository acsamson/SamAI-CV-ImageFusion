#!/usr/bin/env bash 

DATA_train_label0=train/0/ 
DATA_train_label1=train/1/ 
DATA_val=val 

echo "Create train.txt..."
find $DATA_train_label0 -name *.tif | cut -d '/' -f2 -f4| sed "s/$/ 0/">>train.txt
find $DATA_train_label1 -name *.tif | cut -d '/' -f2 -f4| sed "s/$/ 1/">>train.txt
echo "Done.."

echo "Create val.txt..."
find $DATA_val -name *_0.tif | cut -d '/' -f2| sed "s/$/ 0/">>val.txt
find $DATA_val -name *_1.tif | cut -d '/' -f2| sed "s/$/ 1/">>val.txt
echo "Done.."