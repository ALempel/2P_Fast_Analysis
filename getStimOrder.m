function A=getStimOrder(Filepath)
Filename=[Filepath '\stimOrder.txt'];
file=fopen(Filename,'r');
A=[];
Line=fgets(file);
while ischar(Line(1))
    A=[A,eval(Line)];
    Line=fgets(file);
end