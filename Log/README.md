运行的命令是:

```sh
sudo ./plot_training_log.py.example 0 `date +%Y-%m-%d-%H-%M-%S`.png  train_log.log
```



==先解释下之前的`train_net.sh`==

==注意`Test里面没有loss,因此不能用2和3`,,,,一般用0和6就好==

为了生成日志要加上

```shell
/Users/lianshanchun/caffe/build/tools/caffe train --solver=/Users/lianshanchun/caffe/examples/imageFusion/solver.prototxt  2>&1   | tee /Users/lianshanchun/caffe/examples/imageFusion/Log/train_log.log $@
```

> 2>&1 是将标准出错重定向到标准输出，这里的标准输出已经重定向到了out.file文件，即将标准出错也输出到out.file文件中。最后一个&， 是让该命令在后台执行



先把caffe下tools的extra里面的三个

* extract_seconds.py
* parse_log.sh
* plot_training_log.py.example

拷贝到`Log`文件夹下

日志文件是通过训练的时候生成的,其实也可以在训练完成后再cmd+a选择终端的所有

然后再粘贴到`Log`文件夹下

==注意需要修改`parse_log.sh`里面的==

改为:

```sh
#!/bin/bash
# Usage parse_log.sh caffe.log
# It creates the following two text files, each containing a table:
#     caffe.log.test (columns: '#Iters Seconds TestAccuracy TestLoss')
#     caffe.log.train (columns: '#Iters Seconds TrainingLoss LearningRate')
# encoding : utf-8

# get the dirname of the script




DIR="$( cd "$(dirname "$0")" ; pwd -P )"

if [ "$#" -lt 1 ]
then
echo "Usage parse_log.sh /path/to/your.log"
exit
fi
LOG=`basename $1`
sed -n '/Iteration .* Testing net/,/Iteration *. loss/p' $1 > aux.txt
sed -i '/Waiting for data/d' aux.txt
sed -i '/prefetch queue empty/d' aux.txt
sed -i '/Iteration .* loss/d' aux.txt
sed -i '/Iteration .* lr/d' aux.txt
sed -i '/Train net/d' aux.txt



#grep 'Iteration ' aux.txt | sed  's/.*Iteration \([[:digit:]]*\).*/\1/g' > aux0.txt
#############                自定义,查找1000倍数的存入
grep '] Solving ' $1 > LSC_aux.txt
grep ', loss = ' $1 >> LSC_aux.txt
grep 'Iteration ' LSC_aux.txt | sed  's/.*Iteration \([[:digit:]]*\).*/\1/g' > aux0.txt
cp aux0.txt check.txt
grep '^[0]'  check.txt  > aux0.txt
grep '^[1-9]\d*000$'  check.txt  >> aux0.txt
###################################################
#注意要在rm里添加删除掉的文件


grep 'Test net output #0' aux.txt | awk '{print $11}' > aux1.txt
grep 'Test net output #1' aux.txt | awk '{print $11}' > aux2.txt

# Extracting elapsed seconds
# For extraction of time since this line contains the start time
grep '] Solving ' $1 > aux3.txt
grep 'Testing net' $1 >> aux3.txt
$DIR/extract_seconds.py aux3.txt aux4.txt

# Generating
echo '#Iters Seconds TestAccuracy TestLoss'> $LOG.test
paste aux0.txt aux4.txt aux1.txt aux2.txt | column -t >> $LOG.test
rm aux.txt aux0.txt aux1.txt aux2.txt aux3.txt aux4.txt check.txt LSC_aux.txt

# For extraction of time since this line contains the start time
grep '] Solving ' $1 > aux.txt
grep ', loss = ' $1 >> aux.txt



grep 'Iteration ' aux.txt | sed  's/.*Iteration \([[:digit:]]*\).*/\1/g' > aux0.txt
grep ', loss = ' $1 | awk -F = '{print $2}' > aux1.txt
grep ', lr = ' $1 | awk '{print $9}' > aux2.txt

# Extracting elapsed seconds
$DIR/extract_seconds.py aux.txt aux3.txt

# Generating
echo '#Iters Seconds TrainingLoss LearningRate'> $LOG.train
paste aux0.txt aux3.txt aux1.txt aux2.txt | column -t >> $LOG.train
rm aux.txt aux0.txt aux1.txt aux2.txt  aux3.txt

```



说明:

```
Notes:  
    1. Supporting multiple logs.  
    2. Log file name must end with the lower-cased ".log".  
Supported chart types:  


    0: Test accuracy  vs. Iters  
    1: Test accuracy  vs. Seconds  
    2: Test loss  vs. Iters  #我的测试里面没有loss
    3: Test loss  vs. Seconds  
    4: Train learning rate  vs. Iters  
    5: Train learning rate  vs. Seconds  
    6: Train loss  vs. Iters  
    7: Train loss  vs. Seconds  
```

> 遇到IndexError时候,可能是中途复制的log,日志信息不完整,删掉一些
>
> 再者就是权限问题,

