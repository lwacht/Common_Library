//stop progress if any of the required documents are missing
try{
	var reqDocs = sepGetReqdDocs();
	if(reqDocs.length>0){
		cancel = true;
		showMessage = true;
		logDebug("The following documents are required: ");
		for (x in reqDocs){
			logDebug(reqDocs[x]["docGroup"] + " - " + reqDocs[x]["docType"]  + br);
		}
	}
}catch(err){
	logDebug("A JavaScript Error occurred: WTUB:*/*/*/*: " + err.message);
	logDebug(err.stack)
}

//stop progress if any of the required fees/inspections/documents are not taken care of
try{
	sepStopWorkflow();
}catch(err){
	logDebug("A JavaScript Error occurred: WTUB:*/*/*/*: " + err.message);
	logDebug(err.stack)
}

