function normVals=normalize1(newVals)
[m n k]=size(newVals);
for i=1:m
    for j=1:n
        h(i,j)=newVals(i,j,1)+newVals(i,j,2)+newVals(i,j,3)+newVals(i,j,4)+...
            +newVals(i,j,5)+newVals(i,j,6)+newVals(i,j,7)+newVals(i,j,8)+...
            +newVals(i,j,9)+newVals(i,j,10)+newVals(i,j,11)+newVals(i,j,12)+...
            +newVals(i,j,13)+newVals(i,j,14)+newVals(i,j,15)+newVals(i,j,16);
        for p=1:k
        normVals(i,j,p)=newVals(i,j,p)/h(i,j);
        end
    end
end


            
    