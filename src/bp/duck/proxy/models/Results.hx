package bp.duck.proxy.models;

/**
 * Users
 */
typedef Audited = {
	?id:String,
	?created:String
}

typedef BasicResult = {
	?success:Bool,
	?error:String
}

typedef DeleteManyResult = {
	> BasicResult,
	?deleted:Int
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

typedef WithResults<T> = {
	>BasicResult,
	?results:Array<T>
};

typedef PaginatedResult<T> = {
	> WithResults<T>,
	?total:Int,
	?page:Int,
	?previousCursor:String,
	?nextCursor:String,
};



typedef UserSelectResult = {
	> PaginatedResult<{
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

/**
 * Addresses
 */
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
	> PaginatedResult<{
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

/**
 * Mailboxes
 */
typedef MailboxCreateResult = Identify;

typedef MailboxDeleteResult = BasicResult;

typedef MailboxSelectResult = {
	> BasicResult,
	> WithResults<Mailbox>,
}

typedef MailboxInfoResult = {
	> Identify,
	> Mailbox,
}

typedef MailboxUpdateResult = BasicResult;

/**
 * Messages
 */
typedef MessageDeleteResult = BasicResult;

typedef MessagesDeleteResult = DeleteManyResult;
typedef AttachmentDownloadResult = RealSource;

typedef SubmissionResult = {
	> BasicResult,
	queueId:String,
}

typedef MessageForwardResult = {
	> SubmissionResult,
	forwarded:{
		seq:String, type:String, value:String
	}
}

typedef MessageDownloadResult = tink.io.Source.RealSource;

typedef MessageListResult = {
	> PaginatedResult<MessageHead>,
}

typedef AttachmentInfo = {
	> FdBase,
	?disposition:String,
	?transferEncoding:String,
	?related:Bool,
	?sizeKb:Int
}

typedef FileInfo = {
	> FdBase,
	?size:String
}

typedef MessageInfoResult = {
	> BasicResult,
	> MessageInfo<AttachmentInfo, FileInfo>,
	?user:String,
}

typedef MessageSelectResult = {
	> PaginatedResult<{ > MessageHead, ?url:String}>,
}

typedef DraftSubmitResult = {
	> SubmissionResult,
	?message:{
		?mailbox:String,
		?id:Int
	}
}

typedef MessageUpdateResult = {
	> Identify,
	?updated:Int
}

/**
 * Storage
 */
typedef FileDeleteResult = BasicResult;

typedef FileDownloadResult = RealSource;

typedef FileListResult = {
	> PaginatedResult<{
		?id:String,
		?filename:String,
		?contentType:String,
		?size:Int
	}>,
}

typedef FileUploadResult = {
	> Identify,
}
