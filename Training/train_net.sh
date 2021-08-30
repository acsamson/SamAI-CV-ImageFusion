#!/usr/bin/env sh

#/Users/lianshanchun/caffe/build/tools/caffe train --solver=/Users/lianshanchun/caffe/examples/imageFusion/solver.prototxt 

# TOOLS=/Users/lianshanchun/caffe/build/tools  
# LOG=/Users/lianshanchun/caffe/examples/imageFusion/Log/train_log.log  
# $TOOLS/caffe train \  
#   --solver=/Users/lianshanchun/caffe/examples/imageFusion/solver.prototxt 2>&1   | tee $LOG $@
 
/Users/lianshanchun/caffe/build/tools/caffe train --solver=/Users/lianshanchun/caffe/examples/imageFusion_Gold/solver.prototxt  2>&1   | tee /Users/lianshanchun/caffe/examples/imageFusion_Gold/Log/train_log.log $@