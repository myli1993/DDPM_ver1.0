function nse = NSE(arrObs,arrPred)
soor=sum((arrPred-arrObs).^2);
makh=sum((arrObs-mean(arrObs)).^2);
nse=1-soor/makh;