package bp.duck.proxy.models;

#if macro
import tink.macro.BuildCache;

using tink.MacroApi;
#end

/**
 * Common
 */
typedef Audited = {
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

/**
 * Users
 */
typedef UserUpsertResult = Identify;

typedef UserResolutionResult = UserUpsertResult;
typedef UserDeleteResult = BasicResult;

typedef WithResults<T> = {
	> BasicResult,
	?results:Array<T>
};

typedef PaginatedResult<T> = {
	> WithResults<T>,
	?total:Int,
	?page:Int,
	?previousCursor:Dynamic,
	?nextCursor:Dynamic,
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
	> Identify,
	> Audited,
	?limits:{
		forwards:QuotaGroup
	},
	?autoReply:AutoReply,
}

typedef UserAddressListResult = {
	> BasicResult,
	> WithResults<{
		> AddressBase, > Audited, > Identify,
	}>,
}

typedef RegisteredAddressListResult = {
	> PaginatedResult<{
		> AddressBase, > Audited, > Identify,
	}>,
}

typedef RenameDomainResult = BasicResult;

typedef AddressInfoResult = {
	> Identify,
	> Audited,
	> AddressProfileBase,
}

typedef ForwardedAddressInfoResult = {
	> AddressBase,
	> Identify,
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

/**
 * Two Factor Auth
 */
typedef TwoFactorAuthDisableResult = BasicResult;

typedef TwoFactorAuthTotpDisableResult = BasicResult;
typedef CustomTwoFactorAuthDisableResult = BasicResult;
typedef TwoFactorAuthEnableResult = BasicResult;
typedef CustomTwoFactorAuthEnableResult = BasicResult;

typedef TwoFactorAuthGenSeedResult = {
	> BasicResult,
	?seed:String,
	?qrcode:String
}

typedef TwoFactorAuthValidateResult = BasicResult;

/**
 * Application Specific Passwords (ASPs)
 */
typedef ASPBaseResult = {
	> ASPBase,
	?lastUse:{
		?time:Dynamic,
		?event:Dynamic
	}
}

typedef ASPCreateResult = {
	> Identify,
	?password:String,
	?mobileconfig:String,
}

typedef ASPDeleteResult = BasicResult;

typedef ASPListResult = {
	> BasicResult,
	> WithResults<{
		> ASPBaseResult, id:String
	}>,
}

typedef ASPInfoResult = {
	> Identify,
	> Audited,
	> ASPBaseResult,
}

/**
 * Archive
 */
typedef ArchiveListResult = MessageSelectResult;

typedef ArchiveRestoreResult = {
	> Identify,
	mailbox:String
}

typedef ArchiveBulkRestoreResult = BasicResult;

/**
 * Audit
 */
typedef AuditCreateResult = Identify;

typedef AuditExportResult = RealSource;

typedef AuditInfoResult = {
	> BasicResult,
	> AuditBase<String>,
	user:String,
}

/**
 * Authentication
 */
typedef AuthenticateResult = {
	> Identify,
	username:String,
	scope:String,
	?require2fa:Dynamic,
	?requirePasswordChange:Bool,
	?token:String
}

typedef AuthInvalidateResult = BasicResult;

typedef AuthLog = {
	> Auditable,
	> Audited,
	id:String,
	action:String,
	result:String
}

typedef AuthLogListResult = PaginatedResult<AuthLog>;

typedef AuthLogResult = {
	> BasicResult,
	> AuthLog,
};

/**
 * Autoreplies
 */
typedef AutoReplyDeleteResult = BasicResult;

typedef AutoReplyInfoResult = {
	> BasicResult,
	> AutoReplyBase<String>,
}

typedef AutoReplyUpdateResult = BasicResult;

/**
 * DKIM
 */
typedef PublicDkimInfo = {
	> PublicDkimBase,
	dnsTxt:{
		name:String, value:String
	}
}

typedef DkimCreateResult = {
	> Identify,
	> PublicDkimBase,
}

typedef DkimDeleteResult = BasicResult;

typedef DkimListResult = PaginatedResult<{
	> Audited, > PublicDkimBase, id:String,
}>;

typedef DkimInfoResult = {
	> Identify,
	> PublicDkimInfo,
}

typedef DkimResolutionResult = {
	> Identify,
}

/**
 * Domain Aliases
* **/
typedef DomainAliasCreateResult = Identify;

typedef DomainAliasDeleteResult = BasicResult;

typedef DomainAliasListResult = PaginatedResult<{
	> Identify, > DomainAlias,
}>;

typedef DomainAliasInfoResult = {
	> Identify,
	> DomainAlias,
}

typedef DomainAliasResolutionResult = Identify;

/**
 * Filters
 */
typedef FilterCreateResult = Identify;

typedef FilterDeleteResult = BasicResult;
typedef FilterListResult = PaginatedResult<Filter>;

typedef FilterInfoResult = {
	> Identify,
	> Filter,
}

typedef FilterUpdateResult = Identify;
