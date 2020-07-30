package bp.duck.proxy.models;

/**
 * Common
 */
/**
 * Users
 */
typedef UserUpsertRequest = {
	> UserBase,
	> Auditable,
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
};

typedef UserDeleteRequest = {
	> Auditable,
};

typedef PaginatedRequest = {
	?query:String,
	?limit:Int,
	?page:Int,
	?next:Int,
	?previous:Int
};

typedef UserSelectRequest = {
	> PaginatedRequest,
	?tags:String,
	?requiredTags:String,
	?metaData:Bool
}

typedef UserLogoutRequest = {
	?reason:String
}

typedef PasswordResetRequest = {
	> Auditable,
	?validAfter:String,
}

typedef UserUpdateRequest = {
	> UserUpsertRequest,
	> Auditable,
	?existingPassword:String,
	?disable2fa:Bool,
}

/**
 * Addresses
 */
typedef UserAddressCreateRequest = {
	> AddressBase,
}

typedef ForwardedAddressCreateRequest = {
	> ForwardedAddressBase,
	?autoreply:{
		?status:Bool,
		?start:String,
		?end:String,
		?name:String,
		?subject:String,
		?text:String,
		?html:String
	}
}

typedef AddressResolutionRequest = {
	?allowWildcard:Bool,
}

typedef RegisteredAddressListRequest = {
	> PaginatedRequest,
	?tags:String,
	?requiredTags:String
}

typedef RenameDomainRequest = {
	oldDomain:String,
	newDomain:String
}

typedef AddressUpdateRequest = {
	> AddressProfileBase,
	?name:String,
}

typedef ForwardedAddressUpdateRequest = {
	> ForwardedAddressBase,
	?forwards:Int,
	?autoreply:AutoReply
}

/**
 * Mailboxes
 */
typedef MailboxCreateRequest = {
	> MailboxBase,
	path:String,
}

typedef MailboxSelectRequest = {
	?specialUse:Bool,
	?showHidden:Bool,
	?counters:Bool,
	?sizes:Bool
}

typedef MailboxUpdateRequest = Mailbox;

/**
 * Messages
 */
typedef MessagesDeleteRequest = {
	?async:Bool
}

typedef MessageForwardRequest = {
	?target:Int,
	?addresses:Array<String>
}

typedef MessageListRequest = {
	> PaginatedRequest,
	?unseen:Int,
	?metaData:Bool
}

typedef MessageInfoRequest = {
	?markAsSeen:Bool
}

typedef MessageSelectRequest = {
	> PaginatedRequest,
	?mailbox:String,
	?thread:String,
	?datestart:Date,
	?datend:Date,
	?from:String,
	?to:String,
	?subject:String,
	?flagged:Bool,
	?unseen:Bool,
	?searchable:Bool,
	?or:{
		query:String,
		from:String,
		to:String,
		subject:String
	}
}

typedef DraftSubmitRequest = {
	deleteFiles:Bool
}

typedef MessageUpdateRequest = {
	> HasMeta,
	?moveTo:String,
	?seen:Bool,
	?flagged:Bool,
	?draft:Bool,
	?expires:Date,
}

typedef AttachmentCreate = {
	> FdBase,
	?cid:String,
	?content:String
}

typedef DraftCreateRequest = {
	> Auditable,
	> MessageInfo<AttachmentCreate, String>,
	?meta:Dynamic
}

/**
 * Storage
 */
typedef FileListRequest = PaginatedRequest;

typedef FileUploadRequest = {
	> Auditable,
	filename:String,
	contentType:String
}

/**
 * Submission
 */
typedef SubmitMessageRequest = {
	> DraftCreateRequest,
	?uploadOnly:Bool,
	?isDraft:Bool,
	?sendTime:Date
}

/**
 * Two Factor Auth
 */
typedef TwoFactorAuthDisableRequest = Auditable;

typedef TwoFactorAuthTotpDisableRequest = Auditable;
typedef CustomTwoFactorAuthDisableRequest = Auditable;

typedef TwoFactorAuthEnableRequest = {
	> Auditable,
	token:String
}

typedef CustomTwoFactorAuthEnableRequest = {
	> Auditable,
}

typedef TwoFactorAuthGenSeedRequest = {
	> Auditable,
	issuer:String,
	?label:String
}

typedef TwoFactorAuthValidateRequest = {
	> Auditable,

	token:String,
}

/**
 * Application Specific Passwords (ASPs)
 */
typedef ASPCreateRequest = {
	> ASPBase,
	?generateMobileconfig:Bool,
	?address:String,
	?ttl:Int,
	?sess:String,
	?ip:String
}

typedef ASPListRequest = {
	?showAll:Bool
}

/**
 * Archive
 */
typedef ArchiveListRequest = PaginatedRequest;

typedef ArchiveRestoreRequest = {
	?mailbox:String
}

typedef ArchiveBulkRestoreRequest = {
	start:Date,
	end:Date
}

/**
 * Audit
 */
typedef AuditCreateRequest = AuditBase<Date>;

/**
 * Authentication
 */
typedef AuthenticateRequest = {
	> Auditable,
	username:String,
	password:String,
	?protocol:String,
	?scope:String,
	?token:Bool,
}

typedef AuthLogListRequest = {
	> PaginatedRequest,
	?filterIp:String,
	?action:String
}

/**
 * Autoreplies
 */
typedef AutoReplyUpdateRequest = AutoReplyBase<Date>;

/**
 * DKIM
 *
 */
typedef DkimCreateRequest = PrivateDkimBase;

typedef DkimListRequest = PaginatedRequest;

/**
 * Domain Aliases
* **/
typedef DomainAliasCreateRequest = DomainAlias;

typedef DomainAliasListRequest = PaginatedRequest;

/**
 * Filters
 */
typedef FilterCreateRequest = FilterInfo;

typedef FilterUpdateRequest = FilterInfo;
