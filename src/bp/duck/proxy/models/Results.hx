package bp.duck.proxy.models;

typedef BasicResult = {
	?success:Bool,
	?error:String
}

typedef UserUpsertResult = {
	> BasicResult,
	id:String,
}

typedef UserDeleteResult = BasicResult;

typedef PaginatedResult = {
	total:Int,
	page:Int,
	previousCursor:String,
	nextCursor:String,
};

typedef UserSelectResult = {
	> BasicResult,
	> PaginatedResult,
	results:Array<{
		> UserBase, quota:QuotaBase
	}>,
}

typedef QuotaGroup = {
	> QuotaBase,
	ttl:Dynamic,
}

typedef UserInfoResult = {
	>BasicResult,
	> UserBase,
	keyInfo:Dynamic,
	limits:{
		quota:QuotaBase, recipients:QuotaGroup, forwards:QuotaGroup, received:QuotaGroup, imapUpload:QuotaGroup, imapDownload:QuotaGroup,
		pop3Download:QuotaGroup,
	},
	?fromWhitelist:Array<String>,
	disabledScopes:Array<String>
};

typedef PasswordResetResult = {
	>BasicResult,
	password:String,
}