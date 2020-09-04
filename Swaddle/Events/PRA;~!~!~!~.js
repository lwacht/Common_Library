//renew license
try{
	sepRenewLicensePayment();
}catch(err){
	logDebug("A JavaScript Error occurred: PRA:*/*/*/*: Renew license: " + err.message);
	logDebug(err.stack)
}