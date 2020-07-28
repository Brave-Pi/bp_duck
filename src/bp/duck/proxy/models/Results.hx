package bp.duck.proxy.models;

// users
typedef Audited = {
	?id:String,
	?created:String
}

typedef BasicResult = {
	?success:Bool,
	?error:String
}

typedef Identify = {
	> BasicResult,
	?id:String
};

typedef UserUpsertResult = {
	> Identify,
}

typedef UserResolutionResult = UserUpsertResult;
typedef UserDeleteResult = BasicResult;

typedef PaginatedResult = {
	> BasicResult,
	?total:Int,
	?page:Int,
	?previousCursor:String,
	?nextCursor:String,
};

typedef WithResults<T> = {
	results:Array<T>
}

typedef UserSelectResult = {
	> PaginatedResult,
	> WithResults<{
		> UserBase, quota:QuotaBase
	}>,
}

typedef QuotaGroup = {
	> QuotaBase,
	ttl:Dynamic,
}

typedef UserInfoResult = {
	> BasicResult,
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
	> BasicResult,
	password:String,
}

// addresses
typedef UserAddressCreateResult = Identify;
typedef ForwardedAddressCreateResult = Identify;
typedef ForwardedAddressDeleteResult = BasicResult;
typedef UserAddressDeleteResult = BasicResult;

typedef AddressResolutionResult = {
	> ForwardedAddressBase,
	> BasicResult,
	> Audited,
	?limits:{
		forwards:QuotaGroup
	},
	?autoReply:AutoReply,
}

typedef UserAddressListResult = {
	> BasicResult,
	> WithResults<{
		> AddressBase, > Audited,
	}>,
}

typedef RegisteredAddressListResult = {
	> PaginatedResult,
	> WithResults<{
		> AddressBase, > Audited,
	}>,
}

typedef RenameDomainResult = BasicResult;

typedef AddressInfoResult = {
	> BasicResult,
	> Audited,
	> AddressProfileBase,
}

typedef ForwardedAddressInfoResult = {
	> AddressBase,
	> Audited,
	limits:{
		forwards:QuotaGroup
	},
	?autoreply:AutoReply,
	?forwardedDisabled:Bool,
}

typedef AddressUpdateResult = BasicResult;
typedef ForwardedAddressUpdateResult = BasicResult;
