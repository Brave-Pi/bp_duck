package bp.duck.proxy.models;

typedef UserUpsertRequest = {
	>UserBase, >Auditable,
	?username:String,
	?name:String,
	
	?hashedPassword:String,
	?allowUnsafe:Bool,
	?address:String,
	?emptyAddress:Bool,
	?requirePasswordchance:Bool,
	?tags:Array<String>,
	?addTagsToAddress:Bool,
	?retention:Int,
	?uploadSentMessages:Bool,
	?encryptMessages:Bool,
	?encryptForwarded:Bool,
	?pubKey:String,
	?metaData:Dynamic,
	?language:String,
	?targets:Array<String>,
	?spamLevel:Int,
	?quota:Int,
	?recipients:Int,
	?forwards:Int,
	?imapMaxUpload:Int,
	?imapMaxDownload:Int,
	?pop3MaxDownload:Int,
	?pop3MaxMessages:Int,
	?imapMaxConnections:Int,
	?receivedMax:Int,
	?mailboxes:{
		?sent:String,
		?junk:String,
		?drafts:String,
		?trash:String
	},
	?disabledScopes:Array<String>,
	?fromWhiteList:Array<String>,
	?ip:String
};

typedef UserDeleteRequest = {
	>Auditable,
	?ip:String
};

typedef PaginatedRequest = {
	?limit:Int,
	?page:Int,
	?next:Int,
	?previous:Int
};

typedef UserSelectRequest = {
	> PaginatedRequest,
	querquery:String,
	tags:String,
	requiredTags:String,
	metaData:Bool
}

typedef UserLogoutRequest = {
    reason:String
}

typedef PasswordResetRequest = {
	>Auditable,
	?validAfter:String,
	
	?ip:String,
}

typedef UserUpdateRequest = {
	>UserUpsertRequest,
	>Auditable,
	?existingPassword:String,
	?disable2fa:Bool,
}